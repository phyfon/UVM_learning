interface counter_if #(parameter int NBITS = 4) (input logic CLK);

    logic nRST;
    logic clear;
    logic count_enable;
    logic [NBITS-1:0] overflow_val;

    logic [NBITS-1:0] count_out;
    logic overflow_flag;

endinterface