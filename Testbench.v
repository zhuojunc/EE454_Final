`timescale 1ns / 1ps

module axiProtocol_tb;
	reg clk;
    always #10 clk = ~clk;


    reg  rst;
	reg  en;
	reg en_;
	// reg LAST;
	// reg [7:0] ARADDR;
	// reg [3:0] ARLEN;
	// reg [3:0] ARID;
	// reg [7:0] AWADDR;
	// reg [3:0] AWID;
	reg [127:0] INDATA;
    reg [15:0] tb_R;
    reg [15:0] tb_W;

    wire ARREADY;
	wire RVALID;
	wire RLAST;
	wire AWREADY;
	wire WREADY;
	wire BVALID;
	wire [4:0] BRESP;

    wire ARVALID;
    wire RREADY;
	wire [15:0] MOUT;
    wire [8:0] SOUT;
	wire RRESP;
	wire [7:0] RDATA;
	wire AWVALID;
	wire WVALID;
	wire WLAST;
	wire BREADY;
	wire [11:0] AWOUT;
	wire [7:0] WDATA;
	wire [4:0] BOUT;
	
	integer i;
	integer j;

Master DUT(.rst(rst), .clk(clk), .en(en), .en_(en_), .tb_R(tb_R), .IN(SOUT), .tb_W(tb_W), .INDATA(INDATA), 
.ARREADY(ARREADY), .RVALID(RVALID), .RLAST(RLAST), .AWREADY(AWREADY), .WREADY(WREADY), .BVALID(BVALID), .BRESP(BRESP),
.ARVALID(ARVALID), .RREADY(RREADY), .OUT(MOUT), .RRESP(RRESP), .RDATA(RDATA), .AWVALID(AWVALID), .WVALID(WVALID), .WLAST(WLAST), .BREADY(BREADY), .AWOUT(AWOUT), .WDATA(WDATA), .BOUT(BOUT));

Slave UUT(.rst(rst), .clk(clk), .ARVALID(ARVALID), .RREADY(RREADY), .IN(MOUT), .AWVALID(AWVALID), .WVALID(WVALID), .WLAST(WLAST), .AWIN(AWOUT), .WDATA(WDATA), .BREADY(BREADY),
.ARREADY(ARREADY), .RVALID(RVALID), .RLAST(RLAST), .OUT(SOUT), .AWREADY(AWREADY), .WREADY(WREADY), .BVALID(BVALID), .BRESP(BRESP));

initial
begin
    //  initialize everything input to zero
    rst = 0;
    clk = 0;
    en = 0;
    en_ = 0;
    // LAST = 0;
    // ARADDR = 0;
    // ARLEN = 0;
    // ARID = 0;
    // AWADDR = 0;
    INDATA = 0;
    tb_R = 0;
    tb_W = 0;

    // test case 1 (write 8 data)
    rst = 1;
    #20
    rst = 0;

        // BURST WRITE
        #10
        INDATA[7:0] = 8'b00000001;
        INDATA[15:8] = 8'b00000010;
        INDATA[23:16] = 8'b00000011;
	INDATA[31:24] = 8'b00000100;

	INDATA[39:32] = 8'b00000001;
        INDATA[47:40] = 8'b00000010;
        INDATA[55:48] = 8'b00000011;
	INDATA[63:56] = 8'b00000100;

        tb_W[15:8] = 8'b00000001;
        tb_W[7:4] = 4'b0111;
        tb_W[3:0] = 4'b0001;
		
		$display("Starting WRITE %d", tb_W[3:0]);
	    for (i = 0; i <= tb_W[7:4]; i = i + 1) begin
			$display("Expected WRITE data %d to ADDR %d", INDATA[i * 8 +: 8], tb_W[15:8] + i);
		end		
	
        en_ = 1;
        #20 
        en_ = 0;



    // test case 1 (read 8 data)
    #4000
    rst = 1;
    #20
    rst = 0;

        // BURST READ
        #10
        tb_R[15:8] = 8'b00000001;
        tb_R[7:4] = 4'b0111;
        tb_R[3:0] = 4'b0001;
		
		$display("\nStarting READ %d", tb_R[3:0]);
	    for (j = 0; j <= tb_R[7:4]; j = j + 1) begin
			$display("Expected READ data %d starting at ADDR %d", INDATA[j * 8 +: 8], tb_R[15:8]);
		end
		
        en = 1;
        #20 
        en = 0;
	
	#4000
    INDATA = 0;
    tb_R = 0;
    tb_W = 0;

    // test case 2 (write 16 data)
    rst = 1;
    #20
    rst = 0;

        // BURST WRITE
        #10
        INDATA[7:0] = 8'b00000001;
        INDATA[15:8] = 8'b00000010;
        INDATA[23:16] = 8'b00000011;
	INDATA[31:24] = 8'b00000100;

	INDATA[39:32] = 8'b00000001;
        INDATA[47:40] = 8'b00000010;
        INDATA[55:48] = 8'b00000011;
	INDATA[63:56] = 8'b00000100;

	INDATA[71:64] = 8'b00000001;
        INDATA[79:72] = 8'b00000010;
        INDATA[87:80] = 8'b00000011;
	INDATA[95:88] = 8'b00000100;

	INDATA[103:96] = 8'b00000001;
        INDATA[111:104] = 8'b00000010;
        INDATA[119:112] = 8'b00000011;
	INDATA[127:120] = 8'b00000100;

        tb_W[15:8] = 8'b00000001;
        tb_W[7:4] = 4'b1111;
        tb_W[3:0] = 4'b0010;
		
		$display("\nStarting WRITE %d", tb_W[3:0]);
	    for (i = 0; i <= tb_W[7:4]; i = i + 1) begin
			$display("Expected WRITE data %d to ADDR %d", INDATA[i * 8 +: 8], tb_W[15:8] + i);
		end		
	
        en_ = 1;
        #20 
        en_ = 0;



    // test case 2 (read 16 data)
    #8000
    rst = 1;
    #20
    rst = 0;

        // BURST READ
        #10
        tb_R[15:8] = 8'b00000001;
        tb_R[7:4] = 4'b1111;
        tb_R[3:0] = 4'b0010;
		
		$display("\nStarting READ %d", tb_R[3:0]);
	    for (j = 0; j <= tb_R[7:4]; j = j + 1) begin
			$display("Expected READ data %d starting at ADDR %d", INDATA[j * 8 +: 8], tb_R[15:8]);
		end
		
        en = 1;
        #20 
        en = 0;	

	#8000
	INDATA = 0;
    tb_R = 0;
    tb_W = 0;

    // test case 3 (write 1 data)
    rst = 1;
    #20
    rst = 0;

        // BURST WRITE
        #10
        INDATA[7:0] = 8'b00000001;

        tb_W[15:8] = 8'b00000001;
        tb_W[7:4] = 4'b0000;
        tb_W[3:0] = 4'b0011;
		
		$display("\nStarting WRITE %d", tb_W[3:0]);
	    for (i = 0; i <= tb_W[7:4]; i = i + 1) begin
			$display("Expected WRITE data %d to ADDR %d", INDATA[i * 8 +: 8], tb_W[15:8] + i);
		end		
	
        en_ = 1;
        #20 
        en_ = 0;



    // test case 3 (read 1 data)
    #500
    rst = 1;
    #20
    rst = 0;

        // BURST READ
        #10
        tb_R[15:8] = 8'b00000001;
        tb_R[7:4] = 4'b0000;
        tb_R[3:0] = 4'b0011;
		
		$display("\nStarting READ %d", tb_R[3:0]);
	    for (j = 0; j <= tb_R[7:4]; j = j + 1) begin
			$display("Expected READ data %d starting at ADDR %d", INDATA[j * 8 +: 8], tb_R[15:8]);
		end
		
        en = 1;
        #20 
        en = 0;
end

endmodule
