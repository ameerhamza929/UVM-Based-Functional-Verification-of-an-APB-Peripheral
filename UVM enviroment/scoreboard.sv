class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    // ============================================================
    // CURRENT MODEL
    // ============================================================

    logic [31:0] ctrl_model;
    logic [31:0] scratch_model;
    logic [31:0] int_en_model;
    logic [31:0] int_status_model;

    // Timer
    logic [31:0] timer_load_model;
    logic [31:0] timer_ctrl_model;
    logic [31:0] timer_value_model;
    logic [31:0] timer_model;

    // RAM
    logic [31:0] ram_model [0:63];

    // FIFO
    logic [31:0] fifo_model [$:7];

    // ============================================================
    // NEXT MODEL
    // ============================================================

    logic [31:0] ctrl_model_next;
    logic [31:0] scratch_model_next;
    logic [31:0] int_en_model_next;
    logic [31:0] int_status_model_next;

    logic [31:0] timer_load_model_next;
    logic [31:0] timer_ctrl_model_next;
    logic [31:0] timer_value_model_next;
    logic [31:0] timer_model_next;

    logic [31:0] ram_model_next [0:63];

    logic [31:0] fifo_model_next [$:7];

    // ============================================================
    // STATUS / OUTPUT MODEL
    // ============================================================

    logic error_model;
    logic [31:0] PRDATA_model;
    logic [3:0] fifo_level;
    logic fifo_full;
    logic fifo_empty;
    logic overflow;
    logic underflow;
    logic IRQ_model;
    logic PSLVERR_model;
    logic valid_write;
    logic valid_read;

    // ============================================================
    // COUNTERS
    // ============================================================

    int countpass = 0;
    int countfail = 0;
    int overflow_count = 0;
    int underflow_count = 0;
    int access_error = 0;

    // ============================================================
    // TRANSACTION SIGNALS
    // ============================================================

    logic PSEL = 0;
    logic PREADY = 0;
    logic PENABLE = 0;
    logic [31:0] PWDATA = 0;
    logic PWRITE = 0;
    logic [31:0] PRDATA = 0;
    logic [11:0] PADDR = 0;

    // ============================================================
    // ADDRESSES
    // ============================================================

    localparam logic [11:0] A_CTRL        = 12'h000;
    localparam logic [11:0] A_STATUS      = 12'h004;
    localparam logic [11:0] A_INT_EN      = 12'h008;
    localparam logic [11:0] A_INT_STATUS  = 12'h00C;
    localparam logic [11:0] A_SCRATCH     = 12'h010;
    localparam logic [11:0] A_TIMER_LOAD  = 12'h014;
    localparam logic [11:0] A_TIMER_CTRL  = 12'h018;
    localparam logic [11:0] A_TIMER_VALUE = 12'h01C;
    localparam logic [11:0] A_FIFO_DATA   = 12'h020;
    localparam logic [11:0] A_FIFO_STATUS = 12'h024;

    uvm_analysis_imp#(apb_transaction,scoreboard) mn2sc;


    function new(string name = "scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction


    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mn2sc = new("mn2sc", this);

        for(int i = 0; i < 64; i++) begin
            ram_model[i] = 0;
            ram_model_next[i] = 0;
        end

        ctrl_model = 0;
        ctrl_model_next = 0;

        scratch_model = 0;
        scratch_model_next = 0;

        int_en_model = 0;
        int_en_model_next = 0;

        int_status_model = 0;
        int_status_model_next = 0;

        timer_load_model = 0;
        timer_load_model_next = 0;

        timer_ctrl_model = 0;
        timer_ctrl_model_next = 0;

        timer_value_model = 0;
        timer_value_model_next = 0;

        timer_model = 0;
        timer_model_next = 0;
    endfunction


    virtual function void write(apb_transaction tr);

        // ========================================================
        // RESET
        // ========================================================

        if(!tr.PRESETn) begin

            ctrl_model = 0;
            ctrl_model_next = 0;

            scratch_model = 0;
            scratch_model_next = 0;

            int_en_model = 0;
            int_en_model_next = 0;

            int_status_model = 0;
            int_status_model_next = 0;

            timer_load_model = 0;
            timer_load_model_next = 0;

            timer_ctrl_model = 0;
            timer_ctrl_model_next = 0;

            timer_value_model = 0;
            timer_value_model_next = 0;

            timer_model = 0;
            timer_model_next = 0;

            for(int i = 0; i < 64; i++) begin
                ram_model[i] = 0;
                ram_model_next[i] = 0;
            end

            fifo_model.delete();
            fifo_model_next.delete();

            overflow_count = 0;
            underflow_count = 0;

            fifo_level = 0;
            fifo_full = 0;
            fifo_empty = 1;

        end


        // ========================================================
        // NORMAL OPERATION
        // ========================================================

        else begin

            // ----------------------------------------------------
            // COMMIT PREVIOUS NEXT STATE
            // ----------------------------------------------------

            ctrl_model = ctrl_model_next;
            scratch_model = scratch_model_next;
            int_en_model = int_en_model_next;
            int_status_model = int_status_model_next;

            timer_load_model = timer_load_model_next;
            timer_ctrl_model = timer_ctrl_model_next;
            timer_value_model = timer_value_model_next;
            timer_model = timer_model_next;

            for(int i = 0; i < 64; i++)
                ram_model[i] = ram_model_next[i];

            fifo_model = fifo_model_next;


            // ----------------------------------------------------
            // DEFAULT NEXT STATE = CURRENT STATE
            // ----------------------------------------------------

            ctrl_model_next = ctrl_model;
            scratch_model_next = scratch_model;
            int_en_model_next = int_en_model;
            int_status_model_next = int_status_model;

            timer_load_model_next = timer_load_model;
            timer_ctrl_model_next = timer_ctrl_model;
            timer_value_model_next = timer_value_model;
            timer_model_next = timer_model;

            for(int i = 0; i < 64; i++)
                ram_model_next[i] = ram_model[i];

            fifo_model_next = fifo_model;


            // ----------------------------------------------------
            // DEFAULTS
            // ----------------------------------------------------

            valid_read = 1'b1;
            valid_write = 1'b1;
            PRDATA_model = 32'h0000_0000;

            PSEL = tr.PSEL;
            PENABLE = tr.PENABLE;
            PREADY = tr.PREADY;
            PWDATA = tr.PWDATA;
            PWRITE = tr.PWRITE;
            PRDATA = tr.PRDATA;
            PADDR = tr.PADDR;


            // ----------------------------------------------------
            // FIFO STATUS
            // ----------------------------------------------------

            fifo_level = fifo_model.size();
            fifo_empty = (fifo_model.size() == 0);
            fifo_full = (fifo_model.size() == 8);


            // ----------------------------------------------------
            // FIFO OVERFLOW / UNDERFLOW
            // ----------------------------------------------------

            if(tr.PSEL && tr.PENABLE && tr.PREADY && fifo_full && tr.PWRITE && tr.PADDR == A_FIFO_DATA)
                overflow_count++;

            if(tr.PSEL && tr.PENABLE && tr.PREADY && fifo_empty && !tr.PWRITE && tr.PADDR == A_FIFO_DATA)
                underflow_count++;

            if(ctrl_model[1] && timer_ctrl_model[0] && !(tr.PADDR == A_TIMER_CTRL && tr.PWRITE && tr.PSEL && tr.PENABLE && tr.PREADY)) begin

                if(timer_model > 1) begin

                    timer_model_next = timer_model - 1;

                end

                else begin

                    timer_model_next = 0;
                    int_status_model_next[0] = 1'b1;

                    if(timer_ctrl_model[1])
                        timer_model_next = timer_load_model;
                    else
                        timer_ctrl_model_next[0] = 1'b0;

                end

            end

            // ====================================================
            // CTRL
            // ====================================================

            if(tr.PSEL && tr.PENABLE && tr.PREADY && tr.PADDR == A_CTRL) begin

                if(tr.PWRITE) begin
                    for(int i = 0; i < 4; i++) begin
                        if(tr.PSTRB[i])
                            ctrl_model_next[i*8 +: 8] = tr.PWDATA[i*8 +: 8];
                    end
                end

                PRDATA_model = {28'b0, ctrl_model[3:0]};

            end


            // ====================================================
            // STATUS
            // ====================================================

            else if(tr.PSEL && tr.PENABLE && tr.PREADY && tr.PADDR == A_STATUS) begin

                valid_write = 1'b0;

                fifo_level = fifo_model.size();
                fifo_empty = (fifo_model.size() == 0);
                fifo_full = (fifo_model.size() == 8);

                PRDATA_model = {27'b0, (|(int_status_model & int_en_model)), fifo_full, fifo_empty, (ctrl_model[1] && timer_ctrl_model[0] && (timer_model != 0)), ctrl_model[0]};

            end


            // ====================================================
            // INT_EN
            // ====================================================

            else if(tr.PSEL && tr.PENABLE && tr.PREADY && tr.PADDR == A_INT_EN) begin

                if(tr.PWRITE) begin
                    for(int i = 0; i < 4; i++) begin
                        if(tr.PSTRB[i])
                            int_en_model_next[i*8 +: 8] = tr.PWDATA[i*8 +: 8];
                    end
                end

                PRDATA_model = {29'b0, int_en_model[2:0]};

            end


            // ====================================================
            // INT_STATUS
            // ====================================================

            else if(tr.PSEL && tr.PENABLE && tr.PREADY && tr.PADDR == A_INT_STATUS) begin

                if(tr.PWRITE) begin
                    for(int i = 0; i < 4; i++) begin
                        if(tr.PSTRB[i])
                            int_status_model_next[i*8 +: 8] = int_status_model[i*8 +: 8] & ~tr.PWDATA[i*8 +: 8];
                    end
                end

                PRDATA_model = {29'b0, int_status_model[2:0]};

            end


            // ====================================================
            // SCRATCH
            // ====================================================

            else if(tr.PSEL && tr.PENABLE && tr.PREADY && tr.PADDR == A_SCRATCH) begin

                if(tr.PWRITE) begin
                    for(int i = 0; i < 4; i++) begin
                        if(tr.PSTRB[i])
                            scratch_model_next[i*8 +: 8] = tr.PWDATA[i*8 +: 8];
                    end
                end

                PRDATA_model = scratch_model;

            end


            // ====================================================
            // FIFO DATA
            // ====================================================

            else if(tr.PSEL && tr.PENABLE && tr.PREADY && tr.PADDR == A_FIFO_DATA) begin

                fifo_level = fifo_model.size();
                fifo_empty = (fifo_model.size() == 0);
                fifo_full = (fifo_model.size() == 8);

                if(!ctrl_model[2]) begin

                    valid_read = 1'b0;
                    valid_write = 1'b0;

                end

                else if(tr.PWRITE) begin

                    if(fifo_full)
                        valid_write = 1'b0;

                    else if(tr.PSTRB != 4'b1111)
                        valid_write = 1'b0;

                    else
                        fifo_model_next.push_front(tr.PWDATA);

                end

                else begin

                    if(fifo_empty) begin

                        valid_read = 1'b0;

                    end

                    else begin

                        PRDATA_model = fifo_model[fifo_model.size()-1];
                        fifo_model_next.pop_back();

                    end

                end

                fifo_level = fifo_model_next.size();
                fifo_empty = (fifo_model_next.size() == 0);
                fifo_full = (fifo_model_next.size() == 8);

            end


            // ====================================================
            // FIFO STATUS
            // ====================================================

            else if(tr.PSEL && tr.PENABLE && tr.PREADY && tr.PADDR == A_FIFO_STATUS) begin

                valid_write = 1'b0;

                fifo_level = fifo_model.size();
                fifo_empty = (fifo_model.size() == 0);
                fifo_full = (fifo_model.size() == 8);

                PRDATA_model = {24'd0, fifo_level, 2'b00, fifo_full, fifo_empty};

            end


            // ====================================================
            // RAM
            // ====================================================

            else if(tr.PSEL && tr.PENABLE && tr.PREADY && tr.PADDR >= 12'h100 && tr.PADDR <= 12'h1FC && tr.PADDR[1:0] == 2'b00) begin

                if(tr.PWRITE) begin
                    for(int b = 0; b < 4; b++) begin
                        if(tr.PSTRB[b])
                            ram_model_next[tr.PADDR[7:2]][b*8 +: 8] = tr.PWDATA[b*8 +: 8];
                    end
                end

                PRDATA_model = ram_model[tr.PADDR[7:2]];

            end


            // ====================================================
            // TIMER LOAD
            // ====================================================

            else if(tr.PSEL && tr.PENABLE && tr.PREADY && tr.PADDR == A_TIMER_LOAD) begin

                if(tr.PWRITE) begin

                    for(int b = 0; b < 4; b++) begin
                        if(tr.PSTRB[b])
                            timer_load_model_next[b*8 +: 8] = tr.PWDATA[b*8 +: 8];
                    end

                    if(!timer_ctrl_model[0])
                        timer_model_next = timer_load_model_next;

                end

                PRDATA_model = timer_load_model;

            end


            // ====================================================
            // TIMER CTRL
            // ====================================================

            else if(tr.PSEL && tr.PENABLE && tr.PREADY && tr.PADDR == A_TIMER_CTRL) begin

                logic [31:0] old_timer_ctrl;

                old_timer_ctrl = timer_ctrl_model;

                if(tr.PWRITE) begin

                    for(int b = 0; b < 4; b++) begin
                        if(tr.PSTRB[b])
                            timer_ctrl_model_next[b*8 +: 8] = tr.PWDATA[b*8 +: 8];
                    end

                    if(timer_ctrl_model_next[0] && !old_timer_ctrl[0])
                        timer_model_next = timer_load_model;

                end

                PRDATA_model = {29'b0, timer_ctrl_model[2:0]};

            end


            // ====================================================
            // TIMER VALUE
            // ====================================================

            else if(tr.PSEL && tr.PENABLE && tr.PREADY && tr.PADDR == A_TIMER_VALUE) begin

                valid_write = 1'b0;
                PRDATA_model = timer_model;

            end


            // ====================================================
            // INVALID ADDRESS
            // ====================================================

            else begin

                valid_read = 1'b0;
                valid_write = 1'b0;
                PRDATA_model = 32'h0000_0000;

            end


            // ====================================================
            // ACCESS ERROR
            // ====================================================

            access_error = tr.PWRITE ? !valid_write : !valid_read;


            // ====================================================
            // TIMER DECREMENT
            // ====================================================

            

        end


        // ========================================================
        // IRQ
        // ========================================================

        IRQ_model = ctrl_model[0] && (|(int_status_model & int_en_model));


        // ========================================================
        // PSLVERR
        // ========================================================

        if(tr.PRESETn) begin

            if(tr.PWRITE)
                PSLVERR_model = (!valid_write && tr.PENABLE && tr.PREADY && tr.PWRITE);
            else
                PSLVERR_model = (!valid_read && tr.PENABLE && tr.PREADY && !tr.PWRITE);

        end

        else
            PSLVERR_model = 1'b0;


        // ========================================================
        // WRITE CHECK
        // ========================================================

        if(tr.PSEL && tr.PENABLE && tr.PREADY && tr.PWRITE) begin

            if((tr.PSLVERR === PSLVERR_model) && (tr.IRQ === IRQ_model)) begin

                `uvm_info("[PASS]", $sformatf("WRITE PASS | PADDR=%h | PWDATA=%h | PSLVERR=%b/%b | IRQ=%b/%b | fifo_level=%d | fifo_empty=%d | fifo_full=%d", tr.PADDR, tr.PWDATA, tr.PSLVERR, PSLVERR_model, tr.IRQ, IRQ_model, fifo_level, fifo_empty, fifo_full), UVM_LOW)

                countpass++;

            end

            else begin

                `uvm_error("[FAIL]", $sformatf("WRITE FAIL | PADDR=%h | PWDATA=%h | PSLVERR DUT=%b EXP=%b | IRQ DUT=%b EXP=%b | ctrl_exp=%h | int_en_model=%h | int_status_model=%h", tr.PADDR, tr.PWDATA, tr.PSLVERR, PSLVERR_model, tr.IRQ, IRQ_model, ctrl_model, int_en_model, int_status_model))

                countfail++;

            end

        end


        // ========================================================
        // READ CHECK
        // ========================================================

        else if(tr.PSEL && tr.PENABLE && tr.PREADY) begin

            if((tr.PRDATA === PRDATA_model) && (tr.PSLVERR === PSLVERR_model) && (tr.IRQ === IRQ_model)) begin

                `uvm_info("[PASS]", $sformatf("READ PASS | PADDR=%h | PRDATA=%h/%h | PSLVERR=%b/%b | IRQ=%b/%b", tr.PADDR, tr.PRDATA, PRDATA_model, tr.PSLVERR, PSLVERR_model, tr.IRQ, IRQ_model), UVM_LOW)

                countpass++;

            end

            else begin

                `uvm_error("[FAIL]", $sformatf("READ FAIL | PADDR=%h | PRDATA DUT=%h EXP=%h | PSLVERR DUT=%b EXP=%b | IRQ DUT=%b EXP=%b", tr.PADDR, tr.PRDATA, PRDATA_model, tr.PSLVERR, PSLVERR_model, tr.IRQ, IRQ_model))

                countfail++;

            end

        end


        // ========================================================
        // DEBUG
        // ========================================================

        //`uvm_info("SC", $sformatf("CURRENT: timer=%d | timer_next=%d | ctrl[1]=%b | timer_ctrl[0]=%b | PSEL=%b | PENABLE=%b | PREADY=%b | PADDR=%h", timer_model, timer_model_next, ctrl_model[1], timer_ctrl_model[0], tr.PSEL, tr.PENABLE, tr.PREADY, tr.PADDR), UVM_LOW)

    endfunction


    // ============================================================
    // REPORT
    // ============================================================

    virtual function void report_phase(uvm_phase phase);

        `uvm_info("SC", "FINAL REPORT", UVM_LOW)
        `uvm_info("SC", $sformatf("NO. of Passes = %d", countpass), UVM_LOW)
        `uvm_info("SC", $sformatf("NO. of FAILS = %d", countfail), UVM_LOW)
        `uvm_info("SC", $sformatf("NO. of Overflows = %d", overflow_count), UVM_LOW)
        `uvm_info("SC", $sformatf("NO. of Underflows = %d", underflow_count), UVM_LOW)

    endfunction

endclass