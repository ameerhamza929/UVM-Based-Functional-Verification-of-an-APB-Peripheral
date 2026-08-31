class apb_timer_sequence extends uvm_sequence#(apb_transaction);
    `uvm_object_utils(apb_timer_sequence)

    function new(string name = "apb_timer_sequence");
        super.new(name);
    endfunction

    virtual task body();
        apb_transaction tr;
        // ONE SHOT
        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PADDR = 12'h000;
        tr.PWDATA = {28'd0,4'b1111};
        tr.PSTRB = 4'b1111;
        tr.PRESETn = 1;
        tr.PSEL = 1;
        tr.PWRITE = 1;
        finish_item(tr);

        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PADDR = 12'h014;
        tr.PWDATA = 7;
        tr.PSTRB = 4'b1111;
        tr.PRESETn = 1;
        tr.PSEL = 1;
        tr.PWRITE = 1;
        finish_item(tr);

        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PADDR = 12'h018;
        tr.PWDATA = {29'd0,3'b101};
        tr.PSTRB = 4'b1111;
        tr.PRESETn = 1;
        tr.PSEL = 1;
        tr.PWRITE = 1;
        finish_item(tr);

        for(int i = 0;i<5;i++)begin
            tr = apb_transaction::type_id::create("tr");
            start_item(tr);
            tr.PADDR = 12'h01C;
            tr.PWDATA = {29'd0,3'b000};
            tr.PSTRB = 4'b1111;
            tr.PRESETn = 1;
            tr.PSEL = 1;
            tr.PWRITE = 0;
            finish_item(tr);
        end
         //PERIODIC

        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PADDR = 12'h014;
        tr.PWDATA = 9;
        tr.PSTRB = 4'b1111;
        tr.PRESETn = 1;
        tr.PSEL = 1;
        tr.PWRITE = 1;
        finish_item(tr);

        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PADDR = 12'h018;
        tr.PWDATA = {29'd0,3'b111};
        tr.PSTRB = 4'b1111;
        tr.PRESETn = 1;
        tr.PSEL = 1;
        tr.PWRITE = 1;
        finish_item(tr);

        for(int i = 0;i<9;i++)begin
            tr = apb_transaction::type_id::create("tr");
            start_item(tr);
            tr.PADDR = 12'h01C;
            tr.PWDATA = {29'd0,3'b000};
            tr.PSTRB = 4'b1111;
            tr.PRESETn = 1;
            tr.PSEL = 1;
            tr.PWRITE = 0;
            finish_item(tr);
        end

        //start/stop/restart

        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PADDR = 12'h014;
        tr.PWDATA = 110;
        tr.PSTRB = 4'b1111;
        tr.PRESETn = 1;
        tr.PSEL = 1;
        tr.PWRITE = 1;
        finish_item(tr);

        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PADDR = 12'h018;
        tr.PWDATA = {29'd0,3'b111};
        tr.PSTRB = 4'b1111;
        tr.PRESETn = 1;
        tr.PSEL = 1;
        tr.PWRITE = 1;
        finish_item(tr);

        for(int i = 0;i<20;i++)begin
            tr = apb_transaction::type_id::create("tr");
            start_item(tr);
            tr.PADDR = 12'h01C;
            tr.PWDATA = {29'd0,3'b000};
            tr.PSTRB = 4'b1111;
            tr.PRESETn = 1;
            tr.PSEL = 1;
            tr.PWRITE = 0;
            finish_item(tr);
        end

        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PADDR = 12'h018;
        tr.PWDATA = {29'd0,3'b110};
        tr.PSTRB = 4'b1111;
        tr.PRESETn = 1;
        tr.PSEL = 1;
        tr.PWRITE = 1;
        finish_item(tr);

        for(int i = 0; i<9; i++)begin
            tr = apb_transaction::type_id::create("tr");
            start_item(tr);
            tr.PADDR = 12'h01C;
            tr.PWDATA = {29'd0,3'b000};
            tr.PSTRB = 4'b1111;
            tr.PRESETn = 1;
            tr.PSEL = 1;
            tr.PWRITE = 0;
            finish_item(tr);
        end

        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PADDR = 12'h018;
        tr.PWDATA = {29'd0,3'b111};
        tr.PSTRB = 4'b1111;
        tr.PRESETn = 1;
        tr.PSEL = 1;
        tr.PWRITE = 1;
        finish_item(tr);

        for(int i = 0;i<9;i++)begin
            tr = apb_transaction::type_id::create("tr");
            start_item(tr);
            tr.PADDR = 12'h01C;
            tr.PWDATA = {29'd0,3'b000};
            tr.PSTRB = 4'b1111;
            tr.PRESETn = 1;
            tr.PSEL = 1;
            tr.PWRITE = 0;
            finish_item(tr);
        end

        


    endtask

endclass