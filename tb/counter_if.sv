
`timescale 1ns / 10ps

interface counter_if #(
    parameter int NBITS = 4
)(
    input logic CLK
);

    // DUT inputs
    logic nRST;
    logic clear;
    logic count_enable;
    logic [NBITS-1:0] overflow_val;

    // DUT outputs
    logic [NBITS-1:0] count_out;
    logic overflow_flag;

endinterface

