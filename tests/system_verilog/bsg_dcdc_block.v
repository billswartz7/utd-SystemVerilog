module bsg_dcdc_block

  import bsg_manycore_pkg::*;
  import bsg_dcdc_manycore_pkg::*;

 #(parameter ring_width_p = "inv")

  (input                      clk_i
  ,input                      reset_i
  
  // Data from FSB
  ,input                      v_i
  ,input  [ring_width_p-1:0]  data_i
  ,output                     ready_o
  
  // Data to FSB
  ,output                     v_o
  ,output [ring_width_p-1:0]  data_o
  ,input                      yumi_i);
  

  //  _____   _____     _______   _____   __  __                                      
  // |  __ \ / ____|   / /  __ \ / ____| |  \/  |                                     
  // | |  | | |       / /| |  | | |      | \  / | __ _ _ __  _   _  ___ ___  _ __ ___ 
  // | |  | | |      / / | |  | | |      | |\/| |/ _` | '_ \| | | |/ __/ _ \| '__/ _ \
  // | |__| | |____ / /  | |__| | |____  | |  | | (_| | | | | |_| | (_| (_) | | |  __/
  // |_____/ \_____/_/   |_____/ \_____| |_|  |_|\__,_|_| |_|\__, |\___\___/|_|  \___|
  //                                                          __/ |                   
  //                                                         |___/                    

  `declare_bsg_manycore_link_sif_s
    (bsg_dcdc_manycore_pkg::addr_width_gp
    ,bsg_dcdc_manycore_pkg::data_width_gp
    ,`BSG_SAFE_CLOG2(bsg_dcdc_manycore_pkg::num_tiles_x_gp)
    ,`BSG_SAFE_CLOG2(bsg_dcdc_manycore_pkg::num_tiles_y_gp));

  // horizontal -- {E,W}
  bsg_manycore_link_sif_s [E:W][bsg_dcdc_manycore_pkg::num_tiles_y_gp-1:0]  hor_link_sif_li;
  bsg_manycore_link_sif_s [E:W][bsg_dcdc_manycore_pkg::num_tiles_y_gp-1:0]  hor_link_sif_lo;

  // vertical -- {S,N}
  bsg_manycore_link_sif_s [S:N][bsg_dcdc_manycore_pkg::num_tiles_x_gp-1:0]  ver_link_sif_li;
  bsg_manycore_link_sif_s [S:N][bsg_dcdc_manycore_pkg::num_tiles_x_gp-1:0]  ver_link_sif_lo;

  localparam dcdc_mc_x_cord_width_lp = `BSG_SAFE_CLOG2(bsg_dcdc_manycore_pkg::num_tiles_x_gp) ;
  localparam dcdc_mc_y_cord_width_lp = `BSG_SAFE_CLOG2(bsg_dcdc_manycore_pkg::num_tiles_y_gp+1) ;

  bsg_manycore #
    (.bank_size_p(bsg_dcdc_manycore_pkg::bank_size_gp) // all in words
    ,.imem_size_p(bsg_dcdc_manycore_pkg::imem_size_gp) // all in words
    ,.num_banks_p(bsg_dcdc_manycore_pkg::num_banks_gp)
    ,.num_tiles_x_p(bsg_dcdc_manycore_pkg::num_tiles_x_gp)
    ,.num_tiles_y_p(bsg_dcdc_manycore_pkg::num_tiles_y_gp)
    ,.extra_io_rows_p(1)

    ,.stub_w_p({bsg_dcdc_manycore_pkg::num_tiles_y_gp{1'b0}})
    ,.stub_e_p({bsg_dcdc_manycore_pkg::num_tiles_y_gp{1'b0}})
    ,.stub_n_p({bsg_dcdc_manycore_pkg::num_tiles_x_gp{1'b0}})
    ,.stub_s_p({bsg_dcdc_manycore_pkg::num_tiles_x_gp{1'b0}})

    ,.hetero_type_vec_p(bsg_dcdc_manycore_pkg::hetero_type_vec_gp)
    ,.debug_p(0)
    ,.addr_width_p(bsg_dcdc_manycore_pkg::addr_width_gp)
    ,.data_width_p(bsg_dcdc_manycore_pkg::data_width_gp))
  dcdc_manycore
    (.clk_i(clk_i)
    ,.reset_i(reset_i)

    // these should be tied off
    ,.hor_link_sif_i(hor_link_sif_li)
    ,.hor_link_sif_o(hor_link_sif_lo)

    // north side should be tied off
    ,.ver_link_sif_i(ver_link_sif_li)
    ,.ver_link_sif_o(ver_link_sif_lo));

  //  ______ _____ ____      __  __     __  __                                      
  // |  ____/ ____|  _ \    / /  \ \   |  \/  |                                     
  // | |__ | (___ | |_) |  / /____\ \  | \  / | __ _ _ __  _   _  ___ ___  _ __ ___ 
  // |  __| \___ \|  _ <  | <______> | | |\/| |/ _` | '_ \| | | |/ __/ _ \| '__/ _ \
  // | |    ____) | |_) |  \ \    / /  | |  | | (_| | | | | |_| | (_| (_) | | |  __/
  // |_|   |_____/|____/    \_\  /_/   |_|  |_|\__,_|_| |_|\__, |\___\___/|_|  \___|
  //                                                        __/ |                   
  //                                                       |___/                    

  bsg_manycore_links_to_fsb #
    (.ring_width_p(ring_width_p)
    ,.dest_id_p(5)
    ,.num_links_p(bsg_dcdc_manycore_pkg::num_tiles_x_gp)
    ,.addr_width_p(bsg_dcdc_manycore_pkg::addr_width_gp)
    ,.data_width_p(bsg_dcdc_manycore_pkg::data_width_gp)
    ,.x_cord_width_p(`BSG_SAFE_CLOG2(bsg_dcdc_manycore_pkg::num_tiles_x_gp)   )
    ,.y_cord_width_p(`BSG_SAFE_CLOG2(bsg_dcdc_manycore_pkg::num_tiles_y_gp+1) )
    ,.remote_credits_p(128)

    // max bandwidth of incoming packets is 1 every 2.5 cycles
    // so a pseudo 1r1w large fifo, which can do a packet every 2 cycles
    // is appropriate
    ,.use_pseudo_large_fifo_p(1))
  l2f
    (.clk_i(clk_i)
    ,.reset_i(reset_i)

    // later we may change this to be the west side
    // changes must be mirrored in master node
    ,.links_sif_i(ver_link_sif_lo[S])
    ,.links_sif_o(ver_link_sif_li[S])

    ,.v_i(v_i)
    ,.data_i(data_i)
    ,.ready_o(ready_o)

    ,.v_o(v_o)
    ,.data_o(data_o)
    ,.yumi_i(yumi_i));

    //////////////////////////////////////////////////////////////////////////
    // Tie the unused I/O
    genvar                   i;
    for (i = 0; i < bsg_dcdc_manycore_pkg::num_tiles_y_gp; i=i+1) begin: rof2
         bsg_manycore_link_sif_tieoff #(.addr_width_p   ( bsg_dcdc_manycore_pkg::addr_width_gp  )
                                        ,.data_width_p  ( bsg_dcdc_manycore_pkg::data_width_gp  )
                                        ,.x_cord_width_p( dcdc_mc_x_cord_width_lp               )
                                        ,.y_cord_width_p( dcdc_mc_y_cord_width_lp               )
                                        ) bmlst
         (.clk_i(clk_i)
          ,.reset_i(reset_i)
          ,.link_sif_i(hor_link_sif_lo[W][i])
          ,.link_sif_o(hor_link_sif_li[W][i])
          );

         bsg_manycore_link_sif_tieoff #(.addr_width_p   (bsg_dcdc_manycore_pkg::addr_width_gp  )
                                        ,.data_width_p  (bsg_dcdc_manycore_pkg::data_width_gp  )
                                        ,.x_cord_width_p(dcdc_mc_x_cord_width_lp               )
                                        ,.y_cord_width_p(dcdc_mc_y_cord_width_lp               )
                                        ) bmlst2
         (.clk_i(clk_i)
          ,.reset_i(reset_i)
          ,.link_sif_i(hor_link_sif_lo[E][i])
          ,.link_sif_o(hor_link_sif_li[E][i])
          );
      end


    for (i = 0; i < bsg_dcdc_manycore_pkg::num_tiles_x_gp; i=i+1) begin: rof
         // tie off north side; which is inaccessible
         bsg_manycore_link_sif_tieoff #(.addr_width_p   (bsg_dcdc_manycore_pkg::addr_width_gp )
                                        ,.data_width_p  (bsg_dcdc_manycore_pkg::data_width_gp )
                                        ,.x_cord_width_p(dcdc_mc_x_cord_width_lp              )
                                        ,.y_cord_width_p(dcdc_mc_y_cord_width_lp              )
                                        ) bmlst3
         (.clk_i(clk_i)
          ,.reset_i(reset_i)
          ,.link_sif_i(ver_link_sif_lo[N][i])
          ,.link_sif_o(ver_link_sif_li[N][i])
          );
      end
  
endmodule
