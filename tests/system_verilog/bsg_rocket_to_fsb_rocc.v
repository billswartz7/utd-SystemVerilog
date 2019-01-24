`include "bsg_rocket_pkg.vh"
`include "bsg_fsb_pkg.v"

module bsg_rocket_to_fsb_rocc
  import bsg_rocket_pkg::*;
  import bsg_fsb_pkg::*;
# (parameter dest_id_p      = 0
   ,use_pseudo_large_fifo_p = 0
   ,remote_credits_p        = 128 )
  (input                        clk_i
  ,input                        reset_i
  // rocc cmd out
  ,output                       rocc_cmd_v_o
  ,output      bsg_rocc_cmd_pkt rocc_cmd_data_o
  ,input                        rocc_cmd_ready_i
  // rocc resp in
  ,input                        rocc_resp_v_i
  ,input      bsg_rocc_resp_pkt rocc_resp_data_i
  ,output                       rocc_resp_ready_o
  // rocc mem req in
  ,input                        rocc_mem_req_v_i
  ,input   bsg_rocc_mem_req_pkt rocc_mem_req_data_i
  ,output                       rocc_mem_req_ready_o
  // rocc mem resp out
  ,output                       rocc_mem_resp_v_o
  ,output bsg_rocc_mem_resp_pkt rocc_mem_resp_data_o
  // rocc ctrl in
  ,input   bsg_rocc_ctrl_in_pkt rocc_ctrl_i
  // rocc ctrl out
  ,output bsg_rocc_ctrl_out_pkt rocc_ctrl_o
  // fsb in
  ,input                        fsb_node_v_i
  ,input   bsg_fsb_pkt_client_s fsb_node_data_i
  ,output                       fsb_node_yumi_o
  // fsb out
  ,output                       fsb_node_v_o
  ,output  bsg_fsb_pkt_client_s fsb_node_data_o
  ,input                        fsb_node_yumi_i);

  wire       host_in_valid;
  bsg_host_t host_in_data;
  wire       host_in_ready;

  wire       host_out_valid;
  bsg_host_t host_out_data;
  wire       host_out_ready;

  wire            nasti_aw_valid;
  bsg_nasti_a_pkt nasti_aw_data;
  wire            nasti_aw_ready;

  wire            nasti_w_valid;
  bsg_nasti_w_pkt nasti_w_data;
  wire            nasti_w_ready;

  wire            nasti_b_valid;
  bsg_nasti_b_pkt nasti_b_data;
  wire            nasti_b_ready;

  wire            nasti_ar_valid;
  bsg_nasti_a_pkt nasti_ar_data;
  wire            nasti_ar_ready;

  wire            nasti_r_valid;
  bsg_nasti_r_pkt nasti_r_data;
  wire            nasti_r_ready;

  rocket_chip rocket
    (.clk(clk_i)
    ,.reset(reset_i)

    //----------------------------------------------------------------------------
    // BEGIN host client
    //----------------------------------------------------------------------------

    // host in
    ,.io_host_in_ready(host_in_ready)
    ,.io_host_in_valid(host_in_valid)
    ,.io_host_in_bits(host_in_data)
    // host out
    ,.io_host_out_ready(host_out_ready)
    ,.io_host_out_valid(host_out_valid)
    ,.io_host_out_bits(host_out_data)

    //----------------------------------------------------------------------------
    // END host client
    //----------------------------------------------------------------------------

    //----------------------------------------------------------------------------
    // BEGIN nasti(axi) master
    //----------------------------------------------------------------------------

    // aw out
    ,.io_mem_0_aw_ready(nasti_aw_ready)
    ,.io_mem_0_aw_valid(nasti_aw_valid)
    ,.io_mem_0_aw_bits_addr(nasti_aw_data.addr)
    ,.io_mem_0_aw_bits_len(nasti_aw_data.len)
    ,.io_mem_0_aw_bits_size(nasti_aw_data.size)
    ,.io_mem_0_aw_bits_burst(nasti_aw_data.burst)
    ,.io_mem_0_aw_bits_lock(nasti_aw_data.lock)
    ,.io_mem_0_aw_bits_cache(nasti_aw_data.cache)
    ,.io_mem_0_aw_bits_prot(nasti_aw_data.prot)
    ,.io_mem_0_aw_bits_qos(nasti_aw_data.qos)
    ,.io_mem_0_aw_bits_region(nasti_aw_data.region)
    ,.io_mem_0_aw_bits_id(nasti_aw_data.id)
    // w out
    ,.io_mem_0_w_ready(nasti_w_ready)
    ,.io_mem_0_w_valid(nasti_w_valid)
    ,.io_mem_0_w_bits_data(nasti_w_data.data)
    ,.io_mem_0_w_bits_last(nasti_w_data.last)
    ,.io_mem_0_w_bits_strb(nasti_w_data.strb)
    // b in
    ,.io_mem_0_b_ready(nasti_b_ready)
    ,.io_mem_0_b_valid(nasti_b_valid)
    ,.io_mem_0_b_bits_resp(nasti_b_data.resp)
    ,.io_mem_0_b_bits_id(nasti_b_data.id)
    // ar out
    ,.io_mem_0_ar_ready(nasti_ar_ready)
    ,.io_mem_0_ar_valid(nasti_ar_valid)
    ,.io_mem_0_ar_bits_addr(nasti_ar_data.addr)
    ,.io_mem_0_ar_bits_len(nasti_ar_data.len)
    ,.io_mem_0_ar_bits_size(nasti_ar_data.size)
    ,.io_mem_0_ar_bits_burst(nasti_ar_data.burst)
    ,.io_mem_0_ar_bits_lock(nasti_ar_data.lock)
    ,.io_mem_0_ar_bits_cache(nasti_ar_data.cache)
    ,.io_mem_0_ar_bits_prot(nasti_ar_data.prot)
    ,.io_mem_0_ar_bits_qos(nasti_ar_data.qos)
    ,.io_mem_0_ar_bits_region(nasti_ar_data.region)
    ,.io_mem_0_ar_bits_id(nasti_ar_data.id)
    // r in
    ,.io_mem_0_r_ready(nasti_r_ready)
    ,.io_mem_0_r_valid(nasti_r_valid)
    ,.io_mem_0_r_bits_resp(nasti_r_data.resp)
    ,.io_mem_0_r_bits_data(nasti_r_data.data)
    ,.io_mem_0_r_bits_last(nasti_r_data.last)
    ,.io_mem_0_r_bits_id(nasti_r_data.id)

    //----------------------------------------------------------------------------
    // END nasti(axi) master
    //----------------------------------------------------------------------------

    //----------------------------------------------------------------------------
    // BEGIN rocc
    //----------------------------------------------------------------------------

    // cmd out
    ,.io_rocc_0_0_cmd_ready(rocc_cmd_ready_i)
    ,.io_rocc_0_0_cmd_valid(rocc_cmd_v_o)
    ,.io_rocc_0_0_cmd_bits_inst_funct(rocc_cmd_data_o.inst_funct)
    ,.io_rocc_0_0_cmd_bits_inst_rs2(rocc_cmd_data_o.inst_rs2)
    ,.io_rocc_0_0_cmd_bits_inst_rs1(rocc_cmd_data_o.inst_rs1)
    ,.io_rocc_0_0_cmd_bits_inst_xd(rocc_cmd_data_o.inst_xd)
    ,.io_rocc_0_0_cmd_bits_inst_xs1(rocc_cmd_data_o.inst_xs1)
    ,.io_rocc_0_0_cmd_bits_inst_xs2(rocc_cmd_data_o.inst_xs2)
    ,.io_rocc_0_0_cmd_bits_inst_rd(rocc_cmd_data_o.inst_rd)
    ,.io_rocc_0_0_cmd_bits_inst_opcode(rocc_cmd_data_o.inst_opcode)
    ,.io_rocc_0_0_cmd_bits_rs1(rocc_cmd_data_o.rs1)
    ,.io_rocc_0_0_cmd_bits_rs2(rocc_cmd_data_o.rs2)
    // resp in
    ,.io_rocc_0_0_resp_ready(rocc_resp_ready_o)
    ,.io_rocc_0_0_resp_valid(rocc_resp_v_i)
    ,.io_rocc_0_0_resp_bits_rd(rocc_resp_data_i.rd)
    ,.io_rocc_0_0_resp_bits_data(rocc_resp_data_i.data)
    // mem req in
    ,.io_rocc_0_0_mem_req_ready(rocc_mem_req_ready_o)
    ,.io_rocc_0_0_mem_req_valid(rocc_mem_req_v_i)
    ,.io_rocc_0_0_mem_req_bits_addr(rocc_mem_req_data_i.addr)
    ,.io_rocc_0_0_mem_req_bits_tag(rocc_mem_req_data_i.tag)
    ,.io_rocc_0_0_mem_req_bits_cmd(rocc_mem_req_data_i.cmd)
    ,.io_rocc_0_0_mem_req_bits_typ(rocc_mem_req_data_i.typ)
    ,.io_rocc_0_0_mem_req_bits_phys(rocc_mem_req_data_i.phys)
    ,.io_rocc_0_0_mem_req_bits_data(rocc_mem_req_data_i.data)
    // mem resp out
    ,.io_rocc_0_0_mem_resp_valid(rocc_mem_resp_v_o)
    ,.io_rocc_0_0_mem_resp_bits_addr(rocc_mem_resp_data_o.addr)
    ,.io_rocc_0_0_mem_resp_bits_tag(rocc_mem_resp_data_o.tag)
    ,.io_rocc_0_0_mem_resp_bits_cmd(rocc_mem_resp_data_o.cmd)
    ,.io_rocc_0_0_mem_resp_bits_typ(rocc_mem_resp_data_o.typ)
    ,.io_rocc_0_0_mem_resp_bits_data(rocc_mem_resp_data_o.data)
    ,.io_rocc_0_0_mem_resp_bits_nack(rocc_mem_resp_data_o.nack)
    ,.io_rocc_0_0_mem_resp_bits_replay(rocc_mem_resp_data_o.replay)
    ,.io_rocc_0_0_mem_resp_bits_has_data(rocc_mem_resp_data_o.has_data)
    ,.io_rocc_0_0_mem_resp_bits_data_word_bypass(rocc_mem_resp_data_o.data_word_bypass)
    ,.io_rocc_0_0_mem_resp_bits_store_data(rocc_mem_resp_data_o.store_data)
    // ctrl in
    ,.io_rocc_0_0_busy(rocc_ctrl_i.busy)
    ,.io_rocc_0_0_interrupt(rocc_ctrl_i.interrupt)
    // ctrl out
    ,.io_rocc_0_0_s(rocc_ctrl_o.s)
    ,.io_rocc_0_0_exception(rocc_ctrl_o.exception)
    ,.io_rocc_0_0_host_id(rocc_ctrl_o.host_id)

    //----------------------------------------------------------------------------
    // END rocc
    //----------------------------------------------------------------------------

    //----------------------------------------------------------------------------
    // BEGIN unused
    //----------------------------------------------------------------------------

    ,.io_host_debug_stats_csr()

    ,.io_mem_0_aw_bits_user()
    ,.io_mem_0_w_bits_user()
    ,.io_mem_0_b_bits_user()
    ,.io_mem_0_ar_bits_user()
    ,.io_mem_0_r_bits_user()

    ,.io_rocc_0_0_autl_acquire_ready()
    ,.io_rocc_0_0_autl_acquire_valid(1'b0)

    ,.io_rocc_0_0_autl_grant_ready(1'b0)
    ,.io_rocc_0_0_autl_grant_valid()
    ,.io_rocc_0_0_autl_grant_bits_addr_beat()
    ,.io_rocc_0_0_autl_grant_bits_client_xact_id()
    ,.io_rocc_0_0_autl_grant_bits_manager_xact_id()
    ,.io_rocc_0_0_autl_grant_bits_is_builtin_type()
    ,.io_rocc_0_0_autl_grant_bits_g_type()
    ,.io_rocc_0_0_autl_grant_bits_data()

    ,.init(1'b0));

    //----------------------------------------------------------------------------
    // END unused
    //----------------------------------------------------------------------------

  // host

  wire          htun_valid_i;
  bsg_tun_dmx_t htun_data_i;
  wire          htun_yumi_o;

  wire          htun_valid_o;
  bsg_tun_dmx_t htun_data_o;
  wire          htun_yumi_i;

  bsg_host host
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    // host in
    ,.host_valid_i(host_out_valid)
    ,.host_data_i(host_out_data)
    ,.host_ready_o(host_out_ready)
    // host out
    ,.host_valid_o(host_in_valid)
    ,.host_data_o(host_in_data)
    ,.host_ready_i(host_in_ready)
    // data in
    ,.valid_i(htun_valid_i)
    ,.data_i(htun_data_i)
    ,.yumi_o(htun_yumi_o)
    // data out
    ,.valid_o(htun_valid_o)
    ,.data_o(htun_data_o)
    ,.yumi_i(htun_yumi_i));

  // nasti client

  wire          resp_valid;
  bsg_tun_dmx_t resp_data;
  wire          resp_yumi;

  wire          req_valid;
  bsg_tun_dmx_t req_data;
  wire          req_yumi;

  bsg_nasti_client nasti_client
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    // aw in
    ,.nasti_aw_valid_i(nasti_aw_valid)
    ,.nasti_aw_data_i(nasti_aw_data)
    ,.nasti_aw_ready_o(nasti_aw_ready)
    // w in
    ,.nasti_w_valid_i(nasti_w_valid)
    ,.nasti_w_data_i(nasti_w_data)
    ,.nasti_w_ready_o(nasti_w_ready)
    // b out
    ,.nasti_b_valid_o(nasti_b_valid)
    ,.nasti_b_data_o(nasti_b_data)
    ,.nasti_b_ready_i(nasti_b_ready)
    // ar in
    ,.nasti_ar_valid_i(nasti_ar_valid)
    ,.nasti_ar_data_i(nasti_ar_data)
    ,.nasti_ar_ready_o(nasti_ar_ready)
    // r out
    ,.nasti_r_valid_o(nasti_r_valid)
    ,.nasti_r_data_o(nasti_r_data)
    ,.nasti_r_ready_i(nasti_r_ready)
    // resp in
    ,.resp_valid_i(resp_valid)
    ,.resp_data_i(resp_data)
    ,.resp_yumi_o(resp_yumi)
    // req out
    ,.req_valid_o(req_valid)
    ,.req_data_o(req_data)
    ,.req_yumi_i(req_yumi));

  // tunnel

  bsg_tun_dmx_ctrl_t  dmx_v_i;
  bsg_tun_dmx_array_t dmx_data_i;
  bsg_tun_dmx_ctrl_t  dmx_yumi_o;

  assign dmx_v_i    = {htun_valid_o, req_valid};
  assign dmx_data_i = {htun_data_o, req_data};
  assign {htun_yumi_i, req_yumi} = dmx_yumi_o;

  bsg_tun_dmx_ctrl_t  dmx_v_o;
  bsg_tun_dmx_array_t dmx_data_o;
  bsg_tun_dmx_ctrl_t  dmx_yumi_i;

  assign {htun_valid_i, resp_valid} = dmx_v_o;
  assign {htun_data_i, resp_data}   = dmx_data_o;
  assign dmx_yumi_i = {htun_yumi_o, resp_yumi};

  wire                      mux_v_i;
  bsg_fsb_pkt_client_data_t mux_data_i;
  wire                      mux_yumi_o;

  wire                      mux_v_o;
  bsg_fsb_pkt_client_data_t mux_data_o;
  wire                      mux_yumi_i;

  bsg_channel_tunnel #
    (.width_p(bsg_tun_dmx_width_p) // taken from bsg_rocket_pkg.vh
     ,.num_in_p(bsg_tun_num_in_p)   // taken from bsg_rocket_pkg.vh
     // assumption: incoming bandwidth from fsb/comm_link is 1/2
     // the outgoing bandwidth
     ,.use_pseudo_large_fifo_p(use_pseudo_large_fifo_p)
     ,.remote_credits_p(remote_credits_p)
     )
  tunnel
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    // dmux in
    ,.v_i(dmx_v_i)
    ,.data_i(dmx_data_i)
    ,.yumi_o(dmx_yumi_o)
    // dmux out
    ,.v_o(dmx_v_o)
    ,.data_o(dmx_data_o)
    ,.yumi_i(dmx_yumi_i)
    // mux in
    ,.multi_v_i(mux_v_i)
    ,.multi_data_i(mux_data_i)
    ,.multi_yumi_o(mux_yumi_o)
    // mux out
    ,.multi_v_o(mux_v_o)
    ,.multi_data_o(mux_data_o)
    ,.multi_yumi_i(mux_yumi_i));

  assign mux_v_i    = fsb_node_v_i;
  assign mux_data_i = bsg_fsb_pkt_client_data_t ' (fsb_node_data_i);
  assign fsb_node_yumi_o = mux_yumi_o;

  // Synplify (FPGA synth) does not support casting with a constant,
  // it must be a type. I create a type bsg_fsb_id_t for casting a
  // 32-bit (int) parameter dest_id_p
  typedef logic [3:0] bsg_fsb_id_t;

  assign fsb_node_v_o           = mux_v_o;
  assign fsb_node_data_o.destid = bsg_fsb_id_t ' (dest_id_p);
  assign fsb_node_data_o.cmd    = 1'b0;
  assign fsb_node_data_o.data   = mux_data_o;
  assign mux_yumi_i = fsb_node_yumi_i;

endmodule
