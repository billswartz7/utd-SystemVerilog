module bsg_chip_guts

  import bsg_fsb_pkg::*;
  import bsg_rocket_pkg::*;
  import bsg_chip_pkg::*  ;
  import bsg_manycore_pkg::*  ;
  import bsg_dcdc_manycore_pkg::*  ;

 #(parameter nodes_p = bsg_chip_pkg::fsb_nodes_gp
  ,parameter num_channels_p = 4
  ,parameter channel_width_p = 8
  ,parameter enabled_at_start_vec_p = { bsg_chip_pkg::fsb_nodes_gp{1'b0} }
  ,parameter master_p = 0
  ,parameter master_to_client_speedup_p = 100
  ,parameter master_bypass_test_p = 5'b00000)

  (input                        core_clk_i
  ,input                        io_master_clk_i
  ,input                        manycore_clk_i
  ,input                        async_reset_i

  // input from i/o
  ,input   [num_channels_p-1:0] io_clk_tline_i
  ,input   [num_channels_p-1:0] io_valid_tline_i
  ,input  [channel_width_p-1:0] io_data_tline_i [num_channels_p-1:0]
  ,output  [num_channels_p-1:0] io_token_clk_tline_o

  // out to i/o
  ,output  [num_channels_p-1:0] im_clk_tline_o
  ,output  [num_channels_p-1:0] im_valid_tline_o
  ,output [channel_width_p-1:0] im_data_tline_o [num_channels_p-1:0]
  ,input   [num_channels_p-1:0] token_clk_tline_i

  // note: generate by the master (FPGA) and sent to the slave (ASIC)
  // not used by slave (ASIC).
  ,output reg                   im_slave_reset_tline_r_o

  // this signal is the post-calibration reset signal
  // synchronous to the core clock
  ,output                       core_reset_o);

  localparam ring_bytes_lp = 10;
  localparam ring_width_lp = ring_bytes_lp*channel_width_p;

  //  out of rocket nodes (rocc cmd)
  wire [bsg_chip_pkg::rocc_num_gp-1:0] core_rocc_cmd_v;
  bsg_rocc_cmd_pkt core_rocc_cmd_data [bsg_chip_pkg::rocc_num_gp-1:0];
  wire [bsg_chip_pkg::rocc_num_gp-1:0] core_rocc_cmd_ready;

  // into rocket nodes (rocc resp)
  wire [bsg_chip_pkg::rocc_num_gp-1:0] core_rocc_resp_v;
  bsg_rocc_resp_pkt core_rocc_resp_data [bsg_chip_pkg::rocc_num_gp-1:0];
  wire [bsg_chip_pkg::rocc_num_gp-1:0] core_rocc_resp_ready;

  // into rocket nodes (rocc mem req)
  wire [bsg_chip_pkg::rocc_num_gp-1:0] core_rocc_mem_req_v;
  bsg_rocc_mem_req_pkt core_rocc_mem_req_data [bsg_chip_pkg::rocc_num_gp-1:0];
  wire [bsg_chip_pkg::rocc_num_gp-1:0] core_rocc_mem_req_ready;

  // out of rocket nodes (rocc mem resp)
  wire [bsg_chip_pkg::rocc_num_gp-1:0] core_rocc_mem_resp_v;
  bsg_rocc_mem_resp_pkt core_rocc_mem_resp_data [bsg_chip_pkg::rocc_num_gp-1:0];

  // into rocket nodes (rocc ctrl)
  bsg_rocc_ctrl_in_pkt core_rocc_ctrl_in [bsg_chip_pkg::rocc_num_gp-1:0];

  // out of rocket nodes (rocc ctrl)
  bsg_rocc_ctrl_out_pkt core_rocc_ctrl_out [bsg_chip_pkg::rocc_num_gp-1:0];

  // into rocket nodes (fsb data)
  wire [nodes_p-1:0]       core_node_v_A;
  wire [ring_width_lp-1:0] core_node_data_A [nodes_p-1:0];
  wire [nodes_p-1:0]       core_node_ready_A;

  // into rocket nodes (fsb control)
  wire [nodes_p-1:0]       core_node_en_r_lo;
  wire [nodes_p-1:0]       core_node_reset_r_lo;

  // out of rocket nodes (fsb data)
  wire [nodes_p-1:0]       core_node_v_B;
  wire [ring_width_lp-1:0] core_node_data_B [nodes_p-1:0];
  wire [nodes_p-1:0]       core_node_yumi_B;

  // rocket node client(s)
  // we put a loop here to have consistent naming
  // with other bsg guts modules
  genvar                  i;

  //  _____            _        _      _____                    
  // |  __ \          | |      | |    / ____|                   
  // | |__) |___   ___| | _____| |_  | |     ___  _ __ ___  ___ 
  // |  _  // _ \ / __| |/ / _ \ __| | |    / _ \| '__/ _ \/ __|
  // | | \ \ (_) | (__|   <  __/ |_  | |___| (_) | | |  __/\__ \
  // |_|  \_\___/ \___|_|\_\___|\__|  \_____\___/|_|  \___||___/

  for (i = 0; i < bsg_chip_pkg::num_rockets_gp; i=i+1)
    begin: n

       // MBT: rewrite dest_id_p to fix "single hardened block" bug
       bsg_fsb_pkt_client_s fsb_node_data_out;
       bsg_fsb_pkt_client_s fsb_node_data_out_fix;

       // replace dest_id_p of outgoing packets
       always_comb
	 begin
	    fsb_node_data_out_fix = fsb_node_data_out;
	    fsb_node_data_out_fix.destid = (4) ' (i);
	 end

       assign core_node_data_B[i] = fsb_node_data_out_fix;

       bsg_rocket_node_client_rocc #
         (.dest_id_p(i))
       clnt
         (.clk_i(core_clk_i)

         // ctrl
         ,.reset_i(core_node_reset_r_lo[i])
         ,.en_i(core_node_en_r_lo[i])
         // rocc cmd out
         ,.rocc_cmd_v_o(core_rocc_cmd_v[i])
         ,.rocc_cmd_data_o(core_rocc_cmd_data[i])
         ,.rocc_cmd_ready_i(core_rocc_cmd_ready[i])
         // rocc resp in
         ,.rocc_resp_v_i(core_rocc_resp_v[i])
         ,.rocc_resp_data_i(core_rocc_resp_data[i])
         ,.rocc_resp_ready_o(core_rocc_resp_ready[i])
         // rocc mem req in
         ,.rocc_mem_req_v_i(core_rocc_mem_req_v[i])
         ,.rocc_mem_req_data_i(core_rocc_mem_req_data[i])
         ,.rocc_mem_req_ready_o(core_rocc_mem_req_ready[i])
         // rocc mem resp out
         ,.rocc_mem_resp_v_o(core_rocc_mem_resp_v[i])
         ,.rocc_mem_resp_data_o(core_rocc_mem_resp_data[i])
         // rocc ctrl in
         ,.rocc_ctrl_i(core_rocc_ctrl_in[i])
         // rocc ctrl out
         ,.rocc_ctrl_o(core_rocc_ctrl_out[i])
         // fsb in
         ,.fsb_node_v_i(core_node_v_A[i])
         ,.fsb_node_data_i(core_node_data_A[i])
         ,.fsb_node_ready_o(core_node_ready_A[i])
         // fsb out
         ,.fsb_node_v_o(core_node_v_B[i])
//         ,.fsb_node_data_o(core_node_data_B[i])
	  ,.fsb_node_data_o(fsb_node_data_out)
         ,.fsb_node_yumi_i(core_node_yumi_B[i]));
    end

  //  _____            _        _    __   __        _                                 
  // |  __ \          | |      | |   \ \ / /       | |     /\                         
  // | |__) |___   ___| | _____| |_   \ V / ___ ___| |    /  \   _ __ _ __ __ _ _   _ 
  // |  _  // _ \ / __| |/ / _ \ __|   > < / __/ _ \ |   / /\ \ | '__| '__/ _` | | | |
  // | | \ \ (_) | (__|   <  __/ |_   / . \ (_|  __/ |  / ____ \| |  | | | (_| | |_| |
  // |_|  \_\___/ \___|_|\_\___|\__| /_/ \_\___\___|_| /_/    \_\_|  |_|  \__,_|\__, |
  //                                                                             __/ |
  //                                                                            |___/ 

  bsg_rocket_accelerator_array #
    (.nodes_p(num_rockets_gp))
  acc
    (.clk_i(core_clk_i)
    ,.manycore_clk_i(manycore_clk_i)
    // ctrl
    ,.reset_i(core_node_reset_r_lo[num_rockets_gp-1:0])
    ,.en_i(core_node_en_r_lo[num_rockets_gp-1:0])
    // rocc cmd in
    ,.rocc_cmd_v_i(core_rocc_cmd_v)
    ,.rocc_cmd_data_i(core_rocc_cmd_data)
    ,.rocc_cmd_ready_o(core_rocc_cmd_ready)
    // rocc resp out
    ,.rocc_resp_v_o(core_rocc_resp_v)
    ,.rocc_resp_data_o(core_rocc_resp_data)
    ,.rocc_resp_ready_i(core_rocc_resp_ready)
    // rocc mem req out
    ,.rocc_mem_req_v_o(core_rocc_mem_req_v)
    ,.rocc_mem_req_data_o(core_rocc_mem_req_data)
    ,.rocc_mem_req_ready_i(core_rocc_mem_req_ready)
    // rocc mem resp in
    ,.rocc_mem_resp_v_i(core_rocc_mem_resp_v)
    ,.rocc_mem_resp_data_i(core_rocc_mem_resp_data)
    // rocc ctrl out
    ,.rocc_ctrl_o(core_rocc_ctrl_in)
    // rocc ctrl in
    ,.rocc_ctrl_i(core_rocc_ctrl_out)

);

  //  _                    _    _____ _     _  __ _            
  // | |                  | |  / ____| |   (_)/ _| |           
  // | |     _____   _____| | | (___ | |__  _| |_| |_ ___ _ __ 
  // | |    / _ \ \ / / _ \ |  \___ \| '_ \| |  _| __/ _ \ '__|
  // | |___|  __/\ V /  __/ |  ____) | | | | | | | ||  __/ |   
  // |______\___| \_/ \___|_| |_____/|_| |_|_|_|  \__\___|_|   

  logic                     lvl_shift_clk;
  logic                     lvl_shift_reset;
  logic                     lvl_shift_core_node_v_A;
  logic [ring_width_lp-1:0] lvl_shift_core_node_data_A;
  logic                     lvl_shift_core_node_ready_A;
  logic                     lvl_shift_core_node_v_B;
  logic [ring_width_lp-1:0] lvl_shift_core_node_data_B;
  logic                     lvl_shift_core_node_yumi_B;

  bsg_fsb_node_level_shift_fsb_domain #
    (.ring_width_p(ring_width_lp))
  fsb_node_level_shift_inst
    (.en_ls_i(core_node_en_r_lo[bsg_chip_pkg::fsb_idx_dcdc_manycore_gp])

    ,.clk_i(core_clk_i)
    ,.reset_i(core_node_reset_r_lo[bsg_chip_pkg::fsb_idx_dcdc_manycore_gp])
    
    ,.clk_o(lvl_shift_clk)
    ,.reset_o(lvl_shift_reset)

    //----- ATTACHED TO FSB -----//
    ,.fsb_v_i_o(core_node_v_B[bsg_chip_pkg::fsb_idx_dcdc_manycore_gp])
    ,.fsb_data_i_o(core_node_data_B[bsg_chip_pkg::fsb_idx_dcdc_manycore_gp])
    ,.fsb_yumi_o_i(core_node_yumi_B[bsg_chip_pkg::fsb_idx_dcdc_manycore_gp])

    ,.fsb_v_o_i(core_node_v_A[bsg_chip_pkg::fsb_idx_dcdc_manycore_gp])
    ,.fsb_data_o_i(core_node_data_A[bsg_chip_pkg::fsb_idx_dcdc_manycore_gp])
    ,.fsb_ready_i_o(core_node_ready_A[bsg_chip_pkg::fsb_idx_dcdc_manycore_gp])

    //----- ATTACHED TO NODE -----//
    ,.node_v_i_o(lvl_shift_core_node_v_A)
    ,.node_data_i_o(lvl_shift_core_node_data_A)
    ,.node_ready_o_i(lvl_shift_core_node_ready_A)

    ,.node_v_o_i(lvl_shift_core_node_v_B)
    ,.node_data_o_i(lvl_shift_core_node_data_B)
    ,.node_yumi_i_o(lvl_shift_core_node_yumi_B));

  //  _____   _____     _______   _____   _____                               _   ____  _            _    
  // |  __ \ / ____|   / /  __ \ / ____| |  __ \                             | | |  _ \| |          | |   
  // | |  | | |       / /| |  | | |      | |__) |____      _____ _ __ ___  __| | | |_) | | ___   ___| | __
  // | |  | | |      / / | |  | | |      |  ___/ _ \ \ /\ / / _ \ '__/ _ \/ _` | |  _ <| |/ _ \ / __| |/ /
  // | |__| | |____ / /  | |__| | |____  | |  | (_) \ V  V /  __/ | |  __/ (_| | | |_) | | (_) | (__|   < 
  // |_____/ \_____/_/   |_____/ \_____| |_|   \___/ \_/\_/ \___|_|  \___|\__,_| |____/|_|\___/ \___|_|\_\
                                                                                                      
  bsg_dcdc_block #
    (.ring_width_p(ring_width_lp))
  dcdc_block
    (.clk_i(lvl_shift_clk)
    ,.reset_i(lvl_shift_reset)

    ,.v_i(lvl_shift_core_node_v_A)
    ,.data_i(lvl_shift_core_node_data_A)
    ,.ready_o(lvl_shift_core_node_ready_A)

    ,.v_o(lvl_shift_core_node_v_B)
    ,.data_o(lvl_shift_core_node_data_B)
    ,.yumi_i(lvl_shift_core_node_yumi_B));

  //  ______               _      _____ _     _        ____            
  // |  ____|             | |    / ____(_)   | |      |  _ \           
  // | |__ _ __ ___  _ __ | |_  | (___  _  __| | ___  | |_) |_   _ ___ 
  // |  __| '__/ _ \| '_ \| __|  \___ \| |/ _` |/ _ \ |  _ <| | | / __|
  // | |  | | | (_) | | | | |_   ____) | | (_| |  __/ | |_) | |_| \__ \
  // |_|  |_|  \___/|_| |_|\__| |_____/|_|\__,_|\___| |____/ \__,_|___/

  // fsb reset
  wire                     core_calib_done_r_lo;

  // fsb in
  wire                     core_cl_valid_lo;
  wire [ring_width_lp-1:0] core_cl_data_lo;
  wire                     core_fsb_yumi_lo;

  // fsb out
  wire                     core_fsb_valid_lo;
  wire [ring_width_lp-1:0] core_fsb_data_lo;
  wire                     core_cl_ready_lo;

  bsg_fsb #
    (.width_p(ring_width_lp)
    ,.nodes_p(6)
    ,.snoop_vec_p( { nodes_p { 1'b0 } })
    ,.enabled_at_start_vec_p(enabled_at_start_vec_p))
  fsb
    (.clk_i(core_clk_i)
    ,.reset_i(~core_calib_done_r_lo)

    // -------- fsb node --------

    // node ctrl
    ,.node_reset_r_o(core_node_reset_r_lo)
    ,.node_en_r_o(core_node_en_r_lo)

    // node in
    ,.node_v_i(core_node_v_B)
    ,.node_data_i(core_node_data_B)
    ,.node_yumi_o(core_node_yumi_B)

    // node out
    ,.node_v_o(core_node_v_A)
    ,.node_data_o(core_node_data_A)
    ,.node_ready_i(core_node_ready_A)

    // -------- bsg comm link --------

    // asm in
    ,.asm_v_i(core_cl_valid_lo)
    ,.asm_data_i(core_cl_data_lo)
    ,.asm_yumi_o(core_fsb_yumi_lo)

    // asm out
    ,.asm_v_o(core_fsb_valid_lo)
    ,.asm_data_o(core_fsb_data_lo)
    ,.asm_ready_i(core_cl_ready_lo));

  //   _____                            _      _       _    
  //  / ____|                          | |    (_)     | |   
  // | |     ___  _ __ ___  _ __ ___   | |     _ _ __ | | __
  // | |    / _ \| '_ ` _ \| '_ ` _ \  | |    | | '_ \| |/ /
  // | |___| (_) | | | | | | | | | | | | |____| | | | |   < 
  //  \_____\___/|_| |_| |_|_| |_| |_| |______|_|_| |_|_|\_\

  bsg_comm_link #
    (.channel_width_p(channel_width_p)
    ,.core_channels_p(ring_bytes_lp)
    ,.link_channels_p(num_channels_p)
    ,.master_p(master_p)
    ,.master_to_slave_speedup_p(master_to_client_speedup_p)
    ,.master_bypass_test_p(master_bypass_test_p))
  comm_link
    (.core_clk_i(core_clk_i)
    ,.io_master_clk_i(io_master_clk_i)

    // reset
    ,.async_reset_i(async_reset_i)

    // core ctrl
    ,.core_calib_done_r_o(core_calib_done_r_lo)

    // core in
    ,.core_valid_i(core_fsb_valid_lo)
    ,.core_data_i(core_fsb_data_lo)
    ,.core_ready_o(core_cl_ready_lo)

    // core out
    ,.core_valid_o(core_cl_valid_lo)
    ,.core_data_o(core_cl_data_lo)
    ,.core_yumi_i(core_fsb_yumi_lo)

    // in from i/o
    ,.io_valid_tline_i(io_valid_tline_i)
    ,.io_data_tline_i(io_data_tline_i)
    ,.io_clk_tline_i(io_clk_tline_i)              // clk
    ,.io_token_clk_tline_o(io_token_clk_tline_o)  // clk

    // out to i/o
    ,.im_valid_tline_o(im_valid_tline_o)
    ,.im_data_tline_o(im_data_tline_o)
    ,.im_clk_tline_o(im_clk_tline_o)       // clk
    ,.token_clk_tline_i(token_clk_tline_i) // clk

    ,.im_slave_reset_tline_r_o(im_slave_reset_tline_r_o));

  assign core_reset_o = ~core_calib_done_r_lo;

endmodule
