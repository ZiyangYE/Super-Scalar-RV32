package worklib.uart

import spinal.core._
import spinal.lib._

case class UARTCfg(
                    FIFOSize: Int = 4,
                    SampleSize: Int = 7
                  ){}

case class UARTReg() extends Bundle with IMasterSlave{
  val ClkDiv = UInt(16 bit)
  val ROverRun = Bool()
  val OverRun = Bool()
  val TXThreshold = UInt(4 bit)
  val RXThreshold = UInt(4 bit)
  val TXBusy = Bool()
  val RXBusy = Bool()
  val TXCnt = UInt(4 bit)
  val RXCnt = UInt(4 bit)

  override def asMaster(): Unit = {
    out(ClkDiv)
    out(ROverRun)
    in(OverRun)
    out(TXThreshold)
    out(RXThreshold)
    in(TXBusy)
    in(RXBusy)
    in(TXCnt)
    in(RXCnt)
  }

  override def asSlave(): Unit = {
    in(ClkDiv)
    in(ROverRun)
    out(OverRun)
    in(TXThreshold)
    in(RXThreshold)
    out(TXBusy)
    out(RXBusy)
    out(TXCnt)
    out(RXCnt)
  }

}

//System Interface
case class UARTSIO() extends Bundle with IMasterSlave{
  val txdata = Stream (Bits(8 bits))
  val rxdata = Stream (Bits(8 bits))

  val reg = UARTReg()

  override def asMaster(): Unit = {
    master(txdata)
    slave(rxdata)
    master(reg)
  }

  override def asSlave(): Unit = {
    slave(txdata)
    master(rxdata)
    slave(reg)
  }
}

//External Interface
case class UARTEIO() extends Bundle {
  val txd = out Bool()
  val rxd = in Bool()
}

//Interrupt Interface
case class UARTInt() extends Bundle with IMasterSlave{
  val TXFIFOEmpty = Bool()
  val RXFIFOFull = Bool()

  override def asMaster(): Unit = {
    in(TXFIFOEmpty)
    in(RXFIFOFull)
  }
  override def asSlave(): Unit = {
    out(TXFIFOEmpty)
    out(RXFIFOFull)
  }
}

class UART(cfg:UARTCfg=UARTCfg()) extends Component {
  val sio = slave(UARTSIO())
  val eio = UARTEIO()
  val int = slave(UARTInt())

  val tx = new UART_TX(cfg.SampleSize)
  val rx = new UART_RX(cfg.SampleSize)

  val RXStream = StreamFifo(dataType = Bits(8 bit),depth=cfg.FIFOSize)
  val TXStream = StreamFifo(dataType = Bits(8 bit),depth=cfg.FIFOSize)

  sio.reg.TXCnt:=TXStream.io.occupancy.resized
  sio.reg.RXCnt:=RXStream.io.occupancy.resized
  sio.reg.TXBusy:=tx.io.busy
  sio.reg.RXBusy:=rx.io.busy

  sio.txdata>>TXStream.io.push
  sio.rxdata<<RXStream.io.pop

  int.RXFIFOFull:=sio.reg.RXCnt>sio.reg.RXThreshold
  int.TXFIFOEmpty:=sio.reg.TXCnt<sio.reg.TXThreshold

  val tickgen = new Area {
    val counter = Reg(UInt(16 bit)) init(0)
    val tick = counter === 0
    when(counter===0 || counter>sio.reg.ClkDiv) {
      counter:=sio.reg.ClkDiv
    }otherwise{
      counter:=counter-1
    }
  }

  TXStream.io.pop >> tx.io.data
  tx.io.txd <> eio.txd
  tx.io.tick <> tickgen.tick

  val tr = rx.io.data.throwWhen(RXStream.io.occupancy === cfg.FIFOSize-1)
  tr >> RXStream.io.push
  rx.io.rxd <> eio.rxd
  rx.io.tick <> tickgen.tick

  sio.reg.OverRun.setAsReg() init(False)
  when(rx.io.data.valid&&RXStream.io.occupancy === cfg.FIFOSize-1){
    sio.reg.OverRun := True
  }
  when(sio.reg.ROverRun){
    sio.reg.OverRun:=False
  }
}


//Define a custom SpinalHDL configuration with synchronous reset instead of the default asynchronous one. This configuration can be resued everywhere
object Cfg extends SpinalConfig(
  defaultConfigForClockDomains = ClockDomainConfig(
    resetKind = ASYNC,
    resetActiveLevel = LOW
  )
)

//Generate the MyTopLevel's Verilog using the above custom configuration.
object UART_cfg {
  def main(args: Array[String]) {
    Cfg.generateVerilog(new UART(UARTCfg()))
  }
}