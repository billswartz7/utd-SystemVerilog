// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_r_rf32x80.v
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
////////////////////////////////////////////////////////////////////////
/*
//	Description:	Trap Stack Array
//			- Dual-Ported.
//			- Port1 - Write Port; Used by wrpr, trap insertion.
//			Write occurs in W Stage. (M1:M2:W).
//			- Port2 - Read Port; Used by rdpr, done/retry.
//			Read occurs in E Stage. 
//			- Arranged as 6(trap-levels/thread) x 4 threads = 24 entries.
//			Trap-level and thread id used to index array.
*/
////////////////////////////////////////////////////////////////////////
// Local header file includes / local defines
////////////////////////////////////////////////////////////////////////

//FPGA_SYN enables all FPGA related modifications
`ifdef FPGA_SYN
`define FPGA_SYN_32x80
`endif

`ifdef FPGA_SYN_32x80
module bw_r_rf32x80 (/*AUTOARG*/
   // Outputs
   dout, so, 
   // Inputs
   rd_en, rd_adr, wr_en, nib_wr_en, wr_adr, din, 
   si, se, sehold, rclk, rst_tri_en, reset_l);	

parameter NUM_TPL = 6 ;			// 6 supported trap levels.
parameter NUM_ENTRIES = 32 ;	// 8 entries per thread

/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
// End of automatics
input [4:0]   rd_adr;	  // read adr. 
input	      rd_en;	  // read pointer
input         wr_en;	  // write pointer vld
input [19:0]  nib_wr_en;  // enable write of a byte in tsa. 
input [4:0]   wr_adr;	  // write adr.
input [79:0] din;	      // wr data for tsa.
input		  rclk;	      // clock
input         reset_l;    // active low reset
input         rst_tri_en; // reset and scan  
input         sehold;     // scan hold 
input		  si;		  // scan in 
input		  se;		  // scan enable 

/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
// End of automatics
output	[79:0] dout ; // rd data for tsa.
output			so ;   // scan out write 

wire [79:0]    dout;
wire clk; 
wire wr_vld, wr_vld_d1; 

reg	[79:0]		tsa_rdata;
reg [79:0]     local_dout;
// reg		        so; 

integer i,j;

wire	[79:0]	write_mask;
wire	[79:0]	write_mask_d1;
//
// added for atpg support
wire [4:0]   sehold_rd_adr;	   // output of sehold mux - read adr. 
wire	     sehold_rd_en;	   // output of sehold mux - read pointer
wire         sehold_wr_en;	   // output of sehold mux - write pointer vld
wire [19:0]  sehold_nib_wr_en; // output of sehold mux - enable write of a byte in tsa. 
wire  [4:0]   sehold_wr_adr;	   // output of sehold mux - write adr.
wire [79:0]  sehold_din;	   // wr data for tsa.

reg [4:0]   rd_adr_d1;	   // flopped read adr. 
wire	     rd_en_d1;	   // flopped read pointer
wire         wr_en_d1;	   // flopped write pointer vld
wire [19:0]  nib_wr_en_d1; // flopped enable write of a byte in tsa. 
reg [4:0]   wr_adr_d1;	   // flopped write adr.
wire [79:0]  din_d1;	   // flopped wr data for tsa.
// wire [5:0]   local_scan1;
// wire [25:0]  local_scan2;
// wire [78:0]  local_scan3;

//
// creating local clock
assign clk=rclk;
// 
//=========================================================================================
//	support for atpg pattern generation
//=========================================================================================
//
// read controls
dp_mux2es #(1) mux_sehold_rd_ctrl (
    .in0  ({rd_en}),
    .in1  ({rd_en_d1}),
    .sel  (sehold),
    .dout ({sehold_rd_en})
);
//
// modified to match circuit implementataion
dff_s #(1) dff_rd_ctrl_d1(
    .din ({sehold_rd_en}),
    .q   ({rd_en_d1}),
    .clk (clk), 
    .se  (se),
    .si  (),
    .so  ()
);
//
// write controls
// modified to match circuit implementataion
dp_mux2es #(21) mux_sehold_wr_ctrl (
        .in0    ({nib_wr_en[19:0], wr_en}),
        .in1    ({nib_wr_en_d1[19:0], wr_en_d1}),
        .sel    (sehold),
        .dout   ({sehold_nib_wr_en[19:0], sehold_wr_en})
);

// modified to match circuit implementataion
dff_s #(21) dff_wr_ctrl_d1(
    .din ({sehold_nib_wr_en[19:0], sehold_wr_en}),
    .q   ({nib_wr_en_d1[19:0], wr_en_d1}),
    .clk (clk), 
    .se  (se),
    .si  (),
    .so  ()
);
//
// write data
dp_mux2es #(80) mux_sehold_din (
        .in0    (din[79:0]),
        .in1    (din_d1[79:0]),
        .sel    (sehold),
        .dout   (sehold_din[79:0])
);

