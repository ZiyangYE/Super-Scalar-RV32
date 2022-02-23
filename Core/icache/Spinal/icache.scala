package worklib.core

import spinal.core._
import spinal.lib._

case class icacheCfg(
  val readPortCount : Int = 2, // 1 means 32 bit port, 2 means 64 bit port
  val memPortWidth : Int = 8,
  val memSize : Int = 32768,
  val memAdrOffset : Int = 0,
  val partCount : Int = 4,
  val partSize : Int = 64 // counted in 4Bytes
){}

case class ROMInterface(cfg:icacheCfg) extends Bundle with IMasterSlave{
  val memFlow = slave Flow(Bits(cfg.memPortWidth bits))
  val memAddr = out UInt(log2Up(cfg.memSize) bits)

  override def asMaster(): Unit = {
    master(memFlow)
    in(memAddr)
  }
}

case class icacheInterface(cfg:icacheCfg) extends Bundle with IMasterSlave{
  val readData = out Bits(cfg.readPortCount*32 bits)
  val readValid = out Bits(cfg.readPortCount bits)
  val readAddr = in UInt(32 bits)

  override def asMaster(): Unit = {
    in(readData)
    in(readValid)
    out(readAddr)
  }
}

class icache(
  cfg : icacheCfg = icacheCfg()
)extends Component {
  val romIO = new ROMInterface(cfg)
  val cacheIO = new icacheInterface(cfg)

  romIO.memAddr.setAsReg() init(0)

  val readPortArray = new Array[Bits](cfg.readPortCount)
  val readValidArray = new Array[Bool](cfg.readPortCount)
  for(i <- 0 until cfg.readPortCount){
    readPortArray(i) = (Bits(32 bits))
    readValidArray(i) = Bool()
    cacheIO.readData(i*32,32 bits) := readPortArray(i)
    cacheIO.readValid(i) := readValidArray(i)
  }


  val cacheFileArray = new Array[Mem[Bits]](cfg.partCount)
  val cacheLineAvr = Reg(Bits(cfg.partCount*cfg.partSize bits)) init(0)
  //Divide Availbility to seperate var

  val cacheAddr = new Array[UInt](cfg.partCount)
  val cacheOrd = new Array[UInt](cfg.partCount)

  val cacheAddrLen = 32-log2Up(cfg.partSize)-2 //sub ext 2 because size of cacheByte is 32bits
  val cacheAddrMSB = 32-cacheAddrLen

  var ordLen = 1
  if(cfg.partCount>1){
    ordLen = log2Up(cfg.partCount)
  }

  for(i <- 0 until cfg.partCount){
    cacheFileArray(i) = Mem(Bits(32 bits), cfg.partSize)

    val setted = UInt(cacheAddrLen bits)
    setted.setAll()
    cacheAddr(i) = Reg(UInt(cacheAddrLen bits)) init(setted)
    //set all high to prevent miscached
    //as the high zone is used for peripheals

    cacheOrd(i) = Reg(UInt(ordLen bits))
    cacheOrd(i).init(i)
  }

  val requestRead = True
  val inPage = False
  val matchedPage = UInt(ordLen bits)
  matchedPage:=0


  for(i <- 0 until cfg.readPortCount){
    val ioHighAddr = (cacheIO.readAddr+i*U(4))(31 downto cacheAddrMSB)
    val ioLowAddr = (cacheIO.readAddr+i*U(4))(cacheAddrMSB-1 downto 0)

    readValidArray(i).setAsReg()
    readPortArray(i).setAsReg()
    readValidArray(i):= False
    readPortArray(i):=0

    for(j <- 0 until cfg.partCount){
      when(ioHighAddr === cacheAddr(j)){
        if(i==0){
          inPage := True
          matchedPage := cacheOrd(j)
          requestRead := ~cacheLineAvr(j*cfg.partSize,cfg.partSize bits)(ioLowAddr>>2)
        }
        readValidArray(i) := cacheLineAvr(j*cfg.partSize,cfg.partSize bits)(ioLowAddr>>2)
        readPortArray(i) := cacheFileArray(j).readAsync(ioLowAddr>>2)
      }
    }


  }
  val ioHighAddr = (cacheIO.readAddr)(31 downto cacheAddrMSB)
  val ioLowAddr = cacheIO.readAddr(cacheAddrMSB-1 downto 0)
  //if found, decrease the order
  when(matchedPage>0){
    for(i <- 0 until cfg.partCount){
      when(cacheOrd(i) === matchedPage){
        cacheOrd(i) := cacheOrd(i) - 1
      }
      when(cacheOrd(i) === matchedPage - 1){
        cacheOrd(i) := cacheOrd(i) + 1
      }
    }
  }
  //when not in page, assign a new cache part
  val pageReAssign = False
  when(!inPage){
    for(i <- 0 until cfg.partCount){
      when(cacheOrd(i) === cfg.partCount-1){
        cacheAddr(i) := ioHighAddr
        cacheLineAvr(i*cfg.partSize,cfg.partSize bits):= B(0)
        pageReAssign := True
      }
    }
  }


  //do the read
  //if requestRead, force to read the readport0 position
  //otherwise, automatically read the part0, part1 if there are invalid positions
  //the automatical read is limited to part0 and part1 to avoid useless read

  //do the invalid position check and part lookup
  //and generate the read address
  var doRead = False
  val readPos = UInt(32 bits)
  readPos := cacheIO.readAddr
  val readPart = U(0,log2Up(cfg.partCount) bits)
  val readLowPos = readPos(cacheAddrMSB-1 downto 2)
  val readHighPos = readPos(31 downto cacheAddrMSB)

  when(requestRead){//force read, find the target part
    doRead := True
    //if reassign triggered, read into partOrd3, otherwise, check the addr
    when(pageReAssign){//reassigned, find the part with the highest order
      for(i <- 0 until cfg.partCount){
        when(cacheOrd(i) === cfg.partCount-1){
          readPart := U(i)
        }
      }
    }otherwise{//not reassigned, find the part with the correct address
      for(i<-0 until cfg.partCount){
        when(cacheAddr(i) === readHighPos){
          readPart := U(i)
        }
      }
    }
  }otherwise{//auto read, find if there're invalid position in the part
    def priorityEncoder(input:Bits):UInt = {
      val inputLen = input.getWidth
      val outputLen = log2Up(inputLen)
      val output = UInt(outputLen bits)
      output := 0
      for(i <- inputLen-1 to 0 by -1){
        when(input(i)===True){
          output:=U(i)
        }
      }
      return output
    }

    val firstHave = False
    for(j <- 0 until cfg.partCount){
      //if msb===true, it means the cache is not assigned
      when(cacheAddr(j).msb===False && cacheOrd(j)===0 && ((~cacheLineAvr(j*cfg.partSize,cfg.partSize bits)).asUInt=/=0)){//invalid bit ari
        firstHave := True
        readHighPos:= cacheAddr(j)
        readPart := U(j)
        readLowPos:=priorityEncoder(~cacheLineAvr(j*cfg.partSize,cfg.partSize bits))
        doRead := True
      }
    }
    if(cfg.partCount>1){
      if(firstHave==False){
        for(j <- 0 until cfg.partCount){
          //if msb===true, it means the cache is not assigned
          when(cacheAddr(j).msb===False && cacheOrd(j)===1 && ((~cacheLineAvr(j*cfg.partSize,cfg.partSize bits)).asUInt=/=0)){//invalid bit ari
            readHighPos:= cacheAddr(j)
            readPart := U(j)
            readLowPos:=priorityEncoder(~cacheLineAvr(j*cfg.partSize,cfg.partSize bits))
            doRead := True
          }
        }
      }
    }
  }


  //if the part reassign is triggered, giveup the current operation
  val readSM = new Area{
    object cacheState extends SpinalEnum {
      val IDLE, READ, ASSERT = newElement()
    }
    import cacheState._

    val state = RegInit(IDLE)
    val romReadReg = Reg(UInt(32 bits),U(0))
    val width = cfg.memPortWidth
    val readCycles = U(32/width-1)
    val counter = Reg(UInt(log2Up(32/width) bits)) init(0)
    val assignLowPos = Reg(UInt(32-cacheAddrLen-2 bits),U(0))
    val avrOffset = UInt(log2Up(cfg.partSize * cfg.partCount) bits)
    avrOffset:=(readPart*cfg.partSize).resize(avrOffset.getWidth)

    //goto activate when request read or auto read
    switch(state){
      is(IDLE){
        romIO.memAddr := (readPos-U(cfg.memAdrOffset)).resize(romIO.memAddr.getWidth)
        assignLowPos:= readLowPos
        when(doRead){
          state:=READ
        }
      }
      is(READ){
        when(pageReAssign){
          counter:=0
          state:=IDLE
        }otherwise {
          romReadReg(counter*width,width bits) := romIO.memFlow.payload.asUInt
          when(romIO.memFlow.valid) {
            counter := counter + 1
            when(counter === readCycles) {
              state:=ASSERT
            }
          }
        }
      }
      is(ASSERT){
        counter:=0
        romIO.memAddr := (readPos-U(cfg.memAdrOffset)).resize(romIO.memAddr.getWidth)
        assignLowPos:= readLowPos

        when(pageReAssign) {
          state:=IDLE
        }otherwise {
          cacheLineAvr(avrOffset,cfg.partSize bits)(assignLowPos) := True
          for(i<-0 until cfg.partCount){
            when(i===readPart){
              cacheFileArray(i).write(assignLowPos, romReadReg.asBits)
            }
          }
          when(doRead){
            when(romIO.memAddr===readPos){
              state:=IDLE
            }otherwise {
              state:=READ
            }
          }otherwise{
            state:=IDLE
          }
        }
      }
    }
  }
}

object icache_cfg extends SpinalConfig(
  defaultConfigForClockDomains = ClockDomainConfig(
    resetKind = ASYNC,
    resetActiveLevel = LOW
  )
)

//Generate the MyTopLevel's Verilog using the above custom configuration.
object icache_gen {
  def main(args: Array[String]) {
    icache_cfg.generateVerilog(new icache())
  }
}
