module read_ptr_empty #( parameter ADDRESS_BITS = 4 ) (read_inc, read_clk, read_rst, rq2_write_ptr,rempty,read_addr,read_ptr);

  input   [ADDRESS_BITS :0] rq2_write_ptr;
  input   read_inc, read_clk, read_rst;
  
  
  output  logic [ADDRESS_BITS-1:0] read_addr;
  output logic  rempty;
  output logic [ADDRESS_BITS :0] read_ptr;


  logic [ADDRESS_BITS:0] rbin;
  logic [ADDRESS_BITS:0] rgraynext, rbinnext;
  logic rempty_val,half_empty;

   always_ff @(posedge read_clk or negedge read_rst)
    if (!read_rst)
      {rbin, read_ptr} <= '0;
    else
      {rbin, read_ptr} <= {rbinnext, rgraynext};
  
 always_comb begin 
		read_addr = rbin[ADDRESS_BITS-1:0];
		rbinnext = rbin + (read_inc & ~rempty);
		rgraynext = (rbinnext>>1) ^ rbinnext;
		rempty_val = (rgraynext == rq2_write_ptr);
		half_empty = (rq2_write_ptr >= 228);
  end

  always_ff @(posedge read_clk or negedge read_rst) begin
    if (!read_rst)
      rempty <= 1'b1;
    else
      rempty <= rempty_val;
	end
endmodule

