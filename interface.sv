interface  intf (input logic clk ,rst);

	logic wr_en , rd_en;
	logic [7:0] datain ;
	logic [7:0] dataout;
	logic full , empty;

	clocking driver_cb @(posedge clk);
		default input #1 output  #1;
		//to drive the DUT,  input signals in the main design acts as
		//output
		//input signals are sampled at 1ns before clock edge 
		//output signals driven after 1ns after cloc edge
		output rst ;
		output wr_en;
		output rd_en;
		output datain;
		input dataout ;
		input full , empty;
	endclocking 

	clocking mon_cb @(posedge clk) ;
		default input #0 output #0;
		input rst ;
		input rd_en;
		input wr_en;
		input datain;
	        input  full ,empty;        //output from DUT act as input 
		input dataout;
	endclocking

	modport driver_m (clocking driver_cb , input clk);

	modport mon_m (clocking mon_cb , inout clk);

endinterface

