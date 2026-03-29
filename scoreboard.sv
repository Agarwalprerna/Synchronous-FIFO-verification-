class scoreboard;

    int no_of_trans;
    mailbox #(transaction) m2s;
    bit [7:0] expected_dataout;
    bit [7:0] fifoQueue[$];

   function new(mailbox #(transaction) m2s);
       this.m2s = m2s;
       expected_dataout = 0;
   endfunction

   task main();
	transaction tr;

        forever begin
	     m2s.get(tr);
             no_of_trans++;
       
             tr.display("scoreboard");
             
	     

	    // if(tr.rst) begin
	//	     fifoQueue.delete();
	  //   end
             
	     if(tr.wr_en) begin
		     fifoQueue.push_back(tr.datain);
		  
		     $display("datain = %0d" , tr.datain);
	     end

	     if (tr.rd_en) begin
		     if(fifoQueue.size() > 0) begin
			     expected_dataout = fifoQueue.pop_front();
			   
			     if(expected_dataout == tr.dataout)
				     $display("Correct value  => expected = %d , tr.dataout = %d" , expected_dataout , tr.dataout) ;
			     else 
				    // $display("Got wrong value");
			             $display("FAIL => expected dataout = %0d , actual = %0d" , expected_dataout , tr.dataout);
		     end
		     else begin
			     $display("READ when FIFO empty");
		     end
	     end
     end
endtask

endclass

