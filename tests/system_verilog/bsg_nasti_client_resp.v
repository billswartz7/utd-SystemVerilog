`include "bsg_rocket_pkg.vh"

module bsg_nasti_client_resp
  import bsg_rocket_pkg::*;
  (input                  clk_i
  ,input                  reset_i
  // r out
  ,output                 nasti_r_valid_o
  ,output bsg_nasti_r_pkt nasti_r_data_o
  ,input                  nasti_r_ready_i
  // resp in
  ,input                  resp_valid_i
  ,input    bsg_tun_dmx_t resp_data_i
  ,output                 resp_yumi_o);

  assign nasti_r_valid_o = resp_valid_i;
  assign nasti_r_data_o.resp = 2'd0;

  bsg_nasti_sr_pkt nasti_sr_data;

  assign nasti_sr_data = bsg_nasti_sr_pkt ' (resp_data_i);

  assign nasti_r_data_o.last = nasti_sr_data.last;
  assign nasti_r_data_o.data = nasti_sr_data.data;
  assign nasti_r_data_o.id   = nasti_sr_data.id;

  assign resp_yumi_o = resp_valid_i & nasti_r_ready_i;

endmodule
