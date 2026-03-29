module RTL #(parameter depth = 8 , width = 8 ) (input clk ,rst , wr_en , rd_en ,  input [width -1 :0] datain , output reg [width -1:0] dataout  , output full , empty);

//internal signals
 reg [$clog2(depth) - 1:0] wr_ptr , rd_ptr;


 //fifo memory
 reg [width - 1:0]  fifo[0:depth-1] ;

 always @(posedge clk) begin
	 if(rst) begin          //synchronous reset
            wr_ptr <= 0;
	    rd_ptr <= 0;
	    dataout <= 0;
	   // full <= 0;
	    //empty <= 0;


    end else begin
   
   	    if(!full & wr_en) begin
		    fifo[wr_ptr] <= datain;
		    wr_ptr <= wr_ptr +1 ;
	    end
    
	    if(!empty & rd_en) begin
		    dataout <= fifo[rd_ptr];
		    rd_ptr <= rd_ptr +1;
	    end
    end
    end


    assign empty =(wr_ptr == rd_ptr);
    assign full = (wr_ptr + 1 == rd_ptr);

    endmodule

