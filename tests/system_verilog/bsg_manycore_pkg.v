`ifndef __BSG_MANYCORE_PKG_V__
`define __BSG_MANYCORE_PKG_V__

package bsg_manycore_pkg;

  parameter bank_size_gp          = 1024; // in words
  parameter num_banks_gp          = 1;    // number of banks
  parameter imem_size_gp          = 1024; // in words (e.g. instructions)
  parameter mem_size_gp           = (num_banks_gp * bank_size_gp + imem_size_gp) * 4;

  parameter addr_width_gp         = 20;
  parameter data_width_gp         = 32;

  parameter hetero_type_vec_gp    = 0;

  //parameter fsb_remote_credits_gp = 128;

  parameter num_tiles_x_gp        = 16;
  parameter num_tiles_y_gp        = 31;

  // The distribution of the rocc interface.
  //   1. Non-zero value is the index of the rocc interface,
  //      starting from 1.
  //   2. for example, {32'h0000_2010}
  //      indicates there are two rocc interface, their x_cords are 1 and 3.
  //   3. rocc_num_p must not bigger than tiles_x
  parameter rocc_dist_vec_gp = 64'h0400_0300_0200_0100 ;
  //-----------------------------------------------------
  // out_fifo  configuraton
  parameter out_fifo_num_gp      = 4 ;

  parameter out_fifo_dist_vec_gp = 64'h0004_0003_0002_0001;

  parameter out_fifo_width_scale_gp   = 2 ;

endpackage // bsg_manycore_pkg

`endif // __BSG_MANYCORE_PKG_V__
