`ifndef __BSG_CHIP_PKG_V__
`define __BSG_CHIP_PKG_V__

package bsg_chip_pkg;

  parameter fsb_nodes_gp                     = 6;

  parameter fsb_idx_rocket_manycore_start_gp = 0;
  parameter fsb_idx_rocket_manycore_end_gp   = 3;
  parameter fsb_idx_rocket_bnn_gp            = 4;
  parameter fsb_idx_dcdc_manycore_gp         = 5;

  parameter num_rockets_gp   = 5 ;
  parameter rocc_num_gp      = num_rockets_gp;
  
  // For bsg_test_node_master
  parameter tile_id_ptr_gp   = -1;
  parameter max_cycles_gp    = 500000;

endpackage // bsg_chip_pkg

`endif // __BSG_CHIP_PKG_V__
