
//**************************************************************************************************************************************************************************
//************************************************************** ASYNC_FIFO ************************************************************************************************
//************************************* Authors: Sri Sai Sumanth Yadalaplaii, Dileepkumar Pulluru, Navaneeth Kumar Gadde, Karthika Munnuri**********************************
//************************************************************** Date: 04/24/2024 ******************************************************************************************

module async_fifo_tb;

  parameter DATADDRESS_BITS = 8;
  parameter ADDRESS_BITS = 4;

  logic write_inc, write_clk, write_rst;
  logic read_inc, read_clk, read_rst;
  logic [DATADDRESS_BITS-1:0] write_data;
  wire [DATADDRESS_BITS-1:0] read_data;
  wire write_full, rempty;
  logic [DATADDRESS_BITS-1:0] verif_data_q[$];
  logic [DATADDRESS_BITS-1:0] verif_write_data;


 Asynch_FIFO #(DATADDRESS_BITS, ADDRESS_BITS) dut (.*);

  initial begin
    write_clk = 1'b0;
    read_clk = 1'b0;

    fork
      forever #33.33ns write_clk = ~write_clk;  // 
      forever #50ns read_clk = ~read_clk;
    join
  end

 initial 
  begin
    write_inc = 1'b0;
    write_data = '0;
    write_rst = 1'b0;
    repeat(5) @(posedge write_clk);
    write_rst = 1'b1;

  for(int j=0; j<2; j++) 
	begin
      for (int i=0; i<460; i++) 
	  begin
        @(posedge write_clk iff !write_full);
        write_inc = (i%2 == 0)? 1'b1 : 1'b0;
        if (write_inc) 
		begin
          write_data = $urandom;
          verif_data_q.push_front(write_data);
        end
      end
      #1ns;
    end
 end

 initial 
  begin
    {read_inc,read_rst} = 2'b0;
    repeat(5) @(posedge read_clk);
    read_rst = 1'b1;

  for (int j=0; j<2; j++) 
	begin
      for (int i=0; i<460; i++) 
	  begin
        @(posedge read_clk iff !rempty)
        read_inc = (i%2 == 0)? 1'b1 : 1'b0;
        if (read_inc) 
		begin
          verif_write_data = verif_data_q.pop_back();
		  
          $display("Checking read_data: expected write_data = %d, read_data = %d", verif_write_data, read_data);
        end
      end
    end
    $finish;
  end

endmodule