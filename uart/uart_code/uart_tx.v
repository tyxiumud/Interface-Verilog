`timescale 1ns / 1ps
module uart_tx(
	//-----------input 
	clk,rst_n,pi_data,tx_en,
	//-----------output 
	tx_data,tx_done
    );
input clk;
input rst_n;
input [7:0] pi_data;
input tx_en;//synchronous
output reg tx_data;
output reg tx_done;
localparam baud_cnt_end = 'd434 - 'd1							;
// localparam baud_cnt_m 	= (baud_cnt_end ) / 'd2 		 		;
// localparam baud_cnt_m 	= (baud_cnt_end + 'd1) / 'd2 - 'd1  ;
reg tx_flag;
reg [8:0] baud_cnt;
reg [3:0] bit_cnt;
reg [7:0] pi_data_r;

always@(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0)
		tx_flag <= 1'b0;
	else if(tx_en == 1'b1 && tx_flag == 1'b0)
		tx_flag <= 1'b1;
	else if(bit_cnt == 4'd9 && baud_cnt == baud_cnt_end)
	    tx_flag <= 1'b0;
end

always@(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0)
		bit_cnt <= 4'd0;
	else if(tx_flag == 1'b0)
		bit_cnt <= 4'd0;
	else if(baud_cnt == baud_cnt_end)
        bit_cnt <= bit_cnt + 1'b1;
	else 	
	    bit_cnt <= bit_cnt;
end

always@(posedge clk or negedge rst_n) begin 
	if(rst_n == 1'b0)
		baud_cnt <= 13'd0;	
	else if(baud_cnt == baud_cnt_end)
		baud_cnt <= 13'd0;
	else if(tx_flag == 1'b1)
        baud_cnt <= baud_cnt + 1'b1;
	else 
	    baud_cnt <= 13'd0;
end

always@(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0)
		pi_data_r <= 8'd0;
	else if(tx_en == 1'b1)
		pi_data_r <= pi_data;
	else 
	    pi_data_r <= pi_data_r;
end 

always@(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0)
		tx_data <= 1'b1;
	else if(tx_flag == 1'b1)
			case(bit_cnt)
				4'd0 : tx_data <= 1'b0			;
				4'd1 : tx_data <= pi_data_r[0]	;
				4'd2 : tx_data <= pi_data_r[1]	;
				4'd3 : tx_data <= pi_data_r[2]	;
				4'd4 : tx_data <= pi_data_r[3]	;
				4'd5 : tx_data <= pi_data_r[4]	;
				4'd6 : tx_data <= pi_data_r[5]	;
				4'd7 : tx_data <= pi_data_r[6]	;
				4'd8 : tx_data <= pi_data_r[7]	;
				4'd9 : tx_data <= 1'b1			;
				default:;
			endcase
		else 
			tx_data <= 1'b1;
end

always@(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        tx_done <= 1'b0;
    else if(bit_cnt == 4'd9 && baud_cnt == baud_cnt_end)
        tx_done <= 1'b1;
    else 
        tx_done <= 1'b0;
end

endmodule
