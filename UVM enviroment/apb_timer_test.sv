class apb_timer_test extends uvm_test;
    `uvm_component_utils(apb_timer_test)
    enviroment e;
    function new(string name = "apb_timer_test",uvm_component parent);
        super.new(name,parent);
        
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = enviroment::type_id::create("e",this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        apb_timer_sequence seq = apb_timer_sequence::type_id::create("seq");
        phase.raise_objection(this);
        e.a.d.apply_reset();
        seq.start(e.a.s);
        phase.drop_objection(this);
    endtask



endclass