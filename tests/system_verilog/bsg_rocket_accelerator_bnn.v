`include "bsg_rocket_pkg.vh"

module bsg_rocket_accelerator_bnn
  import bsg_rocket_pkg::*;
  (input                       clk_i
  ,input                       reset_i
  ,input                       en_i
  // rocc cmd in
  ,input                       rocc_cmd_v_i
  ,input      bsg_rocc_cmd_pkt rocc_cmd_data_i
  ,output                      rocc_cmd_ready_o
  // rocc resp out
  ,output                      rocc_resp_v_o
  ,output    bsg_rocc_resp_pkt rocc_resp_data_o
  ,input                       rocc_resp_ready_i
  // rocc mem req out
  ,output                      rocc_mem_req_v_o
  ,output bsg_rocc_mem_req_pkt rocc_mem_req_data_o
  ,input                       rocc_mem_req_ready_i
  // rocc mem resp in
  ,input                       rocc_mem_resp_v_i
  ,input bsg_rocc_mem_resp_pkt rocc_mem_resp_data_i
  // rocc ctrl out
  ,output  bsg_rocc_ctrl_in_pkt rocc_ctrl_o
  // rocc ctrl in
  ,input  bsg_rocc_ctrl_out_pkt rocc_ctrl_i

  ,input  [63:0] manycore_req_msg_i
  ,output [0 :0] manycore_req_rdy_o
  ,input  [0 :0] manycore_req_val_i
  );

// BNN is stubbed out when running synthesis on the top-level chip
`ifndef SYNTHESIS_TOPLEVEL_STUB

  assign rocc_mem_req_data_o.phys = 1'b1;
  assign rocc_ctrl_o.interrupt = 1'b0;

  RoccXcelWrapper bb
    (.clk(clk_i)
    ,.reset(reset_i)
    // cmd in
    ,.io_cmd_ready(rocc_cmd_ready_o)
    ,.io_cmd_valid(rocc_cmd_v_i)
    ,.io_cmd_bits_inst_funct(rocc_cmd_data_i.inst_funct)
    ,.io_cmd_bits_inst_rs2(rocc_cmd_data_i.inst_rs2)
    ,.io_cmd_bits_inst_rs1(rocc_cmd_data_i.inst_rs1)
    ,.io_cmd_bits_inst_xd(rocc_cmd_data_i.inst_xd)
    ,.io_cmd_bits_inst_xs1(rocc_cmd_data_i.inst_xs1)
    ,.io_cmd_bits_inst_xs2(rocc_cmd_data_i.inst_xs2)
    ,.io_cmd_bits_inst_rd(rocc_cmd_data_i.inst_rd)
    ,.io_cmd_bits_inst_opcode(rocc_cmd_data_i.inst_opcode)
    ,.io_cmd_bits_rs1(rocc_cmd_data_i.rs1)
    ,.io_cmd_bits_rs2(rocc_cmd_data_i.rs2)
    // resp out
    ,.io_resp_ready(rocc_resp_ready_i)
    ,.io_resp_valid(rocc_resp_v_o)
    ,.io_resp_bits_rd(rocc_resp_data_o.rd)
    ,.io_resp_bits_data(rocc_resp_data_o.data)
    // mem req out
    ,.io_mem_req_ready( rocc_mem_req_ready_i )
    ,.io_mem_req_valid( rocc_mem_req_v_o )
    ,.io_mem_req_bits_addr( rocc_mem_req_data_o.addr )
    ,.io_mem_req_bits_tag( rocc_mem_req_data_o.tag )
    ,.io_mem_req_bits_cmd( rocc_mem_req_data_o.cmd )
    ,.io_mem_req_bits_typ( rocc_mem_req_data_o.typ )
    ,.io_mem_req_bits_data( rocc_mem_req_data_o.data )
    // mem resp in
    ,.io_mem_resp_valid( rocc_mem_resp_v_i )
    ,.io_mem_resp_bits_addr( rocc_mem_resp_data_i.addr )
    ,.io_mem_resp_bits_tag( rocc_mem_resp_data_i.tag )
    ,.io_mem_resp_bits_cmd( rocc_mem_resp_data_i.cmd )
    ,.io_mem_resp_bits_typ( rocc_mem_resp_data_i.typ )
    ,.io_mem_resp_bits_data( rocc_mem_resp_data_i.data )
    ,.io_mem_resp_bits_nack( rocc_mem_resp_data_i.nack )
    ,.io_mem_resp_bits_replay( rocc_mem_resp_data_i.replay )
    ,.io_mem_resp_bits_has_data( rocc_mem_resp_data_i.has_data )
    ,.io_mem_resp_bits_data_word_bypass( rocc_mem_resp_data_i.data_word_bypass )
    ,.io_mem_resp_bits_store_data( rocc_mem_resp_data_i.store_data )
    // manycore messages
    ,.io_manycore_req_val( manycore_req_val_i )
    ,.io_manycore_req_rdy( manycore_req_rdy_o )
    ,.io_manycore_req_msg( manycore_req_msg_i )
    // ctrl out
    ,.io_busy(rocc_ctrl_o.busy));

`endif

endmodule
