`define mon vif.mon_m.mon_cb

class monitor;
	virtual intf vif;
	mailbox #(transaction ) m2s;

         //for coverage
	 bit wr_en_s;
	 bit rd_en_s;
	 bit [7:0] datain_s;
	 bit [7:0] dataout_s;
	 bit full_s;
	 bit empty_s;

	 //covergroup

	 covergroup fifo_cg;

		 cp_wr: coverpoint wr_en_s{
			 bins write = {1};
			 bins no_write = {0};
			 }

	         cp_rd: coverpoint rd_en_s {
	                 bins read = {1};
	                 bins no_read = {0};
	                }
                  cp_op : coverpoint {wr_en_s , rd_en_s} {
                          bins idle = {2'b00};
                          bins write = {2'b10};
                          bins read = {2'b01};
                          bins both = {2'b11};
                        }
                  cp_full: coverpoint full_s{
                           bins full = {1};
                           bins not_full = {0};
                        }
                  cp_empty: coverpoint empty_s {
                            bins empty = {1};
                            bins not_empty = {0};
                         }

		 cp_overflow : coverpoint (vif.wr_en && vif.full) {
		                bins overflow = {1};
		                bins no_overflow = {0};
		          }
	          cp_underflow : coverpoint (vif.rd_en && vif.empty) {
	                         bins underflow = {1};
	                         bins no_underflow = {0};
	                   }			 

                  cross1 : cross cp_wr , cp_rd;
                  cross2 : cross cp_wr , cp_full;
                  cross3 : cross cp_rd , cp_empty;
		  cross4 : cross cp_rd , cp_underflow {
			        ignore_bins invalid = binsof(cp_rd.no_read) && binsof(cp_underflow.underflow); }
		  cross5 : cross cp_wr , cp_overflow {
			         ignore_bins invalid = binsof(cp_wr.no_write) && binsof(cp_overflow.overflow); }

            endgroup



         function new( virtual intf vif , mailbox #(transaction) m2s);
		 this.m2s = m2s;
		 this.vif = vif;
		 fifo_cg  = new();
	 endfunction

	 task main();
		 forever begin
			 transaction tr;
			  tr  = new();

			 @(posedge vif.mon_m.clk);

                          wr_en_s = `mon.wr_en;
			  rd_en_s = `mon.rd_en;
			  datain_s = `mon.datain;
			  dataout_s = `mon.dataout;
			  full_s = `mon.full;
			  empty_s = `mon.empty;


			 
		//	  tr.wr_en = `mon.wr_en;
		//	  tr.rd_en = `mon.rd_en;
		//	  tr.datain = `mon.datain;
		//	  tr.dataout = `mon.dataout;
		//	  tr.full = `mon.full;
		//	  tr.empty = `mon.empty;
		//
                          tr.wr_en = wr_en_s;
			  tr.rd_en = rd_en_s;
			  tr.datain = datain_s;
			  tr.dataout = dataout_s;
			  tr.full = full_s;
			  tr.empty = empty_s;

                           fifo_cg.sample();
			  m2s.put(tr);
			  tr.display("monitor");
		  end
	  endtask
  endclass


 
