`ifndef VERILATOR
module testbench;
  reg [4095:0] vcdfile;
  reg clock;
`else
module testbench(input clock, output reg genclock);
  initial genclock = 1;
`endif
  reg genclock = 1;
  reg [31:0] cycle = 0;
  wire [0:0] PI_clk = clock;
  reg [7:0] PI_wdata;
  reg [0:0] PI_wen;
  reg [9:0] PI_addr;
  testbench UUT (
    .clk(PI_clk),
    .wdata(PI_wdata),
    .wen(PI_wen),
    .addr(PI_addr)
  );
`ifndef VERILATOR
  initial begin
    if ($value$plusargs("vcd=%s", vcdfile)) begin
      $dumpfile(vcdfile);
      $dumpvars(0, testbench);
    end
    #5 clock = 0;
    while (genclock) begin
      #5 clock = 0;
      #5 clock = 1;
    end
  end
`endif
  initial begin
`ifndef VERILATOR
    #1;
`endif
    // UUT.$formal$memory.sv:26$1_CHECK = 1'b0;
    // UUT.$formal$memory.sv:26$1_EN = 1'b0;
    UUT.test_data = 8'b00000000;
    UUT.test_data_valid = 1'b0;
    UUT.test_addr = 10'b1010111101;
    UUT.uut.bank0[8'b10111101] = 8'b10111111;
    UUT.uut.bank0[8'b00000000] = 8'b00000000;
    UUT.uut.bank1[8'b10111101] = 8'b00100011;
    UUT.uut.bank1[8'b00000000] = 8'b00000000;
    UUT.uut.bank2[8'b10111101] = 8'b00100010;
    UUT.uut.bank2[8'b00000000] = 8'b00000000;
    UUT.uut.bank3[8'b10111101] = 8'b00100010;
    UUT.uut.bank3[8'b00000000] = 8'b00000000;

    // state 0
    PI_wdata = 8'b00100011;
    PI_wen = 1'b1;
    PI_addr = 10'b1010111101;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_wdata <= 8'b00000000;
      PI_wen <= 1'b0;
      PI_addr <= 10'b1010111101;
    end

    // state 2
    if (cycle == 1) begin
      PI_wdata <= 8'b00000000;
      PI_wen <= 1'b0;
      PI_addr <= 10'b0000000000;
    end

    genclock <= cycle < 2;
    cycle <= cycle + 1;
  end
endmodule
