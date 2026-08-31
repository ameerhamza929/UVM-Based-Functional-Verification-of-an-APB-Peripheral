interface apb_if(input logic PCLK);

  timeunit 1ns;
  timeprecision 1ps;

  logic        PRESETn;
  logic [11:0] PADDR;
  logic        PSEL;
  logic        PENABLE;
  logic        PWRITE;
  logic [31:0] PWDATA;
  logic [3:0]  PSTRB;
  logic [31:0] PRDATA;
  logic        PREADY;
  logic        PSLVERR;
  logic        IRQ;

  clocking drv_cb @(posedge PCLK);
   // default input #1step output #1step;
    output PADDR, PSEL, PENABLE, PWRITE, PWDATA, PSTRB, PRESETn;
    input  PRDATA, PREADY, PSLVERR, IRQ;
  endclocking

  clocking mon_cb @(posedge PCLK);
   // default input #2ns;
    input PRESETn, PADDR, PSEL, PENABLE, PWRITE, PWDATA, PSTRB;
    input PRDATA, PREADY, PSLVERR, IRQ;
  endclocking

  modport DUT (
    input  PCLK, PRESETn, PADDR, PSEL, PENABLE, PWRITE, PWDATA, PSTRB,
    output PRDATA, PREADY, PSLVERR, IRQ
  );

  modport TB(
    input PCLK,PRDATA, PREADY, PSLVERR, IRQ,
    output  PRESETn, PADDR, PSEL, PENABLE, PWRITE, PWDATA, PSTRB,
    clocking drv_cb
  );

  modport MON(
    clocking mon_cb
  );

endinterface
