class agent extends uvm_agent;
    `uvm_component_utils(agent)

    function new(string name = "agent", uvm_component parent);
        super.new(name,parent);
    endfunction

    apb_driver d;
    apb_monitor m;
    uvm_sequencer #(apb_transaction) s;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        s = uvm_sequencer#(apb_transaction)::type_id::create("s",this);
        m = apb_monitor::type_id::create("m",this);
        d = apb_driver::type_id::create("d",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        d.seq_item_port.connect(s.seq_item_export); 
    endfunction

endclass