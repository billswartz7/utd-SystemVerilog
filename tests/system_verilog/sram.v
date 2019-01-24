module DataArray_T9(
  input CLK,
  input RST,
  input init,
  input [7:0] W0A,
  input W0E,
  input [127:0] W0I,
  input [127:0] W0M,
  input [7:0] R1A,
  input R1E,
  output [127:0] R1O
);


 bsg_mem_1r1w_sync_mask_write_bit  #
 (.width_p(128)
 ,.els_p(256)
 ,.read_write_same_addr_p(0))
 mem
 (.clk_i(CLK)
 ,.reset_i(RST)
 ,.w_v_i(W0E)
 ,.w_mask_i(W0M)
 ,.w_addr_i(W0A)
 ,.w_data_i(W0I)
 ,.r_v_i(R1E)
 ,.r_addr_i(R1A)
 ,.r_data_o(R1O));

endmodule

module MetadataArray_tag_arr(
  input CLK,
  input RST,
  input init,
  input [5:0] W0A,
  input W0E,
  input [87:0] W0I,
  input [87:0] W0M,
  input [5:0] R1A,
  input R1E,
  output [87:0] R1O
);


 bsg_mem_1r1w_sync_mask_write_bit  #
 (.width_p(88)
 ,.els_p(64)
 ,.read_write_same_addr_p(0))
 mem
 (.clk_i(CLK)
 ,.reset_i(RST)
 ,.w_v_i(W0E)
 ,.w_mask_i(W0M)
 ,.w_addr_i(W0A)
 ,.w_data_i(W0I)
 ,.r_v_i(R1E)
 ,.r_addr_i(R1A)
 ,.r_data_o(R1O));

endmodule

module ICache_T198(
  input CLK,
  input RST,
  input init,
  input [7:0] RW0A,
  input RW0E,
  input RW0W,
  input [127:0] RW0I,
  output [127:0] RW0O
);

bsg_mem_1rw_sync #
 (.width_p(128)
 ,.els_p(256))
 mem
 (.clk_i(CLK)
 ,.reset_i(RST)
 ,.addr_i(RW0A)
 ,.v_i(RW0E)
 ,.w_i(RW0W)
 ,.data_i(RW0I)
 ,.data_o(RW0O));

endmodule

module ICache_tag_array(
  input CLK,
  input RST,
  input init,
  input [5:0] RW0A,
  input RW0E,
  input RW0W,
  input [79:0] RW0M,
  input [79:0] RW0I,
  output [79:0] RW0O
);

bsg_mem_1rw_sync_mask_write_bit #
 (.width_p(80)
 ,.els_p(64))
 mem
 (.clk_i(CLK)
 ,.reset_i(RST)
 ,.addr_i(RW0A)
 ,.v_i(RW0E)
 ,.w_mask_i(RW0M)
 ,.w_i(RW0W)
 ,.data_i(RW0I)
 ,.data_o(RW0O));

endmodule

