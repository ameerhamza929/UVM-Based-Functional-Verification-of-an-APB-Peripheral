class apb_sequence_smoke extends uvm_sequence#(apb_transaction);
    `uvm_object_utils(apb_sequence_smoke)

    function new(string name = "apb_sequence_smoke");
        super.new(name);
    endfunction

    virtual task body;
        apb_transaction tr;

        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PRESETn = 0;
        finish_item(tr);
        //CTRL REG WRITE
        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PRESETn = 1;
        tr.PADDR = 32'd0;
        tr.PSTRB = 4'b1111;
        tr.PWRITE = 1;
        tr.PWDATA = {27'd0,1'd0,1'd1,1'd0,1'd1};
        tr.PSEL = 1;
        finish_item(tr);
        //INT_EN REG WRITE
        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PRESETn = 1;
        tr.PADDR = 32'd8;
        tr.PWRITE = 1;
        tr.PSTRB = 4'b1111;
        tr.PWDATA = {27'd0,1'd0,1'd0,1'd0,1'd1};
        tr.PSEL = 1;
        finish_item(tr);
        //CTRL REG READ
        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PRESETn = 1;
        tr.PADDR = 12'd0;
        tr.PWRITE = 0;
        tr.PSTRB = 4'b1111;
        tr.PWDATA = {27'd0,1'd0,1'd0,1'd0,1'd1};
        tr.PSEL = 1;
        finish_item(tr);
        //INT_EN REG READ 
        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PRESETn = 1;
        tr.PADDR = 12'd8;
        tr.PWRITE = 0;
        tr.PSTRB = 4'b1111;
        tr.PWDATA = {27'd0,1'd0,1'd1,1'd0,1'd1};
        tr.PSEL = 1;
        finish_item(tr);
        //RAM ACCESS FOR WRITE
        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PRESETn = 1;
        tr.PADDR = 12'h100;
        tr.PWRITE = 1;
        tr.PSTRB = 4'b1111;
        tr.PWDATA = 32'd9;
        tr.PSEL = 1;
        finish_item(tr);

        //RAM ACCESS FOR WRITE
        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PRESETn = 1;
        tr.PADDR = 12'h1FC;
        tr.PWRITE = 1;
        tr.PSTRB = 4'b1111;
        tr.PWDATA = 32'd530;
        tr.PSEL = 1;
        finish_item(tr);

        //RAM ACCESS FOR READ
        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PRESETn = 1;
        tr.PADDR = 12'h100;
        tr.PWRITE = 0;
        tr.PSTRB = 4'b1111;
        tr.PWDATA = 32'd9;
        tr.PSEL = 1;
        finish_item(tr);

        //RAM ACCESS FOR READ
        tr = apb_transaction::type_id::create("tr");
        start_item(tr);
        tr.PRESETn = 1;
        tr.PADDR = 12'h1FC;
        tr.PWRITE = 0;
        tr.PSTRB = 4'b1111;
        tr.PWDATA = 32'd9;
        tr.PSEL = 1;
        finish_item(tr);

    endtask

endclass