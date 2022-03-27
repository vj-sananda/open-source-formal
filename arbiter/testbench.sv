module testbench (
  input clk
);

  reg  rst;
  reg [12:0] count;
  reg [3:0] past_gnt;
   
  initial rst = 1;
  initial count = 0;

  always @(posedge clk) begin
      count <= count + 1;
      if (count > 6)
        rst <= 0;
   end
   
  wire [3:0] req;
  wire [3:0] gnt;

  assign req = 4'b1111;
   
  arbiter uut (
    .clk  (clk  ),
    .rst  (rst  ),
    .req (req ),
    .gnt(gnt)
  );

   always @(posedge clk) begin
      past_gnt <= gnt;
      
     if (!rst && count > 10) begin
        cover(gnt == 4'b1000);
        
        case(past_gnt)
          4'b0001: assert(gnt == 4'b0010);
          4'b0010: assert(gnt == 4'b0100);
          4'b0100: assert(gnt == 4'b1000);
          4'b1000: assert(gnt == 4'b0001);
        endcase // case ($past(gnt))
     end
   end // always @ (posedge clk)
   
endmodule
