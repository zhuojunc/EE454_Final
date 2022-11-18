`timescale 1ns / 1ps

module Master
(
    input  rst,
    input  clk,
	input  en,
	input en_,
	// input  LAST,
	input [15:0] tb_R, // tb_R[15:8] ARADDR, tb_R[7:4] ARLEN, tb_R[3:0] ARID
	// input [7:0] ARADDR,
	// input [3:0] ARLEN,
	// input [3:0] ARID,
    input [8:0] IN,
	input [15:0] tb_W, // tb_W[15:8] AWADDR, tb_W[7:4] AWLEN, tb_W[3:0] AWID
	// input [7:0] AWADDR,
	// input [3:0] AWID,
	input [127:0] INDATA, // max 16 data bytes
	// input [7:0] INDATA,
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
	output reg [4:0] BOUT
);

	reg [1:0] next_state = 2'b00;
	reg [1:0] current_state = 2'b00;
	reg [2:0] next_state_ = 3'b000;
	reg [2:0] current_state_ = 3'b000;
	integer start = 0;
//	reg [127:0] start = 0;
//	reg [127:0] end = 0;
	
	// Current write number
	reg [3:0] count = 4'b0000;
	
/* 	always @* begin
   		WLAST <= LAST;
		WDATA <= INDATA;	
	end */
	
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
				WLAST <= 0;
				WDATA <= 0;
				count <= 0;
			end
			
			1: begin
				AWVALID <= 1;
				// AWOUT <= {AWADDR, AWID};
				AWOUT <= {tb_W[15:8], tb_W[3:0]};
			end
			
			2: begin
				AWVALID <= 0;
				WVALID <= 1;
				// WDATA <= INDATA;
				start <= count * 8;
				//end = count * 8;
				WDATA <= INDATA[start +: 8];
				// WLAST <= count == tb_W[7:4] ? 1 : 0; // tb_W[7:4]==0 -> 1 data byte
				if (tb_W[7:4]) begin
					count <= count + 1;
				end
			end
			
			3: begin
				if (WREADY) begin
					if (tb_W[7:4]) begin
						start <= count * 8;
						WDATA <= INDATA[start +: 8];
						// WLAST <= count == tb_W[7:4] ? 1 : 0; // tb_W[7:4]==0 -> 1 data byte
						count <= count + 1;
					end
				end
				
				BREADY <= 1;
				if (BVALID) begin
					WVALID <= 0;
					BOUT <= BRESP;
				end
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
				OUT <= tb_R;
			end
			
			2: begin
				ARVALID <= 0;
				RREADY <= 1;
				if (RVALID) begin
					RRESP <= IN[0];
					RDATA <= IN[8:1];
				end
			end
			
			3: begin
				if (RVALID) begin
					RRESP <= IN[0];
					RDATA <= IN[8:1];
				end	
			end
			
		endcase
		
	end
	
	always@(posedge clk) begin
		WLAST = count == tb_W[7:4] ? 1 : 0;
	end
endmodule
