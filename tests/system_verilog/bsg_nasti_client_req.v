`include "bsg_rocket_pkg.vh"

module bsg_nasti_client_req
  import bsg_rocket_pkg::*;
  (input                  clk_i
  ,input                  reset_i
  // ar
  ,input                  nasti_ar_valid_i
  ,input  bsg_nasti_a_pkt nasti_ar_data_i
  ,output                 nasti_ar_ready_o
  // aw
  ,input                  nasti_aw_valid_i
  ,input  bsg_nasti_a_pkt nasti_aw_data_i
  ,output                 nasti_aw_ready_o
  // w
  ,input                  nasti_w_valid_i
  ,input  bsg_nasti_w_pkt nasti_w_data_i
  ,output                 nasti_w_ready_o
  // b
  ,output                 nasti_b_valid_o
  ,output bsg_nasti_b_pkt nasti_b_data_o
  ,input                  nasti_b_ready_i
  // req out
  ,output                 req_valid_o
  ,output   bsg_tun_dmx_t req_data_o
  ,input                  req_yumi_i);

  enum logic [5:0] {IDLE   = 6'b000001
                   ,RADDR  = 6'b000010
                   ,WVALID = 6'b000100
                   ,WIDLE  = 6'b001000
                   ,WLAST  = 6'b010000
                   ,WACK   = 6'b100000} state_n, state_r;

  // fsm
  always_ff @(posedge clk_i)
    if (reset_i)
      state_r <= IDLE;
    else
      state_r <= state_n;

  always_comb begin

    state_n = state_r;

    unique case (state_r)

      IDLE:
        if (nasti_aw_valid_i)
          state_n = WVALID;
        else if (nasti_ar_valid_i)
          state_n = RADDR;

      RADDR:
        if (req_yumi_i)
          state_n = IDLE;

      WVALID:
        if (req_yumi_i)
          state_n = WIDLE;

      WIDLE:
        if (nasti_w_data_i.last & nasti_w_valid_i)
          state_n = WLAST;
        else if (nasti_w_valid_i)
          state_n = WVALID;

      WLAST:
        if (req_yumi_i)
          state_n = WACK;

      WACK:
        if (nasti_b_ready_i)
          state_n = IDLE;

      default:
        state_n = IDLE;

    endcase

  end

  // req out
  bsg_tun_dmx_t    req_data_r;
  bsg_nasti_sa_pkt req_aw_n;
  bsg_nasti_sw_pkt req_w_n;
  bsg_nasti_sa_pkt req_ar_n;

  assign req_aw_n.addr = nasti_aw_data_i.addr;
  assign req_aw_n.id   = nasti_aw_data_i.id;
  assign req_aw_n.rw   = 1'b1;

  assign req_w_n.last = nasti_w_data_i.last;
  assign req_w_n.data = nasti_w_data_i.data;

  assign req_ar_n.addr = nasti_ar_data_i.addr;
  assign req_ar_n.id   = nasti_ar_data_i.id;
  assign req_ar_n.rw   = 1'b0;

  always_ff @(posedge clk_i)
    if (state_r == IDLE & nasti_aw_valid_i)
      req_data_r <= bsg_tun_dmx_t ' (req_aw_n);
    else if (state_r == WIDLE & nasti_w_valid_i)
      req_data_r <= bsg_tun_dmx_t ' (req_w_n);
    else if (state_r == IDLE & nasti_ar_valid_i)
      req_data_r <= bsg_tun_dmx_t ' (req_ar_n);

  assign req_data_o = req_data_r;
  assign req_valid_o = ( state_r == RADDR
                      || state_r == WVALID
                      || state_r == WLAST)? 1'b1 : 1'b0;

  // nasti
  assign nasti_ar_ready_o = (state_r == IDLE)? 1'b1 : 1'b0;
  assign nasti_aw_ready_o = (state_r == IDLE)? 1'b1 : 1'b0;
  assign nasti_w_ready_o = (state_r == WIDLE)? 1'b1 : 1'b0;

  bsg_nasti_id_t nasti_b_id_r;

  always_ff @(posedge clk_i)
    if (state_r == IDLE & nasti_aw_valid_i)
      nasti_b_id_r <= nasti_aw_data_i.id;

  assign nasti_b_valid_o = (state_r == WACK)? 1'b1 : 1'b0;
  assign nasti_b_data_o.id = nasti_b_id_r;
  assign nasti_b_data_o.resp = 2'd0;

endmodule
