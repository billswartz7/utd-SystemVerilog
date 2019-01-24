`include "bsg_rocket_pkg.vh"

module bsg_nasti_client
  import bsg_rocket_pkg::*;
  (input                  clk_i
  ,input                  reset_i
  // aw in
  ,input                  nasti_aw_valid_i
  ,input  bsg_nasti_a_pkt nasti_aw_data_i
  ,output                 nasti_aw_ready_o
  // w in
  ,input                  nasti_w_valid_i
  ,input  bsg_nasti_w_pkt nasti_w_data_i
  ,output                 nasti_w_ready_o
  // b out
  ,output                 nasti_b_valid_o
  ,output bsg_nasti_b_pkt nasti_b_data_o
  ,input                  nasti_b_ready_i
  // ar in
  ,input                  nasti_ar_valid_i
  ,input  bsg_nasti_a_pkt nasti_ar_data_i
  ,output                 nasti_ar_ready_o
  // r out
  ,output                 nasti_r_valid_o
  ,output bsg_nasti_r_pkt nasti_r_data_o
  ,input                  nasti_r_ready_i
  // resp in
  ,input                  resp_valid_i
  ,input    bsg_tun_dmx_t resp_data_i
  ,output                 resp_yumi_o
  // req out
  ,output                 req_valid_o
  ,output   bsg_tun_dmx_t req_data_o
  ,input                  req_yumi_i);

  bsg_nasti_client_req client_req
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    // aw in
    ,.nasti_aw_valid_i(nasti_aw_valid_i)
    ,.nasti_aw_data_i(nasti_aw_data_i)
    ,.nasti_aw_ready_o(nasti_aw_ready_o)
    // w in
    ,.nasti_w_valid_i(nasti_w_valid_i)
    ,.nasti_w_data_i(nasti_w_data_i)
    ,.nasti_w_ready_o(nasti_w_ready_o)
    // b out
    ,.nasti_b_valid_o(nasti_b_valid_o)
    ,.nasti_b_data_o(nasti_b_data_o)
    ,.nasti_b_ready_i(nasti_b_ready_i)
    // ar in
    ,.nasti_ar_valid_i(nasti_ar_valid_i)
    ,.nasti_ar_data_i(nasti_ar_data_i)
    ,.nasti_ar_ready_o(nasti_ar_ready_o)
    // req out
    ,.req_valid_o(req_valid_o)
    ,.req_data_o(req_data_o)
    ,.req_yumi_i(req_yumi_i));

  bsg_nasti_client_resp client_resp
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    // resp in
    ,.resp_valid_i(resp_valid_i)
    ,.resp_data_i(resp_data_i)
    ,.resp_yumi_o(resp_yumi_o)
    // r out
    ,.nasti_r_valid_o(nasti_r_valid_o)
    ,.nasti_r_data_o(nasti_r_data_o)
    ,.nasti_r_ready_i(nasti_r_ready_i));

endmodule
