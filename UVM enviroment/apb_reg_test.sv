class apb_reg_test extends uvm_test;
    `uvm_component_utils(apb_reg_test)
    enviroment e;
    function new(string name = "apb_reg_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = enviroment::type_id::create("e",this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        apb_sequence_reg seq = apb_sequence_reg::type_id::create("seq");
        phase.raise_objection(this);
        `uvm_info("TEST","Inside Run phase",UVM_DEBUG)
        e.a.d.apply_reset();
        seq.start(e.a.s);
        phase.drop_objection(this);
    endtask 

endclass