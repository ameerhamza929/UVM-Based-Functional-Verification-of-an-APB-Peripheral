// This is not a solution , just an example of top 

module top_example;
  logic PCLK = 1'b0;
  always #5ns PCLK = ~PCLK;

  apb_if apb(PCLK);

  apb_peripheral dut (
    .PCLK    (PCLK),
    .PRESETn (apb.PRESETn),
    .PADDR   (apb.PADDR),
    .PSEL    (apb.PSEL),
    .PENABLE (apb.PENABLE),
    .PWRITE  (apb.PWRITE),
    .PWDATA  (apb.PWDATA),
    .PSTRB   (apb.PSTRB),
    .PRDATA  (apb.PRDATA),
    .PREADY  (apb.PREADY),
    .PSLVERR (apb.PSLVERR),
    .IRQ     (apb.IRQ)
  );

  initial begin
    apb.PRESETn = 1'b0;
    apb.PSEL    = 1'b0;
    apb.PENABLE = 1'b0;
    apb.PWRITE  = 1'b0;
    apb.PADDR   = '0;
    apb.PWDATA  = '0;
    apb.PSTRB   = 4'hF;
    repeat (4) @(posedge PCLK);
    apb.PRESETn = 1'b1;
  end
endmodule
