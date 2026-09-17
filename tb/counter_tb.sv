module tb_top;

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

        uvm_config_db#(virtual counter_if)::set(
            null,
            "*",
            "vif",
            vif
        );

        run_test("counter_test");

    end

endmodule