// Generator : SpinalHDL v1.6.0    git head : 73c8d8e2b86b45646e9d0b2e729291f2b65e6be3
// Component : icache


`define cacheState_binary_sequential_type [1:0]
`define cacheState_binary_sequential_IDLE 2'b00
`define cacheState_binary_sequential_READ 2'b01
`define cacheState_binary_sequential_ASSERT_1 2'b10


module icache (
  input               romIO_memFlow_valid,
  input      [7:0]    romIO_memFlow_payload,
  output reg [14:0]   romIO_memAddr,
  output reg [63:0]   cacheIO_readData,
  output reg [1:0]    cacheIO_readValid,
  input      [31:0]   cacheIO_readAddr,
  input               clk,
  input               resetn
);
  wire       [31:0]   _zz__zz_5_port0;
  wire       [31:0]   _zz__zz_5_port1;
  wire       [31:0]   _zz__zz_6_port0;
  wire       [31:0]   _zz__zz_6_port1;
  wire       [31:0]   _zz__zz_7_port0;
  wire       [31:0]   _zz__zz_7_port1;
  wire       [31:0]   _zz__zz_8_port0;
  wire       [31:0]   _zz__zz_8_port1;
  wire       [31:0]   _zz__zz_when_icache_l99_4;
  wire       [31:0]   _zz__zz_when_icache_l99_4_1;
  wire       [2:0]    _zz__zz_when_icache_l99_4_2;
  wire       [31:0]   _zz__zz_cacheIO_readData_2;
  wire       [31:0]   _zz__zz_cacheIO_readData_2_1;
  wire       [2:0]    _zz__zz_cacheIO_readData_2_2;
  wire       [63:0]   _zz_requestRead;
  wire       [5:0]    _zz_requestRead_1;
  wire       [63:0]   _zz__zz_cacheIO_readValid;
  wire       [5:0]    _zz__zz_cacheIO_readValid_1;
  wire       [63:0]   _zz_requestRead_2;
  wire       [5:0]    _zz_requestRead_3;
  wire       [63:0]   _zz__zz_cacheIO_readValid_2;
  wire       [5:0]    _zz__zz_cacheIO_readValid_3;
  wire       [63:0]   _zz_requestRead_4;
  wire       [5:0]    _zz_requestRead_5;
  wire       [63:0]   _zz__zz_cacheIO_readValid_4;
  wire       [5:0]    _zz__zz_cacheIO_readValid_5;
  wire       [63:0]   _zz_requestRead_6;
  wire       [5:0]    _zz_requestRead_7;
  wire       [63:0]   _zz__zz_cacheIO_readValid_6;
  wire       [5:0]    _zz__zz_cacheIO_readValid_7;
  wire       [31:0]   _zz__zz_when_icache_l99_5;
  wire       [31:0]   _zz__zz_when_icache_l99_5_1;
  wire       [3:0]    _zz__zz_when_icache_l99_5_2;
  wire       [31:0]   _zz__zz_cacheIO_readData_7;
  wire       [31:0]   _zz__zz_cacheIO_readData_7_1;
  wire       [3:0]    _zz__zz_cacheIO_readData_7_2;
  wire       [63:0]   _zz__zz_cacheIO_readValid_1_1;
  wire       [5:0]    _zz__zz_cacheIO_readValid_1_2;
  wire       [63:0]   _zz__zz_cacheIO_readValid_1_3;
  wire       [5:0]    _zz__zz_cacheIO_readValid_1_4;
  wire       [63:0]   _zz__zz_cacheIO_readValid_1_5;
  wire       [5:0]    _zz__zz_cacheIO_readValid_1_6;
  wire       [63:0]   _zz__zz_cacheIO_readValid_1_7;
  wire       [5:0]    _zz__zz_cacheIO_readValid_1_8;
  wire       [1:0]    _zz_when_icache_l120;
  wire       [1:0]    _zz_when_icache_l120_1;
  wire       [1:0]    _zz_when_icache_l120_2;
  wire       [1:0]    _zz_when_icache_l120_3;
  wire       [8:0]    _zz_readSM_avrOffset;
  wire       [31:0]   _zz__zz_5_port;
  wire       [31:0]   _zz__zz_6_port;
  wire       [31:0]   _zz__zz_7_port;
  wire       [31:0]   _zz__zz_8_port;
  wire       [31:0]   _zz_romIO_memAddr;
  wire       [5:0]    _zz_readSM_romReadReg;
  wire       [31:0]   _zz_romIO_memAddr_1;
  wire       [7:0]    _zz_cacheLineAvr;
  wire       [7:0]    _zz_cacheLineAvr_1;
  wire       [31:0]   _zz_when_icache_l263;
  reg                 _zz_1;
  reg                 _zz_2;
  reg                 _zz_3;
  reg                 _zz_4;
  reg        [31:0]   _zz_cacheIO_readData;
  reg                 _zz_cacheIO_readValid;
  reg        [31:0]   _zz_cacheIO_readData_1;
  reg                 _zz_cacheIO_readValid_1;
  reg        [255:0]  cacheLineAvr;
  reg        [23:0]   _zz_when_icache_l99;
  reg        [1:0]    _zz_matchedPage;
  reg        [23:0]   _zz_when_icache_l99_1;
  reg        [1:0]    _zz_matchedPage_1;
  reg        [23:0]   _zz_when_icache_l99_2;
  reg        [1:0]    _zz_matchedPage_2;
  reg        [23:0]   _zz_when_icache_l99_3;
  reg        [1:0]    _zz_matchedPage_3;
  reg                 requestRead;
  reg                 inPage;
  reg        [1:0]    matchedPage;
  wire       [23:0]   _zz_when_icache_l99_4;
  wire       [7:0]    _zz_cacheIO_readData_2;
  wire                when_icache_l99;
  wire       [5:0]    _zz_cacheIO_readData_3;
  wire                when_icache_l99_1;
  wire       [5:0]    _zz_cacheIO_readData_4;
  wire                when_icache_l99_2;
  wire       [5:0]    _zz_cacheIO_readData_5;
  wire                when_icache_l99_3;
  wire       [5:0]    _zz_cacheIO_readData_6;
  wire       [23:0]   _zz_when_icache_l99_5;
  wire       [7:0]    _zz_cacheIO_readData_7;
  wire                when_icache_l99_4;
  wire       [5:0]    _zz_cacheIO_readData_8;
  wire                when_icache_l99_5;
  wire       [5:0]    _zz_cacheIO_readData_9;
  wire                when_icache_l99_6;
  wire       [5:0]    _zz_cacheIO_readData_10;
  wire                when_icache_l99_7;
  wire       [5:0]    _zz_cacheIO_readData_11;
  wire       [23:0]   ioHighAddr;
  wire       [7:0]    ioLowAddr;
  wire                when_icache_l115;
  wire                when_icache_l117;
  wire                when_icache_l120;
  wire                when_icache_l117_1;
  wire                when_icache_l120_1;
  wire                when_icache_l117_2;
  wire                when_icache_l120_2;
  wire                when_icache_l117_3;
  wire                when_icache_l120_3;
  reg                 pageReAssign;
  wire                when_icache_l127;
  wire                when_icache_l129;
  wire                when_icache_l129_1;
  wire                when_icache_l129_2;
  wire                when_icache_l129_3;
  reg                 doRead;
  reg        [31:0]   readPos;
  reg        [1:0]    readPart;
  wire       [5:0]    readLowPos;
  wire       [23:0]   readHighPos;
  wire                when_icache_l157;
  wire                when_icache_l157_1;
  wire                when_icache_l157_2;
  wire                when_icache_l157_3;
  wire                when_icache_l163;
  wire                when_icache_l163_1;
  wire                when_icache_l163_2;
  wire                when_icache_l163_3;
  wire                when_icache_l185;
  wire       [63:0]   _zz_when_icache_l175;
  reg        [5:0]    _zz_readPos;
  wire                when_icache_l175;
  wire                when_icache_l175_1;
  wire                when_icache_l175_2;
  wire                when_icache_l175_3;
  wire                when_icache_l175_4;
  wire                when_icache_l175_5;
  wire                when_icache_l175_6;
  wire                when_icache_l175_7;
  wire                when_icache_l175_8;
  wire                when_icache_l175_9;
  wire                when_icache_l175_10;
  wire                when_icache_l175_11;
  wire                when_icache_l175_12;
  wire                when_icache_l175_13;
  wire                when_icache_l175_14;
  wire                when_icache_l175_15;
  wire                when_icache_l175_16;
  wire                when_icache_l175_17;
  wire                when_icache_l175_18;
  wire                when_icache_l175_19;
  wire                when_icache_l175_20;
  wire                when_icache_l175_21;
  wire                when_icache_l175_22;
  wire                when_icache_l175_23;
  wire                when_icache_l175_24;
  wire                when_icache_l175_25;
  wire                when_icache_l175_26;
  wire                when_icache_l175_27;
  wire                when_icache_l175_28;
  wire                when_icache_l175_29;
  wire                when_icache_l175_30;
  wire                when_icache_l175_31;
  wire                when_icache_l175_32;
  wire                when_icache_l175_33;
  wire                when_icache_l175_34;
  wire                when_icache_l175_35;
  wire                when_icache_l175_36;
  wire                when_icache_l175_37;
  wire                when_icache_l175_38;
  wire                when_icache_l175_39;
  wire                when_icache_l175_40;
  wire                when_icache_l175_41;
  wire                when_icache_l175_42;
  wire                when_icache_l175_43;
  wire                when_icache_l175_44;
  wire                when_icache_l175_45;
  wire                when_icache_l175_46;
  wire                when_icache_l175_47;
  wire                when_icache_l175_48;
  wire                when_icache_l175_49;
  wire                when_icache_l175_50;
  wire                when_icache_l175_51;
  wire                when_icache_l175_52;
  wire                when_icache_l175_53;
  wire                when_icache_l175_54;
  wire                when_icache_l175_55;
  wire                when_icache_l175_56;
  wire                when_icache_l175_57;
  wire                when_icache_l175_58;
  wire                when_icache_l175_59;
  wire                when_icache_l175_60;
  wire                when_icache_l175_61;
  wire                when_icache_l175_62;
  wire                when_icache_l175_63;
  wire                when_icache_l185_1;
  wire       [63:0]   _zz_when_icache_l175_1;
  reg        [5:0]    _zz_readPos_1;
  wire                when_icache_l175_64;
  wire                when_icache_l175_65;
  wire                when_icache_l175_66;
  wire                when_icache_l175_67;
  wire                when_icache_l175_68;
  wire                when_icache_l175_69;
  wire                when_icache_l175_70;
  wire                when_icache_l175_71;
  wire                when_icache_l175_72;
  wire                when_icache_l175_73;
  wire                when_icache_l175_74;
  wire                when_icache_l175_75;
  wire                when_icache_l175_76;
  wire                when_icache_l175_77;
  wire                when_icache_l175_78;
  wire                when_icache_l175_79;
  wire                when_icache_l175_80;
  wire                when_icache_l175_81;
  wire                when_icache_l175_82;
  wire                when_icache_l175_83;
  wire                when_icache_l175_84;
  wire                when_icache_l175_85;
  wire                when_icache_l175_86;
  wire                when_icache_l175_87;
  wire                when_icache_l175_88;
  wire                when_icache_l175_89;
  wire                when_icache_l175_90;
  wire                when_icache_l175_91;
  wire                when_icache_l175_92;
  wire                when_icache_l175_93;
  wire                when_icache_l175_94;
  wire                when_icache_l175_95;
  wire                when_icache_l175_96;
  wire                when_icache_l175_97;
  wire                when_icache_l175_98;
  wire                when_icache_l175_99;
  wire                when_icache_l175_100;
  wire                when_icache_l175_101;
  wire                when_icache_l175_102;
  wire                when_icache_l175_103;
  wire                when_icache_l175_104;
  wire                when_icache_l175_105;
  wire                when_icache_l175_106;
  wire                when_icache_l175_107;
  wire                when_icache_l175_108;
  wire                when_icache_l175_109;
  wire                when_icache_l175_110;
  wire                when_icache_l175_111;
  wire                when_icache_l175_112;
  wire                when_icache_l175_113;
  wire                when_icache_l175_114;
  wire                when_icache_l175_115;
  wire                when_icache_l175_116;
  wire                when_icache_l175_117;
  wire                when_icache_l175_118;
  wire                when_icache_l175_119;
  wire                when_icache_l175_120;
  wire                when_icache_l175_121;
  wire                when_icache_l175_122;
  wire                when_icache_l175_123;
  wire                when_icache_l175_124;
  wire                when_icache_l175_125;
  wire                when_icache_l175_126;
  wire                when_icache_l175_127;
  wire                when_icache_l185_2;
  wire       [63:0]   _zz_when_icache_l175_2;
  reg        [5:0]    _zz_readPos_2;
  wire                when_icache_l175_128;
  wire                when_icache_l175_129;
  wire                when_icache_l175_130;
  wire                when_icache_l175_131;
  wire                when_icache_l175_132;
  wire                when_icache_l175_133;
  wire                when_icache_l175_134;
  wire                when_icache_l175_135;
  wire                when_icache_l175_136;
  wire                when_icache_l175_137;
  wire                when_icache_l175_138;
  wire                when_icache_l175_139;
  wire                when_icache_l175_140;
  wire                when_icache_l175_141;
  wire                when_icache_l175_142;
  wire                when_icache_l175_143;
  wire                when_icache_l175_144;
  wire                when_icache_l175_145;
  wire                when_icache_l175_146;
  wire                when_icache_l175_147;
  wire                when_icache_l175_148;
  wire                when_icache_l175_149;
  wire                when_icache_l175_150;
  wire                when_icache_l175_151;
  wire                when_icache_l175_152;
  wire                when_icache_l175_153;
  wire                when_icache_l175_154;
  wire                when_icache_l175_155;
  wire                when_icache_l175_156;
  wire                when_icache_l175_157;
  wire                when_icache_l175_158;
  wire                when_icache_l175_159;
  wire                when_icache_l175_160;
  wire                when_icache_l175_161;
  wire                when_icache_l175_162;
  wire                when_icache_l175_163;
  wire                when_icache_l175_164;
  wire                when_icache_l175_165;
  wire                when_icache_l175_166;
  wire                when_icache_l175_167;
  wire                when_icache_l175_168;
  wire                when_icache_l175_169;
  wire                when_icache_l175_170;
  wire                when_icache_l175_171;
  wire                when_icache_l175_172;
  wire                when_icache_l175_173;
  wire                when_icache_l175_174;
  wire                when_icache_l175_175;
  wire                when_icache_l175_176;
  wire                when_icache_l175_177;
  wire                when_icache_l175_178;
  wire                when_icache_l175_179;
  wire                when_icache_l175_180;
  wire                when_icache_l175_181;
  wire                when_icache_l175_182;
  wire                when_icache_l175_183;
  wire                when_icache_l175_184;
  wire                when_icache_l175_185;
  wire                when_icache_l175_186;
  wire                when_icache_l175_187;
  wire                when_icache_l175_188;
  wire                when_icache_l175_189;
  wire                when_icache_l175_190;
  wire                when_icache_l175_191;
  wire                when_icache_l185_3;
  wire       [63:0]   _zz_when_icache_l175_3;
  reg        [5:0]    _zz_readPos_3;
  wire                when_icache_l175_192;
  wire                when_icache_l175_193;
  wire                when_icache_l175_194;
  wire                when_icache_l175_195;
  wire                when_icache_l175_196;
  wire                when_icache_l175_197;
  wire                when_icache_l175_198;
  wire                when_icache_l175_199;
  wire                when_icache_l175_200;
  wire                when_icache_l175_201;
  wire                when_icache_l175_202;
  wire                when_icache_l175_203;
  wire                when_icache_l175_204;
  wire                when_icache_l175_205;
  wire                when_icache_l175_206;
  wire                when_icache_l175_207;
  wire                when_icache_l175_208;
  wire                when_icache_l175_209;
  wire                when_icache_l175_210;
  wire                when_icache_l175_211;
  wire                when_icache_l175_212;
  wire                when_icache_l175_213;
  wire                when_icache_l175_214;
  wire                when_icache_l175_215;
  wire                when_icache_l175_216;
  wire                when_icache_l175_217;
  wire                when_icache_l175_218;
  wire                when_icache_l175_219;
  wire                when_icache_l175_220;
  wire                when_icache_l175_221;
  wire                when_icache_l175_222;
  wire                when_icache_l175_223;
  wire                when_icache_l175_224;
  wire                when_icache_l175_225;
  wire                when_icache_l175_226;
  wire                when_icache_l175_227;
  wire                when_icache_l175_228;
  wire                when_icache_l175_229;
  wire                when_icache_l175_230;
  wire                when_icache_l175_231;
  wire                when_icache_l175_232;
  wire                when_icache_l175_233;
  wire                when_icache_l175_234;
  wire                when_icache_l175_235;
  wire                when_icache_l175_236;
  wire                when_icache_l175_237;
  wire                when_icache_l175_238;
  wire                when_icache_l175_239;
  wire                when_icache_l175_240;
  wire                when_icache_l175_241;
  wire                when_icache_l175_242;
  wire                when_icache_l175_243;
  wire                when_icache_l175_244;
  wire                when_icache_l175_245;
  wire                when_icache_l175_246;
  wire                when_icache_l175_247;
  wire                when_icache_l175_248;
  wire                when_icache_l175_249;
  wire                when_icache_l175_250;
  wire                when_icache_l175_251;
  wire                when_icache_l175_252;
  wire                when_icache_l175_253;
  wire                when_icache_l175_254;
  wire                when_icache_l175_255;
  reg        `cacheState_binary_sequential_type readSM_state;
  reg        [31:0]   readSM_romReadReg;
  wire       [1:0]    readSM_readCycles;
  reg        [1:0]    readSM_counter;
  reg        [5:0]    readSM_assignLowPos;
  wire       [7:0]    readSM_avrOffset;
  wire                when_icache_l242;
  wire                when_icache_l258;
  wire                when_icache_l258_1;
  wire                when_icache_l258_2;
  wire                when_icache_l258_3;
  wire                when_icache_l263;
  `ifndef SYNTHESIS
  reg [63:0] readSM_state_string;
  `endif

  (* ram_style = "distributed" *) reg [31:0] _zz_5 [0:63];
  (* ram_style = "distributed" *) reg [31:0] _zz_6 [0:63];
  (* ram_style = "distributed" *) reg [31:0] _zz_7 [0:63];
  (* ram_style = "distributed" *) reg [31:0] _zz_8 [0:63];

  assign _zz_readSM_romReadReg = (readSM_counter * 4'b1000);
  assign _zz__zz_when_icache_l99_4 = (cacheIO_readAddr + _zz__zz_when_icache_l99_4_1);
  assign _zz__zz_when_icache_l99_4_2 = 3'b000;
  assign _zz__zz_when_icache_l99_4_1 = {29'd0, _zz__zz_when_icache_l99_4_2};
  assign _zz__zz_cacheIO_readData_2 = (cacheIO_readAddr + _zz__zz_cacheIO_readData_2_1);
  assign _zz__zz_cacheIO_readData_2_2 = 3'b000;
  assign _zz__zz_cacheIO_readData_2_1 = {29'd0, _zz__zz_cacheIO_readData_2_2};
  assign _zz_requestRead = cacheLineAvr[63 : 0];
  assign _zz_requestRead_1 = (_zz_cacheIO_readData_2 >>> 2);
  assign _zz__zz_cacheIO_readValid = cacheLineAvr[63 : 0];
  assign _zz__zz_cacheIO_readValid_1 = (_zz_cacheIO_readData_2 >>> 2);
  assign _zz_requestRead_2 = cacheLineAvr[127 : 64];
  assign _zz_requestRead_3 = (_zz_cacheIO_readData_2 >>> 2);
  assign _zz__zz_cacheIO_readValid_2 = cacheLineAvr[127 : 64];
  assign _zz__zz_cacheIO_readValid_3 = (_zz_cacheIO_readData_2 >>> 2);
  assign _zz_requestRead_4 = cacheLineAvr[191 : 128];
  assign _zz_requestRead_5 = (_zz_cacheIO_readData_2 >>> 2);
  assign _zz__zz_cacheIO_readValid_4 = cacheLineAvr[191 : 128];
  assign _zz__zz_cacheIO_readValid_5 = (_zz_cacheIO_readData_2 >>> 2);
  assign _zz_requestRead_6 = cacheLineAvr[255 : 192];
  assign _zz_requestRead_7 = (_zz_cacheIO_readData_2 >>> 2);
  assign _zz__zz_cacheIO_readValid_6 = cacheLineAvr[255 : 192];
  assign _zz__zz_cacheIO_readValid_7 = (_zz_cacheIO_readData_2 >>> 2);
  assign _zz__zz_when_icache_l99_5 = (cacheIO_readAddr + _zz__zz_when_icache_l99_5_1);
  assign _zz__zz_when_icache_l99_5_2 = (1'b1 * 3'b100);
  assign _zz__zz_when_icache_l99_5_1 = {28'd0, _zz__zz_when_icache_l99_5_2};
  assign _zz__zz_cacheIO_readData_7 = (cacheIO_readAddr + _zz__zz_cacheIO_readData_7_1);
  assign _zz__zz_cacheIO_readData_7_2 = (1'b1 * 3'b100);
  assign _zz__zz_cacheIO_readData_7_1 = {28'd0, _zz__zz_cacheIO_readData_7_2};
  assign _zz__zz_cacheIO_readValid_1_1 = cacheLineAvr[63 : 0];
  assign _zz__zz_cacheIO_readValid_1_2 = (_zz_cacheIO_readData_7 >>> 2);
  assign _zz__zz_cacheIO_readValid_1_3 = cacheLineAvr[127 : 64];
  assign _zz__zz_cacheIO_readValid_1_4 = (_zz_cacheIO_readData_7 >>> 2);
  assign _zz__zz_cacheIO_readValid_1_5 = cacheLineAvr[191 : 128];
  assign _zz__zz_cacheIO_readValid_1_6 = (_zz_cacheIO_readData_7 >>> 2);
  assign _zz__zz_cacheIO_readValid_1_7 = cacheLineAvr[255 : 192];
  assign _zz__zz_cacheIO_readValid_1_8 = (_zz_cacheIO_readData_7 >>> 2);
  assign _zz_when_icache_l120 = (matchedPage - 2'b01);
  assign _zz_when_icache_l120_1 = (matchedPage - 2'b01);
  assign _zz_when_icache_l120_2 = (matchedPage - 2'b01);
  assign _zz_when_icache_l120_3 = (matchedPage - 2'b01);
  assign _zz_readSM_avrOffset = (readPart * 7'h40);
  assign _zz_romIO_memAddr = (readPos - 32'h0);
  assign _zz_romIO_memAddr_1 = (readPos - 32'h0);
  assign _zz_cacheLineAvr = (readSM_avrOffset + _zz_cacheLineAvr_1);
  assign _zz_cacheLineAvr_1 = {2'd0, readSM_assignLowPos};
  assign _zz_when_icache_l263 = {17'd0, romIO_memAddr};
  assign _zz__zz_5_port = readSM_romReadReg;
  assign _zz__zz_6_port = readSM_romReadReg;
  assign _zz__zz_7_port = readSM_romReadReg;
  assign _zz__zz_8_port = readSM_romReadReg;
  assign _zz__zz_5_port0 = _zz_5[_zz_cacheIO_readData_3];
  assign _zz__zz_5_port1 = _zz_5[_zz_cacheIO_readData_8];
  always @(posedge clk) begin
    if(_zz_4) begin
      _zz_5[readSM_assignLowPos] <= _zz__zz_5_port;
    end
  end

  assign _zz__zz_6_port0 = _zz_6[_zz_cacheIO_readData_4];
  assign _zz__zz_6_port1 = _zz_6[_zz_cacheIO_readData_9];
  always @(posedge clk) begin
    if(_zz_3) begin
      _zz_6[readSM_assignLowPos] <= _zz__zz_6_port;
    end
  end

  assign _zz__zz_7_port0 = _zz_7[_zz_cacheIO_readData_5];
  assign _zz__zz_7_port1 = _zz_7[_zz_cacheIO_readData_10];
  always @(posedge clk) begin
    if(_zz_2) begin
      _zz_7[readSM_assignLowPos] <= _zz__zz_7_port;
    end
  end

  assign _zz__zz_8_port0 = _zz_8[_zz_cacheIO_readData_6];
  assign _zz__zz_8_port1 = _zz_8[_zz_cacheIO_readData_11];
  always @(posedge clk) begin
    if(_zz_1) begin
      _zz_8[readSM_assignLowPos] <= _zz__zz_8_port;
    end
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(readSM_state)
      `cacheState_binary_sequential_IDLE : readSM_state_string = "IDLE    ";
      `cacheState_binary_sequential_READ : readSM_state_string = "READ    ";
      `cacheState_binary_sequential_ASSERT_1 : readSM_state_string = "ASSERT_1";
      default : readSM_state_string = "????????";
    endcase
  end
  `endif

  always @(*) begin
    _zz_1 = 1'b0;
    case(readSM_state)
      `cacheState_binary_sequential_IDLE : begin
      end
      `cacheState_binary_sequential_READ : begin
      end
      default : begin
        if(!pageReAssign) begin
          if(when_icache_l258_3) begin
            _zz_1 = 1'b1;
          end
        end
      end
    endcase
  end

  always @(*) begin
    _zz_2 = 1'b0;
    case(readSM_state)
      `cacheState_binary_sequential_IDLE : begin
      end
      `cacheState_binary_sequential_READ : begin
      end
      default : begin
        if(!pageReAssign) begin
          if(when_icache_l258_2) begin
            _zz_2 = 1'b1;
          end
        end
      end
    endcase
  end

  always @(*) begin
    _zz_3 = 1'b0;
    case(readSM_state)
      `cacheState_binary_sequential_IDLE : begin
      end
      `cacheState_binary_sequential_READ : begin
      end
      default : begin
        if(!pageReAssign) begin
          if(when_icache_l258_1) begin
            _zz_3 = 1'b1;
          end
        end
      end
    endcase
  end

  always @(*) begin
    _zz_4 = 1'b0;
    case(readSM_state)
      `cacheState_binary_sequential_IDLE : begin
      end
      `cacheState_binary_sequential_READ : begin
      end
      default : begin
        if(!pageReAssign) begin
          if(when_icache_l258) begin
            _zz_4 = 1'b1;
          end
        end
      end
    endcase
  end

  always @(*) begin
    cacheIO_readData[31 : 0] = _zz_cacheIO_readData;
    cacheIO_readData[63 : 32] = _zz_cacheIO_readData_1;
  end

  always @(*) begin
    cacheIO_readValid[0] = _zz_cacheIO_readValid;
    cacheIO_readValid[1] = _zz_cacheIO_readValid_1;
  end

  always @(*) begin
    requestRead = 1'b1;
    if(when_icache_l99) begin
      requestRead = (! _zz_requestRead[_zz_requestRead_1]);
    end
    if(when_icache_l99_1) begin
      requestRead = (! _zz_requestRead_2[_zz_requestRead_3]);
    end
    if(when_icache_l99_2) begin
      requestRead = (! _zz_requestRead_4[_zz_requestRead_5]);
    end
    if(when_icache_l99_3) begin
      requestRead = (! _zz_requestRead_6[_zz_requestRead_7]);
    end
  end

  always @(*) begin
    inPage = 1'b0;
    if(when_icache_l99) begin
      inPage = 1'b1;
    end
    if(when_icache_l99_1) begin
      inPage = 1'b1;
    end
    if(when_icache_l99_2) begin
      inPage = 1'b1;
    end
    if(when_icache_l99_3) begin
      inPage = 1'b1;
    end
  end

  always @(*) begin
    matchedPage = 2'b00;
    if(when_icache_l99) begin
      matchedPage = _zz_matchedPage;
    end
    if(when_icache_l99_1) begin
      matchedPage = _zz_matchedPage_1;
    end
    if(when_icache_l99_2) begin
      matchedPage = _zz_matchedPage_2;
    end
    if(when_icache_l99_3) begin
      matchedPage = _zz_matchedPage_3;
    end
  end

  assign _zz_when_icache_l99_4 = _zz__zz_when_icache_l99_4[31 : 8];
  assign _zz_cacheIO_readData_2 = _zz__zz_cacheIO_readData_2[7 : 0];
  assign when_icache_l99 = (_zz_when_icache_l99_4 == _zz_when_icache_l99);
  assign _zz_cacheIO_readData_3 = (_zz_cacheIO_readData_2 >>> 2);
  assign when_icache_l99_1 = (_zz_when_icache_l99_4 == _zz_when_icache_l99_1);
  assign _zz_cacheIO_readData_4 = (_zz_cacheIO_readData_2 >>> 2);
  assign when_icache_l99_2 = (_zz_when_icache_l99_4 == _zz_when_icache_l99_2);
  assign _zz_cacheIO_readData_5 = (_zz_cacheIO_readData_2 >>> 2);
  assign when_icache_l99_3 = (_zz_when_icache_l99_4 == _zz_when_icache_l99_3);
  assign _zz_cacheIO_readData_6 = (_zz_cacheIO_readData_2 >>> 2);
  assign _zz_when_icache_l99_5 = _zz__zz_when_icache_l99_5[31 : 8];
  assign _zz_cacheIO_readData_7 = _zz__zz_cacheIO_readData_7[7 : 0];
  assign when_icache_l99_4 = (_zz_when_icache_l99_5 == _zz_when_icache_l99);
  assign _zz_cacheIO_readData_8 = (_zz_cacheIO_readData_7 >>> 2);
  assign when_icache_l99_5 = (_zz_when_icache_l99_5 == _zz_when_icache_l99_1);
  assign _zz_cacheIO_readData_9 = (_zz_cacheIO_readData_7 >>> 2);
  assign when_icache_l99_6 = (_zz_when_icache_l99_5 == _zz_when_icache_l99_2);
  assign _zz_cacheIO_readData_10 = (_zz_cacheIO_readData_7 >>> 2);
  assign when_icache_l99_7 = (_zz_when_icache_l99_5 == _zz_when_icache_l99_3);
  assign _zz_cacheIO_readData_11 = (_zz_cacheIO_readData_7 >>> 2);
  assign ioHighAddr = cacheIO_readAddr[31 : 8];
  assign ioLowAddr = cacheIO_readAddr[7 : 0];
  assign when_icache_l115 = (2'b00 < matchedPage);
  assign when_icache_l117 = (_zz_matchedPage == matchedPage);
  assign when_icache_l120 = (_zz_matchedPage == _zz_when_icache_l120);
  assign when_icache_l117_1 = (_zz_matchedPage_1 == matchedPage);
  assign when_icache_l120_1 = (_zz_matchedPage_1 == _zz_when_icache_l120_1);
  assign when_icache_l117_2 = (_zz_matchedPage_2 == matchedPage);
  assign when_icache_l120_2 = (_zz_matchedPage_2 == _zz_when_icache_l120_2);
  assign when_icache_l117_3 = (_zz_matchedPage_3 == matchedPage);
  assign when_icache_l120_3 = (_zz_matchedPage_3 == _zz_when_icache_l120_3);
  always @(*) begin
    pageReAssign = 1'b0;
    if(when_icache_l127) begin
      if(when_icache_l129) begin
        pageReAssign = 1'b1;
      end
      if(when_icache_l129_1) begin
        pageReAssign = 1'b1;
      end
      if(when_icache_l129_2) begin
        pageReAssign = 1'b1;
      end
      if(when_icache_l129_3) begin
        pageReAssign = 1'b1;
      end
    end
  end

  assign when_icache_l127 = (! inPage);
  assign when_icache_l129 = (_zz_matchedPage == 2'b11);
  assign when_icache_l129_1 = (_zz_matchedPage_1 == 2'b11);
  assign when_icache_l129_2 = (_zz_matchedPage_2 == 2'b11);
  assign when_icache_l129_3 = (_zz_matchedPage_3 == 2'b11);
  always @(*) begin
    doRead = 1'b0;
    if(requestRead) begin
      doRead = 1'b1;
    end else begin
      if(when_icache_l185) begin
        doRead = 1'b1;
      end
      if(when_icache_l185_1) begin
        doRead = 1'b1;
      end
      if(when_icache_l185_2) begin
        doRead = 1'b1;
      end
      if(when_icache_l185_3) begin
        doRead = 1'b1;
      end
    end
  end

  always @(*) begin
    readPos = cacheIO_readAddr;
    if(!requestRead) begin
      if(when_icache_l185) begin
        readPos[31 : 8] = _zz_when_icache_l99;
        readPos[7 : 2] = _zz_readPos;
      end
      if(when_icache_l185_1) begin
        readPos[31 : 8] = _zz_when_icache_l99_1;
        readPos[7 : 2] = _zz_readPos_1;
      end
      if(when_icache_l185_2) begin
        readPos[31 : 8] = _zz_when_icache_l99_2;
        readPos[7 : 2] = _zz_readPos_2;
      end
      if(when_icache_l185_3) begin
        readPos[31 : 8] = _zz_when_icache_l99_3;
        readPos[7 : 2] = _zz_readPos_3;
      end
    end
  end

  always @(*) begin
    readPart = 2'b00;
    if(requestRead) begin
      if(pageReAssign) begin
        if(when_icache_l157) begin
          readPart = 2'b00;
        end
        if(when_icache_l157_1) begin
          readPart = 2'b01;
        end
        if(when_icache_l157_2) begin
          readPart = 2'b10;
        end
        if(when_icache_l157_3) begin
          readPart = 2'b11;
        end
      end else begin
        if(when_icache_l163) begin
          readPart = 2'b00;
        end
        if(when_icache_l163_1) begin
          readPart = 2'b01;
        end
        if(when_icache_l163_2) begin
          readPart = 2'b10;
        end
        if(when_icache_l163_3) begin
          readPart = 2'b11;
        end
      end
    end else begin
      if(when_icache_l185) begin
        readPart = 2'b00;
      end
      if(when_icache_l185_1) begin
        readPart = 2'b01;
      end
      if(when_icache_l185_2) begin
        readPart = 2'b10;
      end
      if(when_icache_l185_3) begin
        readPart = 2'b11;
      end
    end
  end

  assign readLowPos = readPos[7 : 2];
  assign readHighPos = readPos[31 : 8];
  assign when_icache_l157 = (_zz_matchedPage == 2'b11);
  assign when_icache_l157_1 = (_zz_matchedPage_1 == 2'b11);
  assign when_icache_l157_2 = (_zz_matchedPage_2 == 2'b11);
  assign when_icache_l157_3 = (_zz_matchedPage_3 == 2'b11);
  assign when_icache_l163 = (_zz_when_icache_l99 == readHighPos);
  assign when_icache_l163_1 = (_zz_when_icache_l99_1 == readHighPos);
  assign when_icache_l163_2 = (_zz_when_icache_l99_2 == readHighPos);
  assign when_icache_l163_3 = (_zz_when_icache_l99_3 == readHighPos);
  assign when_icache_l185 = (((_zz_when_icache_l99[23] == 1'b0) && (_zz_matchedPage == 2'b00)) && ((~ cacheLineAvr[63 : 0]) != 64'h0));
  assign _zz_when_icache_l175 = (~ cacheLineAvr[63 : 0]);
  always @(*) begin
    _zz_readPos = 6'h0;
    if(when_icache_l175) begin
      _zz_readPos = 6'h3f;
    end
    if(when_icache_l175_1) begin
      _zz_readPos = 6'h3e;
    end
    if(when_icache_l175_2) begin
      _zz_readPos = 6'h3d;
    end
    if(when_icache_l175_3) begin
      _zz_readPos = 6'h3c;
    end
    if(when_icache_l175_4) begin
      _zz_readPos = 6'h3b;
    end
    if(when_icache_l175_5) begin
      _zz_readPos = 6'h3a;
    end
    if(when_icache_l175_6) begin
      _zz_readPos = 6'h39;
    end
    if(when_icache_l175_7) begin
      _zz_readPos = 6'h38;
    end
    if(when_icache_l175_8) begin
      _zz_readPos = 6'h37;
    end
    if(when_icache_l175_9) begin
      _zz_readPos = 6'h36;
    end
    if(when_icache_l175_10) begin
      _zz_readPos = 6'h35;
    end
    if(when_icache_l175_11) begin
      _zz_readPos = 6'h34;
    end
    if(when_icache_l175_12) begin
      _zz_readPos = 6'h33;
    end
    if(when_icache_l175_13) begin
      _zz_readPos = 6'h32;
    end
    if(when_icache_l175_14) begin
      _zz_readPos = 6'h31;
    end
    if(when_icache_l175_15) begin
      _zz_readPos = 6'h30;
    end
    if(when_icache_l175_16) begin
      _zz_readPos = 6'h2f;
    end
    if(when_icache_l175_17) begin
      _zz_readPos = 6'h2e;
    end
    if(when_icache_l175_18) begin
      _zz_readPos = 6'h2d;
    end
    if(when_icache_l175_19) begin
      _zz_readPos = 6'h2c;
    end
    if(when_icache_l175_20) begin
      _zz_readPos = 6'h2b;
    end
    if(when_icache_l175_21) begin
      _zz_readPos = 6'h2a;
    end
    if(when_icache_l175_22) begin
      _zz_readPos = 6'h29;
    end
    if(when_icache_l175_23) begin
      _zz_readPos = 6'h28;
    end
    if(when_icache_l175_24) begin
      _zz_readPos = 6'h27;
    end
    if(when_icache_l175_25) begin
      _zz_readPos = 6'h26;
    end
    if(when_icache_l175_26) begin
      _zz_readPos = 6'h25;
    end
    if(when_icache_l175_27) begin
      _zz_readPos = 6'h24;
    end
    if(when_icache_l175_28) begin
      _zz_readPos = 6'h23;
    end
    if(when_icache_l175_29) begin
      _zz_readPos = 6'h22;
    end
    if(when_icache_l175_30) begin
      _zz_readPos = 6'h21;
    end
    if(when_icache_l175_31) begin
      _zz_readPos = 6'h20;
    end
    if(when_icache_l175_32) begin
      _zz_readPos = 6'h1f;
    end
    if(when_icache_l175_33) begin
      _zz_readPos = 6'h1e;
    end
    if(when_icache_l175_34) begin
      _zz_readPos = 6'h1d;
    end
    if(when_icache_l175_35) begin
      _zz_readPos = 6'h1c;
    end
    if(when_icache_l175_36) begin
      _zz_readPos = 6'h1b;
    end
    if(when_icache_l175_37) begin
      _zz_readPos = 6'h1a;
    end
    if(when_icache_l175_38) begin
      _zz_readPos = 6'h19;
    end
    if(when_icache_l175_39) begin
      _zz_readPos = 6'h18;
    end
    if(when_icache_l175_40) begin
      _zz_readPos = 6'h17;
    end
    if(when_icache_l175_41) begin
      _zz_readPos = 6'h16;
    end
    if(when_icache_l175_42) begin
      _zz_readPos = 6'h15;
    end
    if(when_icache_l175_43) begin
      _zz_readPos = 6'h14;
    end
    if(when_icache_l175_44) begin
      _zz_readPos = 6'h13;
    end
    if(when_icache_l175_45) begin
      _zz_readPos = 6'h12;
    end
    if(when_icache_l175_46) begin
      _zz_readPos = 6'h11;
    end
    if(when_icache_l175_47) begin
      _zz_readPos = 6'h10;
    end
    if(when_icache_l175_48) begin
      _zz_readPos = 6'h0f;
    end
    if(when_icache_l175_49) begin
      _zz_readPos = 6'h0e;
    end
    if(when_icache_l175_50) begin
      _zz_readPos = 6'h0d;
    end
    if(when_icache_l175_51) begin
      _zz_readPos = 6'h0c;
    end
    if(when_icache_l175_52) begin
      _zz_readPos = 6'h0b;
    end
    if(when_icache_l175_53) begin
      _zz_readPos = 6'h0a;
    end
    if(when_icache_l175_54) begin
      _zz_readPos = 6'h09;
    end
    if(when_icache_l175_55) begin
      _zz_readPos = 6'h08;
    end
    if(when_icache_l175_56) begin
      _zz_readPos = 6'h07;
    end
    if(when_icache_l175_57) begin
      _zz_readPos = 6'h06;
    end
    if(when_icache_l175_58) begin
      _zz_readPos = 6'h05;
    end
    if(when_icache_l175_59) begin
      _zz_readPos = 6'h04;
    end
    if(when_icache_l175_60) begin
      _zz_readPos = 6'h03;
    end
    if(when_icache_l175_61) begin
      _zz_readPos = 6'h02;
    end
    if(when_icache_l175_62) begin
      _zz_readPos = 6'h01;
    end
    if(when_icache_l175_63) begin
      _zz_readPos = 6'h0;
    end
  end

  assign when_icache_l175 = (_zz_when_icache_l175[63] == 1'b1);
  assign when_icache_l175_1 = (_zz_when_icache_l175[62] == 1'b1);
  assign when_icache_l175_2 = (_zz_when_icache_l175[61] == 1'b1);
  assign when_icache_l175_3 = (_zz_when_icache_l175[60] == 1'b1);
  assign when_icache_l175_4 = (_zz_when_icache_l175[59] == 1'b1);
  assign when_icache_l175_5 = (_zz_when_icache_l175[58] == 1'b1);
  assign when_icache_l175_6 = (_zz_when_icache_l175[57] == 1'b1);
  assign when_icache_l175_7 = (_zz_when_icache_l175[56] == 1'b1);
  assign when_icache_l175_8 = (_zz_when_icache_l175[55] == 1'b1);
  assign when_icache_l175_9 = (_zz_when_icache_l175[54] == 1'b1);
  assign when_icache_l175_10 = (_zz_when_icache_l175[53] == 1'b1);
  assign when_icache_l175_11 = (_zz_when_icache_l175[52] == 1'b1);
  assign when_icache_l175_12 = (_zz_when_icache_l175[51] == 1'b1);
  assign when_icache_l175_13 = (_zz_when_icache_l175[50] == 1'b1);
  assign when_icache_l175_14 = (_zz_when_icache_l175[49] == 1'b1);
  assign when_icache_l175_15 = (_zz_when_icache_l175[48] == 1'b1);
  assign when_icache_l175_16 = (_zz_when_icache_l175[47] == 1'b1);
  assign when_icache_l175_17 = (_zz_when_icache_l175[46] == 1'b1);
  assign when_icache_l175_18 = (_zz_when_icache_l175[45] == 1'b1);
  assign when_icache_l175_19 = (_zz_when_icache_l175[44] == 1'b1);
  assign when_icache_l175_20 = (_zz_when_icache_l175[43] == 1'b1);
  assign when_icache_l175_21 = (_zz_when_icache_l175[42] == 1'b1);
  assign when_icache_l175_22 = (_zz_when_icache_l175[41] == 1'b1);
  assign when_icache_l175_23 = (_zz_when_icache_l175[40] == 1'b1);
  assign when_icache_l175_24 = (_zz_when_icache_l175[39] == 1'b1);
  assign when_icache_l175_25 = (_zz_when_icache_l175[38] == 1'b1);
  assign when_icache_l175_26 = (_zz_when_icache_l175[37] == 1'b1);
  assign when_icache_l175_27 = (_zz_when_icache_l175[36] == 1'b1);
  assign when_icache_l175_28 = (_zz_when_icache_l175[35] == 1'b1);
  assign when_icache_l175_29 = (_zz_when_icache_l175[34] == 1'b1);
  assign when_icache_l175_30 = (_zz_when_icache_l175[33] == 1'b1);
  assign when_icache_l175_31 = (_zz_when_icache_l175[32] == 1'b1);
  assign when_icache_l175_32 = (_zz_when_icache_l175[31] == 1'b1);
  assign when_icache_l175_33 = (_zz_when_icache_l175[30] == 1'b1);
  assign when_icache_l175_34 = (_zz_when_icache_l175[29] == 1'b1);
  assign when_icache_l175_35 = (_zz_when_icache_l175[28] == 1'b1);
  assign when_icache_l175_36 = (_zz_when_icache_l175[27] == 1'b1);
  assign when_icache_l175_37 = (_zz_when_icache_l175[26] == 1'b1);
  assign when_icache_l175_38 = (_zz_when_icache_l175[25] == 1'b1);
  assign when_icache_l175_39 = (_zz_when_icache_l175[24] == 1'b1);
  assign when_icache_l175_40 = (_zz_when_icache_l175[23] == 1'b1);
  assign when_icache_l175_41 = (_zz_when_icache_l175[22] == 1'b1);
  assign when_icache_l175_42 = (_zz_when_icache_l175[21] == 1'b1);
  assign when_icache_l175_43 = (_zz_when_icache_l175[20] == 1'b1);
  assign when_icache_l175_44 = (_zz_when_icache_l175[19] == 1'b1);
  assign when_icache_l175_45 = (_zz_when_icache_l175[18] == 1'b1);
  assign when_icache_l175_46 = (_zz_when_icache_l175[17] == 1'b1);
  assign when_icache_l175_47 = (_zz_when_icache_l175[16] == 1'b1);
  assign when_icache_l175_48 = (_zz_when_icache_l175[15] == 1'b1);
  assign when_icache_l175_49 = (_zz_when_icache_l175[14] == 1'b1);
  assign when_icache_l175_50 = (_zz_when_icache_l175[13] == 1'b1);
  assign when_icache_l175_51 = (_zz_when_icache_l175[12] == 1'b1);
  assign when_icache_l175_52 = (_zz_when_icache_l175[11] == 1'b1);
  assign when_icache_l175_53 = (_zz_when_icache_l175[10] == 1'b1);
  assign when_icache_l175_54 = (_zz_when_icache_l175[9] == 1'b1);
  assign when_icache_l175_55 = (_zz_when_icache_l175[8] == 1'b1);
  assign when_icache_l175_56 = (_zz_when_icache_l175[7] == 1'b1);
  assign when_icache_l175_57 = (_zz_when_icache_l175[6] == 1'b1);
  assign when_icache_l175_58 = (_zz_when_icache_l175[5] == 1'b1);
  assign when_icache_l175_59 = (_zz_when_icache_l175[4] == 1'b1);
  assign when_icache_l175_60 = (_zz_when_icache_l175[3] == 1'b1);
  assign when_icache_l175_61 = (_zz_when_icache_l175[2] == 1'b1);
  assign when_icache_l175_62 = (_zz_when_icache_l175[1] == 1'b1);
  assign when_icache_l175_63 = (_zz_when_icache_l175[0] == 1'b1);
  assign when_icache_l185_1 = (((_zz_when_icache_l99_1[23] == 1'b0) && (_zz_matchedPage_1 == 2'b00)) && ((~ cacheLineAvr[127 : 64]) != 64'h0));
  assign _zz_when_icache_l175_1 = (~ cacheLineAvr[127 : 64]);
  always @(*) begin
    _zz_readPos_1 = 6'h0;
    if(when_icache_l175_64) begin
      _zz_readPos_1 = 6'h3f;
    end
    if(when_icache_l175_65) begin
      _zz_readPos_1 = 6'h3e;
    end
    if(when_icache_l175_66) begin
      _zz_readPos_1 = 6'h3d;
    end
    if(when_icache_l175_67) begin
      _zz_readPos_1 = 6'h3c;
    end
    if(when_icache_l175_68) begin
      _zz_readPos_1 = 6'h3b;
    end
    if(when_icache_l175_69) begin
      _zz_readPos_1 = 6'h3a;
    end
    if(when_icache_l175_70) begin
      _zz_readPos_1 = 6'h39;
    end
    if(when_icache_l175_71) begin
      _zz_readPos_1 = 6'h38;
    end
    if(when_icache_l175_72) begin
      _zz_readPos_1 = 6'h37;
    end
    if(when_icache_l175_73) begin
      _zz_readPos_1 = 6'h36;
    end
    if(when_icache_l175_74) begin
      _zz_readPos_1 = 6'h35;
    end
    if(when_icache_l175_75) begin
      _zz_readPos_1 = 6'h34;
    end
    if(when_icache_l175_76) begin
      _zz_readPos_1 = 6'h33;
    end
    if(when_icache_l175_77) begin
      _zz_readPos_1 = 6'h32;
    end
    if(when_icache_l175_78) begin
      _zz_readPos_1 = 6'h31;
    end
    if(when_icache_l175_79) begin
      _zz_readPos_1 = 6'h30;
    end
    if(when_icache_l175_80) begin
      _zz_readPos_1 = 6'h2f;
    end
    if(when_icache_l175_81) begin
      _zz_readPos_1 = 6'h2e;
    end
    if(when_icache_l175_82) begin
      _zz_readPos_1 = 6'h2d;
    end
    if(when_icache_l175_83) begin
      _zz_readPos_1 = 6'h2c;
    end
    if(when_icache_l175_84) begin
      _zz_readPos_1 = 6'h2b;
    end
    if(when_icache_l175_85) begin
      _zz_readPos_1 = 6'h2a;
    end
    if(when_icache_l175_86) begin
      _zz_readPos_1 = 6'h29;
    end
    if(when_icache_l175_87) begin
      _zz_readPos_1 = 6'h28;
    end
    if(when_icache_l175_88) begin
      _zz_readPos_1 = 6'h27;
    end
    if(when_icache_l175_89) begin
      _zz_readPos_1 = 6'h26;
    end
    if(when_icache_l175_90) begin
      _zz_readPos_1 = 6'h25;
    end
    if(when_icache_l175_91) begin
      _zz_readPos_1 = 6'h24;
    end
    if(when_icache_l175_92) begin
      _zz_readPos_1 = 6'h23;
    end
    if(when_icache_l175_93) begin
      _zz_readPos_1 = 6'h22;
    end
    if(when_icache_l175_94) begin
      _zz_readPos_1 = 6'h21;
    end
    if(when_icache_l175_95) begin
      _zz_readPos_1 = 6'h20;
    end
    if(when_icache_l175_96) begin
      _zz_readPos_1 = 6'h1f;
    end
    if(when_icache_l175_97) begin
      _zz_readPos_1 = 6'h1e;
    end
    if(when_icache_l175_98) begin
      _zz_readPos_1 = 6'h1d;
    end
    if(when_icache_l175_99) begin
      _zz_readPos_1 = 6'h1c;
    end
    if(when_icache_l175_100) begin
      _zz_readPos_1 = 6'h1b;
    end
    if(when_icache_l175_101) begin
      _zz_readPos_1 = 6'h1a;
    end
    if(when_icache_l175_102) begin
      _zz_readPos_1 = 6'h19;
    end
    if(when_icache_l175_103) begin
      _zz_readPos_1 = 6'h18;
    end
    if(when_icache_l175_104) begin
      _zz_readPos_1 = 6'h17;
    end
    if(when_icache_l175_105) begin
      _zz_readPos_1 = 6'h16;
    end
    if(when_icache_l175_106) begin
      _zz_readPos_1 = 6'h15;
    end
    if(when_icache_l175_107) begin
      _zz_readPos_1 = 6'h14;
    end
    if(when_icache_l175_108) begin
      _zz_readPos_1 = 6'h13;
    end
    if(when_icache_l175_109) begin
      _zz_readPos_1 = 6'h12;
    end
    if(when_icache_l175_110) begin
      _zz_readPos_1 = 6'h11;
    end
    if(when_icache_l175_111) begin
      _zz_readPos_1 = 6'h10;
    end
    if(when_icache_l175_112) begin
      _zz_readPos_1 = 6'h0f;
    end
    if(when_icache_l175_113) begin
      _zz_readPos_1 = 6'h0e;
    end
    if(when_icache_l175_114) begin
      _zz_readPos_1 = 6'h0d;
    end
    if(when_icache_l175_115) begin
      _zz_readPos_1 = 6'h0c;
    end
    if(when_icache_l175_116) begin
      _zz_readPos_1 = 6'h0b;
    end
    if(when_icache_l175_117) begin
      _zz_readPos_1 = 6'h0a;
    end
    if(when_icache_l175_118) begin
      _zz_readPos_1 = 6'h09;
    end
    if(when_icache_l175_119) begin
      _zz_readPos_1 = 6'h08;
    end
    if(when_icache_l175_120) begin
      _zz_readPos_1 = 6'h07;
    end
    if(when_icache_l175_121) begin
      _zz_readPos_1 = 6'h06;
    end
    if(when_icache_l175_122) begin
      _zz_readPos_1 = 6'h05;
    end
    if(when_icache_l175_123) begin
      _zz_readPos_1 = 6'h04;
    end
    if(when_icache_l175_124) begin
      _zz_readPos_1 = 6'h03;
    end
    if(when_icache_l175_125) begin
      _zz_readPos_1 = 6'h02;
    end
    if(when_icache_l175_126) begin
      _zz_readPos_1 = 6'h01;
    end
    if(when_icache_l175_127) begin
      _zz_readPos_1 = 6'h0;
    end
  end

  assign when_icache_l175_64 = (_zz_when_icache_l175_1[63] == 1'b1);
  assign when_icache_l175_65 = (_zz_when_icache_l175_1[62] == 1'b1);
  assign when_icache_l175_66 = (_zz_when_icache_l175_1[61] == 1'b1);
  assign when_icache_l175_67 = (_zz_when_icache_l175_1[60] == 1'b1);
  assign when_icache_l175_68 = (_zz_when_icache_l175_1[59] == 1'b1);
  assign when_icache_l175_69 = (_zz_when_icache_l175_1[58] == 1'b1);
  assign when_icache_l175_70 = (_zz_when_icache_l175_1[57] == 1'b1);
  assign when_icache_l175_71 = (_zz_when_icache_l175_1[56] == 1'b1);
  assign when_icache_l175_72 = (_zz_when_icache_l175_1[55] == 1'b1);
  assign when_icache_l175_73 = (_zz_when_icache_l175_1[54] == 1'b1);
  assign when_icache_l175_74 = (_zz_when_icache_l175_1[53] == 1'b1);
  assign when_icache_l175_75 = (_zz_when_icache_l175_1[52] == 1'b1);
  assign when_icache_l175_76 = (_zz_when_icache_l175_1[51] == 1'b1);
  assign when_icache_l175_77 = (_zz_when_icache_l175_1[50] == 1'b1);
  assign when_icache_l175_78 = (_zz_when_icache_l175_1[49] == 1'b1);
  assign when_icache_l175_79 = (_zz_when_icache_l175_1[48] == 1'b1);
  assign when_icache_l175_80 = (_zz_when_icache_l175_1[47] == 1'b1);
  assign when_icache_l175_81 = (_zz_when_icache_l175_1[46] == 1'b1);
  assign when_icache_l175_82 = (_zz_when_icache_l175_1[45] == 1'b1);
  assign when_icache_l175_83 = (_zz_when_icache_l175_1[44] == 1'b1);
  assign when_icache_l175_84 = (_zz_when_icache_l175_1[43] == 1'b1);
  assign when_icache_l175_85 = (_zz_when_icache_l175_1[42] == 1'b1);
  assign when_icache_l175_86 = (_zz_when_icache_l175_1[41] == 1'b1);
  assign when_icache_l175_87 = (_zz_when_icache_l175_1[40] == 1'b1);
  assign when_icache_l175_88 = (_zz_when_icache_l175_1[39] == 1'b1);
  assign when_icache_l175_89 = (_zz_when_icache_l175_1[38] == 1'b1);
  assign when_icache_l175_90 = (_zz_when_icache_l175_1[37] == 1'b1);
  assign when_icache_l175_91 = (_zz_when_icache_l175_1[36] == 1'b1);
  assign when_icache_l175_92 = (_zz_when_icache_l175_1[35] == 1'b1);
  assign when_icache_l175_93 = (_zz_when_icache_l175_1[34] == 1'b1);
  assign when_icache_l175_94 = (_zz_when_icache_l175_1[33] == 1'b1);
  assign when_icache_l175_95 = (_zz_when_icache_l175_1[32] == 1'b1);
  assign when_icache_l175_96 = (_zz_when_icache_l175_1[31] == 1'b1);
  assign when_icache_l175_97 = (_zz_when_icache_l175_1[30] == 1'b1);
  assign when_icache_l175_98 = (_zz_when_icache_l175_1[29] == 1'b1);
  assign when_icache_l175_99 = (_zz_when_icache_l175_1[28] == 1'b1);
  assign when_icache_l175_100 = (_zz_when_icache_l175_1[27] == 1'b1);
  assign when_icache_l175_101 = (_zz_when_icache_l175_1[26] == 1'b1);
  assign when_icache_l175_102 = (_zz_when_icache_l175_1[25] == 1'b1);
  assign when_icache_l175_103 = (_zz_when_icache_l175_1[24] == 1'b1);
  assign when_icache_l175_104 = (_zz_when_icache_l175_1[23] == 1'b1);
  assign when_icache_l175_105 = (_zz_when_icache_l175_1[22] == 1'b1);
  assign when_icache_l175_106 = (_zz_when_icache_l175_1[21] == 1'b1);
  assign when_icache_l175_107 = (_zz_when_icache_l175_1[20] == 1'b1);
  assign when_icache_l175_108 = (_zz_when_icache_l175_1[19] == 1'b1);
  assign when_icache_l175_109 = (_zz_when_icache_l175_1[18] == 1'b1);
  assign when_icache_l175_110 = (_zz_when_icache_l175_1[17] == 1'b1);
  assign when_icache_l175_111 = (_zz_when_icache_l175_1[16] == 1'b1);
  assign when_icache_l175_112 = (_zz_when_icache_l175_1[15] == 1'b1);
  assign when_icache_l175_113 = (_zz_when_icache_l175_1[14] == 1'b1);
  assign when_icache_l175_114 = (_zz_when_icache_l175_1[13] == 1'b1);
  assign when_icache_l175_115 = (_zz_when_icache_l175_1[12] == 1'b1);
  assign when_icache_l175_116 = (_zz_when_icache_l175_1[11] == 1'b1);
  assign when_icache_l175_117 = (_zz_when_icache_l175_1[10] == 1'b1);
  assign when_icache_l175_118 = (_zz_when_icache_l175_1[9] == 1'b1);
  assign when_icache_l175_119 = (_zz_when_icache_l175_1[8] == 1'b1);
  assign when_icache_l175_120 = (_zz_when_icache_l175_1[7] == 1'b1);
  assign when_icache_l175_121 = (_zz_when_icache_l175_1[6] == 1'b1);
  assign when_icache_l175_122 = (_zz_when_icache_l175_1[5] == 1'b1);
  assign when_icache_l175_123 = (_zz_when_icache_l175_1[4] == 1'b1);
  assign when_icache_l175_124 = (_zz_when_icache_l175_1[3] == 1'b1);
  assign when_icache_l175_125 = (_zz_when_icache_l175_1[2] == 1'b1);
  assign when_icache_l175_126 = (_zz_when_icache_l175_1[1] == 1'b1);
  assign when_icache_l175_127 = (_zz_when_icache_l175_1[0] == 1'b1);
  assign when_icache_l185_2 = (((_zz_when_icache_l99_2[23] == 1'b0) && (_zz_matchedPage_2 == 2'b00)) && ((~ cacheLineAvr[191 : 128]) != 64'h0));
  assign _zz_when_icache_l175_2 = (~ cacheLineAvr[191 : 128]);
  always @(*) begin
    _zz_readPos_2 = 6'h0;
    if(when_icache_l175_128) begin
      _zz_readPos_2 = 6'h3f;
    end
    if(when_icache_l175_129) begin
      _zz_readPos_2 = 6'h3e;
    end
    if(when_icache_l175_130) begin
      _zz_readPos_2 = 6'h3d;
    end
    if(when_icache_l175_131) begin
      _zz_readPos_2 = 6'h3c;
    end
    if(when_icache_l175_132) begin
      _zz_readPos_2 = 6'h3b;
    end
    if(when_icache_l175_133) begin
      _zz_readPos_2 = 6'h3a;
    end
    if(when_icache_l175_134) begin
      _zz_readPos_2 = 6'h39;
    end
    if(when_icache_l175_135) begin
      _zz_readPos_2 = 6'h38;
    end
    if(when_icache_l175_136) begin
      _zz_readPos_2 = 6'h37;
    end
    if(when_icache_l175_137) begin
      _zz_readPos_2 = 6'h36;
    end
    if(when_icache_l175_138) begin
      _zz_readPos_2 = 6'h35;
    end
    if(when_icache_l175_139) begin
      _zz_readPos_2 = 6'h34;
    end
    if(when_icache_l175_140) begin
      _zz_readPos_2 = 6'h33;
    end
    if(when_icache_l175_141) begin
      _zz_readPos_2 = 6'h32;
    end
    if(when_icache_l175_142) begin
      _zz_readPos_2 = 6'h31;
    end
    if(when_icache_l175_143) begin
      _zz_readPos_2 = 6'h30;
    end
    if(when_icache_l175_144) begin
      _zz_readPos_2 = 6'h2f;
    end
    if(when_icache_l175_145) begin
      _zz_readPos_2 = 6'h2e;
    end
    if(when_icache_l175_146) begin
      _zz_readPos_2 = 6'h2d;
    end
    if(when_icache_l175_147) begin
      _zz_readPos_2 = 6'h2c;
    end
    if(when_icache_l175_148) begin
      _zz_readPos_2 = 6'h2b;
    end
    if(when_icache_l175_149) begin
      _zz_readPos_2 = 6'h2a;
    end
    if(when_icache_l175_150) begin
      _zz_readPos_2 = 6'h29;
    end
    if(when_icache_l175_151) begin
      _zz_readPos_2 = 6'h28;
    end
    if(when_icache_l175_152) begin
      _zz_readPos_2 = 6'h27;
    end
    if(when_icache_l175_153) begin
      _zz_readPos_2 = 6'h26;
    end
    if(when_icache_l175_154) begin
      _zz_readPos_2 = 6'h25;
    end
    if(when_icache_l175_155) begin
      _zz_readPos_2 = 6'h24;
    end
    if(when_icache_l175_156) begin
      _zz_readPos_2 = 6'h23;
    end
    if(when_icache_l175_157) begin
      _zz_readPos_2 = 6'h22;
    end
    if(when_icache_l175_158) begin
      _zz_readPos_2 = 6'h21;
    end
    if(when_icache_l175_159) begin
      _zz_readPos_2 = 6'h20;
    end
    if(when_icache_l175_160) begin
      _zz_readPos_2 = 6'h1f;
    end
    if(when_icache_l175_161) begin
      _zz_readPos_2 = 6'h1e;
    end
    if(when_icache_l175_162) begin
      _zz_readPos_2 = 6'h1d;
    end
    if(when_icache_l175_163) begin
      _zz_readPos_2 = 6'h1c;
    end
    if(when_icache_l175_164) begin
      _zz_readPos_2 = 6'h1b;
    end
    if(when_icache_l175_165) begin
      _zz_readPos_2 = 6'h1a;
    end
    if(when_icache_l175_166) begin
      _zz_readPos_2 = 6'h19;
    end
    if(when_icache_l175_167) begin
      _zz_readPos_2 = 6'h18;
    end
    if(when_icache_l175_168) begin
      _zz_readPos_2 = 6'h17;
    end
    if(when_icache_l175_169) begin
      _zz_readPos_2 = 6'h16;
    end
    if(when_icache_l175_170) begin
      _zz_readPos_2 = 6'h15;
    end
    if(when_icache_l175_171) begin
      _zz_readPos_2 = 6'h14;
    end
    if(when_icache_l175_172) begin
      _zz_readPos_2 = 6'h13;
    end
    if(when_icache_l175_173) begin
      _zz_readPos_2 = 6'h12;
    end
    if(when_icache_l175_174) begin
      _zz_readPos_2 = 6'h11;
    end
    if(when_icache_l175_175) begin
      _zz_readPos_2 = 6'h10;
    end
    if(when_icache_l175_176) begin
      _zz_readPos_2 = 6'h0f;
    end
    if(when_icache_l175_177) begin
      _zz_readPos_2 = 6'h0e;
    end
    if(when_icache_l175_178) begin
      _zz_readPos_2 = 6'h0d;
    end
    if(when_icache_l175_179) begin
      _zz_readPos_2 = 6'h0c;
    end
    if(when_icache_l175_180) begin
      _zz_readPos_2 = 6'h0b;
    end
    if(when_icache_l175_181) begin
      _zz_readPos_2 = 6'h0a;
    end
    if(when_icache_l175_182) begin
      _zz_readPos_2 = 6'h09;
    end
    if(when_icache_l175_183) begin
      _zz_readPos_2 = 6'h08;
    end
    if(when_icache_l175_184) begin
      _zz_readPos_2 = 6'h07;
    end
    if(when_icache_l175_185) begin
      _zz_readPos_2 = 6'h06;
    end
    if(when_icache_l175_186) begin
      _zz_readPos_2 = 6'h05;
    end
    if(when_icache_l175_187) begin
      _zz_readPos_2 = 6'h04;
    end
    if(when_icache_l175_188) begin
      _zz_readPos_2 = 6'h03;
    end
    if(when_icache_l175_189) begin
      _zz_readPos_2 = 6'h02;
    end
    if(when_icache_l175_190) begin
      _zz_readPos_2 = 6'h01;
    end
    if(when_icache_l175_191) begin
      _zz_readPos_2 = 6'h0;
    end
  end

  assign when_icache_l175_128 = (_zz_when_icache_l175_2[63] == 1'b1);
  assign when_icache_l175_129 = (_zz_when_icache_l175_2[62] == 1'b1);
  assign when_icache_l175_130 = (_zz_when_icache_l175_2[61] == 1'b1);
  assign when_icache_l175_131 = (_zz_when_icache_l175_2[60] == 1'b1);
  assign when_icache_l175_132 = (_zz_when_icache_l175_2[59] == 1'b1);
  assign when_icache_l175_133 = (_zz_when_icache_l175_2[58] == 1'b1);
  assign when_icache_l175_134 = (_zz_when_icache_l175_2[57] == 1'b1);
  assign when_icache_l175_135 = (_zz_when_icache_l175_2[56] == 1'b1);
  assign when_icache_l175_136 = (_zz_when_icache_l175_2[55] == 1'b1);
  assign when_icache_l175_137 = (_zz_when_icache_l175_2[54] == 1'b1);
  assign when_icache_l175_138 = (_zz_when_icache_l175_2[53] == 1'b1);
  assign when_icache_l175_139 = (_zz_when_icache_l175_2[52] == 1'b1);
  assign when_icache_l175_140 = (_zz_when_icache_l175_2[51] == 1'b1);
  assign when_icache_l175_141 = (_zz_when_icache_l175_2[50] == 1'b1);
  assign when_icache_l175_142 = (_zz_when_icache_l175_2[49] == 1'b1);
  assign when_icache_l175_143 = (_zz_when_icache_l175_2[48] == 1'b1);
  assign when_icache_l175_144 = (_zz_when_icache_l175_2[47] == 1'b1);
  assign when_icache_l175_145 = (_zz_when_icache_l175_2[46] == 1'b1);
  assign when_icache_l175_146 = (_zz_when_icache_l175_2[45] == 1'b1);
  assign when_icache_l175_147 = (_zz_when_icache_l175_2[44] == 1'b1);
  assign when_icache_l175_148 = (_zz_when_icache_l175_2[43] == 1'b1);
  assign when_icache_l175_149 = (_zz_when_icache_l175_2[42] == 1'b1);
  assign when_icache_l175_150 = (_zz_when_icache_l175_2[41] == 1'b1);
  assign when_icache_l175_151 = (_zz_when_icache_l175_2[40] == 1'b1);
  assign when_icache_l175_152 = (_zz_when_icache_l175_2[39] == 1'b1);
  assign when_icache_l175_153 = (_zz_when_icache_l175_2[38] == 1'b1);
  assign when_icache_l175_154 = (_zz_when_icache_l175_2[37] == 1'b1);
  assign when_icache_l175_155 = (_zz_when_icache_l175_2[36] == 1'b1);
  assign when_icache_l175_156 = (_zz_when_icache_l175_2[35] == 1'b1);
  assign when_icache_l175_157 = (_zz_when_icache_l175_2[34] == 1'b1);
  assign when_icache_l175_158 = (_zz_when_icache_l175_2[33] == 1'b1);
  assign when_icache_l175_159 = (_zz_when_icache_l175_2[32] == 1'b1);
  assign when_icache_l175_160 = (_zz_when_icache_l175_2[31] == 1'b1);
  assign when_icache_l175_161 = (_zz_when_icache_l175_2[30] == 1'b1);
  assign when_icache_l175_162 = (_zz_when_icache_l175_2[29] == 1'b1);
  assign when_icache_l175_163 = (_zz_when_icache_l175_2[28] == 1'b1);
  assign when_icache_l175_164 = (_zz_when_icache_l175_2[27] == 1'b1);
  assign when_icache_l175_165 = (_zz_when_icache_l175_2[26] == 1'b1);
  assign when_icache_l175_166 = (_zz_when_icache_l175_2[25] == 1'b1);
  assign when_icache_l175_167 = (_zz_when_icache_l175_2[24] == 1'b1);
  assign when_icache_l175_168 = (_zz_when_icache_l175_2[23] == 1'b1);
  assign when_icache_l175_169 = (_zz_when_icache_l175_2[22] == 1'b1);
  assign when_icache_l175_170 = (_zz_when_icache_l175_2[21] == 1'b1);
  assign when_icache_l175_171 = (_zz_when_icache_l175_2[20] == 1'b1);
  assign when_icache_l175_172 = (_zz_when_icache_l175_2[19] == 1'b1);
  assign when_icache_l175_173 = (_zz_when_icache_l175_2[18] == 1'b1);
  assign when_icache_l175_174 = (_zz_when_icache_l175_2[17] == 1'b1);
  assign when_icache_l175_175 = (_zz_when_icache_l175_2[16] == 1'b1);
  assign when_icache_l175_176 = (_zz_when_icache_l175_2[15] == 1'b1);
  assign when_icache_l175_177 = (_zz_when_icache_l175_2[14] == 1'b1);
  assign when_icache_l175_178 = (_zz_when_icache_l175_2[13] == 1'b1);
  assign when_icache_l175_179 = (_zz_when_icache_l175_2[12] == 1'b1);
  assign when_icache_l175_180 = (_zz_when_icache_l175_2[11] == 1'b1);
  assign when_icache_l175_181 = (_zz_when_icache_l175_2[10] == 1'b1);
  assign when_icache_l175_182 = (_zz_when_icache_l175_2[9] == 1'b1);
  assign when_icache_l175_183 = (_zz_when_icache_l175_2[8] == 1'b1);
  assign when_icache_l175_184 = (_zz_when_icache_l175_2[7] == 1'b1);
  assign when_icache_l175_185 = (_zz_when_icache_l175_2[6] == 1'b1);
  assign when_icache_l175_186 = (_zz_when_icache_l175_2[5] == 1'b1);
  assign when_icache_l175_187 = (_zz_when_icache_l175_2[4] == 1'b1);
  assign when_icache_l175_188 = (_zz_when_icache_l175_2[3] == 1'b1);
  assign when_icache_l175_189 = (_zz_when_icache_l175_2[2] == 1'b1);
  assign when_icache_l175_190 = (_zz_when_icache_l175_2[1] == 1'b1);
  assign when_icache_l175_191 = (_zz_when_icache_l175_2[0] == 1'b1);
  assign when_icache_l185_3 = (((_zz_when_icache_l99_3[23] == 1'b0) && (_zz_matchedPage_3 == 2'b00)) && ((~ cacheLineAvr[255 : 192]) != 64'h0));
  assign _zz_when_icache_l175_3 = (~ cacheLineAvr[255 : 192]);
  always @(*) begin
    _zz_readPos_3 = 6'h0;
    if(when_icache_l175_192) begin
      _zz_readPos_3 = 6'h3f;
    end
    if(when_icache_l175_193) begin
      _zz_readPos_3 = 6'h3e;
    end
    if(when_icache_l175_194) begin
      _zz_readPos_3 = 6'h3d;
    end
    if(when_icache_l175_195) begin
      _zz_readPos_3 = 6'h3c;
    end
    if(when_icache_l175_196) begin
      _zz_readPos_3 = 6'h3b;
    end
    if(when_icache_l175_197) begin
      _zz_readPos_3 = 6'h3a;
    end
    if(when_icache_l175_198) begin
      _zz_readPos_3 = 6'h39;
    end
    if(when_icache_l175_199) begin
      _zz_readPos_3 = 6'h38;
    end
    if(when_icache_l175_200) begin
      _zz_readPos_3 = 6'h37;
    end
    if(when_icache_l175_201) begin
      _zz_readPos_3 = 6'h36;
    end
    if(when_icache_l175_202) begin
      _zz_readPos_3 = 6'h35;
    end
    if(when_icache_l175_203) begin
      _zz_readPos_3 = 6'h34;
    end
    if(when_icache_l175_204) begin
      _zz_readPos_3 = 6'h33;
    end
    if(when_icache_l175_205) begin
      _zz_readPos_3 = 6'h32;
    end
    if(when_icache_l175_206) begin
      _zz_readPos_3 = 6'h31;
    end
    if(when_icache_l175_207) begin
      _zz_readPos_3 = 6'h30;
    end
    if(when_icache_l175_208) begin
      _zz_readPos_3 = 6'h2f;
    end
    if(when_icache_l175_209) begin
      _zz_readPos_3 = 6'h2e;
    end
    if(when_icache_l175_210) begin
      _zz_readPos_3 = 6'h2d;
    end
    if(when_icache_l175_211) begin
      _zz_readPos_3 = 6'h2c;
    end
    if(when_icache_l175_212) begin
      _zz_readPos_3 = 6'h2b;
    end
    if(when_icache_l175_213) begin
      _zz_readPos_3 = 6'h2a;
    end
    if(when_icache_l175_214) begin
      _zz_readPos_3 = 6'h29;
    end
    if(when_icache_l175_215) begin
      _zz_readPos_3 = 6'h28;
    end
    if(when_icache_l175_216) begin
      _zz_readPos_3 = 6'h27;
    end
    if(when_icache_l175_217) begin
      _zz_readPos_3 = 6'h26;
    end
    if(when_icache_l175_218) begin
      _zz_readPos_3 = 6'h25;
    end
    if(when_icache_l175_219) begin
      _zz_readPos_3 = 6'h24;
    end
    if(when_icache_l175_220) begin
      _zz_readPos_3 = 6'h23;
    end
    if(when_icache_l175_221) begin
      _zz_readPos_3 = 6'h22;
    end
    if(when_icache_l175_222) begin
      _zz_readPos_3 = 6'h21;
    end
    if(when_icache_l175_223) begin
      _zz_readPos_3 = 6'h20;
    end
    if(when_icache_l175_224) begin
      _zz_readPos_3 = 6'h1f;
    end
    if(when_icache_l175_225) begin
      _zz_readPos_3 = 6'h1e;
    end
    if(when_icache_l175_226) begin
      _zz_readPos_3 = 6'h1d;
    end
    if(when_icache_l175_227) begin
      _zz_readPos_3 = 6'h1c;
    end
    if(when_icache_l175_228) begin
      _zz_readPos_3 = 6'h1b;
    end
    if(when_icache_l175_229) begin
      _zz_readPos_3 = 6'h1a;
    end
    if(when_icache_l175_230) begin
      _zz_readPos_3 = 6'h19;
    end
    if(when_icache_l175_231) begin
      _zz_readPos_3 = 6'h18;
    end
    if(when_icache_l175_232) begin
      _zz_readPos_3 = 6'h17;
    end
    if(when_icache_l175_233) begin
      _zz_readPos_3 = 6'h16;
    end
    if(when_icache_l175_234) begin
      _zz_readPos_3 = 6'h15;
    end
    if(when_icache_l175_235) begin
      _zz_readPos_3 = 6'h14;
    end
    if(when_icache_l175_236) begin
      _zz_readPos_3 = 6'h13;
    end
    if(when_icache_l175_237) begin
      _zz_readPos_3 = 6'h12;
    end
    if(when_icache_l175_238) begin
      _zz_readPos_3 = 6'h11;
    end
    if(when_icache_l175_239) begin
      _zz_readPos_3 = 6'h10;
    end
    if(when_icache_l175_240) begin
      _zz_readPos_3 = 6'h0f;
    end
    if(when_icache_l175_241) begin
      _zz_readPos_3 = 6'h0e;
    end
    if(when_icache_l175_242) begin
      _zz_readPos_3 = 6'h0d;
    end
    if(when_icache_l175_243) begin
      _zz_readPos_3 = 6'h0c;
    end
    if(when_icache_l175_244) begin
      _zz_readPos_3 = 6'h0b;
    end
    if(when_icache_l175_245) begin
      _zz_readPos_3 = 6'h0a;
    end
    if(when_icache_l175_246) begin
      _zz_readPos_3 = 6'h09;
    end
    if(when_icache_l175_247) begin
      _zz_readPos_3 = 6'h08;
    end
    if(when_icache_l175_248) begin
      _zz_readPos_3 = 6'h07;
    end
    if(when_icache_l175_249) begin
      _zz_readPos_3 = 6'h06;
    end
    if(when_icache_l175_250) begin
      _zz_readPos_3 = 6'h05;
    end
    if(when_icache_l175_251) begin
      _zz_readPos_3 = 6'h04;
    end
    if(when_icache_l175_252) begin
      _zz_readPos_3 = 6'h03;
    end
    if(when_icache_l175_253) begin
      _zz_readPos_3 = 6'h02;
    end
    if(when_icache_l175_254) begin
      _zz_readPos_3 = 6'h01;
    end
    if(when_icache_l175_255) begin
      _zz_readPos_3 = 6'h0;
    end
  end

  assign when_icache_l175_192 = (_zz_when_icache_l175_3[63] == 1'b1);
  assign when_icache_l175_193 = (_zz_when_icache_l175_3[62] == 1'b1);
  assign when_icache_l175_194 = (_zz_when_icache_l175_3[61] == 1'b1);
  assign when_icache_l175_195 = (_zz_when_icache_l175_3[60] == 1'b1);
  assign when_icache_l175_196 = (_zz_when_icache_l175_3[59] == 1'b1);
  assign when_icache_l175_197 = (_zz_when_icache_l175_3[58] == 1'b1);
  assign when_icache_l175_198 = (_zz_when_icache_l175_3[57] == 1'b1);
  assign when_icache_l175_199 = (_zz_when_icache_l175_3[56] == 1'b1);
  assign when_icache_l175_200 = (_zz_when_icache_l175_3[55] == 1'b1);
  assign when_icache_l175_201 = (_zz_when_icache_l175_3[54] == 1'b1);
  assign when_icache_l175_202 = (_zz_when_icache_l175_3[53] == 1'b1);
  assign when_icache_l175_203 = (_zz_when_icache_l175_3[52] == 1'b1);
  assign when_icache_l175_204 = (_zz_when_icache_l175_3[51] == 1'b1);
  assign when_icache_l175_205 = (_zz_when_icache_l175_3[50] == 1'b1);
  assign when_icache_l175_206 = (_zz_when_icache_l175_3[49] == 1'b1);
  assign when_icache_l175_207 = (_zz_when_icache_l175_3[48] == 1'b1);
  assign when_icache_l175_208 = (_zz_when_icache_l175_3[47] == 1'b1);
  assign when_icache_l175_209 = (_zz_when_icache_l175_3[46] == 1'b1);
  assign when_icache_l175_210 = (_zz_when_icache_l175_3[45] == 1'b1);
  assign when_icache_l175_211 = (_zz_when_icache_l175_3[44] == 1'b1);
  assign when_icache_l175_212 = (_zz_when_icache_l175_3[43] == 1'b1);
  assign when_icache_l175_213 = (_zz_when_icache_l175_3[42] == 1'b1);
  assign when_icache_l175_214 = (_zz_when_icache_l175_3[41] == 1'b1);
  assign when_icache_l175_215 = (_zz_when_icache_l175_3[40] == 1'b1);
  assign when_icache_l175_216 = (_zz_when_icache_l175_3[39] == 1'b1);
  assign when_icache_l175_217 = (_zz_when_icache_l175_3[38] == 1'b1);
  assign when_icache_l175_218 = (_zz_when_icache_l175_3[37] == 1'b1);
  assign when_icache_l175_219 = (_zz_when_icache_l175_3[36] == 1'b1);
  assign when_icache_l175_220 = (_zz_when_icache_l175_3[35] == 1'b1);
  assign when_icache_l175_221 = (_zz_when_icache_l175_3[34] == 1'b1);
  assign when_icache_l175_222 = (_zz_when_icache_l175_3[33] == 1'b1);
  assign when_icache_l175_223 = (_zz_when_icache_l175_3[32] == 1'b1);
  assign when_icache_l175_224 = (_zz_when_icache_l175_3[31] == 1'b1);
  assign when_icache_l175_225 = (_zz_when_icache_l175_3[30] == 1'b1);
  assign when_icache_l175_226 = (_zz_when_icache_l175_3[29] == 1'b1);
  assign when_icache_l175_227 = (_zz_when_icache_l175_3[28] == 1'b1);
  assign when_icache_l175_228 = (_zz_when_icache_l175_3[27] == 1'b1);
  assign when_icache_l175_229 = (_zz_when_icache_l175_3[26] == 1'b1);
  assign when_icache_l175_230 = (_zz_when_icache_l175_3[25] == 1'b1);
  assign when_icache_l175_231 = (_zz_when_icache_l175_3[24] == 1'b1);
  assign when_icache_l175_232 = (_zz_when_icache_l175_3[23] == 1'b1);
  assign when_icache_l175_233 = (_zz_when_icache_l175_3[22] == 1'b1);
  assign when_icache_l175_234 = (_zz_when_icache_l175_3[21] == 1'b1);
  assign when_icache_l175_235 = (_zz_when_icache_l175_3[20] == 1'b1);
  assign when_icache_l175_236 = (_zz_when_icache_l175_3[19] == 1'b1);
  assign when_icache_l175_237 = (_zz_when_icache_l175_3[18] == 1'b1);
  assign when_icache_l175_238 = (_zz_when_icache_l175_3[17] == 1'b1);
  assign when_icache_l175_239 = (_zz_when_icache_l175_3[16] == 1'b1);
  assign when_icache_l175_240 = (_zz_when_icache_l175_3[15] == 1'b1);
  assign when_icache_l175_241 = (_zz_when_icache_l175_3[14] == 1'b1);
  assign when_icache_l175_242 = (_zz_when_icache_l175_3[13] == 1'b1);
  assign when_icache_l175_243 = (_zz_when_icache_l175_3[12] == 1'b1);
  assign when_icache_l175_244 = (_zz_when_icache_l175_3[11] == 1'b1);
  assign when_icache_l175_245 = (_zz_when_icache_l175_3[10] == 1'b1);
  assign when_icache_l175_246 = (_zz_when_icache_l175_3[9] == 1'b1);
  assign when_icache_l175_247 = (_zz_when_icache_l175_3[8] == 1'b1);
  assign when_icache_l175_248 = (_zz_when_icache_l175_3[7] == 1'b1);
  assign when_icache_l175_249 = (_zz_when_icache_l175_3[6] == 1'b1);
  assign when_icache_l175_250 = (_zz_when_icache_l175_3[5] == 1'b1);
  assign when_icache_l175_251 = (_zz_when_icache_l175_3[4] == 1'b1);
  assign when_icache_l175_252 = (_zz_when_icache_l175_3[3] == 1'b1);
  assign when_icache_l175_253 = (_zz_when_icache_l175_3[2] == 1'b1);
  assign when_icache_l175_254 = (_zz_when_icache_l175_3[1] == 1'b1);
  assign when_icache_l175_255 = (_zz_when_icache_l175_3[0] == 1'b1);
  assign readSM_readCycles = 2'b11;
  assign readSM_avrOffset = _zz_readSM_avrOffset[7:0];
  assign when_icache_l242 = (readSM_counter == readSM_readCycles);
  assign when_icache_l258 = (2'b00 == readPart);
  assign when_icache_l258_1 = (2'b01 == readPart);
  assign when_icache_l258_2 = (2'b10 == readPart);
  assign when_icache_l258_3 = (2'b11 == readPart);
  assign when_icache_l263 = (_zz_when_icache_l263 == readPos);
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      romIO_memAddr <= 15'h0;
      cacheLineAvr <= 256'h0;
      _zz_when_icache_l99 <= 24'hffffff;
      _zz_matchedPage <= 2'b00;
      _zz_when_icache_l99_1 <= 24'hffffff;
      _zz_matchedPage_1 <= 2'b01;
      _zz_when_icache_l99_2 <= 24'hffffff;
      _zz_matchedPage_2 <= 2'b10;
      _zz_when_icache_l99_3 <= 24'hffffff;
      _zz_matchedPage_3 <= 2'b11;
      readSM_state <= `cacheState_binary_sequential_IDLE;
      readSM_romReadReg <= 32'h0;
      readSM_counter <= 2'b00;
      readSM_assignLowPos <= 6'h0;
    end else begin
      if(when_icache_l115) begin
        if(when_icache_l117) begin
          _zz_matchedPage <= (_zz_matchedPage - 2'b01);
        end
        if(when_icache_l120) begin
          _zz_matchedPage <= (_zz_matchedPage + 2'b01);
        end
        if(when_icache_l117_1) begin
          _zz_matchedPage_1 <= (_zz_matchedPage_1 - 2'b01);
        end
        if(when_icache_l120_1) begin
          _zz_matchedPage_1 <= (_zz_matchedPage_1 + 2'b01);
        end
        if(when_icache_l117_2) begin
          _zz_matchedPage_2 <= (_zz_matchedPage_2 - 2'b01);
        end
        if(when_icache_l120_2) begin
          _zz_matchedPage_2 <= (_zz_matchedPage_2 + 2'b01);
        end
        if(when_icache_l117_3) begin
          _zz_matchedPage_3 <= (_zz_matchedPage_3 - 2'b01);
        end
        if(when_icache_l120_3) begin
          _zz_matchedPage_3 <= (_zz_matchedPage_3 + 2'b01);
        end
      end
      if(when_icache_l127) begin
        if(when_icache_l129) begin
          _zz_when_icache_l99 <= ioHighAddr;
          cacheLineAvr[63 : 0] <= 64'h0;
        end
        if(when_icache_l129_1) begin
          _zz_when_icache_l99_1 <= ioHighAddr;
          cacheLineAvr[127 : 64] <= 64'h0;
        end
        if(when_icache_l129_2) begin
          _zz_when_icache_l99_2 <= ioHighAddr;
          cacheLineAvr[191 : 128] <= 64'h0;
        end
        if(when_icache_l129_3) begin
          _zz_when_icache_l99_3 <= ioHighAddr;
          cacheLineAvr[255 : 192] <= 64'h0;
        end
      end
      case(readSM_state)
        `cacheState_binary_sequential_IDLE : begin
          romIO_memAddr <= _zz_romIO_memAddr[14:0];
          readSM_assignLowPos <= readLowPos;
          if(doRead) begin
            readSM_state <= `cacheState_binary_sequential_READ;
          end
        end
        `cacheState_binary_sequential_READ : begin
          if(pageReAssign) begin
            readSM_counter <= 2'b00;
            readSM_state <= `cacheState_binary_sequential_IDLE;
          end else begin
            readSM_romReadReg[_zz_readSM_romReadReg +: 8] <= romIO_memFlow_payload;
            if(romIO_memFlow_valid) begin
              readSM_counter <= (readSM_counter + 2'b01);
              if(when_icache_l242) begin
                readSM_state <= `cacheState_binary_sequential_ASSERT_1;
              end
            end
          end
        end
        default : begin
          readSM_counter <= 2'b00;
          romIO_memAddr <= _zz_romIO_memAddr_1[14:0];
          readSM_assignLowPos <= readLowPos;
          if(pageReAssign) begin
            readSM_state <= `cacheState_binary_sequential_IDLE;
          end else begin
            cacheLineAvr[_zz_cacheLineAvr] <= 1'b1;
            if(doRead) begin
              if(when_icache_l263) begin
                readSM_state <= `cacheState_binary_sequential_IDLE;
              end else begin
                readSM_state <= `cacheState_binary_sequential_READ;
              end
            end else begin
              readSM_state <= `cacheState_binary_sequential_IDLE;
            end
          end
        end
      endcase
    end
  end

  always @(posedge clk) begin
    _zz_cacheIO_readValid <= 1'b0;
    _zz_cacheIO_readData <= 32'h0;
    if(when_icache_l99) begin
      _zz_cacheIO_readValid <= _zz__zz_cacheIO_readValid[_zz__zz_cacheIO_readValid_1];
      _zz_cacheIO_readData <= _zz__zz_5_port0;
    end
    if(when_icache_l99_1) begin
      _zz_cacheIO_readValid <= _zz__zz_cacheIO_readValid_2[_zz__zz_cacheIO_readValid_3];
      _zz_cacheIO_readData <= _zz__zz_6_port0;
    end
    if(when_icache_l99_2) begin
      _zz_cacheIO_readValid <= _zz__zz_cacheIO_readValid_4[_zz__zz_cacheIO_readValid_5];
      _zz_cacheIO_readData <= _zz__zz_7_port0;
    end
    if(when_icache_l99_3) begin
      _zz_cacheIO_readValid <= _zz__zz_cacheIO_readValid_6[_zz__zz_cacheIO_readValid_7];
      _zz_cacheIO_readData <= _zz__zz_8_port0;
    end
    _zz_cacheIO_readValid_1 <= 1'b0;
    _zz_cacheIO_readData_1 <= 32'h0;
    if(when_icache_l99_4) begin
      _zz_cacheIO_readValid_1 <= _zz__zz_cacheIO_readValid_1_1[_zz__zz_cacheIO_readValid_1_2];
      _zz_cacheIO_readData_1 <= _zz__zz_5_port1;
    end
    if(when_icache_l99_5) begin
      _zz_cacheIO_readValid_1 <= _zz__zz_cacheIO_readValid_1_3[_zz__zz_cacheIO_readValid_1_4];
      _zz_cacheIO_readData_1 <= _zz__zz_6_port1;
    end
    if(when_icache_l99_6) begin
      _zz_cacheIO_readValid_1 <= _zz__zz_cacheIO_readValid_1_5[_zz__zz_cacheIO_readValid_1_6];
      _zz_cacheIO_readData_1 <= _zz__zz_7_port1;
    end
    if(when_icache_l99_7) begin
      _zz_cacheIO_readValid_1 <= _zz__zz_cacheIO_readValid_1_7[_zz__zz_cacheIO_readValid_1_8];
      _zz_cacheIO_readData_1 <= _zz__zz_8_port1;
    end
  end


endmodule
