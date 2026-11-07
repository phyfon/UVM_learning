class counter_test extends uvm_test;

    `uvm_component_utils(counter_test)

    counter_env env;

    function new(string name = "counter_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        env = counter_env::type_id::create(
            "env", this);

    endfunction

    virtual function counter_sequence create_sequence();
    	return counter_sequence::type_id::create("seq");
    endfunction

    task run_phase(uvm_phase phase);

        counter_sequence seq;

        phase.raise_objection(this);
        seq = create_sequence();
        if (seq == null)
            `uvm_fatal("NULL_SEQ", "Test failed to create its sequence")
       

        seq.start(env.agent.sequencer);

        #100;

        phase.drop_objection(this);

    endtask

endclass
