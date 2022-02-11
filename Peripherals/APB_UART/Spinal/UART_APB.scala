package worklib.uart

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb.{Apb3, Apb3Config, Apb3SlaveFactory}

object UART_APB_CFG{
  def getAPBCFG=Apb3Config(
    addressWidth = 4,
    dataWidth = 32
  )
}



class UART_APB(cfg:UARTCfg=UARTCfg()) extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(UART_APB_CFG.getAPBCFG))
    val sio= master(UARTSIO())
  }

  val ByteOrder = Reg(Bool()) init(False)
  val AccessWidth = Reg(UInt(2 bits)) init(0)

  val busCtr=Apb3SlaveFactory(io.apb)

  val CtrConvert = new Area{
    val RPort = Bits(32 bits)
    val WPort = Reg(Bits(32 bits)) init(0)
    val AccCfg = B(3 bits,(2 downto 1)->AccessWidth.asBits,0->ByteOrder)
    val LstCfg = RegNext(AccCfg)

    RPort:="32'x0"
    RPort(3 downto 0):=io.sio.reg.RXCnt.asBits
    RPort(7 downto 4):=io.sio.reg.TXCnt.asBits
    RPort(8):=io.sio.reg.RXBusy
    RPort(9):=io.sio.reg.TXBusy
    RPort(19 downto 16):=io.sio.reg.RXThreshold.asBits
    RPort(23 downto 20):=io.sio.reg.TXThreshold.asBits
    RPort(24):=io.sio.reg.OverRun
    RPort(25):=ByteOrder
    RPort(27 downto 26):=AccessWidth.asBits

    io.sio.reg.RXThreshold:=WPort(19 downto 16).asUInt
    io.sio.reg.TXThreshold:=WPort(23 downto 20).asUInt
    ByteOrder:=WPort(25)
    AccessWidth:=WPort(27 downto 26).asUInt

    io.sio.reg.ROverRun:=WPort(24)

    WPort(24):=False


  }

  val TXConvert = new Area{
    val counter = Reg(UInt(2 bit)) init(0)
    val WritingSignal=False
    //val txdata = Bits(32 bits)
    val txdata = io.apb.PWDATA

    def rst()=counter:=0

    when((io.apb.PADDR === U(0x08).resized)
      && (io.apb.PENABLE===True)
      && (io.apb.PWRITE===True)
      && (io.apb.PSEL(0)===True)
    ){
      WritingSignal:=True
    }

    //io.sio.txdata.valid:=False

    when(ByteOrder===False){
      io.sio.txdata.payload:=counter.mux(
        0->txdata(7 downto 0),
        1->txdata(15 downto 8),
        2->txdata(23 downto 16),
        3->txdata(31 downto 24)
      )
    }otherwise{
      io.sio.txdata.payload:=counter.mux(
        0->txdata(31 downto 24),
        1->txdata(23 downto 16),
        2->txdata(15 downto 8),
        3->txdata(7 downto 0)
      )
    }

    io.sio.txdata.valid:=WritingSignal

    when(!WritingSignal){counter:=0}
    when(WritingSignal){
      when(io.sio.txdata.ready) {
        counter := counter + 1
      }
      when(counter=/=AccessWidth || io.sio.txdata.ready===False) {
        busCtr.writeHalt()
      }
    }
  }

  val RXConvert = new Area{
    val counter = Reg(UInt(3 bit)) init(0)
    val ReadingSignal=False
    val rxdata = Reg(Bits(32 bits)) init(0)

    def rst()=counter:=0

    when((io.apb.PADDR === U(0x0C).resized)
      && (io.apb.PENABLE===True)
      && (io.apb.PWRITE===False)
      && (io.apb.PSEL(0)===True)
    ){
      ReadingSignal:=True
    }

    io.sio.rxdata.ready:=False
    busCtr.read(rxdata,0x0C)

    when(ByteOrder===False){
      switch(counter){
        is(0){rxdata(7 downto 0):=io.sio.rxdata.payload}
        is(1){rxdata(15 downto 8):=io.sio.rxdata.payload}
        is(2){rxdata(23 downto 16):=io.sio.rxdata.payload}
        is(3){rxdata(31 downto 24):=io.sio.rxdata.payload}
      }
    }otherwise{
      switch(counter){
        is(0){rxdata(31 downto 24):=io.sio.rxdata.payload}
        is(1){rxdata(23 downto 16):=io.sio.rxdata.payload}
        is(2){rxdata(15 downto 8):=io.sio.rxdata.payload}
        is(3){rxdata(7 downto 0):=io.sio.rxdata.payload}
      }
    }

    when(counter =/= AccessWidth+U"3'b01" && ReadingSignal){
      io.sio.rxdata.ready:=True
      when(io.sio.rxdata.valid) {
        counter := counter + 1
      }
    }
    when(ReadingSignal){
      when(counter =/= AccessWidth+U"3'b01"){
        busCtr.readHalt()
      }otherwise{
        counter:=0
      }
    }
  }

  when(CtrConvert.AccCfg=/=CtrConvert.LstCfg){
    TXConvert.rst()
    RXConvert.rst()
  }

  busCtr.read(CtrConvert.RPort,0x00)
  busCtr.write(CtrConvert.WPort,0x00)
  io.sio.reg.ClkDiv.setAsReg() init(0)
  busCtr.readAndWrite(io.sio.reg.ClkDiv,0x04)
}


object UART_AP_Cfg extends SpinalConfig(
  defaultConfigForClockDomains = ClockDomainConfig(
    resetKind = ASYNC,
    resetActiveLevel = LOW
  )
)

//Generate the MyTopLevel's Verilog using the above custom configuration.
object UART_APB_cfg {
  def main(args: Array[String]) {
    UART_AP_Cfg.generateVerilog(new UART_APB())
  }
}
