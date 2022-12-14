`timescale 1ns / 1ps

module control_tb;
	reg clk;
    always #10 clk = ~clk;

    reg  rst;
	reg  en;
    reg  [7:0] opcode;	// opcode[7:4] ID, opcode[3:2] ALU-01, MEM-10, IO-11, opcode[1] R-0, W-1, opcode[0] waiting-0, running-1	
	// DELAY 
	wire [4:0] ALU_DELAY = 5'b01010;
	wire [4:0] MEM_DELAY = 5'b10100;
	wire [4:0] IO_DELAY = 5'b11110;
	// ALU Master input
	wire [8:0] ALU_IN;
	wire  ALU_ARREADY;
	wire  ALU_RVALID;
	wire  ALU_RLAST;
	wire  ALU_AWREADY;
	wire  ALU_WREADY;
	wire  ALU_BVALID;
	wire [4:0] ALU_BRESP;
	wire  ALU_WIDLE;
	wire  ALU_RIDLE;
	wire  ALU_WIDLE_prev;
	wire  ALU_RIDLE_prev;
	// MEM Master input
	wire [8:0] MEM_IN;
	wire  MEM_ARREADY;
	wire  MEM_RVALID;
	wire  MEM_RLAST;
	wire  MEM_AWREADY;
	wire  MEM_WREADY;
	wire  MEM_BVALID;
	wire [4:0] MEM_BRESP;
	wire  MEM_WIDLE;
	wire  MEM_RIDLE;
	wire  MEM_WIDLE_prev;
	wire  MEM_RIDLE_prev;
	// I/O Master input
	wire [8:0] IO_IN;
	wire  IO_ARREADY;
	wire  IO_RVALID;
	wire  IO_RLAST;
	wire  IO_AWREADY;
	wire  IO_WREADY;
	wire  IO_BVALID;
	wire [4:0] IO_BRESP;
	wire  IO_WIDLE;
	wire  IO_RIDLE;
	wire  IO_WIDLE_prev;
	wire  IO_RIDLE_prev;
	// ALU Master output
    wire ALU_ARVALID;
    wire ALU_RREADY;
	wire [15:0] ALU_OUT;
	wire ALU_RRESP;
	wire [7:0] ALU_RDATA;
	wire ALU_AWVALID;
	wire ALU_WVALID;
	wire ALU_WLAST;
	wire ALU_BREADY;
	wire [11:0] ALU_AWOUT;
	wire [7:0] ALU_WDATA;
	wire [4:0] ALU_BOUT;
	// MEM Master output
    wire MEM_ARVALID;
    wire MEM_RREADY;
	wire [15:0] MEM_OUT;
	wire MEM_RRESP;
	wire [7:0] MEM_RDATA;
	wire MEM_AWVALID;
	wire MEM_WVALID;
	wire MEM_WLAST;
	wire MEM_BREADY;
	wire [11:0] MEM_AWOUT;
	wire [7:0] MEM_WDATA;
	wire [4:0] MEM_BOUT;
	// I/O Master output
    wire IO_ARVALID;
    wire IO_RREADY;
	wire [15:0] IO_OUT;
	wire IO_RRESP;
	wire [7:0] IO_RDATA;
	wire IO_AWVALID;
	wire IO_WVALID;
	wire IO_WLAST;
	wire IO_BREADY;
	wire [11:0] IO_AWOUT;
	wire [7:0] IO_WDATA;
	wire [4:0] IO_BOUT;

Controller DUT(.rst(rst), .clk(clk), .en(en), .opcode(opcode), 
.ALU_IN(ALU_IN), .ALU_ARREADY(ALU_ARREADY), .ALU_RVALID(ALU_RVALID), .ALU_RLAST(ALU_RLAST), .ALU_AWREADY(ALU_AWREADY), .ALU_WREADY(ALU_WREADY), // ALU Master input
.ALU_BVALID(ALU_BVALID), .ALU_BRESP(ALU_BRESP), .ALU_WIDLE(ALU_WIDLE), .ALU_RIDLE(ALU_RIDLE), .ALU_WIDLE_prev(ALU_WIDLE_prev), .ALU_RIDLE_prev(ALU_RIDLE_prev), 
.MEM_IN(MEM_IN), .MEM_ARREADY(MEM_ARREADY), .MEM_RVALID(MEM_RVALID), .MEM_RLAST(MEM_RLAST), .MEM_AWREADY(MEM_AWREADY), .MEM_WREADY(MEM_WREADY), // MEM Master input
.MEM_BVALID(MEM_BVALID), .MEM_BRESP(MEM_BRESP), .MEM_WIDLE(MEM_WIDLE), .MEM_RIDLE(MEM_RIDLE), .MEM_WIDLE_prev(MEM_WIDLE_prev), .MEM_RIDLE_prev(MEM_RIDLE_prev),
.IO_IN(IO_IN), .IO_ARREADY(IO_ARREADY), .IO_RVALID(IO_RVALID), .IO_RLAST(IO_RLAST), .IO_AWREADY(IO_AWREADY), .IO_WREADY(IO_WREADY), // I/O Master input
.IO_BVALID(IO_BVALID), .IO_BRESP(IO_BRESP), .IO_WIDLE(IO_WIDLE), .IO_RIDLE(IO_RIDLE), .IO_WIDLE_prev(IO_WIDLE_prev), .IO_RIDLE_prev(IO_RIDLE_prev), 
.ALU_ARVALID(ALU_ARVALID), .ALU_RREADY(ALU_RREADY), .ALU_OUT(ALU_OUT), .ALU_RRESP(ALU_RRESP), .ALU_RDATA(ALU_RDATA), .ALU_AWVALID(ALU_AWVALID), // ALU Master output
.ALU_WVALID(ALU_WVALID), .ALU_WLAST(ALU_WLAST), .ALU_BREADY(ALU_BREADY), .ALU_AWOUT(ALU_AWOUT), .ALU_WDATA(ALU_WDATA), .ALU_BOUT(ALU_BOUT),
.MEM_ARVALID(MEM_ARVALID), .MEM_RREADY(MEM_RREADY), .MEM_OUT(MEM_OUT), .MEM_RRESP(MEM_RRESP), .MEM_RDATA(MEM_RDATA), .MEM_AWVALID(MEM_AWVALID), // MEM Master output
.MEM_WVALID(MEM_WVALID), .MEM_WLAST(MEM_WLAST), .MEM_BREADY(MEM_BREADY), .MEM_AWOUT(MEM_AWOUT), .MEM_WDATA(MEM_WDATA), .MEM_BOUT(MEM_BOUT),
.IO_ARVALID(IO_ARVALID), .IO_RREADY(IO_RREADY), .IO_OUT(IO_OUT), .IO_RRESP(IO_RRESP), .IO_RDATA(IO_RDATA), .IO_AWVALID(IO_AWVALID), // I/O Master output
.IO_WVALID(IO_WVALID), .IO_WLAST(IO_WLAST), .IO_BREADY(IO_BREADY), .IO_AWOUT(IO_AWOUT), .IO_WDATA(IO_WDATA), .IO_BOUT(IO_BOUT));

Slave ALU(.rst(rst), .clk(clk), 
.ARVALID(ALU_ARVALID), .RREADY(ALU_RREADY), .IN(ALU_OUT), .AWVALID(ALU_AWVALID), .WVALID(ALU_WVALID), // ALU Slave input
.WLAST(ALU_WLAST), .AWIN(ALU_AWOUT), .WDATA(ALU_WDATA), .BREADY(ALU_BREADY), .DELAY(ALU_DELAY),
.ARREADY(ALU_ARREADY), .RVALID(ALU_RVALID), .RLAST(ALU_RLAST), .OUT(ALU_IN), .AWREADY(ALU_AWREADY), // ALU Slave output
.WREADY(ALU_WREADY), .BVALID(ALU_BVALID), .BRESP(ALU_BRESP), .RIDLE(ALU_RIDLE), .WIDLE(ALU_WIDLE), .RIDLE_prev(ALU_RIDLE_prev), .WIDLE_prev(ALU_WIDLE_prev));

Slave MEM(.rst(rst), .clk(clk), 
.ARVALID(MEM_ARVALID), .RREADY(MEM_RREADY), .IN(MEM_OUT), .AWVALID(MEM_AWVALID), .WVALID(MEM_WVALID), // MEM Slave input
.WLAST(MEM_WLAST), .AWIN(MEM_AWOUT), .WDATA(MEM_WDATA), .BREADY(MEM_BREADY), .DELAY(MEM_DELAY),
.ARREADY(MEM_ARREADY), .RVALID(MEM_RVALID), .RLAST(MEM_RLAST), .OUT(MEM_IN), .AWREADY(MEM_AWREADY), // MEM Slave output
.WREADY(MEM_WREADY), .BVALID(MEM_BVALID), .BRESP(MEM_BRESP), .RIDLE(MEM_RIDLE), .WIDLE(MEM_WIDLE), .RIDLE_prev(MEM_RIDLE_prev), .WIDLE_prev(MEM_WIDLE_prev));

Slave IO(.rst(rst), .clk(clk), 
.ARVALID(IO_ARVALID), .RREADY(IO_RREADY), .IN(IO_OUT), .AWVALID(IO_AWVALID), .WVALID(IO_WVALID), // I/O Slave input
.WLAST(IO_WLAST), .AWIN(IO_AWOUT), .WDATA(IO_WDATA), .BREADY(IO_BREADY), .DELAY(IO_DELAY),
.ARREADY(IO_ARREADY), .RVALID(IO_RVALID), .RLAST(IO_RLAST), .OUT(IO_IN), .AWREADY(IO_AWREADY), // I/O Slave output
.WREADY(IO_WREADY), .BVALID(IO_BVALID), .BRESP(IO_BRESP), .RIDLE(IO_RIDLE), .WIDLE(IO_WIDLE), .RIDLE_prev(IO_RIDLE_prev), .WIDLE_prev(IO_WIDLE_prev));


initial
begin
	// setting everything to zero at the beginning
	rst = 0;
    clk = 0;
    en = 0;
	opcode = 0;

	rst = 1;
    #20
    rst = 0;

	// opcode[7:4] ID, opcode[3:2] ALU-01, MEM-10, IO-11, opcode[1] R-0, W-1, opcode[0] waiting-0, running-1	

	// [Read from ALU, ID 3]*
	opcode = 8'b00110100;
	en = 1;
	#20 
	en = 0;
	// [Write to Memory, ID 4]*
	opcode = 8'b01001010;
	en = 1;
	#20 
	en = 0;
	// [Write to IO, ID 4]
	opcode = 8'b01001110;
	en = 1;
	#20 
	en = 0;
	// [Read from Memory, ID 4]
	opcode = 8'b01001000;
	en = 1;
	#20 
	en = 0;
	// [Write to ALU, ID 3]
	opcode = 8'b00110110;
	en = 1;
	#20 
	en = 0;
	// [Read from Memory, ID 3]
	opcode = 8'b00111000;
	en = 1;
	#20 
	en = 0;
	// [Read from Memory, ID 5]*
	opcode = 8'b01011000;
	en = 1;
	#20 
	en = 0;
	// [Write to ALU, ID 4]
	opcode = 8'b01000110;
	en = 1;
	#20 
	en = 0;
end
endmodule
