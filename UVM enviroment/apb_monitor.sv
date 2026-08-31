class apb_monitor extends uvm_monitor;

    `uvm_component_utils(apb_monitor)

    virtual apb_if.MON bus;
    uvm_analysis_port#(apb_transaction)mn2sc;

    int count = 0;

    function new(string name = "apb_monitor",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual apb_if.MON)::get(this,"","vif",bus))
            `uvm_fatal("MON","Couldn't get the VIF")
        
        mn2sc = new("mn2sc",this);
    endfunction

    virtual task run_phase (uvm_phase phase);
        apb_transaction tr_in;
        //apb_transaction tr_out;
        `uvm_info("MON","Monitor is starting",UVM_MEDIUM)
        forever begin
            @(bus.mon_cb)
            if(!bus.mon_cb.PRESETn)begin
                tr_in = apb_transaction::type_id::create("tr_in");
                tr_in.PRDATA  = bus.mon_cb.PRDATA;
                tr_in.PREADY  = bus.mon_cb.PREADY;
                tr_in.PSLVERR = bus.mon_cb.PSLVERR;
                tr_in.IRQ     = bus.mon_cb.IRQ;
                tr_in.count_cycles = 0;
                tr_in.PRESETn = bus.mon_cb.PRESETn;
                tr_in.PADDR   = bus.mon_cb.PADDR;
                tr_in.PSEL    = bus.mon_cb.PSEL;
                tr_in.PENABLE = bus.mon_cb.PENABLE;
                tr_in.PWRITE  = bus.mon_cb.PWRITE;
                tr_in.PWDATA  = bus.mon_cb.PWDATA;
                tr_in.PSTRB   = bus.mon_cb.PSTRB;
                mn2sc.write(tr_in);
                count = 0;
                `uvm_info("MON_tr_in",$sformatf("PADDR = %d | PSEL = %d | PENABLE = %d | PWRITE = %d | PWDATA = %d | PSTRB = %d | PRESETn = %d | PRDATA = %d",tr_in.PADDR,tr_in.PSEL,tr_in.PENABLE,tr_in.PWRITE,tr_in.PWDATA,tr_in.PSTRB,tr_in.PRESETn,tr_in.PRDATA),UVM_MEDIUM)
            end
            else begin
                //tr_in.count_cycles++;
                tr_in = apb_transaction::type_id::create("tr_in");
                tr_in.PRDATA  = bus.mon_cb.PRDATA;
                tr_in.PREADY  = bus.mon_cb.PREADY;
                tr_in.PSLVERR = bus.mon_cb.PSLVERR;
                tr_in.IRQ     = bus.mon_cb.IRQ;
                tr_in.count_cycles = count - 1;
                tr_in.PRESETn = bus.mon_cb.PRESETn;
                tr_in.PADDR   = bus.mon_cb.PADDR;
                tr_in.PSEL    = bus.mon_cb.PSEL;
                tr_in.PENABLE = bus.mon_cb.PENABLE;
                tr_in.PWRITE  = bus.mon_cb.PWRITE;
                tr_in.PWDATA  = bus.mon_cb.PWDATA;
                tr_in.PSTRB   = bus.mon_cb.PSTRB;
                mn2sc.write(tr_in);
                count = 0;
            `uvm_info("MON_tr_in",$sformatf("PADDR = %d | PSEL = %d | PENABLE = %d | PWRITE = %d | PWDATA = %d | PSTRB = %d | PRESETn = %d | PRDATA = %d",tr_in.PADDR,tr_in.PSEL,tr_in.PENABLE,tr_in.PWRITE,tr_in.PWDATA,tr_in.PSTRB,tr_in.PRESETn,tr_in.PRDATA),UVM_MEDIUM)
            end
            count ++;
        end
    endtask

    

endclass