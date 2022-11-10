`timescale 1ns / 1ps

module Master
(
    input  rst,
    input  clk,
	input  en,
	input en_,
	input  LAST,	
	input [7:0] ARADDR,
	input [3:0] ARLEN,
	input [3:0] ARID,
    input [8:0] IN,
	input [7:0] AWADDR,
	input [3:0] AWID,
	input [7:0] INDATA,
	input  ARREADY,
	input  RVALID,
	input  RLAST,
	input  AWREADY,
	input  WREADY,
	input  BVALID,
	input [4:0] BRESP,
    output reg ARVALID,
    output reg RREADY,
	output reg [15:0] OUT,
	output reg RRESP,
	output reg [7:0] RDATA,
	output reg AWVALID,
	output reg WVALID,
	output reg WLAST,
	output reg BREADY,
	output reg [11:0] AWOUT,
	output reg [7:0] WDATA,
	output reg [4:0] BOUT,
);

	reg [1:0] next_state = 2'b00;
	reg [1:0] current_state = 2'b00;
	reg [2:0] next_state_ = 3'b000;
	reg [2:0] current_state_ = 3'b000;
	
	assign WLAST = LAST;
	assign WDATA = INDATA;
	
	always@(posedge clk or posedge rst) begin
		if (rst) begin		
			next_state <= 0;			
			current_state <= 0;
		end
		
		else begin
		
			case (current_state)
			
				0: begin
					if (en)
						next_state <= 1;
				end
				
				1: begin
					if (ARREADY)
						next_state <= 2;
				end
				
				2: begin
					if (RVALID && !ARREADY)
						next_state <= 3;
				end
				
				3: begin
					if (RLAST)
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
					if (en_)
						next_state_ <= 1;
				end
				
				1: begin
					if (AWREADY)
						next_state_ <= 2;
				end
				
				2: begin
					if (WREADY && !AWREADY)
						next_state_ <= 3;
				end
				
				3: begin
					if (BVALID)
						next_state_ <= 0;
				end

			endcase
			
			current_state_ <= next_state_;

		end			

	end
	
	always@ (posedge clk) begin
		case(next_state_)
		
			0: begin
				AWVALID <= 0;
				WVALID <= 0;
				BREADY <= 0;
				AWOUT <= 0;
				BOUT <= 0;
			end
			
			1: begin
				AWVALID <= 1;
				AWOUT <= {AWADDR, AWID};
			end
			
			2: begin
				AWVALID <= 0;
				WVALID <= 1;
				WDATA <= INDATA;
			end
			
			3: begin
				if (WREADY)
					WDATA <= INDATA;
				BREADY <= 1;
				if (BVALID)
					BOUT <= BRESP;
			end
		
		endcase
	end
	
	always@(posedge clk) begin
		case (next_state)
			
			0: begin						
				ARVALID <= 0;
				RREADY <= 0;
				OUT <= 0;
				RRESP <= 0;
				RDATA <= 0;
			end
			
			1: begin
				ARVALID <= 1;
				OUT <= {ARADDR, ARLEN, ARID};
			end
			
			2: begin
				ARVALID <= 0;
				RREADY <= 1;
			end
			
			3: begin
				if (RVALID) begin
					RRESP <= IN[0];
					RDATA <= IN[8:1];
				end	
			end
			
		endcase
		
	end
	
endmodule