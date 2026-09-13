class counter_transaction extends uvm_sequence_item;

    rand bit nRST;
    rand bit clear;
    rand bit count_enable;
    rand bit [3:0] overflow_val;

    `uvm_object_utils_begin(counter_transaction)
        `uvm_field_int(nRST, UVM_ALL_ON)
        `uvm_field_int(clear, UVM_ALL_ON)
        `uvm_field_int(count_enable, UVM_ALL_ON)
        `uvm_field_int(overflow_val, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "counter_transaction");
        super.new(name);
    endfunction

endclass