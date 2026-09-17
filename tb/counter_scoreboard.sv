class counter_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(counter_scoreboard)

    uvm_analysis_imp #(counter_transaction,
                       counter_scoreboard) analysis_export;

    bit [3:0] expected_count;
    bit expected_overflow;

    function new(string name = "counter_scoreboard",
                 uvm_component parent = null);
        super.new(name, parent);

        analysis_export = new("analysis_export", this);

        expected_count = 0;
        expected_overflow = 0;
    endfunction

    function void write(counter_transaction tr);

        bit [3:0] next_count;
        bit next_overflow;

        // Reset
        if (!tr.nRST) begin

            next_count = 0;
            next_overflow = 0;

        end

        // Clear
        else if (tr.clear) begin

            next_count = 0;

            if (next_count == tr.overflow_val)
                next_overflow = 1;
            else
                next_overflow = 0;

        end

        // Count enabled
        else if (tr.count_enable) begin

            if (expected_count + 1 > tr.overflow_val)
                next_count = 1;
            else
                next_count = expected_count + 1;

            if (next_count == tr.overflow_val)
                next_overflow = 1;
            else
                next_overflow = 0;

        end

        // Hold
        else begin

            next_count = expected_count;

            if (next_count == tr.overflow_val)
                next_overflow = 1;
            else
                next_overflow = 0;

        end

        // Compare DUT against expected values
        if (tr.count_out !== next_count) begin
            `uvm_error("COUNT_MISMATCH",
                $sformatf(
                    "Expected count=%0d, DUT count=%0d",
                    next_count,
                    tr.count_out
                ))
        end

        if (tr.overflow_flag !== next_overflow) begin
            `uvm_error("OVERFLOW_MISMATCH",
                $sformatf(
                    "Expected overflow=%0b, DUT overflow=%0b",
                    next_overflow,
                    tr.overflow_flag
                ))
        end

        expected_count = next_count;
        expected_overflow = next_overflow;

    endfunction

endclass