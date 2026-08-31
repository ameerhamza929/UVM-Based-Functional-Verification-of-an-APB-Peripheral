class apb_fifo_sequence extends uvm_sequence#(apb_transaction);

    `uvm_object_utils(apb_fifo_sequence)

    function new(string name = "apb_fifo_sequence");
        super.new(name);
    endfunction

    virtual task body();
        apb_transaction tr;
        
        tr= apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.c_reg_addr.constraint_mode(0);
        tr.c_ram_addr.constraint_mode(0);
        tr.c_illegal_addr.constraint_mode(0);
        void'(tr.randomize());
        tr.PRESETn = 1;
        tr.PSEL = 1;
        tr.PADDR = 12'h000;
        tr.PWDATA = {28'd0,4'b1111};
        tr.PWRITE = 1'b1;
        tr.PSTRB = 4'b1111;
        finish_item(tr);


        for(int i = 0; i<1000; i++)begin
            tr= apb_transaction::type_id::create("tr");
            start_item(tr);
            tr.c_reg_addr.constraint_mode(0);
            tr.c_ram_addr.constraint_mode(0);
            tr.c_illegal_addr.constraint_mode(0);
            void'(tr.randomize());
            tr.PRESETn = 1;
            tr.PSEL = 1;
            tr.PSTRB = 4'b1111;
            //tr.PADDR = 12'h020;
            finish_item(tr);
        end
        for(int i = 0; i<12; i++)begin
            tr= apb_transaction::type_id::create("tr");
            start_item(tr);
            tr.c_reg_addr.constraint_mode(0);
            tr.c_ram_addr.constraint_mode(0);
            tr.c_illegal_addr.constraint_mode(0);
            void'(tr.randomize());
            tr.PRESETn = 1;
            tr.PSEL = 1;
            tr.PWRITE = 1;
            tr.PSTRB = 4'b1111;
            tr.PADDR = 12'h020;
            finish_item(tr);
        end

        start_item(tr);
            tr.c_reg_addr.constraint_mode(0);
            tr.c_ram_addr.constraint_mode(0);
            tr.c_illegal_addr.constraint_mode(0);
            void'(tr.randomize());
            tr.PRESETn = 1;
            tr.PSEL = 1;
            tr.PWRITE = 0;
            tr.PADDR = 12'h024;
        finish_item(tr);
    
    endtask 


endclass