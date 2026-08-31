`include "uvm_macros.svh"
import uvm_pkg::*;
class apb_transaction extends uvm_sequence_item;
    `uvm_object_utils(apb_transaction)

    function new(string name = "apb_transaction");
        super.new(name);
    endfunction

    logic        PRESETn;
    rand logic [11:0] PADDR;
    logic        PSEL;
    logic        PENABLE;
    rand logic        PWRITE;
    randc logic [31:0] PWDATA;
    rand logic [3:0]  PSTRB;
    logic [31:0] PRDATA;
    logic        PREADY;
    logic        PSLVERR;
    logic        IRQ;
    logic [31:0] count_cycles = 0;

    constraint c_reg_addr{ PADDR inside {[12'h000:12'h1C]};
                            PADDR[1:0]==2'b00;  }

    constraint c_fifo_addr {PADDR inside {[12'h020:12'h024]};
                             PADDR[1:0]==2'b00;}

    constraint c_ram_addr {PADDR inside {[12'h100:12'h1FC]};
                                PADDR[1:0]==2'b00;}

    constraint c_read_only {
    (PADDR == 12'h004 || PADDR == 12'h01C || PADDR == 12'h024) -> PWRITE == 1'b0;
    }

    constraint c_illegal_addr{ PADDR > 12'h1FC; }
    
    
endclass
