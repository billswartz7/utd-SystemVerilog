// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: sctag_pcx_rptr_0.v
// Copyright (c) 2006 Sun Microsystems, Inc.  All Rights Reserved.
// DO NOT ALTER OR REMOVE COPYRIGHT NOTICES.
// 
// The above named program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public
// License version 2 as published by the Free Software Foundation.
// 
// The above named program is distributed in the hope that it will be 
// useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// General Public License for more details.
// 
// You should have received a copy of the GNU General Public
// License along with this work; if not, write to the Free Software
// Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
// 
// ========== Copyright Header End ============================================
module sctag_pcx_rptr_0 (/*AUTOARG*/
   // Outputs
   sig_buf, 
   // Inputs
   sig
   );


// this repeater has 164 bits

output  [163:0] sig_buf;
input   [163:0] sig;


assign  sig_buf  = sig;



//output                   pcx_sctag_data_rdy_px1_buf;
//output [`PCX_WIDTH-1:0]  pcx_sctag_data_px2_buf;   // pcx to sctag packet
//output                   pcx_sctag_atm_px1_buf; // indicates that the current packet is atm with the next
//output			sctag_pcx_stall_pq_buf;

//input                   pcx_sctag_data_rdy_px1;
//input [`PCX_WIDTH-1:0]  pcx_sctag_data_px2;   // pcx to sctag packet
//input                   pcx_sctag_atm_px1; // indicates that the current packet is atm with the next
//input			sctag_pcx_stall_pq;


//assign	pcx_sctag_data_rdy_px1_buf = pcx_sctag_data_rdy_px1; 
//assign	pcx_sctag_data_px2_buf = pcx_sctag_data_px2;
//assign	pcx_sctag_atm_px1_buf = pcx_sctag_atm_px1;
//assign	sctag_pcx_stall_pq_buf = sctag_pcx_stall_pq;

endmodule
