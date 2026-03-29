`include "transaction.sv"
`include "Generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;

	
	Generator  g1;
	driver  d1;
	monitor  m1;
	scoreboard  s1;
        
	mailbox #(transaction) g2d;
	mailbox #(transaction) m2s;

	virtual intf  vif;

	function new(virtual intf vif);
		this.vif = vif;
		g2d = new();
		m2s = new();
		g1 = new(g2d);
		d1 = new( vif , g2d);
		m1 = new(vif , m2s);
		s1 = new(m2s);
	endfunction

	task pre_reset();
		d1.reset();
	endtask


	task test();
		fork
			g1.main();
			d1.main();
			m1.main();
			s1.main();
				
		join_any
	 endtask

	 task post_test();
		 wait(g1.ended.triggered);
		 wait(g1.T_count == d1.no_of_trans);
		 wait(g1.T_count == s1.no_of_trans);
	 endtask

	 task  run();
		 pre_reset();
		 test();
		 post_test();
		 #100;
		 $finish;
	 endtask

      
 endclass






