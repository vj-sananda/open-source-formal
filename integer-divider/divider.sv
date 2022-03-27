// Code your design here
module divider(
       input            clk,rst,
       input [7:0]      dividend,
       input [7:0]      divisor,
       input            i_valid,
       output           busy,
       output reg [7:0] q,
       output reg [7:0] rem,
       output reg       o_valid);

       reg [7:0]     dividend_remaining, divisor_r  ;
   

       reg start_division;
       assign busy = start_division;

       always @(posedge clk)
           if (rst) begin
            q <= 0;
            rem <= 0;
            start_division <= 0;
              o_valid <= 0;
           end
           else begin
           o_valid <= 0;

           if (i_valid) begin
             dividend_remaining <= dividend;
             divisor_r <= divisor;
             start_division <= 1;
             q <= 0;
           end

           if (start_division) begin
             if ( dividend_remaining < divisor_r ) begin
                 start_division <= 0;
                 rem <= dividend_remaining;
                 o_valid <= 1;
              end
              else begin
                 dividend_remaining <= dividend_remaining - divisor_r;
                 q <= q + 1;
              end
           end

           end

endmodule

