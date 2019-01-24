`ifndef __BSG_DCDC_MANYCORE_PKG_V__
`define __BSG_DCDC_MANYCORE_PKG_V__

package bsg_dcdc_manycore_pkg;

  parameter bank_size_gp          = 1024; // in words
  parameter num_banks_gp          = 1;    // number of banks
  parameter imem_size_gp          = 1024; // in words (e.g. instructions)
  parameter mem_size_gp           = (num_banks_gp * bank_size_gp + imem_size_gp) * 4;

  parameter addr_width_gp         = 20;
  parameter data_width_gp         = 32;

  parameter hetero_type_vec_gp    = 0;

  //parameter fsb_remote_credits_gp = 128;

  parameter num_tiles_x_gp        = 2;
  parameter num_tiles_y_gp        = 5;

endpackage // bsg_manycore_pkg

`endif // __BSG_DCDC_MANYCORE_PKG_V__
