`timescale 1ns / 1ps

module tb_top_uart;

	// Inputs
	reg sys_clk;
	reg sys_rst_n;
	reg rx_data;
	// Outputs
	wire tx_data;

	// Instantiate the Unit Under Test (UUT)
	top_uart top_uart0 (
		.sys_clk(sys_clk), 
		.sys_rst_n(sys_rst_n), 
		.rx_data(rx_data), 
		.tx_data(tx_data)
	);
always # 10 sys_clk = ~sys_clk;
	initial begin
		// Initialize Inputs
		sys_clk = 0;
		sys_rst_n = 0;
		rx_data = 1;
		// Wait 100 ns for global reset to finish
		#100;
        sys_rst_n = 1'b1;
        #8680;
        rx_data = 1;
        #8680;
        rx_data = 1;
        #8680;
        rx_data = 0;//start
        #8680;
        rx_data = 0;//1
        #8680;
        rx_data = 1;//2
        #8680;
        rx_data = 0;//3
        #8680;
        rx_data = 1;//4
        #8680;
        rx_data = 0;//5
        #8680;
        rx_data = 1;//6
        #8680;
        rx_data = 0;//7
        #8680;
        rx_data = 1;//8
        #(8680*20);;
        rx_data = 1;
        #8680;
        rx_data = 0;
        #8680;
        rx_data = 1;//1
        #8680;
        rx_data = 0;
        #8680;
        rx_data = 1;
        #8680;
        rx_data = 0;//4
        #8680;
        rx_data = 1;
        #8680;
        rx_data = 0;
        #8680;
        rx_data = 1;
        #8680;
        rx_data = 0;//8
        #8680;
        rx_data = 1;
        #8680;
        rx_data = 1;
        #8680;
        rx_data = 1;
		#100000;
		$finish;
	end

initial begin
	$monitor("%dns rx_data is %b tx_data is %b\n",$time,rx_data,tx_data);
end // initial

initial begin 
    $fsdbDumpfile("tb_top_uart.fsdb");
    $fsdbDumpvars(0,tb_top_uart);
    $fsdbDumpMDA();
end

endmodule

