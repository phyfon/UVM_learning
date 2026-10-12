
class counter_sequence extends uvm_sequence #(counter_transaction);

    `uvm_object_utils(counter_sequence)

    function new(string name = "counter_sequence");
        super.new(name);
    endfunction

    task body();

        counter_transaction tr;

        // Apply reset
        tr = counter_transaction::type_id::create("tr");
        start_item(tr);
        tr.nRST         = 0;
        tr.clear        = 0;
        tr.count_enable = 0;
        tr.overflow_val = 4'd10;
        finish_item(tr);

        // Release reset and enable counting
        repeat (20) begin
            tr = counter_transaction::type_id::create("tr");
            start_item(tr);

            if (!tr.randomize() with {
                nRST == 1;
                clear == 0;
                count_enable == 1;
                overflow_val == 10;
            })
                `uvm_fatal("SEQ", "Randomization failed")

            finish_item(tr);
        end

        // Clear the counter
        tr = counter_transaction::type_id::create("tr");
        start_item(tr);
        tr.nRST         = 1;
        tr.clear        = 1;
        tr.count_enable = 0;
        tr.overflow_val = 4'd10;
        finish_item(tr);

        // Generate random counter operations
        repeat (100) begin
            tr = counter_transaction::type_id::create("tr");
            start_item(tr);

            if (!tr.randomize() with {
                nRST == 1;
                overflow_val inside {[1:15]};
            })
                `uvm_fatal("SEQ", "Randomization failed")

            finish_item(tr);
        end

    endtask

endclass

