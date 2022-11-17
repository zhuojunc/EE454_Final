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
    output reg ARREADY,
    output reg RVALID,
	output reg RLAST,
    output reg [8:0] OUT,
	output reg AWREADY,
	output reg WREADY,
	output reg BVALID,
	output reg [4:0] BRESP
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
	
	integer i;
	initial begin
	    for (i = 0; i < 256; i = i + 1) begin
			mem[i] = 0;
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
					if (count + 1 == ARLEN)
						next_state <= 0;
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
					if (WADDR <= 255)
						mem[WADDR] <= WDATA;
					else
						RESP <= 1;
					WADDR <= WADDR + 1;
				end
			end
			
			3: begin
				WREADY <= 0;
				BVALID <= 1;
				BRESP <= {RESP, BID};
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
						count <= count + 1;
						if (count + 1 == ARLEN)
							RLAST = 1;
						
						if (RADDR + count <= 255)
							OUT <= {mem[RADDR+count], 1'b0};
						else
							OUT <= {8'b00000000, 1'b1};
					end
				end
				else begin
					RVALID = 0;
				end
			end
			
		endcase
		
	end
	
endmodule
