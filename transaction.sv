class transaction;
	rand bit wr_en;
	rand bit rd_en;
	rand bit [7:0] datain;

	bit [7:0] dataout;
	bit empty;
	bit full;

	constraint rd_wr { rd_en dist{ 1:=60 , 0:= 40} ;  
                         	wr_en dist {1:=70 , 0:=30} ;  
			}
	constraint both {  
		         (rd_en == 1 &&  wr_en == 1) dist { 1:=30, 0:= 70} ; 
			 }

	function void display(string name);
		$display("[%s]  wr_en= %0d rd_en = %0d datain = %0d =>  dataout = %0d , full = %0d , empty = %0d" ,name , wr_en , rd_en , datain , dataout , full , empty);

	endfunction



endclass

