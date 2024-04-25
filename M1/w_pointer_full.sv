
//**************************************************************************************************************************************************************************
//************************************************************** ASYNC_FIFO ************************************************************************************************
//************************************* Authors: Sri Sai Sumanth Yadalaplaii, Dileepkumar Pulluru, Navaneeth Kumar Gadde, Karthika Munnuri**********************************
//************************************************************** Date: 04/24/2024 ******************************************************************************************

module write_ptr_full #( parameter ADDRESS_BITS = 4 ) (write_inc, write_clk, write_rst, wq2_read_ptr, write_full, write_addr, write_ptr);

  input   [ADDRESS_BITS :0] wq2_read_ptr;
  input   write_inc, write_clk, write_rst;
  output  logic [ADDRESS_BITS-1:0] write_addr;
  output logic  write_full;
  output logic [ADDRESS_BITS :0] write_ptr;

   logic [ADDRESS_BITS:0] wbin;
   logic [ADDRESS_BITS:0] wgraynext, wbinnext;
   logic half_full,write_full_val;
   
  always_comb begin 
	write_addr = wbin[ADDRESS_BITS-1:0];
	wbinnext = wbin + (write_inc & ~write_full);
	wgraynext = ( wbinnext >> 1 ) ^ wbinnext;
	write_full_val = (wgraynext=={~wq2_read_ptr[ADDRESS_BITS:ADDRESS_BITS-1], wq2_read_ptr[ADDRESS_BITS-2:0]});
	half_full = wq2_read_ptr >= 228;
  end
  
  always_ff @(posedge write_clk or negedge write_rst)
  begin
    if (!write_rst)
      {wbin, write_ptr} <= '0;
    else
      {wbin, write_ptr} <= {wbinnext, wgraynext};
  end

  always_ff @(posedge write_clk or negedge write_rst)
  begin
    if (!write_rst)
	
      write_full <= 1'b0;
	  
    else
      write_full <= write_full_val;
  end
  
endmodule