`include "interface.sv"
`include "test.sv"
`include "RTL.sv"
`include "assertion.sv"

module testbench;
   parameter depth = 8;
   parameter width = 8;

  logic clk;
  bit rst;

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
	   rst = 1;
	   #20 ;
	   rst = 0;
	   #1000 ;
	   $finish;
   end

  intf  i_i(clk,rst);
  test t(i_i);

 RTL #(8,8) dut( .clk(i_i.clk) , .rst(i_i.rst) , .wr_en(i_i.wr_en) , .rd_en(i_i.rd_en) , .datain(i_i.datain) , .dataout(i_i.dataout) , .full(i_i.full) ,.empty(i_i.empty) );


 bind RTL assertion #(.depth(depth) , .width(width) ) fifo_ass_inst (
	 .clk(clk),
	 .rst(rst),
	 .wr_en(wr_en),
	 .rd_en(rd_en),
	 .full(full),
	 .empty(empty),
	 .wr_ptr(wr_ptr),
	 .rd_ptr(rd_ptr)
	 );
 


 endmodule


