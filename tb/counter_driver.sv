

class counter_driver extends uvm_driver #(counter_transaction);

    `uvm_component_utils(counter_driver)

   virtual counter_if#(4) vif; 

    function new(string name = "counter_driver",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

if (!uvm_config_db#(virtual counter_if#(4))::get(
        this, "", "vif", vif)) begin
    `uvm_fatal("NOVIF", "Virtual interface not found")
end
    endfunction

    task run_phase(uvm_phase phase);

        counter_transaction tr;

        forever begin

            seq_item_port.get_next_item(tr);

            @(negedge vif.CLK);

            vif.nRST         <= tr.nRST;
            vif.clear        <= tr.clear;
            vif.count_enable <= tr.count_enable;
            vif.overflow_val <= tr.overflow_val;

            seq_item_port.item_done();

        end

    endtask

endclass
