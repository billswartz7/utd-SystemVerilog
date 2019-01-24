module pll
  (input  in_clk_ref
  ,input  in_chip_select
  ,input  in_scn_clk
  ,input  in_sdi
  ,input  in_rstb
  ,output out_sdo
  ,output out_clk_tst
  ,output out_clk
  );

/**
 *
 * +-------------+
 * |             |
 * |             |
 * |  BLACK BOX  |
 * |             |
 * |             |
 * +-------------+
 *
 **/

// For VCS, we will forward the input clk
assign out_clk     = in_clk_ref;
assign out_clk_tst = in_clk_ref;

endmodule
