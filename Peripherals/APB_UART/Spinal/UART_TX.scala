package worklib.uart

import spinal.core._
import spinal.lib._


class UART_TX(sampleTime:Int = 7) extends Component {
  val io = new Bundle {
    val tick = in Bool()
    val data = slave Stream (Bits(8 bits))
    val txd = out Bool()
    val busy = out Bool()
  }

  object UartState extends SpinalEnum {
    val IDLE, START, DATA, STOP = newElement()
  }

  val subDiv = new Area {
    val counter = Reg(UInt(log2Up(sampleTime) bit)) init (0)
    val tick: Bool = Reg(Bool())
    tick := ((counter === 0) && io.tick)

    def rst() = {
      counter := sampleTime
      tick:= False
    }

    when(io.tick) {
      when((counter === 0)) {
        counter := sampleTime
      } otherwise {
        counter := counter - 1
      }
    }
  }

  val bitCnt = new Area {
    val value = Reg(UInt(3 bit))

    def rst() = value := 0

    when(subDiv.tick) {
      value := value + 1
    }
  }

  val stateMac = new Area {

    import UartState._

    val state = RegInit(IDLE)

    io.data.ready := False

    val txd = True

    switch(state) {
      is(IDLE) {
        when(io.data.valid && RegNext(io.tick)) {
          subDiv.rst()
          state := START
        }
      }
      is(START) {
        txd := False
        when(subDiv.tick) {
          state := DATA
          bitCnt.rst()
        }
      }
      is(DATA) {
        txd := io.data.payload(bitCnt.value)
        when(bitCnt.value === 7 && subDiv.tick) {
          io.data.ready := True
          state := STOP
        }
      }
      is(STOP) {
        when(subDiv.tick) {
          when(io.data.valid) {
            state := START
          } otherwise {
            state := IDLE
          }
        }
      }
    }

  }
  io.txd := RegNext(stateMac.txd, True)
  io.busy:=stateMac.state=/=UartState.IDLE
}

//Define a custom SpinalHDL configuration with synchronous reset instead of the default asynchronous one. This configuration can be resued everywhere
object UART_TX_Cfg extends SpinalConfig(
  defaultConfigForClockDomains = ClockDomainConfig(
    resetKind = ASYNC,
    resetActiveLevel = LOW
  )
)

//Generate the MyTopLevel's Verilog using the above custom configuration.
object UART_TX_cfg_O {
  def main(args: Array[String]) {
    UART_TX_Cfg.generateVerilog(new UART_TX)
  }
}