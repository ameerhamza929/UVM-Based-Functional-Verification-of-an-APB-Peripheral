class apb_ram_sequence extends uvm_sequence#(apb_transaction);

    `uvm_object_utils(apb_ram_sequence)

    function new(string name = "apb_ram_sequence");
        super.new(name);
    endfunction

    virtual task body();
        apb_transaction tr;

        for(int i = 0; i<200;i++)begin
            tr= apb_transaction::type_id::create("tr");
            start_item(tr);
            tr.c_reg_addr.constraint_mode(0);
            tr.c_fifo_addr.constraint_mode(0);
            tr.c_illegal_addr.constraint_mode(0);
            void'(tr.randomize());
            tr.PSEL = 1'b1;
            tr.PRESETn = 1;
            finish_item(tr);
        end

    endtask

endclass