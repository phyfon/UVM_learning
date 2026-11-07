`timescale 1ns / 10ps

module tb_top;

    import uvm_pkg::*;
    import counter_pkg::*;


    parameter int NBITS = 4;

    logic CLK;

    counter_if #(NBITS) vif(CLK);


    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end



    socetlib_counter #(
        .NBITS(NBITS)
    ) dut (
        .CLK          (CLK),
        .nRST         (vif.nRST),
        .clear        (vif.clear),
        .count_enable (vif.count_enable),
        .overflow_val (vif.overflow_val),
        .count_out    (vif.count_out),
        .overflow_flag(vif.overflow_flag)
    );


    initial begin
	vif.nRST = 0;
	vif.clear = 0;
	vif.count_enable = 0;
	vif.overflow_val = 4'd10;
	uvm_config_db#(virtual counter_if#(4))::set(null, "*", "vif", vif);
        run_test(); // set by +UVM_TESTNAME

    end

endmodule
