`timescale 1ns / 1ps

always #10 clk = ~clk;

module axiProtocol_tb();

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

    // test case 1 ()
    
end


endmodule