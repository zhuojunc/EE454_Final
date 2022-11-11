`timescale 1ns / 1ps

always #10 clk = ~clk;

module axiProtocol_tb;

    reg  rst;
    reg  clk;
	reg  en;
	reg en_;
	reg  LAST;
	reg [7:0] ARADDR;
	reg [3:0] ARLEN;
	reg [3:0] ARID;
    reg [8:0] IN;
	reg [7:0] AWADDR;
	reg [3:0] AWID;
	reg [7:0] INDATA;

    wire ARVALID;
    wire RREADY;
	wire [15:0] OUT;
	wire RRESP;
	wire [7:0] RDATA;
	wire AWVALID;
	wire WVALID;
	wire WLAST;
	wire BREADY;
	wire [11:0] AWOUT;
	wire [7:0] WDATA;
	wire [4:0] BOUT;

Master DUT (.rst(rst), .clk(clk), .en(en), .en_(en_), .LAST(LAST), .ARADDR(ARADDR), .ARLEN(ARLEN), .ARID(ARID), .AWADDR(AWADDR), .AWID(AWID), .INDATA(INDATA), 
.ARVALID(ARVALID), .RREADY(RREADY), .OUT(OUT), .RRESP(RRESP), .RDATA(RDATA), .AWVALID(AWVALID), .WVALID(WVALID), .WLAST(WLAST), .BREADY(BREADY), .AWOUT(AWOUT), .WDATA(WDATA), .BOUT(BOUT)) 

initial
begin
    //  initialize everything input to zero
    rst = 0;
    clk = 0;
    en = 0;
    en_ = 0;
    LAST = 0;
    ARADDR = 0;
    ARLEN = 0;
    ARID = 0;
    IN = 0;
    AWADDR = 0;
    INDATA = 0;

    // test case 1 (write 3 data)
    rst = 1;
    #20
    rst = 0;

        AWID = 1;
        // first data
        #10
        INDATA = 1;
        AWADDR = 1;
        en_ = 1;
        #20 
        en_ = 0;

        // second data
        #200
        INDATA = 2;
        AWADDR = 2;
        en_ = 1;
        #20 
        en_ = 0;

        // third data
        #200
        INDATA = 1;
        AWADDR = 1;
        LAST = 1
        en_ = 1;
        #20 
        en_ = 0;

    // test case 2 (read 3 data)
    rst = 1;
    #20
    rst = 0;

        ARID = 1;
        ARLEN = 3;
        // read from address 1
        #10
        ARADDR = 1;
        en = 1;
        #20 
        en = 0;

        // read from address 2
        #200
        ARADDR = 2;
        en = 1;
        #20 
        en = 0;

        // read from address 2
        #200
        ARADDR = 3;
        en = 1;
        #20 
        en = 0;
end

endmodule