class apb_sequence_reg extends uvm_sequence#(apb_transaction);
    `uvm_object_utils(apb_sequence_reg)

    function new(string name = "apb_sequence_reg");
        super.new(name);
    endfunction

    virtual task body();
        apb_transaction tr;
        for(int i = 0; i<100; i++)begin
            tr = apb_transaction::type_id::create("tr");
            start_item(tr);
            tr.PRESETn = 1;
            tr.PSEL = 1;
            tr.c_ram_addr.constraint_mode(0);
            tr.c_fifo_addr.constraint_mode(0);
            tr.c_illegal_addr.constraint_mode(0);
            void'(tr.randomize());
            finish_item(tr);
        end
        
    endtask

endclass