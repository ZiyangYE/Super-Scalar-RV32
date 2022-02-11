// Generator : SpinalHDL v1.6.0    git head : 73c8d8e2b86b45646e9d0b2e729291f2b65e6be3
// Component : UART_APB



module UART_APB (
  input      [3:0]    io_apb_PADDR,
  input      [0:0]    io_apb_PSEL,
  input               io_apb_PENABLE,
  output reg          io_apb_PREADY,
  input               io_apb_PWRITE,
  input      [31:0]   io_apb_PWDATA,
  output reg [31:0]   io_apb_PRDATA,
  output              io_apb_PSLVERROR,
  output              io_sio_txdata_valid,
  input               io_sio_txdata_ready,
  output reg [7:0]    io_sio_txdata_payload,
  input               io_sio_rxdata_valid,
  output reg          io_sio_rxdata_ready,
  input      [7:0]    io_sio_rxdata_payload,
  output reg [15:0]   io_sio_reg_ClkDiv,
  output              io_sio_reg_ROverRun,
  input               io_sio_reg_OverRun,
  output     [3:0]    io_sio_reg_TXThreshold,
  output     [3:0]    io_sio_reg_RXThreshold,
  input               io_sio_reg_TXBusy,
  input               io_sio_reg_RXBusy,
  input      [3:0]    io_sio_reg_TXCnt,
  input      [3:0]    io_sio_reg_RXCnt,
  input               clk,
  input               resetn
);
  wire       [2:0]    _zz_when_UART_APB_l137;
  wire       [2:0]    _zz_when_UART_APB_l137_1;
  wire       [2:0]    _zz_when_UART_APB_l144;
  wire       [2:0]    _zz_when_UART_APB_l144_1;
  reg                 ByteOrder;
  reg        [1:0]    AccessWidth;
  wire                busCtr_askWrite;
  wire                busCtr_askRead;
  wire                busCtr_doWrite;
  wire                busCtr_doRead;
  reg        [31:0]   CtrConvert_RPort;
  reg        [31:0]   CtrConvert_WPort;
  reg        [2:0]    CtrConvert_AccCfg;
  reg        [2:0]    CtrConvert_LstCfg;
  reg        [1:0]    TXConvert_counter;
  reg                 TXConvert_WritingSignal;
  wire                when_UART_APB_l68;
  wire                when_UART_APB_l74;
  reg        [7:0]    _zz_io_sio_txdata_payload;
  reg        [7:0]    _zz_io_sio_txdata_payload_1;
  wire                when_UART_APB_l92;
  wire                when_UART_APB_l97;
  reg        [2:0]    RXConvert_counter;
  reg                 RXConvert_ReadingSignal;
  reg        [31:0]   RXConvert_rxdata;
  wire                when_UART_APB_l114;
  wire                when_UART_APB_l121;
  wire                when_UART_APB_l137;
  wire                when_UART_APB_l144;
  wire                when_UART_APB_l152;

  assign _zz_when_UART_APB_l137 = (_zz_when_UART_APB_l137_1 + 3'b001);
  assign _zz_when_UART_APB_l137_1 = {1'd0, AccessWidth};
  assign _zz_when_UART_APB_l144 = (_zz_when_UART_APB_l144_1 + 3'b001);
  assign _zz_when_UART_APB_l144_1 = {1'd0, AccessWidth};
  always @(*) begin
    io_apb_PREADY = 1'b1;
    if(TXConvert_WritingSignal) begin
      if(when_UART_APB_l97) begin
        io_apb_PREADY = 1'b0;
      end
    end
    if(RXConvert_ReadingSignal) begin
      if(when_UART_APB_l144) begin
        io_apb_PREADY = 1'b0;
      end
    end
  end

  always @(*) begin
    io_apb_PRDATA = 32'h0;
    case(io_apb_PADDR)
      4'b1100 : begin
        io_apb_PRDATA[31 : 0] = RXConvert_rxdata;
      end
      4'b0000 : begin
        io_apb_PRDATA[31 : 0] = CtrConvert_RPort;
      end
      4'b0100 : begin
        io_apb_PRDATA[15 : 0] = io_sio_reg_ClkDiv;
      end
      default : begin
      end
    endcase
  end

  assign io_apb_PSLVERROR = 1'b0;
  assign busCtr_askWrite = ((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PWRITE);
  assign busCtr_askRead = ((io_apb_PSEL[0] && io_apb_PENABLE) && (! io_apb_PWRITE));
  assign busCtr_doWrite = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && io_apb_PWRITE);
  assign busCtr_doRead = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && (! io_apb_PWRITE));
  always @(*) begin
    CtrConvert_AccCfg[2 : 1] = AccessWidth;
    CtrConvert_AccCfg[0] = ByteOrder;
  end

  always @(*) begin
    CtrConvert_RPort = 32'h0;
    CtrConvert_RPort[3 : 0] = io_sio_reg_RXCnt;
    CtrConvert_RPort[7 : 4] = io_sio_reg_TXCnt;
    CtrConvert_RPort[8] = io_sio_reg_RXBusy;
    CtrConvert_RPort[9] = io_sio_reg_TXBusy;
    CtrConvert_RPort[19 : 16] = io_sio_reg_RXThreshold;
    CtrConvert_RPort[23 : 20] = io_sio_reg_TXThreshold;
    CtrConvert_RPort[24] = io_sio_reg_OverRun;
    CtrConvert_RPort[25] = ByteOrder;
    CtrConvert_RPort[27 : 26] = AccessWidth;
  end

  assign io_sio_reg_RXThreshold = CtrConvert_WPort[19 : 16];
  assign io_sio_reg_TXThreshold = CtrConvert_WPort[23 : 20];
  assign io_sio_reg_ROverRun = CtrConvert_WPort[24];
  always @(*) begin
    TXConvert_WritingSignal = 1'b0;
    if(when_UART_APB_l68) begin
      TXConvert_WritingSignal = 1'b1;
    end
  end

  assign when_UART_APB_l68 = ((((io_apb_PADDR == 4'b1000) && (io_apb_PENABLE == 1'b1)) && (io_apb_PWRITE == 1'b1)) && (io_apb_PSEL[0] == 1'b1));
  assign when_UART_APB_l74 = (ByteOrder == 1'b0);
  always @(*) begin
    case(TXConvert_counter)
      2'b00 : begin
        _zz_io_sio_txdata_payload = io_apb_PWDATA[7 : 0];
      end
      2'b01 : begin
        _zz_io_sio_txdata_payload = io_apb_PWDATA[15 : 8];
      end
      2'b10 : begin
        _zz_io_sio_txdata_payload = io_apb_PWDATA[23 : 16];
      end
      default : begin
        _zz_io_sio_txdata_payload = io_apb_PWDATA[31 : 24];
      end
    endcase
  end

  always @(*) begin
    if(when_UART_APB_l74) begin
      io_sio_txdata_payload = _zz_io_sio_txdata_payload;
    end else begin
      io_sio_txdata_payload = _zz_io_sio_txdata_payload_1;
    end
  end

  always @(*) begin
    case(TXConvert_counter)
      2'b00 : begin
        _zz_io_sio_txdata_payload_1 = io_apb_PWDATA[31 : 24];
      end
      2'b01 : begin
        _zz_io_sio_txdata_payload_1 = io_apb_PWDATA[23 : 16];
      end
      2'b10 : begin
        _zz_io_sio_txdata_payload_1 = io_apb_PWDATA[15 : 8];
      end
      default : begin
        _zz_io_sio_txdata_payload_1 = io_apb_PWDATA[7 : 0];
      end
    endcase
  end

  assign io_sio_txdata_valid = TXConvert_WritingSignal;
  assign when_UART_APB_l92 = (! TXConvert_WritingSignal);
  assign when_UART_APB_l97 = ((TXConvert_counter != AccessWidth) || (io_sio_txdata_ready == 1'b0));
  always @(*) begin
    RXConvert_ReadingSignal = 1'b0;
    if(when_UART_APB_l114) begin
      RXConvert_ReadingSignal = 1'b1;
    end
  end

  assign when_UART_APB_l114 = ((((io_apb_PADDR == 4'b1100) && (io_apb_PENABLE == 1'b1)) && (io_apb_PWRITE == 1'b0)) && (io_apb_PSEL[0] == 1'b1));
  always @(*) begin
    io_sio_rxdata_ready = 1'b0;
    if(when_UART_APB_l137) begin
      io_sio_rxdata_ready = 1'b1;
    end
  end

  assign when_UART_APB_l121 = (ByteOrder == 1'b0);
  assign when_UART_APB_l137 = ((RXConvert_counter != _zz_when_UART_APB_l137) && RXConvert_ReadingSignal);
  assign when_UART_APB_l144 = (RXConvert_counter != _zz_when_UART_APB_l144);
  assign when_UART_APB_l152 = (CtrConvert_AccCfg != CtrConvert_LstCfg);
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      ByteOrder <= 1'b0;
      AccessWidth <= 2'b00;
      CtrConvert_WPort <= 32'h0;
      TXConvert_counter <= 2'b00;
      RXConvert_counter <= 3'b000;
      RXConvert_rxdata <= 32'h0;
      io_sio_reg_ClkDiv <= 16'h0;
    end else begin
      ByteOrder <= CtrConvert_WPort[25];
      AccessWidth <= CtrConvert_WPort[27 : 26];
      CtrConvert_WPort[24] <= 1'b0;
      if(when_UART_APB_l92) begin
        TXConvert_counter <= 2'b00;
      end
      if(TXConvert_WritingSignal) begin
        if(io_sio_txdata_ready) begin
          TXConvert_counter <= (TXConvert_counter + 2'b01);
        end
      end
      if(when_UART_APB_l121) begin
        case(RXConvert_counter)
          3'b000 : begin
            RXConvert_rxdata[7 : 0] <= io_sio_rxdata_payload;
          end
          3'b001 : begin
            RXConvert_rxdata[15 : 8] <= io_sio_rxdata_payload;
          end
          3'b010 : begin
            RXConvert_rxdata[23 : 16] <= io_sio_rxdata_payload;
          end
          3'b011 : begin
            RXConvert_rxdata[31 : 24] <= io_sio_rxdata_payload;
          end
          default : begin
          end
        endcase
      end else begin
        case(RXConvert_counter)
          3'b000 : begin
            RXConvert_rxdata[31 : 24] <= io_sio_rxdata_payload;
          end
          3'b001 : begin
            RXConvert_rxdata[23 : 16] <= io_sio_rxdata_payload;
          end
          3'b010 : begin
            RXConvert_rxdata[15 : 8] <= io_sio_rxdata_payload;
          end
          3'b011 : begin
            RXConvert_rxdata[7 : 0] <= io_sio_rxdata_payload;
          end
          default : begin
          end
        endcase
      end
      if(when_UART_APB_l137) begin
        if(io_sio_rxdata_valid) begin
          RXConvert_counter <= (RXConvert_counter + 3'b001);
        end
      end
      if(RXConvert_ReadingSignal) begin
        if(!when_UART_APB_l144) begin
          RXConvert_counter <= 3'b000;
        end
      end
      if(when_UART_APB_l152) begin
        TXConvert_counter <= 2'b00;
        RXConvert_counter <= 3'b000;
      end
      case(io_apb_PADDR)
        4'b0000 : begin
          if(busCtr_doWrite) begin
            CtrConvert_WPort <= io_apb_PWDATA[31 : 0];
          end
        end
        4'b0100 : begin
          if(busCtr_doWrite) begin
            io_sio_reg_ClkDiv <= io_apb_PWDATA[15 : 0];
          end
        end
        default : begin
        end
      endcase
    end
  end

  always @(posedge clk) begin
    CtrConvert_LstCfg <= CtrConvert_AccCfg;
  end


endmodule
