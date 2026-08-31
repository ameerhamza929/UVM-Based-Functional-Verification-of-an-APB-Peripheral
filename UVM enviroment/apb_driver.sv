class apb_driver extends uvm_driver#(apb_transaction);

    `uvm_component_utils(apb_driver)

    function new(string name ="apb_driver",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual apb_if.TB bus;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual apb_if.TB)::get(this,"","bus",bus))
            `uvm_fatal("DRV","Couldn't get VIF")
    endfunction

    /*virtual task reset_phase (uvm_phase phase);
        //super.reset_phase(reset_phase);
        bus.drv_cb.PRESETn <= 0;
        `uvm_info("DRV","Entering RESET",UVM_MEDIUM)
        repeat(3)begin
            @(bus.drv_cb);
            `uvm_info("RESET",
                  $sformatf("Reset cycle @ %0t", $time),
                  UVM_MEDIUM)
        end
        bus.drv_cb.PRESETn <= 1;
    endtask*/

    virtual task run_phase(uvm_phase phase);
        forever begin
            apb_transaction tr;
            seq_item_port.get_next_item(tr);
            drive_item(tr);
            seq_item_port.item_done();  
        end
    endtask

    task apply_reset();
        bus.drv_cb.PRESETn <= 0;
        `uvm_info("DRV","Entering RESET",UVM_MEDIUM)
        repeat(3)begin
            @(bus.drv_cb);
            `uvm_info("RESET",
                  $sformatf("Reset cycle @ %0t", $time),
                  UVM_MEDIUM)
        end
        bus.drv_cb.PRESETn <= 1;
    endtask


    task drive_item(apb_transaction tr);
        @(bus.drv_cb)
        bus.drv_cb.PADDR <= tr.PADDR;
        bus.drv_cb.PSEL  <= tr.PSEL; 
        bus.drv_cb.PENABLE <= 0;
        bus.drv_cb.PWRITE <= tr.PWRITE;
        bus.drv_cb.PWDATA <= tr.PWDATA;
        bus.drv_cb.PSTRB  <= tr.PSTRB;
        bus.drv_cb.PRESETn <= tr.PRESETn;
        `uvm_info("DRV",$sformatf("The INTERFACE items currently are PADDR = %d | PSEL = %d | PENABLE = %d | PWRITE = %d | PWDATA = %d | PSTRB = %d | PRESETn = %d| PWDATA = %d | PRDATA = %d ",tr.PADDR,tr.PSEL,tr.PENABLE,tr.PWRITE,tr.PWDATA,tr.PSTRB,tr.PRESETn,tr.PWDATA,tr.PRDATA),UVM_HIGH)
        @(bus.drv_cb)
        bus.drv_cb.PENABLE <= 1;
        `uvm_info("DRV",$sformatf("The INTERFACE items currently are PADDR = %d | PSEL = %d | PENABLE = %d | PWRITE = %d | PWDATA = %d | PSTRB = %d | PRESETn = %d| PWDATA = %d | PRDATA = %d ",tr.PADDR,tr.PSEL,tr.PENABLE,tr.PWRITE,tr.PWDATA,tr.PSTRB,tr.PRESETn,tr.PWDATA,tr.PRDATA),UVM_HIGH)
        // Wait until PREADY becomes 1
        while (!bus.drv_cb.PREADY)begin
            @(bus.drv_cb);
            `uvm_info("DRV", "Wait until ready is high", UVM_HIGH)
        end

        // Transfer complete
        bus.drv_cb.PENABLE <= 0;
        `uvm_info("DRV",$sformatf("The INTERFACE items currently are PADDR = %d | PSEL = %d | PENABLE = %d | PWRITE = %d | PWDATA = %d | PSTRB = %d | PRESETn = %d| PWDATA = %d | PRDATA = %d ",tr.PADDR,tr.PSEL,tr.PENABLE,tr.PWRITE,tr.PWDATA,tr.PSTRB,tr.PRESETn,tr.PWDATA,tr.PRDATA),UVM_HIGH)

    endtask

   

endclass