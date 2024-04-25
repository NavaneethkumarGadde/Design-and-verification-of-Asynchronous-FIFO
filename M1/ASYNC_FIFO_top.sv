
//**************************************************************************************************************************************************************************
//************************************************************** ASYNC_FIFO ************************************************************************************************
//************************************* Authors: Sri Sai Sumanth Yadalaplaii, Dileepkumar Pulluru, Navaneeth Kumar Gadde, Karthika Munnuri**********************************
//************************************************************** Date: 04/24/2024 ******************************************************************************************

module Asynch_FIFO  #( parameter DATASIZE = 8,parameter ADDRESS_BITS = 4 ) (read_data,write_full,rempty,write_data,read_inc,read_clk,read_rst,write_inc,write_clk,write_rst );
 
  input  logic  write_inc, write_clk, write_rst,read_inc, read_clk, read_rst;
  input   logic [DATASIZE-1:0] write_data;
  output  logic [DATASIZE-1:0] read_data;
  output  logic write_full,rempty;


  wire [ADDRESS_BITS-1:0] write_addr, read_addr;
  wire [ADDRESS_BITS:0] wq2_read_ptr, rq2_write_ptr;
  wire [ADDRESS_BITS:0] write_ptr, read_ptr;

  sync_r2w sync_r2w (write_clk, write_rst, read_ptr,wq2_read_ptr);
  
  sync_w2r sync_w2r (read_clk, read_rst,write_ptr,rq2_write_ptr );
  
  FIFO_memory #(DATASIZE, ADDRESS_BITS) MEM (write_inc, write_full, write_clk,write_addr, read_addr,write_data,read_data);
  
  read_ptr_empty #(ADDRESS_BITS) Read_emp_ptr (read_inc, read_clk, read_rst, rq2_write_ptr,rempty,read_addr,read_ptr);
  
  write_ptr_full #(ADDRESS_BITS) Write_full_ptr (write_inc, write_clk, write_rst, wq2_read_ptr, write_full, write_addr, write_ptr);
  

endmodule