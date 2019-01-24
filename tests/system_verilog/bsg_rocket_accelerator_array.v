`include "bsg_rocket_pkg.vh"
`include "bsg_rocc.v"

module bsg_rocket_accelerator_array
  import bsg_rocket_pkg::*;
# (parameter nodes_p = 0
  ,parameter out_fifo_width_lp = bsg_manycore_pkg::data_width_gp
                               * bsg_manycore_pkg::out_fifo_width_scale_gp
  )
  (input                       clk_i
  ,input                       manycore_clk_i
  ,input         [nodes_p-1:0] reset_i
  ,input         [nodes_p-1:0] en_i
  // rocc cmd in
  ,input         [nodes_p-1:0] rocc_cmd_v_i
  ,input      bsg_rocc_cmd_pkt rocc_cmd_data_i [nodes_p-1:0]
  ,output        [nodes_p-1:0] rocc_cmd_ready_o // rocc resp out
  ,output        [nodes_p-1:0] rocc_resp_v_o
  ,output    bsg_rocc_resp_pkt rocc_resp_data_o [nodes_p-1:0]
  ,input         [nodes_p-1:0] rocc_resp_ready_i
  // rocc mem req out
  ,output        [nodes_p-1:0] rocc_mem_req_v_o
  ,output bsg_rocc_mem_req_pkt rocc_mem_req_data_o [nodes_p-1:0]
  ,input         [nodes_p-1:0] rocc_mem_req_ready_i
  // rocc mem resp in
  ,input         [nodes_p-1:0] rocc_mem_resp_v_i
  ,input bsg_rocc_mem_resp_pkt rocc_mem_resp_data_i [nodes_p-1:0]
  // rocc ctrl out
  ,output  bsg_rocc_ctrl_in_pkt rocc_ctrl_o [nodes_p-1:0]
  // rocc ctrl in
  ,input  bsg_rocc_ctrl_out_pkt rocc_ctrl_i [nodes_p-1:0]

);

  wire  [out_fifo_width_lp-1:0] out_fifo_data  ;
  wire  [0 :0]                  out_fifo_ready ;
  wire  [0 :0]                  out_fifo_v     ;

  /////////////////////////////////////////////////////////////////
  //
  // Instantiate the manycore
  //
  // The manycore will be connected to the first n-1 rocc buses.
  //
  localparam min_manycore_rocc_idx_lp = bsg_chip_pkg::fsb_idx_rocket_manycore_start_gp;
  localparam max_manycore_rocc_idx_lp = bsg_chip_pkg::fsb_idx_rocket_manycore_end_gp;

  localparam debug_lp           = 0;

  localparam rocc_num_lp            = bsg_chip_pkg::rocc_num_gp;
  localparam rocc_dist_vec_lp       = bsg_manycore_pkg::rocc_dist_vec_gp;

  localparam out_fifo_num_lp        = bsg_manycore_pkg::out_fifo_num_gp;
  localparam out_fifo_dist_vec_lp   = bsg_manycore_pkg::out_fifo_dist_vec_gp;
  localparam out_fifo_width_scale_lp= bsg_manycore_pkg::out_fifo_width_scale_gp;

  rocc_core_cmd_s  [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] core_cmd_s;
  rocc_core_resp_s [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] core_resp_s;
  rocc_mem_req_s   [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] mem_req_s;
  rocc_mem_resp_s  [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] mem_resp_s;

  wire [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] rocc_ctrl_i_s;
  wire [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] rocc_ctrl_i_exception;
  wire [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] rocc_ctrl_o_interrupt;
  wire [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] rocc_ctrl_o_busy;

  genvar i;

  for(i = min_manycore_rocc_idx_lp; i <= max_manycore_rocc_idx_lp; i++) begin: rocc_assign
        assign  core_cmd_s[i].instr.funct7     = rocc_cmd_data_i [ i ].inst_funct  ;
        assign  core_cmd_s[i].instr.rs2        = rocc_cmd_data_i [ i ].inst_rs2    ;
        assign  core_cmd_s[i].instr.rs1        = rocc_cmd_data_i [ i ].inst_rs1    ;
        assign  core_cmd_s[i].instr.xd         = rocc_cmd_data_i [ i ].inst_xd     ;
        assign  core_cmd_s[i].instr.xs1        = rocc_cmd_data_i [ i ].inst_xs1    ;
        assign  core_cmd_s[i].instr.xs2        = rocc_cmd_data_i [ i ].inst_xs2    ;
        assign  core_cmd_s[i].instr.rd         = rocc_cmd_data_i [ i ].inst_rd     ;
        assign  core_cmd_s[i].instr.op         = rocc_cmd_data_i [ i ].inst_opcode ;
        assign  core_cmd_s[i].rs1_val          = rocc_cmd_data_i [ i ].rs1         ;
        assign  core_cmd_s[i].rs2_val          = rocc_cmd_data_i [ i ].rs2         ;
        assign  core_cmd_s[i].core_host_id     = rocc_ctrl_i     [ i ].host_id     ;

        assign  rocc_resp_data_o [ i ].rd   =core_resp_s[ i ].rd         ;
        assign  rocc_resp_data_o [ i ].data =core_resp_s[ i ].rd_data    ;

        assign  rocc_mem_req_data_o [ i ].addr       =mem_req_s[ i ].req_addr;
        assign  rocc_mem_req_data_o [ i ].tag        =mem_req_s[ i ].req_tag;
        assign  rocc_mem_req_data_o [ i ].cmd        =mem_req_s[ i ].req_cmd;
        assign  rocc_mem_req_data_o [ i ].typ        =mem_req_s[ i ].req_typ;
        assign  rocc_mem_req_data_o [ i ].phys       =mem_req_s[ i ].req_phys;
        assign  rocc_mem_req_data_o [ i ].data       =mem_req_s[ i ].req_data;

        assign  mem_resp_s[ i ].resp_addr             =rocc_mem_resp_data_i [ i ].addr    ;
        assign  mem_resp_s[ i ].resp_tag              =rocc_mem_resp_data_i [ i ].tag     ;
        assign  mem_resp_s[ i ].resp_cmd              =eRoCC_mem_cmd'( rocc_mem_resp_data_i [ i ].cmd);
        assign  mem_resp_s[ i ].resp_typ              =eRoCC_mem_typ'( rocc_mem_resp_data_i [ i ].typ);
        assign  mem_resp_s[ i ].resp_data             =rocc_mem_resp_data_i [ i ].data      ;
        assign  mem_resp_s[ i ].resp_nack             =rocc_mem_resp_data_i [ i ].nack      ;
        assign  mem_resp_s[ i ].resp_replay           =rocc_mem_resp_data_i [ i ].replay    ;
        assign  mem_resp_s[ i ].resp_has_data         =rocc_mem_resp_data_i [ i ].has_data  ;
        assign  mem_resp_s[ i ].resp_data_word_bypass =rocc_mem_resp_data_i [ i ].data_word_bypass    ;
        assign  mem_resp_s[ i ].resp_store_data       =rocc_mem_resp_data_i [ i ].store_data          ;


        assign rocc_ctrl_i_s[i]         = rocc_ctrl_i[i].s          ;
        assign rocc_ctrl_i_exception[i] = rocc_ctrl_i[i].exception  ;
        assign rocc_ctrl_o[i].interrupt = rocc_ctrl_o_interrupt[i]  ;
        assign rocc_ctrl_o[i].busy      = rocc_ctrl_o_busy[i]       ;
  end

  bsg_manycore_rocc_streambuf_wrapper #
    (.rocc_num_p(max_manycore_rocc_idx_lp - min_manycore_rocc_idx_lp + 1)
    ,.rocc_dist_vec_p(bsg_manycore_pkg::rocc_dist_vec_gp)

    ,.out_fifo_num_p         ( out_fifo_num_lp     )
    ,.out_fifo_dist_vec_p    ( out_fifo_dist_vec_lp)
    ,.out_fifo_width_scale_p ( out_fifo_width_scale_lp)

    ,.bank_size_p(bsg_manycore_pkg::bank_size_gp)
    ,.num_banks_p(bsg_manycore_pkg::num_banks_gp)
    ,.imem_size_p(bsg_manycore_pkg::imem_size_gp)
    ,.addr_width_p(bsg_manycore_pkg::addr_width_gp)
    ,.data_width_p(bsg_manycore_pkg::data_width_gp)
    ,.hetero_type_vec_p(bsg_manycore_pkg::hetero_type_vec_gp)
    ,.num_tiles_x_p(bsg_manycore_pkg::num_tiles_x_gp)
    ,.num_tiles_y_p(bsg_manycore_pkg::num_tiles_y_gp)
    ,.debug_p(1'b0)
    ,.extra_io_rows_p(1))
  manycore_rocc_inst
    (.clk_i(clk_i)
    ,.manycore_clk_i(manycore_clk_i)
    ,.reset_i(reset_i[max_manycore_rocc_idx_lp:min_manycore_rocc_idx_lp])

    //following signals are in rocket clock domain
    //core control signals
    ,.core_status_i      (  rocc_ctrl_i_s         [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] )
    ,.core_exception_i   (  rocc_ctrl_i_exception [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] )
    ,.acc_interrupt_o    (  rocc_ctrl_o_interrupt [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] )
    ,.acc_busy_o         (  rocc_ctrl_o_busy      [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] )
    //command signals
    ,.core_cmd_valid_i   (  rocc_cmd_v_i     [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] )
    ,.core_cmd_s_i       (  core_cmd_s       [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] )
    ,.core_cmd_ready_o   (  rocc_cmd_ready_o [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] )

    ,.core_resp_valid_o  (  rocc_resp_v_o     [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] )
    ,.core_resp_s_o      (  core_resp_s       [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] )
    ,.core_resp_ready_i  (  rocc_resp_ready_i [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] )
    //mem signals
    ,.mem_req_valid_o    (  rocc_mem_req_v_o     [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] )
    ,.mem_req_s_o        (  mem_req_s            [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] )
    ,.mem_req_ready_i    (  rocc_mem_req_ready_i [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] )

    ,.mem_resp_valid_i   (  rocc_mem_resp_v_i [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] )
    ,.mem_resp_s_i       (  mem_resp_s        [ max_manycore_rocc_idx_lp : min_manycore_rocc_idx_lp ] )

    ,.v_o                (  out_fifo_v                          )
    ,.data_o             (  out_fifo_data                       )
    ,.ready_i            (  out_fifo_ready                      ) 
);

  /////////////////////////////////////////////////////////////////
  //
  // Instantiate the BNN
  //
  // The BNN will be connected to the last rocc bus.
  //
  localparam bnn_rocc_idx_lp = bsg_chip_pkg::fsb_idx_rocket_bnn_gp;


  bsg_rocket_accelerator_bnn bnn_rocc_inst
    (
      .clk_i                ( clk_i                                    )
     ,.reset_i              ( reset_i              [ bnn_rocc_idx_lp ] )
     ,.en_i                 ( en_i                 [ bnn_rocc_idx_lp ] )
     ,.rocc_cmd_v_i         ( rocc_cmd_v_i         [ bnn_rocc_idx_lp ] )
     ,.rocc_cmd_data_i      ( rocc_cmd_data_i      [ bnn_rocc_idx_lp ] )
     ,.rocc_cmd_ready_o     ( rocc_cmd_ready_o     [ bnn_rocc_idx_lp ] )
     ,.rocc_resp_v_o        ( rocc_resp_v_o        [ bnn_rocc_idx_lp ] )
     ,.rocc_resp_data_o     ( rocc_resp_data_o     [ bnn_rocc_idx_lp ] )
     ,.rocc_resp_ready_i    ( rocc_resp_ready_i    [ bnn_rocc_idx_lp ] )
     ,.rocc_mem_req_v_o     ( rocc_mem_req_v_o     [ bnn_rocc_idx_lp ] )
     ,.rocc_mem_req_data_o  ( rocc_mem_req_data_o  [ bnn_rocc_idx_lp ] )
     ,.rocc_mem_req_ready_i ( rocc_mem_req_ready_i [ bnn_rocc_idx_lp ] )
     ,.rocc_mem_resp_v_i    ( rocc_mem_resp_v_i    [ bnn_rocc_idx_lp ] )
     ,.rocc_mem_resp_data_i ( rocc_mem_resp_data_i [ bnn_rocc_idx_lp ] )
     ,.rocc_ctrl_o          ( rocc_ctrl_o          [ bnn_rocc_idx_lp ] )
     ,.rocc_ctrl_i          ( rocc_ctrl_i          [ bnn_rocc_idx_lp ] )

     ,.manycore_req_msg_i   ( out_fifo_data    )
     ,.manycore_req_rdy_o   ( out_fifo_ready   )
     ,.manycore_req_val_i   ( out_fifo_v       )
    );

   ////synopsys translate_off
   //initial begin
   //  assert ( rocc_num_lp == nodes_p )
   //  else begin
   //    $error(" rocc_num must match the node number @%m");
   //  end
   //end
   ////synopsys translate_on
  //------------------------------------------------------
  //The output fifo test
  //synopsys translate_off
  if( 1 ) begin
    if(0) begin
        initial begin
            force out_fifo_ready= 1'b1;
        end
    end
    always_ff@( negedge clk_i ) begin
          if( out_fifo_v  & out_fifo_ready )  begin
              $display(  "BNN_DATA ==> %h", out_fifo_data );
             // if( out_fifo_data == out_fifo_width_lp'(64'h003f_c007_ff33_190f) ) begin
             // // if( out_fifo_data == out_fifo_width_lp'(64'hFFFF_FFFF_FFFF_FFFF) ) begin
             //   $display("         ==> Receive finish package, terminates");
             //   $finish();
             // end
          end
    end 
  end
  //synopsys translate_on

endmodule
