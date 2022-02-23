`timescale 10ps/1ps
module icache_tb;

parameter readPortCount = 2;
parameter memPortWidth = 8;
parameter memSize = 32768;
parameter partSize = 64;

localparam readAvrMSB = readPortCount - 1;
localparam readPortMSB = readPortCount * 32 -1;
localparam memAddrMSB = ($clog2(memSize))-1;
localparam memPortMSB = memPortWidth -1;
localparam equivMemCount = 32/memPortWidth;

reg                     romIO_memFlow_valid=0;
reg  [memPortMSB:0]     romIO_memFlow_payload=0;
wire [memAddrMSB:0]     romIO_memAddr;
wire [readPortMSB:0]    cacheIO_readData;
wire [readAvrMSB:0]     cacheIO_readValid;
reg  [31:0]             cacheIO_readAddr=0;
reg                     clk=0;
reg                     resetn=0;

reg [memPortMSB:0]      ROM[memSize-1:0];
//reg [31:0]              ROM_EQ[memSize-1:0];
reg [31:0]              ROM_EQ[16-1:0];

integer timet;
integer timec;

reg[31:0] temp;
initial begin
    integer i;
    integer j;
    temp=$urandom($realtime());
    for(i=0;i<memSize;i=i+1)
        ROM[i] = $urandom();
    
    for(i=0;i<memSize;i=i+equivMemCount)begin
        for(j=0;j<equivMemCount;j=j+1)begin
            //temp= (temp << memPortWidth);
            //temp[memPortWidth:0] = ROM[i+j];
            temp= (temp >> memPortWidth);
            temp[31:31-memPortMSB] = ROM[i+j];
            //$display("TEMP = %h",temp);
        end
        ROM_EQ[i] <= temp;
    end

    #20;
    resetn=1;
    #10;
    @(posedge clk);
    timet=$time;
    @(posedge clk);
    timec=$time-timet;

    $display("start forward read");
    timet=$time;
    forward_check();
    timet=$time-timet;
    timet=timet/timec;
    $display("forward read time = %d, read count = %d",timet,memSize/4);
    $display("cycle per read = %f",1.0*timet/(memSize/4.0));
    
    $display("start dual read");
    timet=$time;
    seq_dualread();
    timet=$time-timet;
    timet=timet/timec;
    $display("dual read time = %d, read count = %d",timet,memSize/2);
    $display("cycle per read = %f",1.0*timet/(memSize/2.0));

    $display("start backward read");
    timet=$time;
    backward_check();
    timet=$time-timet;
    timet=timet/timec;
    $display("backward read time = %d, read count = %d",timet,memSize/4);
    $display("cycle per read = %f",1.0*timet/(memSize/4.0));

    $display("start small range random read");
    timet=$time;
    smallrange_random_check();
    timet=$time-timet;
    timet=timet/timec;
    $display("small range random read time = %d, read count = %d",timet,partSize*16*100);
    $display("cycle per read = %f",1.0*timet/(partSize*16*100.0));

    $display("start mid range random read");
    timet=$time;
    midrange_random_check();
    timet=$time-timet;
    timet=timet/timec;
    $display("mid range random read time = %d, read count = %d",timet,partSize*16*400);
    $display("cycle per read = %f",1.0*timet/(partSize*16*400.0));

    $display("start full range random read");
    timet=$time;
    fullrange_random_check();
    timet=$time-timet;
    timet=timet/timec;
    $display("full range random read time = %d, read count = %d",timet,memSize*100);
    $display("cycle per read = %f",1.0*timet/(memSize*100.0));

    $display("finish with no error");
    #200;
    $display("stop");
    $stop;
end

always begin
    #5 clk<=~clk;
end

reg [memAddrMSB:0]   lastAddr=0;
reg [3:0] IntAdr=0;

always@(*)begin
    romIO_memFlow_valid<=lastAddr==romIO_memAddr;
end

wire [memAddrMSB:0]     adrMux=romIO_memFlow_valid?romIO_memAddr+IntAdr:romIO_memAddr;

always@(posedge clk or negedge resetn) begin
    if(resetn==0)begin
        lastAddr<=32'hffffffff;
    end else begin
        lastAddr<=romIO_memAddr;
        romIO_memFlow_payload<=ROM[adrMux];

        if(romIO_memFlow_valid)begin
            if(IntAdr!=equivMemCount-1)
                IntAdr<=IntAdr+1;
        end else
            IntAdr<=1;
    end 
end

task read_next(input[31:0] adr);
    integer j;
    //$display("read_next: %h",adr);
    do begin
        @(posedge clk);
        #1;
        for(j=0;j<readPortCount;j=j+1)begin
            if(cacheIO_readValid[j])begin
                if(cacheIO_readData[j*32 +:32]!=ROM_EQ[cacheIO_readAddr+j])begin
                    $display("ERROR: ROM[%d] = %h, cacheIO_readData[%d] = %h, port = %d",cacheIO_readAddr+j,ROM_EQ[cacheIO_readAddr+j],j,cacheIO_readData[j*32 +:32],j);
                    $stop;
                end
            end
        end
    end
    while(cacheIO_readValid[0]==0);
    cacheIO_readAddr<=adr;
endtask

task forward_check();
    integer i;
    for(i=0;i<memSize;i=i+4)begin
        read_next(i);
    end
endtask

task seq_dualread();
    integer i;
    integer j;
    for(i=0;i<memSize;i=i+partSize*4)begin
        for(j=0;j<partSize*4;j=j+4)begin
            read_next(i+j);
        end
        for(j=0;j<partSize*4;j=j+4)begin
            read_next(i+j);
        end
    end
endtask

task backward_check();
    integer i;
    for(i=memSize-4;i>=0;i=i-4)begin
        read_next(i);
    end
endtask

task smallrange_random_check();
    integer i;
    integer j;
    integer k;
    integer m;
    for(j=0;j<16;j=j+1)begin
        m=$random();
        if(m<0)m=-m;
        m=m%(memSize/4);
        m=m*4;
        if(m>partSize*2)
            m=m-partSize*2;
        for(i=0;i<partSize*100;i=i+1)begin
            k=$random();
            if(k<0)k=-k;
            k=k%(partSize*2);
            k=k/4;
            k=k*4;
            read_next(m+k);
        end
    end
endtask

task midrange_random_check();
    integer i;
    integer j;
    integer k;
    integer m;
    integer readrange;
    readrange=24;
    //when readrange>16, cache reassign will occur continuesly
    //otherwise, cache hitrate would be close to 100%
    for(j=0;j<16;j=j+1)begin
        m=$random();
        if(m<0)m=-m;
        m=m%(memSize/4);
        m=m*4;
        if(m>partSize*readrange)
            m=m-partSize*readrange;
        for(i=0;i<partSize*400;i=i+1)begin
            k=$random();
            if(k<0)k=-k;
            k=k%(partSize*readrange);
            k=k/4;
            k=k*4;
            read_next(m+k);
        end
    end
endtask

task fullrange_random_check();
    integer i;
    integer k;
    for(i=0;i<memSize*100;i=i+1)begin
        k=$random();
        if(k<0)k=-k;
        k=k%memSize;
        k=k/4;
        k=k*4;
        read_next(k);
    end
endtask

icache DUT(
    .clk(clk),
    .resetn(resetn),
    .romIO_memFlow_valid(romIO_memFlow_valid),
    .romIO_memFlow_payload(romIO_memFlow_payload),
    .romIO_memAddr(romIO_memAddr),
    .cacheIO_readData(cacheIO_readData),
    .cacheIO_readValid(cacheIO_readValid),
    .cacheIO_readAddr(cacheIO_readAddr)
);

endmodule
