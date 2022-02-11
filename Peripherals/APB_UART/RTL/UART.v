// Generator : SpinalHDL v1.6.0    git head : 73c8d8e2b86b45646e9d0b2e729291f2b65e6be3
// Component : UART


`define UartState_binary_sequential_type [1:0]
`define UartState_binary_sequential_IDLE 2'b00
`define UartState_binary_sequential_START 2'b01
`define UartState_binary_sequential_DATA 2'b10
`define UartState_binary_sequential_STOP 2'b11

`define UartState_1_binary_sequential_type [1:0]
`define UartState_1_binary_sequential_IDLE 2'b00
`define UartState_1_binary_sequential_START 2'b01
`define UartState_1_binary_sequential_DATA 2'b10
`define UartState_1_binary_sequential_STOP 2'b11


module UART (
  input               sio_txdata_valid,
  output              sio_txdata_ready,
  input      [7:0]    sio_txdata_payload,
  output              sio_rxdata_valid,
  input               sio_rxdata_ready,
  output     [7:0]    sio_rxdata_payload,
  input      [15:0]   sio_reg_ClkDiv,
  input               sio_reg_ROverRun,
  output reg          sio_reg_OverRun,
  input      [3:0]    sio_reg_TXThreshold,
  input      [3:0]    sio_reg_RXThreshold,
  output              sio_reg_TXBusy,
  output              sio_reg_RXBusy,
  output     [3:0]    sio_reg_TXCnt,
  output     [3:0]    sio_reg_RXCnt,
  output              eio_txd,
  input               eio_rxd,
  output              int_TXFIFOEmpty,
  output              int_RXFIFOFull,
  input               clk,
  input               resetn
);
  reg                 rx_io_data_ready;
  wire                tx_io_data_ready;
  wire                tx_io_txd;
  wire                tx_io_busy;
  wire                rx_io_data_valid;
  wire       [7:0]    rx_io_data_payload;
  wire                rx_io_busy;
  wire                RXStream_io_push_ready;
  wire                RXStream_io_pop_valid;
  wire       [7:0]    RXStream_io_pop_payload;
  wire       [2:0]    RXStream_io_occupancy;
  wire       [2:0]    RXStream_io_availability;
  wire                TXStream_io_push_ready;
  wire                TXStream_io_pop_valid;
  wire       [7:0]    TXStream_io_pop_payload;
  wire       [2:0]    TXStream_io_occupancy;
  wire       [2:0]    TXStream_io_availability;
  reg        [15:0]   tickgen_counter;
  wire                tickgen_tick;
  wire                when_UART_l114;
  wire                when_Stream_l408;
  reg                 tr_valid;
  wire                tr_ready;
  wire       [7:0]    tr_payload;
  wire                when_UART_l131;

  UART_TX tx (
    .io_tick            (tickgen_tick             ), //i
    .io_data_valid      (TXStream_io_pop_valid    ), //i
    .io_data_ready      (tx_io_data_ready         ), //o
    .io_data_payload    (TXStream_io_pop_payload  ), //i
    .io_txd             (tx_io_txd                ), //o
    .io_busy            (tx_io_busy               ), //o
    .clk                (clk                      ), //i
    .resetn             (resetn                   )  //i
  );
  UART_RX rx (
    .io_tick            (tickgen_tick        ), //i
    .io_data_valid      (rx_io_data_valid    ), //o
    .io_data_ready      (rx_io_data_ready    ), //i
    .io_data_payload    (rx_io_data_payload  ), //o
    .io_rxd             (eio_rxd             ), //i
    .io_busy            (rx_io_busy          ), //o
    .clk                (clk                 ), //i
    .resetn             (resetn              )  //i
  );
  StreamFifo RXStream (
    .io_push_valid      (tr_valid                  ), //i
    .io_push_ready      (RXStream_io_push_ready    ), //o
    .io_push_payload    (tr_payload                ), //i
    .io_pop_valid       (RXStream_io_pop_valid     ), //o
    .io_pop_ready       (sio_rxdata_ready          ), //i
    .io_pop_payload     (RXStream_io_pop_payload   ), //o
    .io_flush           (1'b0                      ), //i
    .io_occupancy       (RXStream_io_occupancy     ), //o
    .io_availability    (RXStream_io_availability  ), //o
    .clk                (clk                       ), //i
    .resetn             (resetn                    )  //i
  );
  StreamFifo TXStream (
    .io_push_valid      (sio_txdata_valid          ), //i
    .io_push_ready      (TXStream_io_push_ready    ), //o
    .io_push_payload    (sio_txdata_payload        ), //i
    .io_pop_valid       (TXStream_io_pop_valid     ), //o
    .io_pop_ready       (tx_io_data_ready          ), //i
    .io_pop_payload     (TXStream_io_pop_payload   ), //o
    .io_flush           (1'b0                      ), //i
    .io_occupancy       (TXStream_io_occupancy     ), //o
    .io_availability    (TXStream_io_availability  ), //o
    .clk                (clk                       ), //i
    .resetn             (resetn                    )  //i
  );
  assign sio_reg_TXCnt = {1'd0, TXStream_io_occupancy};
  assign sio_reg_RXCnt = {1'd0, RXStream_io_occupancy};
  assign sio_reg_TXBusy = tx_io_busy;
  assign sio_reg_RXBusy = rx_io_busy;
  assign sio_txdata_ready = TXStream_io_push_ready;
  assign sio_rxdata_valid = RXStream_io_pop_valid;
  assign sio_rxdata_payload = RXStream_io_pop_payload;
  assign int_RXFIFOFull = (sio_reg_RXThreshold < sio_reg_RXCnt);
  assign int_TXFIFOEmpty = (sio_reg_TXCnt < sio_reg_TXThreshold);
  assign tickgen_tick = (tickgen_counter == 16'h0);
  assign when_UART_l114 = ((tickgen_counter == 16'h0) || (sio_reg_ClkDiv < tickgen_counter));
  assign eio_txd = tx_io_txd;
  assign when_Stream_l408 = (RXStream_io_occupancy == 3'b011);
  always @(*) begin
    tr_valid = rx_io_data_valid;
    if(when_Stream_l408) begin
      tr_valid = 1'b0;
    end
  end

  always @(*) begin
    rx_io_data_ready = tr_ready;
    if(when_Stream_l408) begin
      rx_io_data_ready = 1'b1;
    end
  end

  assign tr_payload = rx_io_data_payload;
  assign tr_ready = RXStream_io_push_ready;
  assign when_UART_l131 = (rx_io_data_valid && (RXStream_io_occupancy == 3'b011));
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      tickgen_counter <= 16'h0;
      sio_reg_OverRun <= 1'b0;
    end else begin
      if(when_UART_l114) begin
        tickgen_counter <= sio_reg_ClkDiv;
      end else begin
        tickgen_counter <= (tickgen_counter - 16'h0001);
      end
      if(when_UART_l131) begin
        sio_reg_OverRun <= 1'b1;
      end
      if(sio_reg_ROverRun) begin
        sio_reg_OverRun <= 1'b0;
      end
    end
  end


endmodule

//StreamFifo replaced by StreamFifo

module StreamFifo (
  input               io_push_valid,
  output              io_push_ready,
  input      [7:0]    io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [7:0]    io_pop_payload,
  input               io_flush,
  output     [2:0]    io_occupancy,
  output     [2:0]    io_availability,
  input               clk,
  input               resetn
);
  reg        [7:0]    _zz_logic_ram_port0;
  wire       [1:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [1:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [1:0]    _zz_io_availability;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [1:0]    logic_pushPtr_valueNext;
  reg        [1:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [1:0]    logic_popPtr_valueNext;
  reg        [1:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_io_pop_valid;
  wire                when_Stream_l933;
  wire       [1:0]    logic_ptrDif;
  reg [7:0] logic_ram [0:3];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {1'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {1'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_io_availability = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_pop_payload = 1'b1;
  always @(posedge clk) begin
    if(_zz_io_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= io_push_payload;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 2'b11);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 2'b00;
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 2'b11);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 2'b00;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_io_pop_valid && (! logic_full))));
  assign io_pop_payload = _zz_logic_ram_port0;
  assign when_Stream_l933 = (logic_pushing != logic_popping);
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_io_availability};
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      logic_pushPtr_value <= 2'b00;
      logic_popPtr_value <= 2'b00;
      logic_risingOccupancy <= 1'b0;
      _zz_io_pop_valid <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_io_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if(when_Stream_l933) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module UART_RX (
  input               io_tick,
  output reg          io_data_valid,
  input               io_data_ready,
  output reg [7:0]    io_data_payload,
  input               io_rxd,
  output              io_busy,
  input               clk,
  input               resetn
);
  reg        [2:0]    subDiv_counter;
  reg                 subDiv_tick;
  wire                when_UART_RX_l33;
  reg        [2:0]    bitCnt_value;
  reg        [2:0]    keeper_counter;
  reg                 keeper_rxk;
  wire                when_UART_RX_l55;
  wire                when_UART_RX_l57;
  reg        `UartState_1_binary_sequential_type stateMac_state;
  wire                when_UART_RX_l75;
  wire                when_UART_RX_l88;
  wire                when_UART_RX_l102;
  reg                 lState;
  `ifndef SYNTHESIS
  reg [39:0] stateMac_state_string;
  `endif


  `ifndef SYNTHESIS
  always @(*) begin
    case(stateMac_state)
      `UartState_1_binary_sequential_IDLE : stateMac_state_string = "IDLE ";
      `UartState_1_binary_sequential_START : stateMac_state_string = "START";
      `UartState_1_binary_sequential_DATA : stateMac_state_string = "DATA ";
      `UartState_1_binary_sequential_STOP : stateMac_state_string = "STOP ";
      default : stateMac_state_string = "?????";
    endcase
  end
  `endif

  assign when_UART_RX_l33 = (subDiv_counter == 3'b000);
  assign when_UART_RX_l55 = (keeper_rxk != io_rxd);
  assign when_UART_RX_l57 = (3'b001 < keeper_counter);
  assign when_UART_RX_l75 = (keeper_rxk == 1'b0);
  assign when_UART_RX_l88 = (bitCnt_value == 3'b111);
  assign when_UART_RX_l102 = (io_data_valid && io_data_ready);
  assign io_busy = ((stateMac_state != `UartState_1_binary_sequential_IDLE) || lState);
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      io_data_payload <= 8'h0;
      io_data_valid <= 1'b0;
      subDiv_counter <= 3'b000;
      keeper_counter <= 3'b000;
      keeper_rxk <= 1'b1;
      stateMac_state <= `UartState_1_binary_sequential_IDLE;
      lState <= 1'b0;
    end else begin
      if(io_tick) begin
        if(when_UART_RX_l33) begin
          subDiv_counter <= 3'b111;
        end else begin
          subDiv_counter <= (subDiv_counter - 3'b001);
        end
      end
      if(io_tick) begin
        if(when_UART_RX_l55) begin
          keeper_counter <= (keeper_counter + 3'b001);
          if(when_UART_RX_l57) begin
            keeper_counter <= 3'b000;
            keeper_rxk <= (! keeper_rxk);
          end
        end else begin
          keeper_counter <= 3'b000;
        end
      end
      case(stateMac_state)
        `UartState_1_binary_sequential_IDLE : begin
          if(when_UART_RX_l75) begin
            subDiv_counter <= 3'b010;
            stateMac_state <= `UartState_1_binary_sequential_START;
          end
        end
        `UartState_1_binary_sequential_START : begin
          if(subDiv_tick) begin
            stateMac_state <= `UartState_1_binary_sequential_DATA;
          end
        end
        `UartState_1_binary_sequential_DATA : begin
          if(subDiv_tick) begin
            if(when_UART_RX_l88) begin
              stateMac_state <= `UartState_1_binary_sequential_STOP;
              io_data_valid <= 1'b1;
            end
            io_data_payload[bitCnt_value] <= keeper_rxk;
          end
        end
        default : begin
          if(subDiv_tick) begin
            stateMac_state <= `UartState_1_binary_sequential_IDLE;
          end
        end
      endcase
      if(when_UART_RX_l102) begin
        io_data_valid <= 1'b0;
      end
      if(subDiv_tick) begin
        lState <= (stateMac_state != `UartState_1_binary_sequential_IDLE);
      end
    end
  end

  always @(posedge clk) begin
    subDiv_tick <= ((subDiv_counter == 3'b000) && io_tick);
    if(subDiv_tick) begin
      bitCnt_value <= (bitCnt_value + 3'b001);
    end
    case(stateMac_state)
      `UartState_1_binary_sequential_IDLE : begin
        if(when_UART_RX_l75) begin
          subDiv_tick <= 1'b0;
        end
      end
      `UartState_1_binary_sequential_START : begin
        if(subDiv_tick) begin
          bitCnt_value <= 3'b000;
        end
      end
      `UartState_1_binary_sequential_DATA : begin
      end
      default : begin
      end
    endcase
  end


endmodule

module UART_TX (
  input               io_tick,
  input               io_data_valid,
  output reg          io_data_ready,
  input      [7:0]    io_data_payload,
  output              io_txd,
  output              io_busy,
  input               clk,
  input               resetn
);
  reg        [2:0]    subDiv_counter;
  reg                 subDiv_tick;
  wire                when_UART_TX_l30;
  reg        [2:0]    bitCnt_value;
  reg        `UartState_binary_sequential_type stateMac_state;
  reg                 stateMac_txd;
  reg                 io_tick_regNext;
  wire                when_UART_TX_l60;
  wire                when_UART_TX_l74;
  reg                 stateMac_txd_regNext;
  `ifndef SYNTHESIS
  reg [39:0] stateMac_state_string;
  `endif


  `ifndef SYNTHESIS
  always @(*) begin
    case(stateMac_state)
      `UartState_binary_sequential_IDLE : stateMac_state_string = "IDLE ";
      `UartState_binary_sequential_START : stateMac_state_string = "START";
      `UartState_binary_sequential_DATA : stateMac_state_string = "DATA ";
      `UartState_binary_sequential_STOP : stateMac_state_string = "STOP ";
      default : stateMac_state_string = "?????";
    endcase
  end
  `endif

  assign when_UART_TX_l30 = (subDiv_counter == 3'b000);
  always @(*) begin
    io_data_ready = 1'b0;
    case(stateMac_state)
      `UartState_binary_sequential_IDLE : begin
      end
      `UartState_binary_sequential_START : begin
      end
      `UartState_binary_sequential_DATA : begin
        if(when_UART_TX_l74) begin
          io_data_ready = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    stateMac_txd = 1'b1;
    case(stateMac_state)
      `UartState_binary_sequential_IDLE : begin
      end
      `UartState_binary_sequential_START : begin
        stateMac_txd = 1'b0;
      end
      `UartState_binary_sequential_DATA : begin
        stateMac_txd = io_data_payload[bitCnt_value];
      end
      default : begin
      end
    endcase
  end

  assign when_UART_TX_l60 = (io_data_valid && io_tick_regNext);
  assign when_UART_TX_l74 = ((bitCnt_value == 3'b111) && subDiv_tick);
  assign io_txd = stateMac_txd_regNext;
  assign io_busy = (stateMac_state != `UartState_binary_sequential_IDLE);
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      subDiv_counter <= 3'b000;
      stateMac_state <= `UartState_binary_sequential_IDLE;
      stateMac_txd_regNext <= 1'b1;
    end else begin
      if(io_tick) begin
        if(when_UART_TX_l30) begin
          subDiv_counter <= 3'b111;
        end else begin
          subDiv_counter <= (subDiv_counter - 3'b001);
        end
      end
      case(stateMac_state)
        `UartState_binary_sequential_IDLE : begin
          if(when_UART_TX_l60) begin
            subDiv_counter <= 3'b111;
            stateMac_state <= `UartState_binary_sequential_START;
          end
        end
        `UartState_binary_sequential_START : begin
          if(subDiv_tick) begin
            stateMac_state <= `UartState_binary_sequential_DATA;
          end
        end
        `UartState_binary_sequential_DATA : begin
          if(when_UART_TX_l74) begin
            stateMac_state <= `UartState_binary_sequential_STOP;
          end
        end
        default : begin
          if(subDiv_tick) begin
            if(io_data_valid) begin
              stateMac_state <= `UartState_binary_sequential_START;
            end else begin
              stateMac_state <= `UartState_binary_sequential_IDLE;
            end
          end
        end
      endcase
      stateMac_txd_regNext <= stateMac_txd;
    end
  end

  always @(posedge clk) begin
    subDiv_tick <= ((subDiv_counter == 3'b000) && io_tick);
    if(subDiv_tick) begin
      bitCnt_value <= (bitCnt_value + 3'b001);
    end
    case(stateMac_state)
      `UartState_binary_sequential_IDLE : begin
        if(when_UART_TX_l60) begin
          subDiv_tick <= 1'b0;
        end
      end
      `UartState_binary_sequential_START : begin
        if(subDiv_tick) begin
          bitCnt_value <= 3'b000;
        end
      end
      `UartState_binary_sequential_DATA : begin
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk) begin
    io_tick_regNext <= io_tick;
  end


endmodule