dff_s #(80) dff_din_d1(
    .din (sehold_din[79:0]),
    .q   (din_d1[79:0]),
    .clk (clk), 
    .se  (se),
    .si  (),
    .so  ()
);

//
// diable write to register file during reset or scan
// assign wr_vld = sehold_wr_en & ~rst_tri_en & reset_l; 
assign wr_vld = sehold_wr_en & ~rst_tri_en;
assign wr_vld_d1 = wr_en_d1 & ~rst_tri_en;

//    always @ (posedge clk)
//      begin
//         so <= 1'bx;
//      end

//=========================================================================================
//	generate wordlines
//=========================================================================================

// Word-Line Generation skipped. Implicit in read and write.

//=========================================================================================
//	write or read to/from memory
//=========================================================================================
// creating the write mask from the nibble enable controls

assign	write_mask[79:0] = 
	{{4{sehold_nib_wr_en[19]}},
	 {4{sehold_nib_wr_en[18]}},
     {4{sehold_nib_wr_en[17]}},
	 {4{sehold_nib_wr_en[16]}},
	 {4{sehold_nib_wr_en[15]}},
	 {4{sehold_nib_wr_en[14]}},
	 {4{sehold_nib_wr_en[13]}},
	 {4{sehold_nib_wr_en[12]}},
	 {4{sehold_nib_wr_en[11]}},
	 {4{sehold_nib_wr_en[10]}},
	 {4{sehold_nib_wr_en[9]}},
	 {4{sehold_nib_wr_en[8]}},
	 {4{sehold_nib_wr_en[7]}},
	 {4{sehold_nib_wr_en[6]}},
	 {4{sehold_nib_wr_en[5]}},
	 {4{sehold_nib_wr_en[4]}},
	 {4{sehold_nib_wr_en[3]}},
	 {4{sehold_nib_wr_en[2]}},
	 {4{sehold_nib_wr_en[1]}},
	 {4{sehold_nib_wr_en[0]}}
	};

assign	write_mask_d1[79:0] = 
	{{4{nib_wr_en_d1[19]}},
	 {4{nib_wr_en_d1[18]}},
     {4{nib_wr_en_d1[17]}},
	 {4{nib_wr_en_d1[16]}},
	 {4{nib_wr_en_d1[15]}},
	 {4{nib_wr_en_d1[14]}},
	 {4{nib_wr_en_d1[13]}},
	 {4{nib_wr_en_d1[12]}},
	 {4{nib_wr_en_d1[11]}},
	 {4{nib_wr_en_d1[10]}},
	 {4{nib_wr_en_d1[9]}},
	 {4{nib_wr_en_d1[8]}},
	 {4{nib_wr_en_d1[7]}},
	 {4{nib_wr_en_d1[6]}},
	 {4{nib_wr_en_d1[5]}},
	 {4{nib_wr_en_d1[4]}},
	 {4{nib_wr_en_d1[3]}},
	 {4{nib_wr_en_d1[2]}},
	 {4{nib_wr_en_d1[1]}},
	 {4{nib_wr_en_d1[0]}}
	};

reg	[79:0]	tsa_mem [NUM_ENTRIES-1:0] /* synthesis syn_ramstyle = block_ram  syn_ramstyle = no_rw_check */ ;

reg	[79:0]		temp_tlvl;
wire	[79:0]		temp_tlvl2;



always @(posedge clk) begin
  rd_adr_d1 <= sehold_rd_adr;
  wr_adr_d1 <= sehold_wr_adr;
end

assign sehold_wr_adr = sehold ? wr_adr_d1 : wr_adr;
assign sehold_rd_adr = sehold ? rd_adr_d1 : rd_adr;

assign temp_tlvl2 = tsa_mem[sehold_rd_adr[4:0]];

always @(posedge clk)
  if(~reset_l) 
    local_dout[79:0] <= 80'b0;
  else
   if (sehold_rd_en)
     local_dout[79:0] <= temp_tlvl2;

always @ ( posedge clk) begin
	temp_tlvl[79:0] = tsa_mem[sehold_wr_adr];
	if (wr_vld & reset_l) begin
		tsa_mem[sehold_wr_adr] = (temp_tlvl[79:0] & ~write_mask[79:0]) | (sehold_din[79:0] &  write_mask[79:0]) ;
	end
end


assign dout[79:0] = local_dout;



endmodule

