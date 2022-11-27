`timescale 1ns / 1ps

module Slave
(
    input  rst,
    input  clk,
    input  ARVALID,
    input  RREADY,
    input [15:0] IN,
	input  AWVALID,
	input  WVALID,
	input  WLAST,
	input [11:0] AWIN,
	input [7:0] WDATA,
	input  BREADY,
	// delay
	input [4:0] DELAY,
    output reg ARREADY,
    output reg RVALID,
	output reg RLAST,
    output reg [8:0] OUT,
	output reg AWREADY,
	output reg WREADY,
	output reg BVALID,
	output reg [4:0] BRESP,
	// READ/WRITE idle
	output reg RIDLE,
	output reg WIDLE
);

	reg [3:0] ARLEN = 4'b0000;
	reg [3:0] count = 4'b0000;
	reg [3:0] RID = 4'b0000;
	reg [7:0] RADDR = 8'b00000000;
	reg [1:0] next_state = 2'b00;
	reg [1:0] current_state = 2'b00;
	
	reg RESP = 1'b0;
	reg [3:0] BID = 4'b0000;
	reg [8:0] WADDR = 9'b000000000;
	reg [2:0] next_state_ = 3'b000;
	reg [2:0] current_state_ = 3'b000;
	
	reg [7:0] mem [0:255];
	
	// delay counter
	reg [4:0] delay_R = 5'b00000;
	reg [4:0] delay_W = 5'b00000;
	
	integer i;
	initial begin
	    for (i = 0; i < 256; i = i + 1) begin
			mem[i] <= 0;
		end	
	end
	
	
	always@(posedge clk or posedge rst) begin
		if (rst) begin		
			next_state <= 0;			
			current_state <= 0;
		end
		
		else begin
		
			case (current_state)
			
				0: begin
					if (ARVALID)
						next_state <= 1;
				end
				
				1: begin
					if (!ARVALID && RREADY)
						next_state <= 2;
				end
				
				2: begin
					if (count == ARLEN)
						next_state <= 3;
				end
				
				// state 3 for introducing a delay
				3: begin
					if (delay_R == DELAY) begin
						next_state <= 0;
					end
				end
								
			
			endcase
			
			current_state <= next_state;
			
		end		
	end
	
	always@(posedge clk or posedge rst) begin
		if (rst) begin		
			next_state_ <= 0;			
			current_state_ <= 0;
		end		
		
		else begin
		
			case (current_state_)
			
				0: begin
					if (AWVALID) begin
						// $display ("\n Going to next_state 1");

						next_state_ <= 1;
					end
				end
				
				1: begin
					if (!AWVALID && WVALID) begin
						// $display ("\n Going to next_state 2");

						next_state_ <= 2;
					end
				end
				
				2: begin
					if (WLAST) begin
						// $display ("\n Going to next_state 3");
						next_state_ <= 3;
					end
				end
				
				3: begin
					if (BREADY) begin
						// $display ("\n Going to next_state 0");

						next_state_ <= 4;
					end
				end
				
				// state 4 for introducing a delay
				4: begin
					if (delay_W == DELAY) begin
						next_state_ <= 0;
					end
				end
				
			endcase
			
			current_state_ <= next_state_;
		
		end
	end
	
	always@(posedge clk) begin
		case (next_state_)
		
			0: begin
				AWREADY <= 0;
				WREADY <= 0;
				BVALID <= 0;
				BRESP <= 0;
				RESP = 1'b0;
				BID = 4'b0000;
				WADDR = 9'b000000000;
				// WIDLE initially idle, delay_W reset
				WIDLE <= 1'b1;
				delay_W <= 0;
				if (AWVALID) begin
					WIDLE <= 1'b0;
				end
			end
			
			1: begin
				AWREADY <= 1;
				BID <= AWIN[3:0];
				WADDR <= AWIN[11:4];
			end
			
			2: begin
				AWREADY <= 0;
				WREADY <= 1;
				if (WVALID) begin
					if (WADDR <= 255) begin
						$display ("Actual WRITE data %d to ADDR %d", WDATA, WADDR);
						mem[WADDR] <= WDATA;
					end
					else
						RESP <= 1;
					WADDR <= WADDR + 1;
				end
			end
			
			3: begin
				BVALID <= 1;
				BRESP <= {RESP, BID};
			end
			
			// start counting delay
			4: begin
				delay_W <= delay_W + 1;	
			end
		
		endcase
	end
	
	always@(posedge clk) begin
		case (next_state)
			
			0: begin						
				ARREADY <= 0;
				RVALID <= 0;
				RLAST <= 0;
				RID <= 4'b0000;
				ARLEN = 4'b0000;
				RADDR = 8'b00000000;
				OUT <= 0;
				count <= 0;
				// RIDLE initially idle, delay_R reset
				RIDLE <= 1'b1;
				delay_R <= 0;
				if (ARVALID) begin
					RIDLE <= 1'b0;
				end				
			end
			
			1: begin
				ARREADY <= 1;
				RID <= IN[3:0];
				ARLEN <= IN[7:4];
				RADDR <= IN[15:8];
			end 
			
			2: begin
				ARREADY <= 0;
				if (WADDR != RADDR) begin
					RVALID = 1;
					if (RREADY) begin
						if (ARLEN) begin
							count <= count + 1;
						end
						// $display(" ARLEN is %d", ARLEN);
						if (count == ARLEN || !ARLEN) begin
							RLAST <= 1;
						end
						if (RADDR + count <= 255  && !RLAST) begin
							// $display(" The RADDR is %d, and the count is %d", RADDR, count);
							OUT <= {mem[RADDR+count], 1'b0};
						end
						else
							OUT <= {8'b00000000, 1'b1};
					end
				end
				else begin
					RVALID = 0;
				end
			end
			
			// start counting delay
			3: begin
				delay_R <= delay_R + 1;	
			end
			
		endcase
		
	end
	
endmodule
