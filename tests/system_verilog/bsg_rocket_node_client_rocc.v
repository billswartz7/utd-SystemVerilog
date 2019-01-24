`include "bsg_rocket_pkg.vh"
`include "bsg_fsb_pkg.v"

module bsg_rocket_node_client_rocc
  import bsg_fsb_pkg::*;
  import bsg_rocket_pkg::*;
# (parameter dest_id_p = 0)
  (input                        clk_i
  ,input                        reset_i
  ,input                        en_i
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
  ,output                       fsb_node_ready_o
  // fsb out
  ,output                       fsb_node_v_o
  ,output  bsg_fsb_pkt_client_s fsb_node_data_o
  ,input                        fsb_node_yumi_i);

// Coyote is stubbed out when running synthesis on the top-level chip
`ifndef SYNTHESIS_TOPLEVEL_STUB

  wire                 fifo_v;
  bsg_fsb_pkt_client_s fifo_data;
  wire                 fifo_yumi;

  bsg_two_fifo #
    (.width_p($bits(bsg_fsb_pkt_client_s)))
  fifo_in
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    // in valid/ready
    ,.v_i(fsb_node_v_i)
    ,.data_i(fsb_node_data_i)
    ,.ready_o(fsb_node_ready_o)
    // out valid/yumi
    ,.v_o(fifo_v)
    ,.data_o(fifo_data)
    ,.yumi_i(fifo_yumi));

  bsg_rocket_to_fsb_rocc #
    (.dest_id_p(dest_id_p)
     ,.use_pseudo_large_fifo_p(1)

     // potentially this number could be lower
     // using less storage; it depends on whether
     // rocket / hostio actually exhibits streaming
     // behavior that needs to be flow controlled

     ,.remote_credits_p(128)
     )
  r2f
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    // rocc cmd out
    ,.rocc_cmd_v_o(rocc_cmd_v_o)
    ,.rocc_cmd_data_o(rocc_cmd_data_o)
    ,.rocc_cmd_ready_i(rocc_cmd_ready_i)
    // rocc resp in
    ,.rocc_resp_v_i(rocc_resp_v_i)
    ,.rocc_resp_data_i(rocc_resp_data_i)
    ,.rocc_resp_ready_o(rocc_resp_ready_o)
    // rocc mem req in
    ,.rocc_mem_req_v_i(rocc_mem_req_v_i)
    ,.rocc_mem_req_data_i(rocc_mem_req_data_i)
    ,.rocc_mem_req_ready_o(rocc_mem_req_ready_o)
    // rocc mem resp out
    ,.rocc_mem_resp_v_o(rocc_mem_resp_v_o)
    ,.rocc_mem_resp_data_o(rocc_mem_resp_data_o)
    // rocc ctrl in
    ,.rocc_ctrl_i(rocc_ctrl_i)
    // rocc ctrl out
    ,.rocc_ctrl_o(rocc_ctrl_o)
    // fsb in
    ,.fsb_node_v_i(fifo_v)
    ,.fsb_node_data_i(fifo_data)
    ,.fsb_node_yumi_o(fifo_yumi)
    // fsb out
    ,.fsb_node_v_o(fsb_node_v_o)
    ,.fsb_node_data_o(fsb_node_data_o)
    ,.fsb_node_yumi_i(fsb_node_yumi_i));

`endif

endmodule
