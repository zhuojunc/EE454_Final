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
	output reg [4:0] IO_BOUT,	
);
	
	reg ALU_en = 1'b0;
	reg ALU_en_ = 1'b0;
	reg [127:0] ALU_INDATA = 0;
    reg [15:0] ALU_R = 0;
    reg [15:0] ALU_W = 0;
	
	// hardcoded 8 byte data
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
	
	reg MEM_en = 1'b0;
	reg MEM_en_ = 1'b0;
	reg [127:0] MEM_INDATA = 0;
    reg [15:0] MEM_R = 0;
    reg [15:0] MEM_W = 0;
	
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
	
	reg IO_en = 1'b0;
	reg IO_en_ = 1'b0;
	reg [127:0] IO_INDATA = 0;
    reg [15:0] IO_R = 0;
    reg [15:0] IO_W = 0;
	
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
	
	Master ALU(.rst(rst), .clk(clk), .en(ALU_en), .en_(ALU_en_), .tb_R(ALU_R), .IN(ALU_IN), .tb_W(ALU_W), .INDATA(ALU_INDATA), 
	.ARREADY(ALU_ARREADY), .RVALID(ALU_RVALID), .RLAST(ALU_RLAST), .AWREADY(ALU_AWREADY), .WREADY(ALU_WREADY), .BVALID(ALU_BVALID), .BRESP(ALU_BRESP), .WIDLE(ALU_WIDLE), .RIDLE(ALU_RIDLE),
	.ARVALID(ALU_ARVALID), .RREADY(ALU_RREADY), .OUT(ALU_OUT), .RRESP(ALU_RRESP), .RDATA(ALU_RDATA), .AWVALID(ALU_AWVALID), .WVALID(ALU_WVALID), .WLAST(ALU_WLAST), .BREADY(ALU_BREADY), .AWOUT(ALU_AWOUT), .WDATA(ALU_WDATA), .BOUT(ALU_BOUT));	

	Master MEM(.rst(rst), .clk(clk), .en(MEM_en), .en_(MEM_en_), .tb_R(MEM_R), .IN(MEM_IN), .tb_W(MEM_W), .INDATA(MEM_INDATA), 
	.ARREADY(MEM_ARREADY), .RVALID(MEM_RVALID), .RLAST(MEM_RLAST), .AWREADY(MEM_AWREADY), .WREADY(MEM_WREADY), .BVALID(MEM_BVALID), .BRESP(MEM_BRESP), .WIDLE(MEM_WIDLE), .RIDLE(MEM_RIDLE),
	.ARVALID(MEM_ARVALID), .RREADY(MEM_RREADY), .OUT(MEM_OUT), .RRESP(MEM_RRESP), .RDATA(MEM_RDATA), .AWVALID(MEM_AWVALID), .WVALID(MEM_WVALID), .WLAST(MEM_WLAST), .BREADY(MEM_BREADY), .AWOUT(MEM_AWOUT), .WDATA(MEM_WDATA), .BOUT(MEM_BOUT));
	
	Master IO(.rst(rst), .clk(clk), .en(IO_en), .en_(IO_en_), .tb_R(IO_R), .IN(IO_IN), .tb_W(IO_W), .INDATA(IO_INDATA), 
	.ARREADY(IO_ARREADY), .RVALID(IO_RVALID), .RLAST(IO_RLAST), .AWREADY(IO_AWREADY), .WREADY(IO_WREADY), .BVALID(IO_BVALID), .BRESP(IO_BRESP), .WIDLE(IO_WIDLE), .RIDLE(IO_RIDLE),
	.ARVALID(IO_ARVALID), .RREADY(IO_RREADY), .OUT(IO_OUT), .RRESP(IO_RRESP), .RDATA(IO_RDATA), .AWVALID(IO_AWVALID), .WVALID(IO_WVALID), .WLAST(IO_WLAST), .BREADY(IO_BREADY), .AWOUT(IO_AWOUT), .WDATA(IO_WDATA), .BOUT(IO_BOUT));
	
	reg [7:0] buffer [0:15];
	reg [3:0] buffer_index = 4'b0000; // next index to assign opcode
	reg  ID_Valid = 1'b1; // instruction can only be run if no previous in the queue with the same ID is running
	reg  idle = 1'b0; // a flag for showing any slave goes from running to idle for READ/WRITE
	integer i;
	integer j;
	
	initial begin
	    for (i = 0; i < 16; i = i + 1) begin
			buffer[i] <= 0;
		end	
	end
	
	always@ (posedge clk) begin
		// when a new instruction is given
		if (en) begin
			buffer[buffer_index] <= opcode;
			buffer_index <= buffer_index + 1;
			ID_Valid = 1;
			for (i = 0; i < buffer_index; i = i + 1) begin
				if (buffer[i][0] && buffer[i][7:4] == opcode[7:4]) begin
					ID_Valid = 0;
				end
			end
			
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
		
		// when any of the slave goes from running to idle for READ/WRITE (race condition if adding instruction at the same time)
		else if (idle) begin
			if (ALU_RIDLE) begin
				integer k = 0;
				for (i = 0; i < buffer_index && k = 0; i = i + 1) begin
					if (!buffer[i][0] && buffer[i][3:1] == 3'b010) begin
						ID_Valid = 1;
						for (j = 0; j < i; j = j + 1) begin
							if (buffer[j][0] && buffer[j][7:4] == buffer[i][7:4]) begin
								ID_Valid = 0;
							end
						end
						if (ID_Valid) begin
							ALU_R[3:0] = buffer[i][7:4];
							buffer[i] <= {buffer[i][7:1], 1'b1};
							ALU_en <= 1;
							k = 1;
						end
					end
				end
			end
			
			if (ALU_WIDLE) begin
				integer k = 0;
				for (i = 0; i < buffer_index && k = 0; i = i + 1) begin
					if (!buffer[i][0] && buffer[i][3:1] == 3'b011) begin
						ID_Valid = 1;
						for (j = 0; j < i; j = j + 1) begin
							if (buffer[j][0] && buffer[j][7:4] == buffer[i][7:4]) begin
								ID_Valid = 0;
							end
						end
						if (ID_Valid) begin
							ALU_W[3:0] = buffer[i][7:4];
							buffer[i] <= {buffer[i][7:1], 1'b1};
							ALU_en_ <= 1;
							k = 1;
						end
					end
				end
			end
			
			if (MEM_RIDLE) begin
				integer k = 0;
				for (i = 0; i < buffer_index && k = 0; i = i + 1) begin
					if (!buffer[i][0] && buffer[i][3:1] == 3'b100) begin
						ID_Valid = 1;
						for (j = 0; j < i; j = j + 1) begin
							if (buffer[j][0] && buffer[j][7:4] == buffer[i][7:4]) begin
								ID_Valid = 0;
							end
						end
						if (ID_Valid) begin
							MEM_R[3:0] = buffer[i][7:4];
							buffer[i] <= {buffer[i][7:1], 1'b1};
							MEM_en <= 1;
							k = 1;
						end
					end
				end
			end
			
			if (MEM_WIDLE) begin
				integer k = 0;
				for (i = 0; i < buffer_index && k = 0; i = i + 1) begin
					if (!buffer[i][0] && buffer[i][3:1] == 3'b101) begin
						ID_Valid = 1;
						for (j = 0; j < i; j = j + 1) begin
							if (buffer[j][0] && buffer[j][7:4] == buffer[i][7:4]) begin
								ID_Valid = 0;
							end
						end
						if (ID_Valid) begin
							MEM_W[3:0] = buffer[i][7:4];
							buffer[i] <= {buffer[i][7:1], 1'b1};
							MEM_en_ <= 1;
							k = 1;
						end
					end
				end
			end	

			if (IO_RIDLE) begin
				integer k = 0;
				for (i = 0; i < buffer_index && k = 0; i = i + 1) begin
					if (!buffer[i][0] && buffer[i][3:1] == 3'b110) begin
						ID_Valid = 1;
						for (j = 0; j < i; j = j + 1) begin
							if (buffer[j][0] && buffer[j][7:4] == buffer[i][7:4]) begin
								ID_Valid = 0;
							end
						end
						if (ID_Valid) begin
							IO_R[3:0] = buffer[i][7:4];
							buffer[i] <= {buffer[i][7:1], 1'b1};
							IO_en <= 1;
							k = 1;
						end
					end
				end
			end
			
			if (IO_WIDLE) begin
				integer k = 0;
				for (i = 0; i < buffer_index && k = 0; i = i + 1) begin
					if (!buffer[i][0] && buffer[i][3:1] == 3'b111) begin
						ID_Valid = 1;
						for (j = 0; j < i; j = j + 1) begin
							if (buffer[j][0] && buffer[j][7:4] == buffer[i][7:4]) begin
								ID_Valid = 0;
							end
						end
						if (ID_Valid) begin
							IO_W[3:0] = buffer[i][7:4];
							buffer[i] <= {buffer[i][7:1], 1'b1};
							IO_en_ <= 1;
							k = 1;
						end
					end
				end
			end			
			
			idle <= 0;
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
	
	// if any slave goes from running to idle, delete finished jobs in buffer
	always@ (posedge ALU_RIDLE) begin	
		integer del_index = 16;
		integer x;
		integer y;
		integer z = 0;
		for (x = 0; x < buffer_index && z = 0; x = x + 1) begin
			if (buffer[x][0] && buffer[x][3:1] == 3'b010) begin
				del_index = x;
				z = 1;
			end
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

	always@ (posedge ALU_WIDLE) begin	
		integer del_index = 16;
		integer x;
		integer y;
		integer z = 0;
		for (x = 0; x < buffer_index && z = 0; x = x + 1) begin
			if (buffer[x][0] && buffer[x][3:1] == 3'b011) begin
				del_index = x;
				z = 1;
			end
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
	
	always@ (posedge MEM_RIDLE) begin	
		integer del_index = 16;
		integer x;
		integer y;
		integer z = 0;
		for (x = 0; x < buffer_index && z = 0; x = x + 1) begin
			if (buffer[x][0] && buffer[x][3:1] == 3'b100) begin
				del_index = x;
				z = 1;
			end
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
	
	always@ (posedge MEM_WIDLE) begin	
		integer del_index = 16;
		integer x;
		integer y;
		integer z = 0;
		for (x = 0; x < buffer_index && z = 0; x = x + 1) begin
			if (buffer[x][0] && buffer[x][3:1] == 3'b101) begin
				del_index = x;
				z = 1;
			end
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
	
	always@ (posedge IO_RIDLE) begin	
		integer del_index = 16;
		integer x;
		integer y;
		integer z = 0;
		for (x = 0; x < buffer_index && z = 0; x = x + 1) begin
			if (buffer[x][0] && buffer[x][3:1] == 3'b110) begin
				del_index = x;
				z = 1;
			end
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
	
	always@ (posedge IO_WIDLE) begin	
		integer del_index = 16;
		integer x;
		integer y;
		integer z = 0;
		for (x = 0; x < buffer_index && z = 0; x = x + 1) begin
			if (buffer[x][0] && buffer[x][3:1] == 3'b111) begin
				del_index = x;
				z = 1;
			end
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

endmodule