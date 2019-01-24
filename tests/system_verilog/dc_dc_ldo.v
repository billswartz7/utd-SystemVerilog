module LDO_16nm_V0_TOP_V1 (
     //----- digital pins -----//
     output CLKOV64
    ,input  CLK_LOAD
    ,input  CLK_REF
    ,output ENH
    ,output ENHH
    ,output ENL
    ,output ENLL
    ,input  EXT_SAM
    ,input  PLL
    ,input  RSTIN
    ,input  SPI_CLK
    ,input  SPI_IN
    ,input  SPI_RST

    //----- analog pins -----//
    ,input VREFH
    ,input VREFL
    ,input VB_RING
    ,input VCAL_HH
    ,input VCAL_LL
    ,input VL
    // ,inout VDDIO
    ,inout VDD_LOAD
    //,input VDD
    // ,inout VDDC
    // ,inout VOUT
    //,input VSS
    );

/**
 *
 * +-------------+
 * |             |
 * |             |
 * |  BLACK BOX  |
 * |             |
 * |             |
 * +-------------+
 *
 **/

endmodule
