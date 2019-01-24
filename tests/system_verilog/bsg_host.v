`include "bsg_rocket_pkg.vh"

module bsg_host
  import bsg_rocket_pkg::*;
  (input                clk_i
  ,input                reset_i
  // host in
  ,input                host_valid_i
  ,input     bsg_host_t host_data_i
  ,output               host_ready_o
  // host out
  ,output               host_valid_o
  ,output    bsg_host_t host_data_o
  ,input                host_ready_i
  // data in
  ,input                valid_i
  ,input  bsg_tun_dmx_t data_i
  ,output               yumi_o
  // data out
  ,output               valid_o
  ,output bsg_tun_dmx_t data_o
  ,input                yumi_i);

  // host-to-yumi

  bsg_tun_dmx_t host_data_n;

  assign host_data_n = bsg_tun_dmx_t ' (host_data_i);

  bsg_two_fifo #
    (.width_p(bsg_tun_dmx_width_p)) // taken from bsg_rocket_pkg.vh
  fifo
    (.clk_i(clk_i)
    ,.reset_i(reset_i)
    // host in
    ,.v_i(host_valid_i)
    ,.data_i(host_data_n)
    ,.ready_o(host_ready_o)
    // data out
    ,.v_o(valid_o)
    ,.data_o(data_o)
    ,.yumi_i(yumi_i));

  // yumi-to-host

  assign host_valid_o = valid_i;
  assign host_data_o  = bsg_host_t ' (data_i);

  assign yumi_o = valid_i & host_ready_i;

endmodule