`else

module bw_r_rf32x80 (/*AUTOARG*/
   // Outputs
   dout, so, 
   // Inputs
   rd_en, rd_adr, wr_en, nib_wr_en, wr_adr, din, 
   si, se, sehold, rclk, rst_tri_en, reset_l);	

parameter NUM_TPL = 6 ;			// 6 supported trap levels.
parameter NUM_ENTRIES = 32 ;	// 8 entries per thread

/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
// End of automatics
input [4:0]   rd_adr;	  // read adr. 
input	      rd_en;	  // read pointer
input         wr_en;	  // write pointer vld
input [19:0]  nib_wr_en;  // enable write of a byte in tsa. 
input [4:0]   wr_adr;	  // write adr.
input [79:0] din;	      // wr data for tsa.
input		  rclk;	      // clock
input         reset_l;    // active low reset
input         rst_tri_en; // reset and scan  
input         sehold;     // scan hold 
input		  si;		  // scan in 
input		  se;		  // scan enable 

/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
// End of automatics
output	[79:0] dout ; // rd data for tsa.
output			so ;   // scan out write 

wire [79:0]    dout;
wire clk; 
wire wr_vld, wr_vld_d1; 

reg	[79:0]		tsa_mem [NUM_ENTRIES-1:0];
reg	[79:0]		tsa_rdata;
reg [79:0]     local_dout;
reg	[79:0]		temp_tlvl;
// reg		        so; 

integer i,j;

wire	[79:0]	write_mask;
wire	[79:0]	write_mask_d1;
//
// added for atpg support
wire [4:0]   sehold_rd_adr;	   // output of sehold mux - read adr. 
wire	     sehold_rd_en;	   // output of sehold mux - read pointer
wire         sehold_wr_en;	   // output of sehold mux - write pointer vld
wire [19:0]  sehold_nib_wr_en; // output of sehold mux - enable write of a byte in tsa. 
wire [4:0]   sehold_wr_adr;	   // output of sehold mux - write adr.
wire [79:0]  sehold_din;	   // wr data for tsa.

wire [4:0]   rd_adr_d1;	   // flopped read adr. 
wire	     rd_en_d1;	   // flopped read pointer
wire         wr_en_d1;	   // flopped write pointer vld
wire [19:0]  nib_wr_en_d1; // flopped enable write of a byte in tsa. 
wire [4:0]   wr_adr_d1;	   // flopped write adr.
wire [79:0]  din_d1;	   // flopped wr data for tsa.
// wire [5:0]   local_scan1;
// wire [25:0]  local_scan2;
// wire [78:0]  local_scan3;

//
// creating local clock
assign clk=rclk;
// 
//=========================================================================================
//	support for atpg pattern generation
//=========================================================================================
//
// read controls
dp_mux2es #(6) mux_sehold_rd_ctrl (
    .in0  ({rd_adr[4:0], rd_en}),
    .in1  ({rd_adr_d1[4:0], rd_en_d1}),
    .sel  (sehold),
    .dout ({sehold_rd_adr[4:0],sehold_rd_en})
);
//
// modified to match circuit implementataion
dff_s #(6) dff_rd_ctrl_d1(
    .din ({sehold_rd_adr[4:0], sehold_rd_en}),
    .q   ({rd_adr_d1[4:0], rd_en_d1}),
    .clk (clk), 
    .se  (se),
    .si  (),
    .so  ()
);
//
// write controls
// modified to match circuit implementataion
dp_mux2es #(26) mux_sehold_wr_ctrl (
        .in0    ({nib_wr_en[19:0], wr_adr[4:0], wr_en}),
        .in1    ({nib_wr_en_d1[19:0], wr_adr_d1[4:0], wr_en_d1}),
        .sel    (sehold),
        .dout   ({sehold_nib_wr_en[19:0], sehold_wr_adr[4:0],sehold_wr_en})
);

// modified to match circuit implementataion
dff_s #(26) dff_wr_ctrl_d1(
    .din ({sehold_nib_wr_en[19:0], sehold_wr_adr[4:0], sehold_wr_en}),
    .q   ({nib_wr_en_d1[19:0], wr_adr_d1[4:0], wr_en_d1}),
    .clk (clk), 
    .se  (se),
    .si  (),
    .so  ()
);
//
// write data
dp_mux2es #(80) mux_sehold_din (
        .in0    (din[79:0]),
        .in1    (din_d1[79:0]),
        .sel    (sehold),
        .dout   (sehold_din[79:0])
);

dff_s #(80) dff_din_d1(
    .din (sehold_din[79:0]),
    .q   (din_d1[79:0]),
    .clk (clk), 
    .se  (se),
    .si  (),
    .so  ()
);

//
// diable write to register file during reset or scan
// assign wr_vld = sehold_wr_en & ~rst_tri_en & reset_l; 
assign wr_vld = sehold_wr_en & ~rst_tri_en;
assign wr_vld_d1 = wr_en_d1 & ~rst_tri_en;

//    always @ (posedge clk)
//      begin
//         so <= 1'bx;
//      end

//=========================================================================================
//	generate wordlines
//=========================================================================================

// Word-Line Generation skipped. Implicit in read and write.

//=========================================================================================
//	write or read to/from memory
//=========================================================================================
// creating the write mask from the nibble enable controls

assign	write_mask[79:0] = 
	{{4{sehold_nib_wr_en[19]}},
	 {4{sehold_nib_wr_en[18]}},
     {4{sehold_nib_wr_en[17]}},
	 {4{sehold_nib_wr_en[16]}},
	 {4{sehold_nib_wr_en[15]}},
	 {4{sehold_nib_wr_en[14]}},
	 {4{sehold_nib_wr_en[13]}},
	 {4{sehold_nib_wr_en[12]}},
	 {4{sehold_nib_wr_en[11]}},
	 {4{sehold_nib_wr_en[10]}},
	 {4{sehold_nib_wr_en[9]}},
	 {4{sehold_nib_wr_en[8]}},
	 {4{sehold_nib_wr_en[7]}},
	 {4{sehold_nib_wr_en[6]}},
	 {4{sehold_nib_wr_en[5]}},
	 {4{sehold_nib_wr_en[4]}},
	 {4{sehold_nib_wr_en[3]}},
	 {4{sehold_nib_wr_en[2]}},
	 {4{sehold_nib_wr_en[1]}},
	 {4{sehold_nib_wr_en[0]}}
	};

assign	write_mask_d1[79:0] = 
	{{4{nib_wr_en_d1[19]}},
	 {4{nib_wr_en_d1[18]}},
     {4{nib_wr_en_d1[17]}},
	 {4{nib_wr_en_d1[16]}},
	 {4{nib_wr_en_d1[15]}},
	 {4{nib_wr_en_d1[14]}},
	 {4{nib_wr_en_d1[13]}},
	 {4{nib_wr_en_d1[12]}},
	 {4{nib_wr_en_d1[11]}},
	 {4{nib_wr_en_d1[10]}},
	 {4{nib_wr_en_d1[9]}},
	 {4{nib_wr_en_d1[8]}},
	 {4{nib_wr_en_d1[7]}},
	 {4{nib_wr_en_d1[6]}},
	 {4{nib_wr_en_d1[5]}},
	 {4{nib_wr_en_d1[4]}},
	 {4{nib_wr_en_d1[3]}},
	 {4{nib_wr_en_d1[2]}},
	 {4{nib_wr_en_d1[1]}},
	 {4{nib_wr_en_d1[0]}}
	};

always @ ( negedge reset_l) 
	begin
        local_dout[79:0] <= 80'h0;
    end

always @ ( posedge reset_l) 
	begin
	    if (rd_en_d1 & clk)
		      begin 
			    if (wr_vld_d1 & (wr_adr_d1[4:0] == rd_adr_d1[4:0]) )
				    local_dout[79:0] <= 80'hx;
				else	
				    for (j=0;j<NUM_ENTRIES;j=j+1)
					    begin
						    if (rd_adr_d1[4:0] == j)
							local_dout[79:0] <= tsa_mem[j] ;
					    end
		      end	
	end




always @ ( posedge reset_l) 
	begin
		if (wr_vld_d1 & clk) 
			for (i=0;i<NUM_ENTRIES;i=i+1)
				begin
				if (wr_adr_d1[4:0] == i)
					begin
					// read
					temp_tlvl[79:0] = tsa_mem[i]; 
					// modify & write
					tsa_mem[i] = 
					(temp_tlvl[79:0] & ~write_mask_d1[79:0]) |
					(din_d1[79:0] &  write_mask_d1[79:0]) ;
					end
				end
	end

	
always @ ( posedge clk) 
	begin
		if (wr_vld & reset_l) 
			for (i=0;i<NUM_ENTRIES;i=i+1)
				begin
				if (sehold_wr_adr[4:0] == i)
					begin
					// read
					temp_tlvl[79:0] = tsa_mem[i]; 
					// modify & write
					tsa_mem[i] = 
					(temp_tlvl[79:0] & ~write_mask[79:0]) |
					(sehold_din[79:0] &  write_mask[79:0]) ;
					end
				end
	end

always @ ( posedge clk ) 
	begin
              begin
				if (sehold_rd_en & reset_l)
					begin 
						if (wr_vld & (sehold_wr_adr[4:0] == sehold_rd_adr[4:0]) )
							local_dout[79:0] <= 80'hx;
						else	
							for (j=0;j<NUM_ENTRIES;j=j+1)
							begin
								if (sehold_rd_adr[4:0] == j)
								local_dout[79:0] <= tsa_mem[j] ;
							end
					end	
            end
	end

assign dout[79:0] = local_dout[79:0];


endmodule
`endif

