class counter_monitor extends uvm_monitor;

    `uvm_component_utils(counter_monitor)

    virtual counter_if vif;

    uvm_analysis_port #(counter_transaction) ap;

    function new(string name = "counter_monitor",
                 uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual counter_if)::get(
                this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF",
                       "Virtual interface not found")
        end
    endfunction

    task run_phase(uvm_phase phase);

        counter_transaction tr;

        forever begin

            @(posedge vif.CLK);

            tr = counter_transaction::type_id::create("tr");

            tr.nRST          = vif.nRST;
            tr.clear         = vif.clear;
            tr.count_enable  = vif.count_enable;
            tr.overflow_val  = vif.overflow_val;

            tr.count_out     = vif.count_out;
            tr.overflow_flag = vif.overflow_flag;

            ap.write(tr);

        end

    endtask

endclass