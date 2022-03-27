module demo (
  input clk,
  input [3:0] a,b,
  output [7:0] result
);

//  always @(posedge clk)
  //  result <= a * b;

 assign result = a * b;

`ifdef FORMAL
  always @(posedge clk) begin
    cover (result == 8'd182);
    assert(result == (a * b) );
  end
`endif
endmodule
