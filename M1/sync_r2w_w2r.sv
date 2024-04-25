
//**************************************************************************************************************************************************************************
//************************************************************** ASYNC_FIFO ************************************************************************************************
//************************************* Authors: Sri Sai Sumanth Yadalaplaii, Dileepkumar Pulluru, Navaneeth Kumar Gadde, Karthika Munnuri**********************************
//************************************************************** Date: 04/24/2024 ******************************************************************************************

module sync_r2w #( parameter ADDRESS_BITS = 4 )(write_clk, write_rst, read_ptr,wq2_read_ptr);

  input   write_clk, write_rst;
  input   [ADDRESS_BITS:0] read_ptr;
  output logic  [ADDRESS_BITS:0] wq2_read_ptr;
   logic [ADDRESS_BITS:0] wq1_read_ptr;

  always_ff @(posedge write_clk or negedge write_rst)
  begin
    if (!write_rst) 
	{wq2_read_ptr,wq1_read_ptr} <= 0;
    else 
	{wq2_read_ptr,wq1_read_ptr} <= {wq1_read_ptr,read_ptr};
  end

endmodule


module sync_w2r #( parameter ADDRESS_BITS = 4 )(read_clk, read_rst,write_ptr,rq2_write_ptr );
  input   read_clk, read_rst;
  input   [ADDRESS_BITS:0] write_ptr;
  output logic [ADDRESS_BITS:0] rq2_write_ptr;
  logic [ADDRESS_BITS:0] rq1_write_ptr;

  always_ff @(posedge read_clk or negedge read_rst)
  begin
    if (!read_rst)
      {rq2_write_ptr,rq1_write_ptr} <= 0;
    else
      {rq2_write_ptr,rq1_write_ptr} <= {rq1_write_ptr,write_ptr};
 end
endmodule


