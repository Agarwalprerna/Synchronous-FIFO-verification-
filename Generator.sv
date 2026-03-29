class Generator;

	transaction tr;

	mailbox #(transaction) g2d;
	int T_count;
	int count;
	event ended;

	function new(mailbox #(transaction) g2d);
	    this.g2d = g2d;
	    count = 0;
    endfunction

    task main();
	    repeat(T_count)begin
		    tr= new();
		    if(tr.randomize()) begin
			    tr.display("GENERATOR");
		          // $display("randomization successfull");
			   g2d.put(tr) ; //after stimulus generation then put into mailbox
			   count ++;
		   end
	   end
	   -> ended;   //triggering event shows generation of stimulus completed
   endtask
 

   endclass

 
