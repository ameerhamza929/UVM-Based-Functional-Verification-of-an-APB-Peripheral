class enviroment extends uvm_env;
    `uvm_component_utils(enviroment)

    function new(string name = "enviroment",uvm_component parent);
        super.new(name,parent);
    endfunction

    agent a;
    scoreboard sc;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        a = agent::type_id::create("a",this);
        sc = scoreboard::type_id::create("sc",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        a.m.mn2sc.connect(sc.mn2sc);
    endfunction

    

endclass