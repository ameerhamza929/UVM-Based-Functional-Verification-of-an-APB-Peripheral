class apb_error_sequence extends uvm_sequence#(apb_transaction);
    `uvm_object_utils(apb_error_sequence)

    function new(string name = "apb_error_sequence");
        super.new(name);
    endfunction

    virtual task body();
        apb_transaction tr;
        //Illegal addr;
        for(int i = 0; i<10; i++)begin
            tr = apb_transaction::type_id::create("tr");
            start_item(tr);
            tr.c_reg_addr.constraint_mode(0);
            tr.c_ram_addr.constraint_mode(0);
            tr.c_fifo_addr.constraint_mode(0);
            void'(tr.randomize());
            tr.PRESETn = 1;
            tr.PSEL = 1;
            finish_item(tr);
        end

        //write on read-only
        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PADDR = 12'h004;
        tr.PWDATA = {29'd0,3'b111};
        tr.PSTRB = 4'b1111;
        tr.PRESETn = 1;
        tr.PSEL = 1;
        tr.PWRITE = 1;    
        finish_item(tr);

        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PADDR = 12'h004;
        tr.PWDATA = {29'd0,3'b111};
        tr.PSTRB = 4'b1111;
        tr.PRESETn = 1;
        tr.PSEL = 1;
        tr.PWRITE = 1;    
        finish_item(tr);      

        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PADDR = 12'h024;
        tr.PWDATA = {29'd0,3'b111};
        tr.PSTRB = 4'b1111;
        tr.PRESETn = 1;
        tr.PSEL = 1;
        tr.PWRITE = 1;    
        finish_item(tr);   

        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PADDR = 12'h020;
        tr.PWDATA = {29'd0,3'b111};
        tr.PSTRB = 4'b1111;
        tr.PRESETn = 1;
        tr.PSEL = 1;
        tr.PWRITE = 1;    
        finish_item(tr); 
        

    endtask

endclass