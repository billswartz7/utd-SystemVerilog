`include "bsg_padmapping.v"
`include "bsg_iopad_macros.v"

module bsg_chip

  // pull in BSG Two's top-level module signature, and the definition of the pads
  `include "bsg_pinout.v"
  `include "bsg_iopads.v"

  //  _____  _      _
  // |  __ \| |    | |
  // | |__) | |    | |     ___
  // |  ___/| |    | |    / __|
  // | |    | |____| |____\__ \
  // |_|    |______|______|___/

  logic core_clk,     io_master_clk,     manycore_clk;
  logic core_tst_clk, io_master_tst_clk, manycore_tst_clk;
  logic core_sdo,     io_master_sdo,     manycore_sdo;
  logic core_clk_pll_out, io_master_clk_pll_out, manycore_clk_pll_out;

  // Core clk pll and clock mux

  pll core_clk_pll
    (.in_clk_ref(PLL_SECTION_1_REF_i_int)
    ,.in_chip_select(PLL_1_CS_i_int)
    ,.in_scn_clk(PLL_SCLK_i_int)
    ,.in_sdi(PLL_1_SDI_i_int)
    ,.in_rstb(PLL_SECTION_1_RST_i_int)
    ,.out_sdo(core_sdo)
    ,.out_clk_tst(core_tst_clk)
    ,.out_clk(core_clk_pll_out));

  bsg_mux
   #(.width_p    (1)
    ,.els_p      (2)
    ,.harden_p   (1)
    ,.balanced_p (1))
  core_clk_mux
    (.data_i ({PLL_1_CLK_BKP_i_int, core_clk_pll_out})
    ,.sel_i  (PLL_1_CLK_SEL_i_int)
    ,.data_o (core_clk));

  // IO Master clk pll and clock mux

  pll io_master_clk_pll
    (.in_clk_ref(PLL_SECTION_2_REF_i_int)
    ,.in_chip_select(PLL_2_CS_i_int)
    ,.in_scn_clk(PLL_SCLK_i_int)
    ,.in_sdi(PLL_2_SDI_i_int)
    ,.in_rstb(PLL_SECTION_2_RST_i_int)
    ,.out_sdo(io_master_sdo)
    ,.out_clk_tst(io_master_tst_clk)
    ,.out_clk(io_master_clk_pll_out));

  bsg_mux
   #(.width_p    (1)
    ,.els_p      (2)
    ,.harden_p   (1)
    ,.balanced_p (1))
  io_master_clk_mux
    (.data_i ({PLL_2_CLK_BKP_i_int, io_master_clk_pll_out})
    ,.sel_i  (PLL_2_CLK_SEL_i_int)
    ,.data_o (io_master_clk));

  // Manycore clk pll and clock mux

  pll manycore_clk_pll
    (.in_clk_ref(PLL_SECTION_3_REF_i_int)
    ,.in_chip_select(PLL_3_CS_i_int)
    ,.in_scn_clk(PLL_SCLK_i_int)
    ,.in_sdi(PLL_3_SDI_i_int)
    ,.in_rstb(PLL_SECTION_3_RST_i_int)
    ,.out_sdo(manycore_sdo)
    ,.out_clk_tst(manycore_tst_clk)
    ,.out_clk(manycore_clk_pll_out));

  bsg_mux
   #(.width_p    (1)
    ,.els_p      (2)
    ,.harden_p   (1)
    ,.balanced_p (1))
  manycore_clk_mux
    (.data_i ({PLL_3_CLK_BKP_i_int, manycore_clk_pll_out})
    ,.sel_i  (PLL_3_CLK_SEL_i_int)
    ,.data_o (manycore_clk));

  assign PLL_1_SDO_o_int = core_sdo;
  assign PLL_SECTION_1_TST_o_int = core_tst_clk;

  assign PLL_2_SDO_o_int = io_master_sdo;
  assign PLL_SECTION_2_TST_o_int = io_master_tst_clk;

  assign PLL_3_SDO_o_int = manycore_sdo;
  assign PLL_SECTION_3_TST_o_int = manycore_tst_clk;

  //  _____   _____     _______   _____   _      _____   ____
  // |  __ \ / ____|   / /  __ \ / ____| | |    |  __ \ / __ \
  // | |  | | |       / /| |  | | |      | |    | |  | | |  | |
  // | |  | | |      / / | |  | | |      | |    | |  | | |  | |
  // | |__| | |____ / /  | |__| | |____  | |____| |__| | |__| |
  // |_____/ \_____/_/   |_____/ \_____| |______|_____/ \____/

  logic dc_dc_ldo_clk_ov4;
  logic dc_dc_ldo_enhh;
  logic dc_dc_ldo_enll;
  logic dc_dc_ldo_enh;
  logic dc_dc_ldo_enl;

  LDO_16nm_V0_TOP_V1 dc_dc_ldo
    (.CLKOV64(dc_dc_ldo_clk_ov4)
    ,.CLK_LOAD(LDO_CLK_LOAD_i_int)
    ,.CLK_REF(LDO_CLK_REF_i_int)
    ,.ENH(dc_dc_ldo_enh)
    ,.ENHH(dc_dc_ldo_enhh)
    ,.ENL(dc_dc_ldo_enl)
    ,.ENLL(dc_dc_ldo_enll)
    ,.EXT_SAM(LDO_EXT_SAM_i_int)
    ,.PLL(core_clk)
    ,.RSTIN(LDO_RSTIN_i_int)
    ,.SPI_CLK(LDO_SPI_CLK_i_int)
    ,.SPI_IN(LDO_SPI_IN_i_int)
    ,.SPI_RST(LDO_SPI_RST_i_int)

    //----- analog pins -----//

    ,.VDD_LOAD(LDO_SECTION_VDD_LOAD_i_int)
    // ,.VDDIO(LDO_SECTION_VDDIO_i_int)
    // ,.VDDC(LDO_SECTION_VDDC_i_int)
    ,.VREFH(LDO_SECTION_VREFH_i_int)
    ,.VREFL(LDO_SECTION_VREFL_i_int)
    ,.VB_RING(LDO_SECTION_VB_RING_i_int)
    ,.VCAL_HH(LDO_SECTION_VCAL_HH_i_int)
    ,.VCAL_LL(LDO_SECTION_VCAL_LL_i_int)
    ,.VL(LDO_SECTION_VL_i_int));

  assign LDO_CLKOV64_o_int = dc_dc_ldo_clk_ov4;
  assign LDO_ENHH_o_int    = dc_dc_ldo_enhh;
  assign LDO_ENLL_o_int    = dc_dc_ldo_enll;
  assign LDO_ENH_o_int     = dc_dc_ldo_enh;
  assign LDO_ENL_o_int     = dc_dc_ldo_enl;

  wire [7:0] sdi_data_i_int_packed [3:0];
  wire [7:0] sdo_data_o_int_packed [3:0];

  assign sdi_data_i_int_packed = { sdi_D_data_i_int, sdi_B_data_i_int, sdi_C_data_i_int, sdi_A_data_i_int };
  assign { sdo_D_data_o_int, sdo_C_data_o_int, sdo_B_data_o_int, sdo_A_data_o_int } = { >> {sdo_data_o_int_packed} };

  `define BSG_SWIZZLE_3120(a) { a[3],a[1],a[2],a[0] }

  //  ____   _____  _____    _____ _     _          _____       _
  // |  _ \ / ____|/ ____|  / ____| |   (_)        / ____|     | |
  // | |_) | (___ | |  __  | |    | |__  _ _ __   | |  __ _   _| |_ ___
  // |  _ < \___ \| | |_ | | |    | '_ \| | '_ \  | | |_ | | | | __/ __|
  // | |_) |____) | |__| | | |____| | | | | |_) | | |__| | |_| | |_\__ \
  // |____/|_____/ \_____|  \_____|_| |_|_| .__/   \_____|\__,_|\__|___/
  //                                      | |
  //                                      |_|

  bsg_chip_guts g
    (.core_clk_i(core_clk)
    ,.io_master_clk_i(io_master_clk)
    ,.manycore_clk_i(manycore_clk)
    ,.async_reset_i(reset_i_int)

    ,.io_clk_tline_i(`BSG_SWIZZLE_3120(sdi_sclk_i_int))
    ,.io_valid_tline_i(`BSG_SWIZZLE_3120(sdi_ncmd_i_int))
    ,.io_data_tline_i(sdi_data_i_int_packed)
    ,.io_token_clk_tline_o(`BSG_SWIZZLE_3120(sdi_token_o_int))

    ,.im_clk_tline_o(sdo_sclk_o_int)
    ,.im_valid_tline_o(sdo_ncmd_o_int)
    ,.im_data_tline_o(sdo_data_o_int_packed)
    ,.token_clk_tline_i(sdo_token_i_int)

    ,.im_slave_reset_tline_r_o()  // unused by ASIC

    ,.core_reset_o());            // post calibration reset

  `include "bsg_pinout_end.v"
