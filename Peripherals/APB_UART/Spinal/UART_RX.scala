package worklib.uart

import spinal.core._
import spinal.lib._


class UART_RX(sampleTime:Int = 7) extends Component {
  val io = new Bundle {
    val tick = in Bool()
    val data = master Stream (Bits(8 bits))
    val rxd = in Bool()
    val busy = out Bool()

    data.payload.setAsReg() init(0)
    data.valid.setAsReg() init(False)
  }

  object UartState extends SpinalEnum {
    val IDLE, START, DATA, STOP = newElement()
  }

  val subDiv = new Area {
    val counter = Reg(UInt(log2Up(sampleTime) bits)) init (0)
    val tick = Reg(Bool())
    tick := ((counter === 0) && io.tick)

    def rst() = {
      counter := (sampleTime/2)-1
      tick := False
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

  val keeper = new Area {
    val counter = Reg(UInt(log2Up(sampleTime) bits)) init (0)
    val rxk = Reg(Bool()) init(True)
    when(io.tick) {
      when(rxk =/= io.rxd) {
        counter:=counter+1
        when(counter > sampleTime/4){
          counter:=0
          rxk := ~rxk
        }
      }otherwise{
        counter:=0
      }
    }
  }


  val stateMac = new Area{
    import UartState._

    val state = RegInit(IDLE)

    switch(state){
      is(IDLE){
        when(keeper.rxk === False){
          subDiv.rst()
          state:= START
        }
      }
      is(START){
        when(subDiv.tick){
          state:=DATA
          bitCnt.rst()
        }
      }
      is(DATA){
        when(subDiv.tick){
          when(bitCnt.value === 7){
            state:=STOP
            io.data.valid:=True
          }
          io.data.payload(bitCnt.value):=keeper.rxk
        }
      }
      is(STOP){
        when(subDiv.tick){
          state:=IDLE
        }
      }
    }

    when(io.data.valid && io.data.ready){
      io.data.valid:=False
    }
  }
  val lState = RegNextWhen(stateMac.state =/= UartState.IDLE,subDiv.tick,False)
  io.busy:=(stateMac.state=/=UartState.IDLE) || lState
}

//Define a custom SpinalHDL configuration with synchronous reset instead of the default asynchronous one. This configuration can be resued everywhere
object UART_RX_Cfg extends SpinalConfig(
  defaultConfigForClockDomains = ClockDomainConfig(
    resetKind = ASYNC,
    resetActiveLevel = LOW
  )
)

//Generate the MyTopLevel's Verilog using the above custom configuration.
object UART_RX_cfg_O {
  def main(args: Array[String]) {
    UART_RX_Cfg.generateVerilog(new UART_RX)
  }
}