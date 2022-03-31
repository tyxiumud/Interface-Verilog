`timescale 1ns / 1ps
module uart_rx(
	//-----------input 
	clk,rst_n,rx_data,
	//-----------output 
	po_data,rx_done
    );
input clk;
input rst_n;
input rx_data;
output [7:0] po_data;
output reg rx_done;

localparam baud_cnt_end = 'd434 - 'd1							;
localparam baud_cnt_m 	= (baud_cnt_end ) / 'd2 		 		;
// localparam baud_cnt_m 	= (baud_cnt_end + 'd1) / 'd2 - 'd1  ;
//------------------------------
reg rx_ff1;
reg rx_ff2;
reg rx_ff3;
reg rx_flag;
reg [12:0] baud_cnt;
reg bit_flag;
reg [3:0] bit_cnt;
reg [7:0] po_data;
reg [7:0] po_data_r;
wire rx_nedge;

always@(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin 
    rx_ff1 <= 1'b0;
    rx_ff2 <= 1'b0;
    rx_ff3 <= 1'b0;
    end 
    else begin 
    rx_ff1 <= rx_data;
    rx_ff2 <= rx_ff1;
    rx_ff3 <= rx_ff2;
    end 
end 

assign rx_nedge = rx_ff3 && ~rx_ff2 && !rx_flag;
// define rx_flag
always@(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0)
		rx_flag <= 1'b0;
	else if(rx_nedge == 1'b1)
	    rx_flag	<= 1'b1;
    else if(bit_cnt == 4'd9 && baud_cnt == baud_cnt_end)
	    rx_flag <= 1'b0;
end
//define band_cnt------------------------------
always@(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0)
		baud_cnt <= 13'd0;	
	else if(baud_cnt == baud_cnt_end)
	    baud_cnt <= 13'd0;
    else if(rx_flag == 1'b1)
        baud_cnt <= baud_cnt + 1'b1;
    else 
        baud_cnt <= 13'd0;
end
//define bit_flag------------------------------
always@(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0)
		bit_flag <= 1'b0;
	else if(baud_cnt == baud_cnt_m)
	    bit_flag <= 1'b1;
    else 
        bit_flag <= 1'b0;
end
//define bit_cnt------------------------------
always@(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0)
		bit_cnt <= 4'd0;
	else if(rx_flag == 0)
	    bit_cnt <= 4'd0;
    else if(baud_cnt == baud_cnt_end && rx_flag == 1'b1)
	    bit_cnt <= bit_cnt + 1'b1;
end
//define rx_done------------------------------
always@(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0)
		rx_done <= 1'b0;
	else if(bit_cnt == 4'd8 && baud_cnt == baud_cnt_end - 'd1)
	    rx_done <= 1'b1;
    else 
	    rx_done <= 1'b0;
end

always@(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) 
        po_data <= 8'b0;
    else if(bit_cnt == 4'd8 && baud_cnt == baud_cnt_end - 'd1)
		po_data <= po_data_r;
	else 
		po_data <= 8'd0;
end

always@(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0)
		po_data_r <= 8'b0;
	else if(rx_flag == 1'b1) begin 
            if(bit_flag)
				case(bit_cnt)
					4'd1    :	po_data_r[0] <= rx_ff2 ;
					4'd2    :	po_data_r[1] <= rx_ff2 ;
					4'd3    :	po_data_r[2] <= rx_ff2 ;
					4'd4    :	po_data_r[3] <= rx_ff2 ;
					4'd5    :	po_data_r[4] <= rx_ff2 ;
					4'd6    :	po_data_r[5] <= rx_ff2 ;
					4'd7    :	po_data_r[6] <= rx_ff2 ;
					4'd8    :	po_data_r[7] <= rx_ff2 ;
					default :   po_data_r <= po_data_r ;	
				endcase
			else 
				po_data_r <= po_data_r;
         end
    else 
        po_data_r <= 8'd0;
end

endmodule

