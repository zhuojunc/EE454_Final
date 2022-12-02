`timescale 1ns / 1ps

module Controller
(
    input  rst,
    input  clk,
	input  en,	// testbench suggests new instruction
	input  [7:0] opcode,	// opcode[7:4] ID, opcode[3:2] ALU-01, MEM-10, IO-11, opcode[1] R-0, W-1, opcode[0] waiting-0, running-1	
	// ALU Master input
	input [8:0] ALU_IN,
	input  ALU_ARREADY,
	input  ALU_RVALID,
	input  ALU_RLAST,
	input  ALU_AWREADY,
	input  ALU_WREADY,
	input  ALU_BVALID,
	input [4:0] ALU_BRESP,
	input  ALU_WIDLE,
	input  ALU_RIDLE,
	input  ALU_WIDLE_prev,
	input  ALU_RIDLE_prev,	
	// MEM Master input
	input [8:0] MEM_IN,
	input  MEM_ARREADY,
	input  MEM_RVALID,
	input  MEM_RLAST,
	input  MEM_AWREADY,
	input  MEM_WREADY,
	input  MEM_BVALID,
	input [4:0] MEM_BRESP,
	input  MEM_WIDLE,
	input  MEM_RIDLE,
	input  MEM_WIDLE_prev,
	input  MEM_RIDLE_prev,
	// I/O Master input
	input [8:0] IO_IN,
	input  IO_ARREADY,
	input  IO_RVALID,
	input  IO_RLAST,
	input  IO_AWREADY,
	input  IO_WREADY,
	input  IO_BVALID,
	input [4:0] IO_BRESP,
	input  IO_WIDLE,
	input  IO_RIDLE,
	input  IO_WIDLE_prev,
	input  IO_RIDLE_prev,	
// ALU Master output
    output reg ALU_ARVALID,
    output reg ALU_RREADY,
	output reg [15:0] ALU_OUT,
	output reg ALU_RRESP,
	output reg [7:0] ALU_RDATA,
	output reg ALU_AWVALID,
	output reg ALU_WVALID,
	output reg ALU_WLAST,
	output reg ALU_BREADY,
	output reg [11:0] ALU_AWOUT,
	output reg [7:0] ALU_WDATA,
	output reg [4:0] ALU_BOUT,
	// MEM Master output
    output reg MEM_ARVALID,
    output reg MEM_RREADY,
	output reg [15:0] MEM_OUT,
	output reg MEM_RRESP,
	output reg [7:0] MEM_RDATA,
	output reg MEM_AWVALID,
	output reg MEM_WVALID,
	output reg MEM_WLAST,
	output reg MEM_BREADY,
	output reg [11:0] MEM_AWOUT,
	output reg [7:0] MEM_WDATA,
	output reg [4:0] MEM_BOUT,
	// I/O Master output
    output reg IO_ARVALID,
    output reg IO_RREADY,
	output reg [15:0] IO_OUT,
	output reg IO_RRESP,
	output reg [7:0] IO_RDATA,
	output reg IO_AWVALID,
	output reg IO_WVALID,
	output reg IO_WLAST,
	output reg IO_BREADY,
	output reg [11:0] IO_AWOUT,
	output reg [7:0] IO_WDATA,
	output reg [4:0] IO_BOUT
);	
	
	reg ALU_en = 1'b0;
	reg ALU_en_ = 1'b0;
	reg [127:0] ALU_INDATA = 0;
    reg [15:0] ALU_R = 0;
    reg [15:0] ALU_W = 0;

    reg MEM_en = 1'b0;
    reg MEM_en_ = 1'b0;
    reg [127:0] MEM_INDATA = 0;
    reg [15:0] MEM_R = 0;
    reg [15:0] MEM_W = 0;

    reg IO_en = 1'b0;
    reg IO_en_ = 1'b0;
    reg [127:0] IO_INDATA = 0;
    reg [15:0] IO_R = 0;
    reg [15:0] IO_W = 0;


	
	// hardcoded 8 byte data
    always@(posedge clk) begin    
	    ALU_INDATA[7:0] = 8'b00000001;
	    ALU_INDATA[15:8] = 8'b00000010;
	    ALU_INDATA[23:16] = 8'b00000011;
	    ALU_INDATA[31:24] = 8'b00000100;

	    ALU_INDATA[39:32] = 8'b00000001;
	    ALU_INDATA[47:40] = 8'b00000010;
	    ALU_INDATA[55:48] = 8'b00000011;
	    ALU_INDATA[63:56] = 8'b00000100;

	    ALU_W[15:8] = 8'b00000001;
	    ALU_W[7:4] = 4'b0111;
	    // ALU_W[3:0] = 4'b0001;	

	    ALU_R[15:8] = 8'b00000001;
	    ALU_R[7:4] = 4'b0111;
	    // ALU_R[3:0] = 4'b0001;
	
	// hardcoded 8 byte data
    MEM_INDATA[7:0] = 8'b00000001;
    MEM_INDATA[15:8] = 8'b00000010;
    MEM_INDATA[23:16] = 8'b00000011;
	MEM_INDATA[31:24] = 8'b00000100;

	MEM_INDATA[39:32] = 8'b00000001;
    MEM_INDATA[47:40] = 8'b00000010;
    MEM_INDATA[55:48] = 8'b00000011;
	MEM_INDATA[63:56] = 8'b00000100;

    MEM_W[15:8] = 8'b00000001;
    MEM_W[7:4] = 4'b0111;
    // MEM_W[3:0] = 4'b0001;	

    MEM_R[15:8] = 8'b00000001;
    MEM_R[7:4] = 4'b0111;
    // MEM_R[3:0] = 4'b0001;	
	// hardcoded 8 byte data
    IO_INDATA[7:0] = 8'b00000001;
    IO_INDATA[15:8] = 8'b00000010;
    IO_INDATA[23:16] = 8'b00000011;
	IO_INDATA[31:24] = 8'b00000100;

	IO_INDATA[39:32] = 8'b00000001;
    IO_INDATA[47:40] = 8'b00000010;
    IO_INDATA[55:48] = 8'b00000011;
	IO_INDATA[63:56] = 8'b00000100;

    IO_W[15:8] = 8'b00000001;
    IO_W[7:4] = 4'b0111;
    // IO_W[3:0] = 4'b0001;	

    IO_R[15:8] = 8'b00000001;
    IO_R[7:4] = 4'b0111;
    // IO_R[3:0] = 4'b0001;	
    end	
	Master ALU(.rst(rst), .clk(clk), .en(ALU_en), .en_(ALU_en_), .tb_R(ALU_R), .IN(ALU_IN), .tb_W(ALU_W), .INDATA(ALU_INDATA), 
	.ARREADY(ALU_ARREADY), .RVALID(ALU_RVALID), .RLAST(ALU_RLAST), .AWREADY(ALU_AWREADY), .WREADY(ALU_WREADY), .BVALID(ALU_BVALID), .BRESP(ALU_BRESP), .WIDLE(ALU_WIDLE), .RIDLE(ALU_RIDLE), .WIDLE_prev(ALU_WIDLE_prev), .RIDLE_prev(ALU_RIDLE_prev),
	.ARVALID(ALU_ARVALID), .RREADY(ALU_RREADY), .OUT(ALU_OUT), .RRESP(ALU_RRESP), .RDATA(ALU_RDATA), .AWVALID(ALU_AWVALID), .WVALID(ALU_WVALID), .WLAST(ALU_WLAST), .BREADY(ALU_BREADY), .AWOUT(ALU_AWOUT), .WDATA(ALU_WDATA), .BOUT(ALU_BOUT));	

	Master MEM(.rst(rst), .clk(clk), .en(MEM_en), .en_(MEM_en_), .tb_R(MEM_R), .IN(MEM_IN), .tb_W(MEM_W), .INDATA(MEM_INDATA), 
	.ARREADY(MEM_ARREADY), .RVALID(MEM_RVALID), .RLAST(MEM_RLAST), .AWREADY(MEM_AWREADY), .WREADY(MEM_WREADY), .BVALID(MEM_BVALID), .BRESP(MEM_BRESP), .WIDLE(MEM_WIDLE), .RIDLE(MEM_RIDLE), .WIDLE_prev(MEM_WIDLE_prev), .RIDLE_prev(MEM_RIDLE_prev),
	.ARVALID(MEM_ARVALID), .RREADY(MEM_RREADY), .OUT(MEM_OUT), .RRESP(MEM_RRESP), .RDATA(MEM_RDATA), .AWVALID(MEM_AWVALID), .WVALID(MEM_WVALID), .WLAST(MEM_WLAST), .BREADY(MEM_BREADY), .AWOUT(MEM_AWOUT), .WDATA(MEM_WDATA), .BOUT(MEM_BOUT));
	
	Master IO(.rst(rst), .clk(clk), .en(IO_en), .en_(IO_en_), .tb_R(IO_R), .IN(IO_IN), .tb_W(IO_W), .INDATA(IO_INDATA), 
	.ARREADY(IO_ARREADY), .RVALID(IO_RVALID), .RLAST(IO_RLAST), .AWREADY(IO_AWREADY), .WREADY(IO_WREADY), .BVALID(IO_BVALID), .BRESP(IO_BRESP), .WIDLE(IO_WIDLE), .RIDLE(IO_RIDLE), .WIDLE_prev(IO_WIDLE_prev), .RIDLE_prev(IO_RIDLE_prev),
	.ARVALID(IO_ARVALID), .RREADY(IO_RREADY), .OUT(IO_OUT), .RRESP(IO_RRESP), .RDATA(IO_RDATA), .AWVALID(IO_AWVALID), .WVALID(IO_WVALID), .WLAST(IO_WLAST), .BREADY(IO_BREADY), .AWOUT(IO_AWOUT), .WDATA(IO_WDATA), .BOUT(IO_BOUT));
	
	reg [7:0] buffer [0:15];
	reg [3:0] buffer_index = 4'b0000; // next index to assign opcode
	reg  ID_Valid = 1'b1; // instruction can only be run if no previous in the queue with the same ID is running
	reg  idle = 1'b0; // a flag for showing any slave READ/WRITE state change
	// flags to keep track of whether each slave READ/WRITE is freed up
	reg ALU_R_change = 1'b0;
	reg ALU_W_change = 1'b0;
	reg MEM_R_change = 1'b0;
	reg MEM_W_change = 1'b0;
	reg IO_R_change = 1'b0;
	reg IO_W_change = 1'b0;
	reg [15:0] Valid = 1; // store all valid ID bits from the buffer, bit 0 always valid
	integer i;
	integer y;
	integer del_index = 16;
	
	initial begin
	    for (i = 0; i < 16; i = i + 1) begin
			buffer[i] <= 0;
		end	
	end
	
	// valid bit i keeps track of whether the instruction at buffer index i is valid
	always@ (posedge clk) begin
		Valid[1] <= !(buffer[0][0] && buffer[0][7:4] == buffer[1][7:4]);
		Valid[2] <= !(buffer[0][0] && buffer[0][7:4] == buffer[2][7:4]) &&
					!(buffer[1][0] && buffer[1][7:4] == buffer[2][7:4]);
		Valid[3] <= !(buffer[0][0] && buffer[0][7:4] == buffer[3][7:4]) &&
					!(buffer[1][0] && buffer[1][7:4] == buffer[3][7:4]) &&
					!(buffer[2][0] && buffer[2][7:4] == buffer[3][7:4]);
		Valid[4] <= !(buffer[0][0] && buffer[0][7:4] == buffer[4][7:4]) &&
					!(buffer[1][0] && buffer[1][7:4] == buffer[4][7:4]) &&
					!(buffer[2][0] && buffer[2][7:4] == buffer[4][7:4]) &&
					!(buffer[3][0] && buffer[3][7:4] == buffer[4][7:4]);
		Valid[5] <= !(buffer[0][0] && buffer[0][7:4] == buffer[5][7:4]) &&
					!(buffer[1][0] && buffer[1][7:4] == buffer[5][7:4]) &&
					!(buffer[2][0] && buffer[2][7:4] == buffer[5][7:4]) &&
					!(buffer[3][0] && buffer[3][7:4] == buffer[5][7:4]) &&
					!(buffer[4][0] && buffer[4][7:4] == buffer[5][7:4]);
		Valid[6] <= !(buffer[0][0] && buffer[0][7:4] == buffer[6][7:4]) &&
					!(buffer[1][0] && buffer[1][7:4] == buffer[6][7:4]) &&
					!(buffer[2][0] && buffer[2][7:4] == buffer[6][7:4]) &&
					!(buffer[3][0] && buffer[3][7:4] == buffer[6][7:4]) &&
					!(buffer[4][0] && buffer[4][7:4] == buffer[6][7:4]) &&
					!(buffer[5][0] && buffer[5][7:4] == buffer[6][7:4]);
		Valid[7] <= !(buffer[0][0] && buffer[0][7:4] == buffer[7][7:4]) &&
					!(buffer[1][0] && buffer[1][7:4] == buffer[7][7:4]) &&
					!(buffer[2][0] && buffer[2][7:4] == buffer[7][7:4]) &&
					!(buffer[3][0] && buffer[3][7:4] == buffer[7][7:4]) &&
					!(buffer[4][0] && buffer[4][7:4] == buffer[7][7:4]) &&
					!(buffer[5][0] && buffer[5][7:4] == buffer[7][7:4]) &&
					!(buffer[6][0] && buffer[6][7:4] == buffer[7][7:4]);
		Valid[8] <= !(buffer[0][0] && buffer[0][7:4] == buffer[8][7:4]) &&
					!(buffer[1][0] && buffer[1][7:4] == buffer[8][7:4]) &&
					!(buffer[2][0] && buffer[2][7:4] == buffer[8][7:4]) &&
					!(buffer[3][0] && buffer[3][7:4] == buffer[8][7:4]) &&
					!(buffer[4][0] && buffer[4][7:4] == buffer[8][7:4]) &&
					!(buffer[5][0] && buffer[5][7:4] == buffer[8][7:4]) &&
					!(buffer[6][0] && buffer[6][7:4] == buffer[8][7:4]) &&
					!(buffer[7][0] && buffer[7][7:4] == buffer[8][7:4]);
		Valid[9] <= !(buffer[0][0] && buffer[0][7:4] == buffer[9][7:4]) &&
					!(buffer[1][0] && buffer[1][7:4] == buffer[9][7:4]) &&
					!(buffer[2][0] && buffer[2][7:4] == buffer[9][7:4]) &&
					!(buffer[3][0] && buffer[3][7:4] == buffer[9][7:4]) &&
					!(buffer[4][0] && buffer[4][7:4] == buffer[9][7:4]) &&
					!(buffer[5][0] && buffer[5][7:4] == buffer[9][7:4]) &&
					!(buffer[6][0] && buffer[6][7:4] == buffer[9][7:4]) &&
					!(buffer[7][0] && buffer[7][7:4] == buffer[9][7:4]) &&
					!(buffer[8][0] && buffer[8][7:4] == buffer[9][7:4]);
		Valid[10] <= !(buffer[0][0] && buffer[0][7:4] == buffer[10][7:4]) &&
					!(buffer[1][0] && buffer[1][7:4] == buffer[10][7:4]) &&
					!(buffer[2][0] && buffer[2][7:4] == buffer[10][7:4]) &&
					!(buffer[3][0] && buffer[3][7:4] == buffer[10][7:4]) &&
					!(buffer[4][0] && buffer[4][7:4] == buffer[10][7:4]) &&
					!(buffer[5][0] && buffer[5][7:4] == buffer[10][7:4]) &&
					!(buffer[6][0] && buffer[6][7:4] == buffer[10][7:4]) &&
					!(buffer[7][0] && buffer[7][7:4] == buffer[10][7:4]) &&
					!(buffer[8][0] && buffer[8][7:4] == buffer[10][7:4]) &&
					!(buffer[9][0] && buffer[9][7:4] == buffer[10][7:4]);
		Valid[11] <= !(buffer[0][0] && buffer[0][7:4] == buffer[11][7:4]) &&
					!(buffer[1][0] && buffer[1][7:4] == buffer[11][7:4]) &&
					!(buffer[2][0] && buffer[2][7:4] == buffer[11][7:4]) &&
					!(buffer[3][0] && buffer[3][7:4] == buffer[11][7:4]) &&
					!(buffer[4][0] && buffer[4][7:4] == buffer[11][7:4]) &&
					!(buffer[5][0] && buffer[5][7:4] == buffer[11][7:4]) &&
					!(buffer[6][0] && buffer[6][7:4] == buffer[11][7:4]) &&
					!(buffer[7][0] && buffer[7][7:4] == buffer[11][7:4]) &&
					!(buffer[8][0] && buffer[8][7:4] == buffer[11][7:4]) &&
					!(buffer[9][0] && buffer[9][7:4] == buffer[11][7:4]) &&
					!(buffer[10][0] && buffer[10][7:4] == buffer[11][7:4]);
		Valid[12] <= !(buffer[0][0] && buffer[0][7:4] == buffer[12][7:4]) &&
					!(buffer[1][0] && buffer[1][7:4] == buffer[12][7:4]) &&
					!(buffer[2][0] && buffer[2][7:4] == buffer[12][7:4]) &&
					!(buffer[3][0] && buffer[3][7:4] == buffer[12][7:4]) &&
					!(buffer[4][0] && buffer[4][7:4] == buffer[12][7:4]) &&
					!(buffer[5][0] && buffer[5][7:4] == buffer[12][7:4]) &&
					!(buffer[6][0] && buffer[6][7:4] == buffer[12][7:4]) &&
					!(buffer[7][0] && buffer[7][7:4] == buffer[12][7:4]) &&
					!(buffer[8][0] && buffer[8][7:4] == buffer[12][7:4]) &&
					!(buffer[9][0] && buffer[9][7:4] == buffer[12][7:4]) &&
					!(buffer[10][0] && buffer[10][7:4] == buffer[12][7:4]) &&
					!(buffer[11][0] && buffer[11][7:4] == buffer[12][7:4]);
		Valid[13] <= !(buffer[0][0] && buffer[0][7:4] == buffer[13][7:4]) &&
					!(buffer[1][0] && buffer[1][7:4] == buffer[13][7:4]) &&
					!(buffer[2][0] && buffer[2][7:4] == buffer[13][7:4]) &&
					!(buffer[3][0] && buffer[3][7:4] == buffer[13][7:4]) &&
					!(buffer[4][0] && buffer[4][7:4] == buffer[13][7:4]) &&
					!(buffer[5][0] && buffer[5][7:4] == buffer[13][7:4]) &&
					!(buffer[6][0] && buffer[6][7:4] == buffer[13][7:4]) &&
					!(buffer[7][0] && buffer[7][7:4] == buffer[13][7:4]) &&
					!(buffer[8][0] && buffer[8][7:4] == buffer[13][7:4]) &&
					!(buffer[9][0] && buffer[9][7:4] == buffer[13][7:4]) &&
					!(buffer[10][0] && buffer[10][7:4] == buffer[13][7:4]) &&
					!(buffer[11][0] && buffer[11][7:4] == buffer[13][7:4]) &&
					!(buffer[12][0] && buffer[12][7:4] == buffer[13][7:4]);
		Valid[14] <= !(buffer[0][0] && buffer[0][7:4] == buffer[14][7:4]) &&
					!(buffer[1][0] && buffer[1][7:4] == buffer[14][7:4]) &&
					!(buffer[2][0] && buffer[2][7:4] == buffer[14][7:4]) &&
					!(buffer[3][0] && buffer[3][7:4] == buffer[14][7:4]) &&
					!(buffer[4][0] && buffer[4][7:4] == buffer[14][7:4]) &&
					!(buffer[5][0] && buffer[5][7:4] == buffer[14][7:4]) &&
					!(buffer[6][0] && buffer[6][7:4] == buffer[14][7:4]) &&
					!(buffer[7][0] && buffer[7][7:4] == buffer[14][7:4]) &&
					!(buffer[8][0] && buffer[8][7:4] == buffer[14][7:4]) &&
					!(buffer[9][0] && buffer[9][7:4] == buffer[14][7:4]) &&
					!(buffer[10][0] && buffer[10][7:4] == buffer[14][7:4]) &&
					!(buffer[11][0] && buffer[11][7:4] == buffer[14][7:4]) &&
					!(buffer[12][0] && buffer[12][7:4] == buffer[14][7:4]) &&
					!(buffer[13][0] && buffer[13][7:4] == buffer[14][7:4]);
		Valid[15] <= !(buffer[0][0] && buffer[0][7:4] == buffer[15][7:4]) &&
					!(buffer[1][0] && buffer[1][7:4] == buffer[15][7:4]) &&
					!(buffer[2][0] && buffer[2][7:4] == buffer[15][7:4]) &&
					!(buffer[3][0] && buffer[3][7:4] == buffer[15][7:4]) &&
					!(buffer[4][0] && buffer[4][7:4] == buffer[15][7:4]) &&
					!(buffer[5][0] && buffer[5][7:4] == buffer[15][7:4]) &&
					!(buffer[6][0] && buffer[6][7:4] == buffer[15][7:4]) &&
					!(buffer[7][0] && buffer[7][7:4] == buffer[15][7:4]) &&
					!(buffer[8][0] && buffer[8][7:4] == buffer[15][7:4]) &&
					!(buffer[9][0] && buffer[9][7:4] == buffer[15][7:4]) &&
					!(buffer[10][0] && buffer[10][7:4] == buffer[15][7:4]) &&
					!(buffer[11][0] && buffer[11][7:4] == buffer[15][7:4]) &&
					!(buffer[12][0] && buffer[12][7:4] == buffer[15][7:4]) &&
					!(buffer[13][0] && buffer[13][7:4] == buffer[15][7:4]) &&
					!(buffer[14][0] && buffer[14][7:4] == buffer[15][7:4]);
	end
	
	always@ (posedge clk) begin
		// when a new instruction is given
		if (en) begin
			buffer[buffer_index] <= opcode;
			buffer_index <= buffer_index + 1;

			// check all instructions in buffer to have different ID from the new instruction
			ID_Valid <= !(buffer[0][0] && buffer[0][7:4] == opcode[7:4]) &&
					!(buffer[1][0] && buffer[1][7:4] == opcode[7:4]) &&
					!(buffer[2][0] && buffer[2][7:4] == opcode[7:4]) &&
					!(buffer[3][0] && buffer[3][7:4] == opcode[7:4]) &&
					!(buffer[4][0] && buffer[4][7:4] == opcode[7:4]) &&
					!(buffer[5][0] && buffer[5][7:4] == opcode[7:4]) &&
					!(buffer[6][0] && buffer[6][7:4] == opcode[7:4]) &&
					!(buffer[7][0] && buffer[7][7:4] == opcode[7:4]) &&
					!(buffer[8][0] && buffer[8][7:4] == opcode[7:4]) &&
					!(buffer[9][0] && buffer[9][7:4] == opcode[7:4]) &&
					!(buffer[10][0] && buffer[10][7:4] == opcode[7:4]) &&
					!(buffer[11][0] && buffer[11][7:4] == opcode[7:4]) &&
					!(buffer[12][0] && buffer[12][7:4] == opcode[7:4]) &&
					!(buffer[13][0] && buffer[13][7:4] == opcode[7:4]) &&
					!(buffer[14][0] && buffer[14][7:4] == opcode[7:4]);
			
			if (ID_Valid) begin
				case(opcode[3:1])
					3'b010: begin
						if (ALU_RIDLE) begin
							ALU_R[3:0] = opcode[7:4];
							buffer[buffer_index] <= {opcode[7:1], 1'b1};
							ALU_en <= 1;
						end
					end
					
					3'b011: begin
						if (ALU_WIDLE) begin
							ALU_W[3:0] = opcode[7:4];
							buffer[buffer_index] <= {opcode[7:1], 1'b1};
							ALU_en_ <= 1;
						end
					end
					
					3'b100: begin
						if (MEM_RIDLE) begin
							MEM_R[3:0] = opcode[7:4];
							buffer[buffer_index] <= {opcode[7:1], 1'b1};
							MEM_en <= 1;
						end
					end
					
					3'b101: begin
						if (MEM_WIDLE) begin
							MEM_W[3:0] = opcode[7:4];
							buffer[buffer_index] <= {opcode[7:1], 1'b1};
							MEM_en_ <= 1;
						end
					end
					
					3'b110: begin
						if (IO_RIDLE) begin
							IO_R[3:0] = opcode[7:4];
							buffer[buffer_index] <= {opcode[7:1], 1'b1};
							IO_en <= 1;
						end
					end
					
					3'b111: begin
						if (IO_WIDLE) begin
							IO_W[3:0] = opcode[7:4];
							buffer[buffer_index] <= {opcode[7:1], 1'b1};
							IO_en_ <= 1;
						end
					end
				endcase
			end
		end
		
		// only allocate new instructions when buffer is not changing and at least one slave READ/WRITE is idle	
		else if (idle && !ALU_R_change && !ALU_W_change && !MEM_R_change && !MEM_W_change && !IO_R_change && !IO_W_change) begin
			if (ALU_RIDLE) begin
				if (!buffer[0][0] && buffer[0][3:1] == 3'b010 && Valid[0]) begin
					ALU_R[3:0] = buffer[0][7:4];
					buffer[0] <= {buffer[0][7:1], 1'b1};
					ALU_en <= 1;
				end
				else if (!buffer[1][0] && buffer[1][3:1] == 3'b010 && Valid[1]) begin
					ALU_R[3:0] = buffer[1][7:4];
					buffer[1] <= {buffer[1][7:1], 1'b1};
					ALU_en <= 1;
				end
				else if (!buffer[2][0] && buffer[2][3:1] == 3'b010 && Valid[2]) begin
					ALU_R[3:0] = buffer[2][7:4];
					buffer[2] <= {buffer[2][7:1], 1'b1};
					ALU_en <= 1;
				end
				else if (!buffer[3][0] && buffer[3][3:1] == 3'b010 && Valid[3]) begin
					ALU_R[3:0] = buffer[3][7:4];
					buffer[3] <= {buffer[3][7:1], 1'b1};
					ALU_en <= 1;
				end
				else if (!buffer[4][0] && buffer[4][3:1] == 3'b010 && Valid[4]) begin
					ALU_R[3:0] = buffer[4][7:4];
					buffer[4] <= {buffer[4][7:1], 1'b1};
					ALU_en <= 1;
				end
				else if (!buffer[5][0] && buffer[5][3:1] == 3'b010 && Valid[5]) begin
					ALU_R[3:0] = buffer[5][7:4];
					buffer[5] <= {buffer[5][7:1], 1'b1};
					ALU_en <= 1;
				end
				else if (!buffer[6][0] && buffer[6][3:1] == 3'b010 && Valid[6]) begin
					ALU_R[3:0] = buffer[6][7:4];
					buffer[6] <= {buffer[6][7:1], 1'b1};
					ALU_en <= 1;
				end
				else if (!buffer[7][0] && buffer[7][3:1] == 3'b010 && Valid[7]) begin
					ALU_R[3:0] = buffer[7][7:4];
					buffer[7] <= {buffer[7][7:1], 1'b1};
					ALU_en <= 1;
				end
				else if (!buffer[8][0] && buffer[8][3:1] == 3'b010 && Valid[8]) begin
					ALU_R[3:0] = buffer[8][7:4];
					buffer[8] <= {buffer[8][7:1], 1'b1};
					ALU_en <= 1;
				end
				else if (!buffer[9][0] && buffer[9][3:1] == 3'b010 && Valid[9]) begin
					ALU_R[3:0] = buffer[9][7:4];
					buffer[9] <= {buffer[9][7:1], 1'b1};
					ALU_en <= 1;
				end
				else if (!buffer[10][0] && buffer[10][3:1] == 3'b010 && Valid[10]) begin
					ALU_R[3:0] = buffer[10][7:4];
					buffer[10] <= {buffer[10][7:1], 1'b1};
					ALU_en <= 1;
				end
				else if (!buffer[11][0] && buffer[11][3:1] == 3'b010 && Valid[11]) begin
					ALU_R[3:0] = buffer[11][7:4];
					buffer[11] <= {buffer[11][7:1], 1'b1};
					ALU_en <= 1;
				end
				else if (!buffer[12][0] && buffer[12][3:1] == 3'b010 && Valid[12]) begin
					ALU_R[3:0] = buffer[12][7:4];
					buffer[12] <= {buffer[12][7:1], 1'b1};
					ALU_en <= 1;
				end
				else if (!buffer[13][0] && buffer[13][3:1] == 3'b010 && Valid[13]) begin
					ALU_R[3:0] = buffer[13][7:4];
					buffer[13] <= {buffer[13][7:1], 1'b1};
					ALU_en <= 1;
				end
				else if (!buffer[14][0] && buffer[14][3:1] == 3'b010 && Valid[14]) begin
					ALU_R[3:0] = buffer[14][7:4];
					buffer[14] <= {buffer[14][7:1], 1'b1};
					ALU_en <= 1;
				end
				else if (!buffer[15][0] && buffer[15][3:1] == 3'b010 && Valid[15]) begin
					ALU_R[3:0] = buffer[15][7:4];
					buffer[15] <= {buffer[15][7:1], 1'b1};
					ALU_en <= 1;
				end
			end
			
			if (ALU_WIDLE) begin
				if (!buffer[0][0] && buffer[0][3:1] == 3'b010 && Valid[0]) begin
					ALU_W[3:0] = buffer[0][7:4];
					buffer[0] <= {buffer[0][7:1], 1'b1};
					ALU_en_ <= 1;
				end
				else if (!buffer[1][0] && buffer[1][3:1] == 3'b010 && Valid[1]) begin
					ALU_W[3:0] = buffer[1][7:4];
					buffer[1] <= {buffer[1][7:1], 1'b1};
					ALU_en_ <= 1;
				end
				else if (!buffer[2][0] && buffer[2][3:1] == 3'b010 && Valid[2]) begin
					ALU_W[3:0] = buffer[2][7:4];
					buffer[2] <= {buffer[2][7:1], 1'b1};
					ALU_en_ <= 1;
				end
				else if (!buffer[3][0] && buffer[3][3:1] == 3'b010 && Valid[3]) begin
					ALU_W[3:0] = buffer[3][7:4];
					buffer[3] <= {buffer[3][7:1], 1'b1};
					ALU_en_ <= 1;
				end
				else if (!buffer[4][0] && buffer[4][3:1] == 3'b010 && Valid[4]) begin
					ALU_W[3:0] = buffer[4][7:4];
					buffer[4] <= {buffer[4][7:1], 1'b1};
					ALU_en_ <= 1;
				end
				else if (!buffer[5][0] && buffer[5][3:1] == 3'b010 && Valid[5]) begin
					ALU_W[3:0] = buffer[5][7:4];
					buffer[5] <= {buffer[5][7:1], 1'b1};
					ALU_en_ <= 1;
				end
				else if (!buffer[6][0] && buffer[6][3:1] == 3'b010 && Valid[6]) begin
					ALU_W[3:0] = buffer[6][7:4];
					buffer[6] <= {buffer[6][7:1], 1'b1};
					ALU_en_ <= 1;
				end
				else if (!buffer[7][0] && buffer[7][3:1] == 3'b010 && Valid[7]) begin
					ALU_W[3:0] = buffer[7][7:4];
					buffer[7] <= {buffer[7][7:1], 1'b1};
					ALU_en_ <= 1;
				end
				else if (!buffer[8][0] && buffer[8][3:1] == 3'b010 && Valid[8]) begin
					ALU_W[3:0] = buffer[8][7:4];
					buffer[8] <= {buffer[8][7:1], 1'b1};
					ALU_en_ <= 1;
				end
				else if (!buffer[9][0] && buffer[9][3:1] == 3'b010 && Valid[9]) begin
					ALU_W[3:0] = buffer[9][7:4];
					buffer[9] <= {buffer[9][7:1], 1'b1};
					ALU_en_ <= 1;
				end
				else if (!buffer[10][0] && buffer[10][3:1] == 3'b010 && Valid[10]) begin
					ALU_W[3:0] = buffer[10][7:4];
					buffer[10] <= {buffer[10][7:1], 1'b1};
					ALU_en_ <= 1;
				end
				else if (!buffer[11][0] && buffer[11][3:1] == 3'b010 && Valid[11]) begin
					ALU_W[3:0] = buffer[11][7:4];
					buffer[11] <= {buffer[11][7:1], 1'b1};
					ALU_en_ <= 1;
				end
				else if (!buffer[12][0] && buffer[12][3:1] == 3'b010 && Valid[12]) begin
					ALU_W[3:0] = buffer[12][7:4];
					buffer[12] <= {buffer[12][7:1], 1'b1};
					ALU_en_ <= 1;
				end
				else if (!buffer[13][0] && buffer[13][3:1] == 3'b010 && Valid[13]) begin
					ALU_W[3:0] = buffer[13][7:4];
					buffer[13] <= {buffer[13][7:1], 1'b1};
					ALU_en_ <= 1;
				end
				else if (!buffer[14][0] && buffer[14][3:1] == 3'b010 && Valid[14]) begin
					ALU_W[3:0] = buffer[14][7:4];
					buffer[14] <= {buffer[14][7:1], 1'b1};
					ALU_en_ <= 1;
				end
				else if (!buffer[15][0] && buffer[15][3:1] == 3'b010 && Valid[15]) begin
					ALU_W[3:0] = buffer[15][7:4];
					buffer[15] <= {buffer[15][7:1], 1'b1};
					ALU_en_ <= 1;
				end
			end
			
			if (MEM_RIDLE) begin
				if (!buffer[0][0] && buffer[0][3:1] == 3'b010 && Valid[0]) begin
					MEM_R[3:0] = buffer[0][7:4];
					buffer[0] <= {buffer[0][7:1], 1'b1};
					MEM_en <= 1;
				end
				else if (!buffer[1][0] && buffer[1][3:1] == 3'b010 && Valid[1]) begin
					MEM_R[3:0] = buffer[1][7:4];
					buffer[1] <= {buffer[1][7:1], 1'b1};
					MEM_en <= 1;
				end
				else if (!buffer[2][0] && buffer[2][3:1] == 3'b010 && Valid[2]) begin
					MEM_R[3:0] = buffer[2][7:4];
					buffer[2] <= {buffer[2][7:1], 1'b1};
					MEM_en <= 1;
				end
				else if (!buffer[3][0] && buffer[3][3:1] == 3'b010 && Valid[3]) begin
					MEM_R[3:0] = buffer[3][7:4];
					buffer[3] <= {buffer[3][7:1], 1'b1};
					MEM_en <= 1;
				end
				else if (!buffer[4][0] && buffer[4][3:1] == 3'b010 && Valid[4]) begin
					MEM_R[3:0] = buffer[4][7:4];
					buffer[4] <= {buffer[4][7:1], 1'b1};
					MEM_en <= 1;
				end
				else if (!buffer[5][0] && buffer[5][3:1] == 3'b010 && Valid[5]) begin
					MEM_R[3:0] = buffer[5][7:4];
					buffer[5] <= {buffer[5][7:1], 1'b1};
					MEM_en <= 1;
				end
				else if (!buffer[6][0] && buffer[6][3:1] == 3'b010 && Valid[6]) begin
					MEM_R[3:0] = buffer[6][7:4];
					buffer[6] <= {buffer[6][7:1], 1'b1};
					MEM_en <= 1;
				end
				else if (!buffer[7][0] && buffer[7][3:1] == 3'b010 && Valid[7]) begin
					MEM_R[3:0] = buffer[7][7:4];
					buffer[7] <= {buffer[7][7:1], 1'b1};
					MEM_en <= 1;
				end
				else if (!buffer[8][0] && buffer[8][3:1] == 3'b010 && Valid[8]) begin
					MEM_R[3:0] = buffer[8][7:4];
					buffer[8] <= {buffer[8][7:1], 1'b1};
					MEM_en <= 1;
				end
				else if (!buffer[9][0] && buffer[9][3:1] == 3'b010 && Valid[9]) begin
					MEM_R[3:0] = buffer[9][7:4];
					buffer[9] <= {buffer[9][7:1], 1'b1};
					MEM_en <= 1;
				end
				else if (!buffer[10][0] && buffer[10][3:1] == 3'b010 && Valid[10]) begin
					MEM_R[3:0] = buffer[10][7:4];
					buffer[10] <= {buffer[10][7:1], 1'b1};
					 MEM_en <= 1;
				end
				else if (!buffer[11][0] && buffer[11][3:1] == 3'b010 && Valid[11]) begin
					MEM_R[3:0] = buffer[11][7:4];
					buffer[11] <= {buffer[11][7:1], 1'b1};
					MEM_en <= 1;
				end
				else if (!buffer[12][0] && buffer[12][3:1] == 3'b010 && Valid[12]) begin
					MEM_R[3:0] = buffer[12][7:4];
					buffer[12] <= {buffer[12][7:1], 1'b1};
					MEM_en <= 1;
				end
				else if (!buffer[13][0] && buffer[13][3:1] == 3'b010 && Valid[13]) begin
					MEM_R[3:0] = buffer[13][7:4];
					buffer[13] <= {buffer[13][7:1], 1'b1};
					MEM_en <= 1;
				end
				else if (!buffer[14][0] && buffer[14][3:1] == 3'b010 && Valid[14]) begin
					MEM_R[3:0] = buffer[14][7:4];
					buffer[14] <= {buffer[14][7:1], 1'b1};
					MEM_en <= 1;
				end
				else if (!buffer[15][0] && buffer[15][3:1] == 3'b010 && Valid[15]) begin
					MEM_R[3:0] = buffer[15][7:4];
					buffer[15] <= {buffer[15][7:1], 1'b1};
					MEM_en <= 1;
				end
			end
			
			if (MEM_WIDLE) begin
				if (!buffer[0][0] && buffer[0][3:1] == 3'b010 && Valid[0]) begin
					MEM_W[3:0] = buffer[0][7:4];
					buffer[0] <= {buffer[0][7:1], 1'b1};
					MEM_en_ <= 1;
				end
				else if (!buffer[1][0] && buffer[1][3:1] == 3'b010 && Valid[1]) begin
					MEM_W[3:0] = buffer[1][7:4];
					buffer[1] <= {buffer[1][7:1], 1'b1};
					MEM_en_ <= 1;
				end
				else if (!buffer[2][0] && buffer[2][3:1] == 3'b010 && Valid[2]) begin
					MEM_W[3:0] = buffer[2][7:4];
					buffer[2] <= {buffer[2][7:1], 1'b1};
					MEM_en_ <= 1;
				end
				else if (!buffer[3][0] && buffer[3][3:1] == 3'b010 && Valid[3]) begin
					MEM_W[3:0] = buffer[3][7:4];
					buffer[3] <= {buffer[3][7:1], 1'b1};
					MEM_en_ <= 1;
				end
				else if (!buffer[4][0] && buffer[4][3:1] == 3'b010 && Valid[4]) begin
					MEM_W[3:0] = buffer[4][7:4];
					buffer[4] <= {buffer[4][7:1], 1'b1};
					MEM_en_ <= 1;
				end
				else if (!buffer[5][0] && buffer[5][3:1] == 3'b010 && Valid[5]) begin
					MEM_W[3:0] = buffer[5][7:4];
					buffer[5] <= {buffer[5][7:1], 1'b1};
					MEM_en_ <= 1;
				end
				else if (!buffer[6][0] && buffer[6][3:1] == 3'b010 && Valid[6]) begin
					MEM_W[3:0] = buffer[6][7:4];
					buffer[6] <= {buffer[6][7:1], 1'b1};
					MEM_en_ <= 1;
				end
				else if (!buffer[7][0] && buffer[7][3:1] == 3'b010 && Valid[7]) begin
					MEM_W[3:0] = buffer[7][7:4];
					buffer[7] <= {buffer[7][7:1], 1'b1};
					MEM_en_ <= 1;
				end
				else if (!buffer[8][0] && buffer[8][3:1] == 3'b010 && Valid[8]) begin
					MEM_W[3:0] = buffer[8][7:4];
					buffer[8] <= {buffer[8][7:1], 1'b1};
					MEM_en_ <= 1;
				end
				else if (!buffer[9][0] && buffer[9][3:1] == 3'b010 && Valid[9]) begin
					MEM_W[3:0] = buffer[9][7:4];
					buffer[9] <= {buffer[9][7:1], 1'b1};
					MEM_en_ <= 1;
				end
				else if (!buffer[10][0] && buffer[10][3:1] == 3'b010 && Valid[10]) begin
					MEM_W[3:0] = buffer[10][7:4];
					buffer[10] <= {buffer[10][7:1], 1'b1};
					MEM_en_ <= 1;
				end
				else if (!buffer[11][0] && buffer[11][3:1] == 3'b010 && Valid[11]) begin
					MEM_W[3:0] = buffer[11][7:4];
					buffer[11] <= {buffer[11][7:1], 1'b1};
					MEM_en_ <= 1;
				end
				else if (!buffer[12][0] && buffer[12][3:1] == 3'b010 && Valid[12]) begin
					MEM_W[3:0] = buffer[12][7:4];
					buffer[12] <= {buffer[12][7:1], 1'b1};
					MEM_en_ <= 1;
				end
				else if (!buffer[13][0] && buffer[13][3:1] == 3'b010 && Valid[13]) begin
					MEM_W[3:0] = buffer[13][7:4];
					buffer[13] <= {buffer[13][7:1], 1'b1};
					MEM_en_ <= 1;
				end
				else if (!buffer[14][0] && buffer[14][3:1] == 3'b010 && Valid[14]) begin
					MEM_W[3:0] = buffer[14][7:4];
					buffer[14] <= {buffer[14][7:1], 1'b1};
					MEM_en_ <= 1;
				end
				else if (!buffer[15][0] && buffer[15][3:1] == 3'b010 && Valid[15]) begin
					MEM_W[3:0] = buffer[15][7:4];
					buffer[15] <= {buffer[15][7:1], 1'b1};
					MEM_en_ <= 1;
				end
			end	

			if (IO_RIDLE) begin
				if (!buffer[0][0] && buffer[0][3:1] == 3'b010 && Valid[0]) begin
					IO_R[3:0] = buffer[0][7:4];
					buffer[0] <= {buffer[0][7:1], 1'b1};
					IO_en <= 1;
				end
				else if (!buffer[1][0] && buffer[1][3:1] == 3'b010 && Valid[1]) begin
					IO_R[3:0] = buffer[1][7:4];
					buffer[1] <= {buffer[1][7:1], 1'b1};
					IO_en <= 1;
				end
				else if (!buffer[2][0] && buffer[2][3:1] == 3'b010 && Valid[2]) begin
					IO_R[3:0] = buffer[2][7:4];
					buffer[2] <= {buffer[2][7:1], 1'b1};
					IO_en <= 1;
				end
				else if (!buffer[3][0] && buffer[3][3:1] == 3'b010 && Valid[3]) begin
					IO_R[3:0] = buffer[3][7:4];
					buffer[3] <= {buffer[3][7:1], 1'b1};
					IO_en <= 1;
				end
				else if (!buffer[4][0] && buffer[4][3:1] == 3'b010 && Valid[4]) begin
					IO_R[3:0] = buffer[4][7:4];
					buffer[4] <= {buffer[4][7:1], 1'b1};
					IO_en <= 1;
				end
				else if (!buffer[5][0] && buffer[5][3:1] == 3'b010 && Valid[5]) begin
					IO_R[3:0] = buffer[5][7:4];
					buffer[5] <= {buffer[5][7:1], 1'b1};
					IO_en <= 1;
				end
				else if (!buffer[6][0] && buffer[6][3:1] == 3'b010 && Valid[6]) begin
					IO_R[3:0] = buffer[6][7:4];
					buffer[6] <= {buffer[6][7:1], 1'b1};
					IO_en <= 1;
				end
				else if (!buffer[7][0] && buffer[7][3:1] == 3'b010 && Valid[7]) begin
					IO_R[3:0] = buffer[7][7:4];
					buffer[7] <= {buffer[7][7:1], 1'b1};
					IO_en <= 1;
				end
				else if (!buffer[8][0] && buffer[8][3:1] == 3'b010 && Valid[8]) begin
					IO_R[3:0] = buffer[8][7:4];
					buffer[8] <= {buffer[8][7:1], 1'b1};
					IO_en <= 1;
				end
				else if (!buffer[9][0] && buffer[9][3:1] == 3'b010 && Valid[9]) begin
					IO_R[3:0] = buffer[9][7:4];
					buffer[9] <= {buffer[9][7:1], 1'b1};
					IO_en <= 1;
				end
				else if (!buffer[10][0] && buffer[10][3:1] == 3'b010 && Valid[10]) begin
					IO_R[3:0] = buffer[10][7:4];
					buffer[10] <= {buffer[10][7:1], 1'b1};
					IO_en <= 1;
				end
				else if (!buffer[11][0] && buffer[11][3:1] == 3'b010 && Valid[11]) begin
					IO_R[3:0] = buffer[11][7:4];
					buffer[11] <= {buffer[11][7:1], 1'b1};
					IO_en <= 1;
				end
				else if (!buffer[12][0] && buffer[12][3:1] == 3'b010 && Valid[12]) begin
					IO_R[3:0] = buffer[12][7:4];
					buffer[12] <= {buffer[12][7:1], 1'b1};
					IO_en <= 1;
				end
				else if (!buffer[13][0] && buffer[13][3:1] == 3'b010 && Valid[13]) begin
					IO_R[3:0] = buffer[13][7:4];
					buffer[13] <= {buffer[13][7:1], 1'b1};
					IO_en <= 1;
				end
				else if (!buffer[14][0] && buffer[14][3:1] == 3'b010 && Valid[14]) begin
					IO_R[3:0] = buffer[14][7:4];
					buffer[14] <= {buffer[14][7:1], 1'b1};
					IO_en <= 1;
				end
				else if (!buffer[15][0] && buffer[15][3:1] == 3'b010 && Valid[15]) begin
					IO_R[3:0] = buffer[15][7:4];
					buffer[15] <= {buffer[15][7:1], 1'b1};
					IO_en <= 1;
				end
			end
			
			if (IO_WIDLE) begin
				if (!buffer[0][0] && buffer[0][3:1] == 3'b010 && Valid[0]) begin
					IO_W[3:0] = buffer[0][7:4];
					buffer[0] <= {buffer[0][7:1], 1'b1};
					IO_en_ <= 1;
				end
				else if (!buffer[1][0] && buffer[1][3:1] == 3'b010 && Valid[1]) begin
					IO_W[3:0] = buffer[1][7:4];
					buffer[1] <= {buffer[1][7:1], 1'b1};
					IO_en_ <= 1;
				end
				else if (!buffer[2][0] && buffer[2][3:1] == 3'b010 && Valid[2]) begin
					IO_W[3:0] = buffer[2][7:4];
					buffer[2] <= {buffer[2][7:1], 1'b1};
					IO_en_ <= 1;
				end
				else if (!buffer[3][0] && buffer[3][3:1] == 3'b010 && Valid[3]) begin
					IO_W[3:0] = buffer[3][7:4];
					buffer[3] <= {buffer[3][7:1], 1'b1};
					IO_en_ <= 1;
				end
				else if (!buffer[4][0] && buffer[4][3:1] == 3'b010 && Valid[4]) begin
					IO_W[3:0] = buffer[4][7:4];
					buffer[4] <= {buffer[4][7:1], 1'b1};
					IO_en_ <= 1;
				end
				else if (!buffer[5][0] && buffer[5][3:1] == 3'b010 && Valid[5]) begin
					IO_W[3:0] = buffer[5][7:4];
					buffer[5] <= {buffer[5][7:1], 1'b1};
					IO_en_ <= 1;
				end
				else if (!buffer[6][0] && buffer[6][3:1] == 3'b010 && Valid[6]) begin
					IO_W[3:0] = buffer[6][7:4];
					buffer[6] <= {buffer[6][7:1], 1'b1};
					IO_en_ <= 1;
				end
				else if (!buffer[7][0] && buffer[7][3:1] == 3'b010 && Valid[7]) begin
					IO_W[3:0] = buffer[7][7:4];
					buffer[7] <= {buffer[7][7:1], 1'b1};
					IO_en_ <= 1;
				end
				else if (!buffer[8][0] && buffer[8][3:1] == 3'b010 && Valid[8]) begin
					IO_W[3:0] = buffer[8][7:4];
					buffer[8] <= {buffer[8][7:1], 1'b1};
					IO_en_ <= 1;
				end
				else if (!buffer[9][0] && buffer[9][3:1] == 3'b010 && Valid[9]) begin
					IO_W[3:0] = buffer[9][7:4];
					buffer[9] <= {buffer[9][7:1], 1'b1};
					IO_en_ <= 1;
				end
				else if (!buffer[10][0] && buffer[10][3:1] == 3'b010 && Valid[10]) begin
					IO_W[3:0] = buffer[10][7:4];
					buffer[10] <= {buffer[10][7:1], 1'b1};
					IO_en_ <= 1;
				end
				else if (!buffer[11][0] && buffer[11][3:1] == 3'b010 && Valid[11]) begin
					IO_W[3:0] = buffer[11][7:4];
					buffer[11] <= {buffer[11][7:1], 1'b1};
					IO_en_ <= 1;
				end
				else if (!buffer[12][0] && buffer[12][3:1] == 3'b010 && Valid[12]) begin
					IO_W[3:0] = buffer[12][7:4];
					buffer[12] <= {buffer[12][7:1], 1'b1};
					IO_en_ <= 1;
				end
				else if (!buffer[13][0] && buffer[13][3:1] == 3'b010 && Valid[13]) begin
					IO_W[3:0] = buffer[13][7:4];
					buffer[13] <= {buffer[13][7:1], 1'b1};
					IO_en_ <= 1;
				end
				else if (!buffer[14][0] && buffer[14][3:1] == 3'b010 && Valid[14]) begin
					IO_W[3:0] = buffer[14][7:4];
					buffer[14] <= {buffer[14][7:1], 1'b1};
					IO_en_ <= 1;
				end
				else if (!buffer[15][0] && buffer[15][3:1] == 3'b010 && Valid[15]) begin
					IO_W[3:0] = buffer[15][7:4];
					buffer[15] <= {buffer[15][7:1], 1'b1};
					IO_en_ <= 1;
				end
			end			
			
			idle <= ALU_R_change || ALU_W_change || MEM_R_change || MEM_W_change || IO_R_change || IO_W_change;
		end
	end
	
	// lower enable for all masters after raised for 1 clock
	always@ (posedge clk) begin
		if (ALU_en) begin
			ALU_en <= 0;
		end
		
		if (ALU_en_) begin
			ALU_en_ <= 0;
		end
		
		if (MEM_en) begin
			MEM_en <= 0;
		end
		
		if (MEM_en_) begin
			MEM_en_ <= 0;
		end	

		if (IO_en) begin
			IO_en <= 0;
		end
		
		if (IO_en_) begin
			IO_en_ <= 0;
		end		
	end
	
	// keep a flag for all slave READ/WRITE state changes
	always@ (posedge clk) begin
		if (ALU_RIDLE && !ALU_RIDLE_prev) begin
			ALU_R_change <= 1;
		end
		if (ALU_WIDLE && !ALU_WIDLE_prev) begin
			ALU_W_change <= 1;
		end
		if (MEM_RIDLE && !MEM_RIDLE_prev) begin
			MEM_R_change <= 1;
		end
		if (MEM_WIDLE && !MEM_WIDLE_prev) begin
			MEM_W_change <= 1;
		end	
		if (IO_RIDLE && !IO_RIDLE_prev) begin
			IO_R_change <= 1;
		end
		if (IO_WIDLE && !IO_WIDLE_prev) begin
			IO_W_change <= 1;
		end		
	end
	
	// only delete when no add to buffer, if multiple changes arrive at same time, delete one at each clk
	always@ (posedge clk) begin
		if (!en) begin
			if (ALU_R_change) begin
				ALU_R_change <= 0;
				del_index = 16;
				if (buffer[0][0] && buffer[0][3:1] == 3'b010) begin
					del_index = 0;
				end
				else if (buffer[1][0] && buffer[1][3:1] == 3'b010) begin
					del_index = 1;
				end
				else if (buffer[2][0] && buffer[2][3:1] == 3'b010) begin
					del_index = 2;
				end
				else if (buffer[3][0] && buffer[3][3:1] == 3'b010) begin
					del_index = 3;
				end
				else if (buffer[4][0] && buffer[4][3:1] == 3'b010) begin
					del_index = 4;
				end
				else if (buffer[5][0] && buffer[5][3:1] == 3'b010) begin
					del_index = 5;
				end
				else if (buffer[6][0] && buffer[6][3:1] == 3'b010) begin
					del_index = 6;
				end
				else if (buffer[7][0] && buffer[7][3:1] == 3'b010) begin
					del_index = 7;
				end
				else if (buffer[8][0] && buffer[8][3:1] == 3'b010) begin
					del_index = 8;
				end
				else if (buffer[9][0] && buffer[9][3:1] == 3'b010) begin
					del_index = 9;
				end
				else if (buffer[10][0] && buffer[10][3:1] == 3'b010) begin
					del_index = 10;
				end
				else if (buffer[11][0] && buffer[11][3:1] == 3'b010) begin
					del_index = 11;
				end
				else if (buffer[12][0] && buffer[12][3:1] == 3'b010) begin
					del_index = 12;
				end
				else if (buffer[13][0] && buffer[13][3:1] == 3'b010) begin
					del_index = 13;
				end
				else if (buffer[14][0] && buffer[14][3:1] == 3'b010) begin
					del_index = 14;
				end
				else if (buffer[15][0] && buffer[15][3:1] == 3'b010) begin
					del_index = 15;
				end
		
				if (del_index < 16) begin
					for (i = del_index; i < buffer_index - 1; i = i + 1) begin
						buffer[i] <= buffer[i+1];
					end
					buffer[buffer_index-1] <= 0;
					buffer_index <= buffer_index - 1;
				end
				else begin
					$display ("\nIndex to delete not found!");
				end
				
				idle <= 1;
			end
			else if (ALU_W_change) begin
				ALU_W_change <= 0;
				del_index = 16;
				if (buffer[0][0] && buffer[0][3:1] == 3'b011) begin
					del_index = 0;
				end
				else if (buffer[1][0] && buffer[1][3:1] == 3'b011) begin
					del_index = 1;
				end
				else if (buffer[2][0] && buffer[2][3:1] == 3'b011) begin
					del_index = 2;
				end
				else if (buffer[3][0] && buffer[3][3:1] == 3'b011) begin
					del_index = 3;
				end
				else if (buffer[4][0] && buffer[4][3:1] == 3'b011) begin
					del_index = 4;
				end
				else if (buffer[5][0] && buffer[5][3:1] == 3'b011) begin
					del_index = 5;
				end
				else if (buffer[6][0] && buffer[6][3:1] == 3'b011) begin
					del_index = 6;
				end
				else if (buffer[7][0] && buffer[7][3:1] == 3'b011) begin
					del_index = 7;
				end
				else if (buffer[8][0] && buffer[8][3:1] == 3'b011) begin
					del_index = 8;
				end
				else if (buffer[9][0] && buffer[9][3:1] == 3'b011) begin
					del_index = 9;
				end
				else if (buffer[10][0] && buffer[10][3:1] == 3'b011) begin
					del_index = 10;
				end
				else if (buffer[11][0] && buffer[11][3:1] == 3'b011) begin
					del_index = 11;
				end
				else if (buffer[12][0] && buffer[12][3:1] == 3'b011) begin
					del_index = 12;
				end
				else if (buffer[13][0] && buffer[13][3:1] == 3'b011) begin
					del_index = 13;
				end
				else if (buffer[14][0] && buffer[14][3:1] == 3'b011) begin
					del_index = 14;
				end
				else if (buffer[15][0] && buffer[15][3:1] == 3'b011) begin
					del_index = 15;
				end
				if (del_index < 16) begin
					for (y = del_index; y < buffer_index - 1; y = y + 1) begin
						buffer[y] <= buffer[y+1];
					end
					buffer[buffer_index-1] <= 0;
					buffer_index <= buffer_index - 1;
				end
				else begin
					$display ("\nIndex to delete not found!");
				end
				
				idle <= 1;
			end
			else if (MEM_R_change) begin
				MEM_R_change <= 0;
				del_index = 16;
				if (buffer[0][0] && buffer[0][3:1] == 3'b100) begin
					del_index = 0;
				end
				else if (buffer[1][0] && buffer[1][3:1] == 3'b100) begin
					del_index = 1;
				end
				else if (buffer[2][0] && buffer[2][3:1] == 3'b100) begin
					del_index = 2;
				end
				else if (buffer[3][0] && buffer[3][3:1] == 3'b100) begin
					del_index = 3;
				end
				else if (buffer[4][0] && buffer[4][3:1] == 3'b100) begin
					del_index = 4;
				end
				else if (buffer[5][0] && buffer[5][3:1] == 3'b100) begin
					del_index = 5;
				end
				else if (buffer[6][0] && buffer[6][3:1] == 3'b100) begin
					del_index = 6;
				end
				else if (buffer[7][0] && buffer[7][3:1] == 3'b100) begin
					del_index = 7;
				end
				else if (buffer[8][0] && buffer[8][3:1] == 3'b100) begin
					del_index = 8;
				end
				else if (buffer[9][0] && buffer[9][3:1] == 3'b100) begin
					del_index = 9;
				end
				else if (buffer[10][0] && buffer[10][3:1] == 3'b100) begin
					del_index = 10;
				end
				else if (buffer[11][0] && buffer[11][3:1] == 3'b100) begin
					del_index = 11;
				end
				else if (buffer[12][0] && buffer[12][3:1] == 3'b100) begin
					del_index = 12;
				end
				else if (buffer[13][0] && buffer[13][3:1] == 3'b100) begin
					del_index = 13;
				end
				else if (buffer[14][0] && buffer[14][3:1] == 3'b100) begin
					del_index = 14;
				end
				else if (buffer[15][0] && buffer[15][3:1] == 3'b100) begin
					del_index = 15;
				end
				if (del_index < 16) begin
					for (y = del_index; y < buffer_index - 1; y = y + 1) begin
						buffer[y] <= buffer[y+1];
					end
					buffer[buffer_index-1] <= 0;
					buffer_index <= buffer_index - 1;
				end
				else begin
					$display ("\nIndex to delete not found!");
				end
				
				idle <= 1;
			end
			else if (MEM_W_change) begin
				MEM_W_change <= 0;
				del_index = 16;
				if (buffer[0][0] && buffer[0][3:1] == 3'b101) begin
					del_index = 0;
				end
				else if (buffer[1][0] && buffer[1][3:1] == 3'b101) begin
					del_index = 1;
				end
				else if (buffer[2][0] && buffer[2][3:1] == 3'b101) begin
					del_index = 2;
				end
				else if (buffer[3][0] && buffer[3][3:1] == 3'b101) begin
					del_index = 3;
				end
				else if (buffer[4][0] && buffer[4][3:1] == 3'b101) begin
					del_index = 4;
				end
				else if (buffer[5][0] && buffer[5][3:1] == 3'b101) begin
					del_index = 5;
				end
				else if (buffer[6][0] && buffer[6][3:1] == 3'b101) begin
					del_index = 6;
				end
				else if (buffer[7][0] && buffer[7][3:1] == 3'b101) begin
					del_index = 7;
				end
				else if (buffer[8][0] && buffer[8][3:1] == 3'b101) begin
					del_index = 8;
				end
				else if (buffer[9][0] && buffer[9][3:1] == 3'b101) begin
					del_index = 9;
				end
				else if (buffer[10][0] && buffer[10][3:1] == 3'b101) begin
					del_index = 10;
				end
				else if (buffer[11][0] && buffer[11][3:1] == 3'b101) begin
					del_index = 11;
				end
				else if (buffer[12][0] && buffer[12][3:1] == 3'b101) begin
					del_index = 12;
				end
				else if (buffer[13][0] && buffer[13][3:1] == 3'b101) begin
					del_index = 13;
				end
				else if (buffer[14][0] && buffer[14][3:1] == 3'b101) begin
					del_index = 14;
				end
				else if (buffer[15][0] && buffer[15][3:1] == 3'b101) begin
					del_index = 15;
				end
				if (del_index < 16) begin
					for (y = del_index; y < buffer_index - 1; y = y + 1) begin
						buffer[y] <= buffer[y+1];
					end
					buffer[buffer_index-1] <= 0;
					buffer_index <= buffer_index - 1;
				end
				else begin
					$display ("\nIndex to delete not found!");
				end
				
				idle <= 1;
			end
			else if (IO_R_change) begin
				IO_R_change <= 0;
				del_index = 16;
				if (buffer[0][0] && buffer[0][3:1] == 3'b110) begin
					del_index = 0;
				end
				else if (buffer[1][0] && buffer[1][3:1] == 3'b110) begin
					del_index = 1;
				end
				else if (buffer[2][0] && buffer[2][3:1] == 3'b110) begin
					del_index = 2;
				end
				else if (buffer[3][0] && buffer[3][3:1] == 3'b110) begin
					del_index = 3;
				end
				else if (buffer[4][0] && buffer[4][3:1] == 3'b110) begin
					del_index = 4;
				end
				else if (buffer[5][0] && buffer[5][3:1] == 3'b110) begin
					del_index = 5;
				end
				else if (buffer[6][0] && buffer[6][3:1] == 3'b110) begin
					del_index = 6;
				end
				else if (buffer[7][0] && buffer[7][3:1] == 3'b110) begin
					del_index = 7;
				end
				else if (buffer[8][0] && buffer[8][3:1] == 3'b110) begin
					del_index = 8;
				end
				else if (buffer[9][0] && buffer[9][3:1] == 3'b110) begin
					del_index = 9;
				end
				else if (buffer[10][0] && buffer[10][3:1] == 3'b110) begin
					del_index = 10;
				end
				else if (buffer[11][0] && buffer[11][3:1] == 3'b110) begin
					del_index = 11;
				end
				else if (buffer[12][0] && buffer[12][3:1] == 3'b110) begin
					del_index = 12;
				end
				else if (buffer[13][0] && buffer[13][3:1] == 3'b110) begin
					del_index = 13;
				end
				else if (buffer[14][0] && buffer[14][3:1] == 3'b110) begin
					del_index = 14;
				end
				else if (buffer[15][0] && buffer[15][3:1] == 3'b110) begin
					del_index = 15;
				end
				if (del_index < 16) begin
					for (y = del_index; y < buffer_index - 1; y = y + 1) begin
						buffer[y] <= buffer[y+1];
					end
					buffer[buffer_index-1] <= 0;
					buffer_index <= buffer_index - 1;
				end
				else begin
					$display ("\nIndex to delete not found!");
				end
				
				idle <= 1;
			end
			else if (IO_W_change) begin
				IO_W_change <= 0;
				del_index = 16;
				if (buffer[0][0] && buffer[0][3:1] == 3'b111) begin
					del_index = 0;
				end
				else if (buffer[1][0] && buffer[1][3:1] == 3'b111) begin
					del_index = 1;
				end
				else if (buffer[2][0] && buffer[2][3:1] == 3'b111) begin
					del_index = 2;
				end
				else if (buffer[3][0] && buffer[3][3:1] == 3'b111) begin
					del_index = 3;
				end
				else if (buffer[4][0] && buffer[4][3:1] == 3'b111) begin
					del_index = 4;
				end
				else if (buffer[5][0] && buffer[5][3:1] == 3'b111) begin
					del_index = 5;
				end
				else if (buffer[6][0] && buffer[6][3:1] == 3'b111) begin
					del_index = 6;
				end
				else if (buffer[7][0] && buffer[7][3:1] == 3'b111) begin
					del_index = 7;
				end
				else if (buffer[8][0] && buffer[8][3:1] == 3'b111) begin
					del_index = 8;
				end
				else if (buffer[9][0] && buffer[9][3:1] == 3'b111) begin
					del_index = 9;
				end
				else if (buffer[10][0] && buffer[10][3:1] == 3'b111) begin
					del_index = 10;
				end
				else if (buffer[11][0] && buffer[11][3:1] == 3'b111) begin
					del_index = 11;
				end
				else if (buffer[12][0] && buffer[12][3:1] == 3'b111) begin
					del_index = 12;
				end
				else if (buffer[13][0] && buffer[13][3:1] == 3'b111) begin
					del_index = 13;
				end
				else if (buffer[14][0] && buffer[14][3:1] == 3'b111) begin
					del_index = 14;
				end
				else if (buffer[15][0] && buffer[15][3:1] == 3'b111) begin
					del_index = 15;
				end
				if (del_index < 16) begin
					for (y = del_index; y < buffer_index - 1; y = y + 1) begin
						buffer[y] <= buffer[y+1];
					end
					buffer[buffer_index-1] <= 0;
					buffer_index <= buffer_index - 1;
				end
				else begin
					$display ("\nIndex to delete not found!");
				end
				
				idle <= 1;
			end
		end
	end

endmodule
