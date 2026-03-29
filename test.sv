`include "environment.sv"
   
program test (intf  i_i );
         //parameter N= 7;
	environment env;

	initial begin
		env = new(i_i);
		env.g1.T_count = 25;
		env.run();
	end
endprogram


