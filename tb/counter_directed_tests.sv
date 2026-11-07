
class counter_reset_test extends counter_test;
    `uvm_component_utils(counter_reset_test)

    function new(string name = "counter_reset_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function counter_sequence create_sequence();
        return counter_reset_sequence::type_id::create("seq");
    endfunction
endclass

class counter_count_test extends counter_test;
    `uvm_component_utils(counter_count_test)

    function new(string name = "counter_count_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function counter_sequence create_sequence();
        return counter_count_sequence::type_id::create("seq");
    endfunction
endclass

class counter_clear_test extends counter_test;
    `uvm_component_utils(counter_clear_test)

    function new(string name = "counter_clear_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function counter_sequence create_sequence();
        return counter_clear_sequence::type_id::create("seq");
    endfunction
endclass

class counter_overflow_test extends counter_test;
    `uvm_component_utils(counter_overflow_test)

    function new(string name = "counter_overflow_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function counter_sequence create_sequence();
        return counter_overflow_sequence::type_id::create("seq");
    endfunction
endclass

