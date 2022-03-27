module testbench(
       input       clk,
       input i_valid,
       input [7:0] dividend,
       input [7:0] divisor
       );

   reg [7:0]       cycle ,i_valid_count, o_valid_count;
   
       reg rst;

       reg [7:0] a;
       reg [7:0] b;

       wire busy,o_valid;
       wire [7:0] q,rem;

       initial rst = 1;
       initial cycle = 0;
       initial begin
          i_valid_count = 0;
          o_valid_count = 0;
       end

       divider uut( clk,rst,dividend,divisor,i_valid,
                    busy,q,rem,o_valid);

       always @(posedge clk) begin
         cycle <= cycle + 1;
         if (cycle > 10)
           rst <= 0;
       end

       always @(posedge clk) begin
          assume(!(i_valid & busy));
          
          assume(!(rst & i_valid));
          assume(!(i_valid & o_valid));
          //cover(i_valid_count > 10);
          cover(q == 8);
          
          assume(divisor > 0);
          assume(o_valid_count <= i_valid_count);
          
          if (i_valid) i_valid_count <= i_valid_count + 1;
          if (o_valid) o_valid_count <= o_valid_count + 1;
       end
      
       always @(posedge clk)
         if (!rst) begin

           //cover(o_valid);

           if (i_valid) begin
              a <= dividend;
              b <= divisor;
           end

           if (o_valid) begin
             assert( (a) == (q*b + rem ));
           end

       end

endmodule
