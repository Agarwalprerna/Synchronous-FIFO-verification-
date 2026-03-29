`define driv vif.driver_m.driver_cb 

class driver;

	int no_of_trans;
	virtual intf vif;
	mailbox #(transaction) g2d;

	function new(virtual intf vif , mailbox #(transaction) g2d);
		this.vif = vif;
		this.g2d = g2d;
	endfunction

	task reset();
		wait(vif.rst);
		$display("enter into reset mode");
		`driv.rst <= 0;

		wait(!vif.rst);
		  `driv.rst <= 1;
		  $display("reset ended");
	  endtask

	  task main();
		  forever begin
			  transaction tr;
			  g2d.get(tr);
			  @(posedge vif.driver_m.clk)
			   `driv.wr_en <= tr.wr_en;
			   `driv.rd_en <= tr.rd_en;
			   `driv.datain <= tr.datain;
			   @(posedge vif.driver_m.clk)
			     tr.dataout = `driv.dataout;
			     tr.full = `driv.full;
			     tr.empty = `driv.empty;
			     tr.display("driver");

			     no_of_trans ++ ;
		     end
	     endtask
	
      endclass

