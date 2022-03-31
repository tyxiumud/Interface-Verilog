`timescale 1ns / 1ps
module top_uart(
	input 		wire 		sys_clk		,
	input 		wire 		sys_rst_n	,
	input 		wire 		rx_data 	,
	output 		wire 		tx_data 	 
    );

wire 	[7:0] 	data		;
wire 			en 			;

uart_rx uart_rx0 (
    .clk        (sys_clk    ), 
    .rst_n      (sys_rst_n  ), 
    //input signals
    .rx_data    (rx_data    ), 
    .po_data    (data 	    ), 
    //output signals
    .rx_done    (en 	    )
    );

uart_tx uart_tx0 (
    .clk        (sys_clk    ), 
    .rst_n      (sys_rst_n  ), 
    //input signals
    .pi_data    (data 	    ), 
    .tx_en      (en 	    ), 
    //output signals
    .tx_data    (tx_data    ),
    .tx_done    ( 		    )
    );



endmodule
