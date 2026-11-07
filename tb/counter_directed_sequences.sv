// The base class inherits counter_sequence so the existing counter_test can
// select any directed sequence through a common return type.
class counter_directed_sequence extends counter_sequence;
    `uvm_object_utils(counter_directed_sequence)

    function new(string name = "counter_directed_sequence");
        super.new(name);
    endfunction

    // Arguments: reset release, clear, count enable, overflow threshold.
    // Each call drives one complete clock cycle via counter_driver.
    task automatic drive_step(bit rst_n, bit clr, bit enable,
                              bit [3:0] threshold);
        counter_transaction tr;
        tr = counter_transaction::type_id::create("tr");
        start_item(tr);
        tr.nRST         = rst_n;
        tr.clear        = clr;
        tr.count_enable = enable;
        tr.overflow_val = threshold;
        finish_item(tr);
    endtask

    virtual task body();
        `uvm_fatal("DIRECTED_BASE", "Start a concrete directed sequence")
    endtask
endclass


// Reset has priority over clear/count; verify reset from nonzero count,
// including a point where overflow_flag was previously asserted.
class counter_reset_sequence extends counter_directed_sequence;
    `uvm_object_utils(counter_reset_sequence)

    function new(string name = "counter_reset_sequence");
        super.new(name);
    endfunction

    virtual task body();
        drive_step(0, 0, 0, 4'd3);         // initial reset
        drive_step(0, 1, 1, 4'd3);         // reset dominates clear + enable
        repeat (3) drive_step(1, 0, 1, 4'd3); // 1,2,3; overflow_flag=1 at 3
        drive_step(0, 0, 0, 4'd3);         // reset from nonzero + overflow high
        drive_step(0, 1, 1, 4'd3);         // remain reset despite other controls
        drive_step(1, 0, 0, 4'd3);         // hold zero after reset release
        drive_step(1, 0, 1, 4'd3);         // restart counting from one
	drive_step(0, 0, 0, 4'd0); 	// reset: count=0, overflow_flag=0
	drive_step(1, 0, 0, 4'd0); 	// hold 0: overflow_flag becomes 1
    endtask
endclass


// Counting, pause/resume, and the fact that overflow_flag is recomputed
// even when count_enable=0 and overflow_val changes.
class counter_count_sequence extends counter_directed_sequence;
    `uvm_object_utils(counter_count_sequence)

    function new(string name = "counter_count_sequence");
        super.new(name);
    endfunction

    virtual task body();
        drive_step(0, 0, 0, 4'd10);           // reset
        repeat (5) drive_step(1, 0, 1, 4'd10); // count 1..5
        repeat (3) drive_step(1, 0, 0, 4'd10); // hold 5
        repeat (2) drive_step(1, 0, 1, 4'd10); // resume: 6,7
        drive_step(1, 0, 0, 4'd7);            // hold 7; overflow_flag=1
        drive_step(1, 0, 0, 4'd8);            // hold 7; overflow_flag=0
        drive_step(1, 0, 1, 4'd10);           // increment to 8
        drive_step(1, 0, 0, 4'd10);           // hold 8
    endtask
endclass


// Clear from nonzero values, with count_enable high or low. Also verify
// clear when overflow_flag was set and the special threshold-zero case.
class counter_clear_sequence extends counter_directed_sequence;
    `uvm_object_utils(counter_clear_sequence)

    function new(string name = "counter_clear_sequence");
        super.new(name);
    endfunction

    virtual task body();
        drive_step(0, 0, 0, 4'd7);             // reset
        repeat (4) drive_step(1, 0, 1, 4'd7); // count to 4
        drive_step(1, 1, 0, 4'd7);             // clear when counting disabled
        repeat (2) drive_step(1, 0, 1, 4'd7); // count to 2
        drive_step(1, 1, 1, 4'd7);             // clear overrides count enable
        drive_step(1, 0, 0, 4'd7);             // hold at zero
        repeat (7) drive_step(1, 0, 1, 4'd7); // reach 7; overflow_flag=1
        drive_step(1, 1, 1, 4'd7);             // clear removes overflow flag
        drive_step(1, 1, 0, 4'd0);             // zero threshold: flag = 1
        drive_step(1, 0, 0, 4'd0);             // hold zero: flag remains 1
        drive_step(1, 0, 1, 4'd0);             // count to 1: flag = 0
    endtask
endclass


// Normal wraparound, boundary thresholds 1 and 15, dynamic threshold
// changes, and the edge case overflow_val=0.
class counter_overflow_sequence extends counter_directed_sequence;
    `uvm_object_utils(counter_overflow_sequence)

    function new(string name = "counter_overflow_sequence");
        super.new(name);
    endfunction

    virtual task body();
        drive_step(0, 0, 0, 4'd4);             // reset
        repeat (4) drive_step(1, 0, 1, 4'd4); // 1,2,3,4: flag=1 at 4
        drive_step(1, 0, 0, 4'd4);             // hold at 4: flag stays 1
        drive_step(1, 0, 1, 4'd4);             // wrap 4 -> 1: flag clears
        repeat (2) drive_step(1, 0, 1, 4'd4); // 2,3
        drive_step(1, 0, 0, 4'd3);             // hold 3, threshold=3: flag=1
        drive_step(1, 0, 0, 4'd4);             // hold 3, threshold=4: flag=0

	drive_step(1, 0, 0, 4'd2); // hold 3 even though threshold is 2
	drive_step(1, 0, 1, 4'd2); // count 3 -> 1 because 4 > 2
	drive_step(1, 0, 1, 4'd2); // count 1 -> 2, overflow_flag=1
	drive_step(1, 0, 1, 4'd2); // count 2 -> 1, overflow_flag=0

        drive_step(1, 1, 0, 4'd1);             // clear to zero
        repeat (3) drive_step(1, 0, 1, 4'd1); // 1 -> 1 -> 1: flag stays 1

        drive_step(0, 0, 0, 4'd15);            // reset
        repeat (15) drive_step(1, 0, 1, 4'd15); // 1..15: flag=1 at 15
        drive_step(1, 0, 1, 4'd15);            // wrap 15 -> 1: flag=0

        drive_step(1, 1, 0, 4'd0);             // clear to 0: flag=1
        drive_step(1, 0, 1, 4'd0);             // count to 1: flag=0
    endtask
endclass

