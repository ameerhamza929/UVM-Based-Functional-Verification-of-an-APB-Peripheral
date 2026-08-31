module top;

    timeunit 1ns;
    timeprecision 1ps;
    import uvm_pkg::*;
    import tb_pkg::*;

    logic PCLK = 0;
    //apb_smoke_test t;

    always #5 PCLK = ~PCLK;

    apb_if bus(.PCLK);

    apb_peripheral dut (
    .PCLK    (bus.DUT.PCLK),
    .PRESETn (bus.DUT.PRESETn),
    .PADDR   (bus.DUT.PADDR),
    .PSEL    (bus.DUT.PSEL),
    .PENABLE (bus.DUT.PENABLE),
    .PWRITE  (bus.DUT.PWRITE),
    .PWDATA  (bus.DUT.PWDATA),
    .PSTRB   (bus.DUT.PSTRB),
    .PRDATA  (bus.DUT.PRDATA),
    .PREADY  (bus.DUT.PREADY),
    .PSLVERR (bus.DUT.PSLVERR),
    .IRQ     (bus.DUT.IRQ)
  );


    initial begin
        //t = apb_smoke_test::type_id::create("t",this);
        uvm_config_db#(virtual apb_if.TB)::set(null,"uvm_test_top.e.a.*","bus",bus.TB);
        uvm_config_db#(virtual apb_if.MON)::set(null,"uvm_test_top.e.a.*","vif",bus.MON);
        //run_test("apb_smoke_test");
        //run_test("apb_reg_test");
        //run_test("apb_fifo_test");
        //run_test("apb_ram_test");
        //run_test("apb_timer_test");
        run_test("apb_error_test");
    end


endmodule