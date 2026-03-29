module assertion #(parameter width = 8 , depth = 8)(

	input logic clk,
	input logic rst,
	input logic wr_en,
	input logic rd_en,

	input logic full,
	input logic empty,

	//input logic [$clog2(depth) : 0] fifo_count ,
	input logic [$clog2(depth)-1 :0] wr_ptr,
	input logic [$clog2(depth) -1:0] rd_ptr

	);

	//way to debug 
	//assert property ( @(posedge clk ) 0)
	  // else $error ("assertion working");
 
	//full assertion
	property p1;
		@(posedge clk) disable iff(rst)
		   ((wr_ptr + 1) % depth == rd_ptr) |-> full;
   endproperty

         full_ass : assert property(p1)
	   else $error("FULL ASSERT FAILED");


	   //No overflow
	   property p2;
		   @(posedge clk) disable iff(rst)
		      !(full && wr_en && !rd_en);
	      endproperty

	      overflow_ass : assert property(p2)
	         else $error("OVERFLOW DETECTED");

            //empty
	    property p3;
                  @(posedge clk) disable iff (rst)
                         (wr_ptr == rd_ptr) |-> empty;
            endproperty
           
            empty_ass: assert property(p3)
                   else $error("EMPTY FLAG WRONG");

          //uderrflow
	  property p4;
                  @(posedge clk) disable iff(rst)
                     ! (empty && rd_en && !wr_en);  //NO UNDERFLOW
           endproperty

            underflow_ass : assert property(p4)
                  else $error("UNDERFLOW DETECTED");

endmodule

