//====================================================================
// bsg_manycore_rocc_wrapper.v
// 01/21/2016, shawnless.xie@gmail.com
//====================================================================
// This module wrapper the bsg_manycore with RoCC interface
// The RoCC distributed at the south of the manycore.
// ******* ID of each RoCC is (num_tiles_y, x)
//
// Pleas contact Prof Taylor for the document.
//
`include "bsg_manycore_packet.vh"
`include "bsg_rocc.v"

module bsg_manycore_rocc_streambuf_wrapper
   import  bsg_noc_pkg::*; // {P=0, W, E, N, S}
 #(
    //////////////////////////////////////////////////////
    //Parameters for RoCC interface
    parameter               rocc_num_p      = "inv"
    //The distribution of the rocc interface.
    //1. Non-zero value is the index of the rocc interface,
    //   starting from 1.
    //2. for example, {32'h0000_2010}
    //   indicates there are two rocc interface, their x_cords are 1 and 3.
    //3. rocc_num_p must not bigger than tiles_x
   ,parameter rocc_dist_vec_p = 0

    //////////////////////////////////////////////////////
    //Parameters for out_fifo interface
   ,parameter               out_fifo_num_p      = "inv"
    //The distribution of the out_fifo interface.
    //The same meaning with rocc_dist_vect_p
   ,parameter out_fifo_dist_vec_p = 0
    //The output fifo width must be multiple times of data_width_p
   ,parameter out_fifo_width_scale_p  = 2
   ,parameter out_fifo_in_channel_num_lp = out_fifo_num_p / out_fifo_width_scale_p 

    //////////////////////////////////////////////////////
    //Parameters for manycore
    // tile params
   ,parameter bank_size_p       = "inv"
   ,parameter num_banks_p       = "inv"
   ,parameter imem_size_p       = "inv" // in words

   // array params
   ,parameter num_tiles_x_p     = -1
   ,parameter num_tiles_y_p     = -1

   ,parameter hetero_type_vec_p = 0
   // enable debugging
   ,parameter debug_p           = 0
   ,parameter extra_io_rows_p   = 1
   ,parameter addr_width_p      = "inv"

   ,parameter x_cord_width_lp   = `BSG_SAFE_CLOG2(num_tiles_x_p)
   ,parameter y_cord_width_lp   = `BSG_SAFE_CLOG2(num_tiles_y_p + extra_io_rows_p) // extra row for I/O at bottom of chip

   // changing this parameter is untested
   ,parameter data_width_p      = 32
   ,parameter bsg_manycore_link_sif_width_lp = `bsg_manycore_link_sif_width(addr_width_p,data_width_p,x_cord_width_lp,y_cord_width_lp)
   // snew * y * x bits
   ,parameter repeater_output_p = 0
   //the async FIFO depth
   ,parameter async_fifo_els_p  = 8

   ,parameter out_fifo_width_lp   = data_width_p       * out_fifo_width_scale_p 
  )
  ( input clk_i
   ,input manycore_clk_i
   ,input                       [rocc_num_p-1:0]  reset_i

   //core control signals
   , input                      [rocc_num_p-1:0]  core_status_i
   , input                      [rocc_num_p-1:0]  core_exception_i
   , output                     [rocc_num_p-1:0]  acc_interrupt_o
   , output                     [rocc_num_p-1:0]  acc_busy_o
   //command signals
   , input                      [rocc_num_p-1:0]  core_cmd_valid_i
   , input  rocc_core_cmd_s     [rocc_num_p-1:0]  core_cmd_s_i
   , output                     [rocc_num_p-1:0]  core_cmd_ready_o

   , output                     [rocc_num_p-1:0]  core_resp_valid_o
   , output rocc_core_resp_s    [rocc_num_p-1:0]  core_resp_s_o
   , input                      [rocc_num_p-1:0]  core_resp_ready_i
   //mem signals
   , output                     [rocc_num_p-1:0]  mem_req_valid_o
   , output  rocc_mem_req_s     [rocc_num_p-1:0]  mem_req_s_o
   , input                      [rocc_num_p-1:0]  mem_req_ready_i

   , input                      [rocc_num_p-1:0]  mem_resp_valid_i
   , input  rocc_mem_resp_s     [rocc_num_p-1:0]  mem_resp_s_i

   //FIFO output 
   , output                             v_o
   , output [out_fifo_width_lp-1:0]     data_o
   , input                              ready_i
  );

  //get one hex from the parameter vector p
 `define GET_HEX(p, ind)       ( (p >> (ind* 4)) & 4'hF )
 `define GET_HEX_MIN_1(p, ind) ( `GET_HEX(p,ind) - 4'h1 )

  //declare the interface to the bsg_manycore
  `declare_bsg_manycore_link_sif_s(addr_width_p, data_width_p, x_cord_width_lp, y_cord_width_lp);

  bsg_manycore_link_sif_s [S:N][num_tiles_x_p-1:0] MC_ver_link_li, MC_ver_link_lo;
  bsg_manycore_link_sif_s [E:W][num_tiles_y_p-1:0] MC_hor_link_li, MC_hor_link_lo;



  //generate the reset signal into the manycore
  //1. if all rocket are in reset status, the manycore are all reseted.
  //2. if any rocket is dis-reseted, the manycore reset is the reset signal
  //   from the rocc interface, which is reset command from rocket core.
  wire                  RC_all_rocket_reset     =  & reset_i ;
  wire [rocc_num_p-1:0] RC_rocc_output_reset ;

  wire RC_reset_n = RC_all_rocket_reset | ( | RC_rocc_output_reset ) ;


  wire MC_reset_n;
  bsg_launch_sync_sync#(.width_p (1) )manycore_reset_sync(
        . iclk_i        ( clk_i         )
       ,. iclk_reset_i  ( 1'b0          )
       ,. oclk_i        ( manycore_clk_i)
       ,. iclk_data_i   ( RC_reset_n       )
       ,. iclk_data_o   (               )
       ,. oclk_data_o   ( MC_reset_n)
  );
   
  logic MC_reset_r;
  always_ff@(posedge manycore_clk_i)  MC_reset_r <= MC_reset_n;
  
  //instantiate the manycore
  bsg_manycore # (
      .bank_size_p      (bank_size_p        )
     ,.imem_size_p      (imem_size_p        )
     ,.num_banks_p      (num_banks_p        )
     ,.data_width_p     (data_width_p       )
     ,.addr_width_p     (addr_width_p       )
     ,.num_tiles_x_p    (num_tiles_x_p      )
     ,.num_tiles_y_p    (num_tiles_y_p      )
     ,.hetero_type_vec_p(hetero_type_vec_p  )

     ,.stub_w_p     ({num_tiles_y_p{1'b0}})
     ,.stub_e_p     ({num_tiles_y_p{1'b0}})
     ,.stub_n_p     ({num_tiles_x_p{1'b0}})
     // south side is unstubbed.
     ,.stub_s_p     ({num_tiles_x_p{1'b0}})
     ,.debug_p(debug_p)
     ,.extra_io_rows_p  ( extra_io_rows_p   )
     ,.repeater_output_p( repeater_output_p )
    ) UUT
      (  .clk_i   (manycore_clk_i     )
    //We only sent the synchronized but not registered reset into manycore.
    //As the manycore will distribute across large area, it will take long
    //time for the reset signal to propgate.
    //Each tile should register the reset inside itself
        ,.reset_i (MC_reset_n     )

        ,.hor_link_sif_i(MC_hor_link_li)
        ,.hor_link_sif_o(MC_hor_link_lo)

        ,.ver_link_sif_i(MC_ver_link_li)
        ,.ver_link_sif_o(MC_ver_link_lo)

        );

   /////////////////////////////////////////////////////////////////////////////////
   // tie off West and North side; which is inaccessible
   genvar                   i;
   for (i = 0; i < num_tiles_y_p; i=i+1)
     begin: rof2
        bsg_manycore_link_sif_tieoff #(.addr_width_p   (addr_width_p  )
                                       ,.data_width_p  (data_width_p  )
                                       ,.x_cord_width_p(x_cord_width_lp)
                                       ,.y_cord_width_p(y_cord_width_lp)
                                       ) bmlst
        (.clk_i(manycore_clk_i)
         ,.reset_i(MC_reset_r)
         ,.link_sif_i(MC_hor_link_lo[W][i])
         ,.link_sif_o(MC_hor_link_li[W][i])
         );

        bsg_manycore_link_sif_tieoff #(.addr_width_p   (addr_width_p  )
                                       ,.data_width_p  (data_width_p  )
                                       ,.x_cord_width_p(x_cord_width_lp)
                                       ,.y_cord_width_p(y_cord_width_lp)
                                       ) bmlst2
        (.clk_i(manycore_clk_i)
         ,.reset_i(MC_reset_r)
         ,.link_sif_i(MC_hor_link_lo[E][i])
         ,.link_sif_o(MC_hor_link_li[E][i])
         );
     end


   // tie off north side; which is inaccessible
   for (i = 0; i < num_tiles_x_p; i=i+1)
     begin: rof
        bsg_manycore_link_sif_tieoff #(.addr_width_p   (addr_width_p)
                                       ,.data_width_p  (data_width_p)
                                       ,.x_cord_width_p(x_cord_width_lp)
                                       ,.y_cord_width_p(y_cord_width_lp)
                                       ) bmlst3
        (.clk_i(manycore_clk_i)
         ,.reset_i(MC_reset_r)
         ,.link_sif_i(MC_ver_link_lo[N][i])
         ,.link_sif_o(MC_ver_link_li[N][i])
         );
     end
   /////////////////////////////////////////////////////////////////////////////////
   // Instantiate the RoCC & out_fifo  interface
   wire [out_fifo_num_p-1:0] [bsg_manycore_link_sif_width_lp-1:0] out_fifo_link_sif_li ;
   wire [out_fifo_num_p-1:0] [bsg_manycore_link_sif_width_lp-1:0] out_fifo_link_sif_lo ;
   wire [out_fifo_num_p-1:0] [x_cord_width_lp-1:0]                out_fifo_x_cord      ;
   wire [out_fifo_num_p-1:0] [y_cord_width_lp-1:0]                out_fifo_y_cord      ;

   localparam  rocc_index_limit_lp =  num_tiles_x_p ;
   genvar io_ind;
   for( io_ind=0; io_ind < rocc_index_limit_lp; io_ind ++) begin: rocc_out_fifo_inst
        if( `GET_HEX(rocc_dist_vec_p, io_ind)  != 0 ) begin: rocc_inst_real

            bsg_manycore_link_sif_s  RC_rocc_link_input, RC_rocc_link_output;
            bsg_manycore_link_sif_async_buffer
           #(  .addr_width_p  (addr_width_p)
              ,.data_width_p  (data_width_p)
              ,.x_cord_width_p(x_cord_width_lp)
              ,.y_cord_width_p(y_cord_width_lp)
              ,.fifo_els_p    (async_fifo_els_p)
            )manycore_rocc_async_buffer(
            .L_clk_i     ( manycore_clk_i  )
           ,.L_reset_i   ( MC_reset_r  )
           ,.L_link_sif_i( MC_ver_link_lo[S][ io_ind ])
           ,.L_link_sif_o( MC_ver_link_li[S][ io_ind ])

           ,.R_clk_i     (   clk_i                                                      )
           ,.R_reset_i   (   reset_i [`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ]        )
           ,.R_link_sif_i(   RC_rocc_link_output )
           ,.R_link_sif_o(   RC_rocc_link_input  )
           );

            bsg_manycore_link_to_rocc
            #(  .addr_width_p  (addr_width_p    )
              , .data_width_p  (data_width_p    )
              , .x_cord_width_p(x_cord_width_lp  )
              , .y_cord_width_p(y_cord_width_lp  )
              ) rocc (
                 .my_x_i( x_cord_width_lp'(io_ind )       )
                ,.my_y_i( y_cord_width_lp'(num_tiles_y_p) )

                ,.link_sif_i ( RC_rocc_link_input  )
                ,.link_sif_o ( RC_rocc_link_output )

                ,.rocket_clk_i  ( clk_i                                                 )
                ,.rocket_reset_i( reset_i   [`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ] )

                ,.core_status_i        (core_status_i    [`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ] )
                ,.core_exception_i     (core_exception_i [`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ] )
                ,.acc_interrupt_o      (acc_interrupt_o  [`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ] )
                ,.acc_busy_o           (acc_busy_o       [`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ] )

                ,.core_cmd_valid_i     (core_cmd_valid_i [`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ] )
                ,.core_cmd_s_i         (core_cmd_s_i     [`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ] )
                ,.core_cmd_ready_o     (core_cmd_ready_o [`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ] )

                ,.core_resp_valid_o    (core_resp_valid_o[`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ] )
                ,.core_resp_s_o        (core_resp_s_o    [`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ] )
                ,.core_resp_ready_i    (core_resp_ready_i[`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ] )

                ,.mem_req_valid_o      (mem_req_valid_o  [`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ] )
                ,.mem_req_s_o          (mem_req_s_o      [`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ] )
                ,.mem_req_ready_i      (mem_req_ready_i  [`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ] )

                ,.mem_resp_valid_i     (mem_resp_valid_i [`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ] )
                ,.mem_resp_s_i         (mem_resp_s_i     [`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ] )

                ,.reset_manycore_r_o   (RC_rocc_output_reset[`GET_HEX_MIN_1(rocc_dist_vec_p, io_ind) ] )
            );
        //----------------------------------------------------
        //Check if we need to instantiate out_fifo interface
        end else if( `GET_HEX(out_fifo_dist_vec_p, io_ind)  != 0 ) begin: out_fifo_inst_real

            bsg_manycore_link_sif_async_buffer
           #(  .addr_width_p  (addr_width_p)
              ,.data_width_p  (data_width_p)
              ,.x_cord_width_p(x_cord_width_lp)
              ,.y_cord_width_p(y_cord_width_lp)
              ,.fifo_els_p    (async_fifo_els_p)
            )manycore_out_fifo_async_buffer(
            .L_clk_i     ( manycore_clk_i  )
           ,.L_reset_i   ( MC_reset_r  )
           ,.L_link_sif_i( MC_ver_link_lo[S][ io_ind ])
           ,.L_link_sif_o( MC_ver_link_li[S][ io_ind ])

           ,.R_clk_i     ( clk_i        )
           //This FIFO will be reseted as Manycore is reseted.
           ,.R_reset_i   ( RC_reset_n   )
           ,.R_link_sif_i( out_fifo_link_sif_lo [ `GET_HEX_MIN_1(out_fifo_dist_vec_p, io_ind) ] )
           ,.R_link_sif_o( out_fifo_link_sif_li [ `GET_HEX_MIN_1(out_fifo_dist_vec_p, io_ind) ] )
           );

           assign out_fifo_x_cord [ `GET_HEX_MIN_1(out_fifo_dist_vec_p, io_ind) ] =  x_cord_width_lp'(io_ind ); 
           assign out_fifo_y_cord [ `GET_HEX_MIN_1(out_fifo_dist_vec_p, io_ind) ] =  y_cord_width_lp'(num_tiles_y_p); 
        //----------------------------------------------------
        //otherwise tieoff
        end else begin: rocc_inst_tieoff
            bsg_manycore_link_sif_tieoff #(.addr_width_p   (addr_width_p)
                                           ,.data_width_p  (data_width_p)
                                           ,.x_cord_width_p(x_cord_width_lp)
                                           ,.y_cord_width_p(y_cord_width_lp)
                                           ) bmlst4
            ( .clk_i(manycore_clk_i)
             ,.reset_i(MC_reset_r)
             ,.link_sif_i(MC_ver_link_lo[S][ io_ind ])
             ,.link_sif_o(MC_ver_link_li[S][ io_ind ])
             );
       end:rocc_inst_tieoff
   end:rocc_out_fifo_inst
   /////////////////////////////////////////////////////////////////////////////////
   // instantiate the link_to_fifo
    bsg_manycore_link_to_fifo #(  
     .addr_width_p   ( addr_width_p     )
    ,.data_width_p   ( data_width_p     )
    ,.x_cord_width_p ( x_cord_width_lp  )
    ,.y_cord_width_p ( y_cord_width_lp  )

    //The output fifo width must be multiple times of data_width_p
    , .out_fifo_width_scale_p  ( out_fifo_width_scale_p )
    //multiple channel are merged to increase the output bandwidth 
    , .in_channel_scale_p      ( out_fifo_in_channel_num_lp )
    )link_to_fifo_inst
  (
    //this will work under rocket clock domain
     .clk_i     ( clk_i         )
    //This FIFO will be reseted as Manycore is reseted.
   , .reset_i   ( RC_reset_n    )

   , .my_x_i    ( out_fifo_x_cord)
   , .my_y_i    ( out_fifo_y_cord)

   //input from the manycore, in the same clock domain with the FIFO
   , .link_sif_i( out_fifo_link_sif_li )
   , .link_sif_o( out_fifo_link_sif_lo )

   //FIFO output 
   , .v_o     ( v_o     ) 
   , .data_o  ( data_o  )
   , .ready_i ( ready_i )
   );

   /////////////////////////////////////////////////////////////////////////////////
   // parameter check
   // synopsys translate_off
   int rocc_index = 0;
   int k=0;
   initial begin
        assert( rocc_num_p <= num_tiles_x_p     )
        else $error(" rocc_num_p must less or equal num_tiles_x_p");

        //validate the rocc_dis_vec_p
        for( k = 0; k< num_tiles_x_p; k++) begin
            if( `GET_HEX(rocc_dist_vec_p, k)  != 4'h0 ) begin
                rocc_index++;
                assert( rocc_index == `GET_HEX(rocc_dist_vec_p,k) )
                else begin
                     $error(" the rocc index must inrease one by one ");
                     $finish();
                end
            end
        end
        //if( rocc_num_p != 0 ) begin
        //     assert ( rocc_num_p == rocc_index )
        //     else begin
        //        $display(" rocc_dist_vec_p = %h ", rocc_dist_vec_p );
        //        $error("the rocc_num_p(%d) must match the maximum rocc index(%d)", rocc_num_p, rocc_index);
        //        $finish();
        //     end
        //end
   end
   // synopsys translate_on
endmodule
