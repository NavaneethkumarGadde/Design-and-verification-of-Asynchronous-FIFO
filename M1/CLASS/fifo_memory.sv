
//**************************************************************************************************************************************************************************
//************************************************************** ASYNC_FIFO ************************************************************************************************
//************************************* Authors: Sri Sai Sumanth Yadalaplaii, Dileepkumar Pulluru, Navaneeth Kumar Gadde, Karthika Munnuri**********************************
//************************************************************** Date: 04/24/2024 ******************************************************************************************

module FIFO_memory #( parameter DATASIZE = 8, parameter ADDRESS_BITS = 4) (write_inc, write_full, write_clk,write_addr, read_addr,write_data,read_data);

  input   write_inc, write_full, write_clk;
  input   [ADDRESS_BITS-1:0] read_addr,write_addr ;
  input   [DATASIZE-1:0] write_data;
  output  logic [DATASIZE-1:0] read_data;


  localparam DEPTH = 1 <<  ADDRESS_BITS;

  logic [DATASIZE-1:0] mem [0:DEPTH-1];

  assign read_data = mem[read_addr];

  always_ff @(posedge write_clk)
  
    if (write_inc && !write_full)
      mem[write_addr] <= write_data;

endmodule
