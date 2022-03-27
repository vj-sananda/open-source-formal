//emits first 1 at lowest priority position
module priority_encode

  ( input   [4-1:0] req,
    output reg [4-1:0] gnt,
    output reg [4-1:0] mask );
  
    assign gnt = req & ~mask;
  
   //This is a for loop that sets a 1 at
  //the first bit position and beyond that req has a 1

   integer             i;
   always @(*) begin
     mask[0] = 1'b0;   
     for(i=1;i<4;i++)
       mask[i] =  mask[i-1] | req[i-1] ;
      end
   
   /*
   genvar              i;
   generate
   for(i=0;i<4;i++) begin:GEN

     if (i == 0)
        always @(*)  mask[0] = 1'b0;   
     else
        always @(*)  mask[i] =  mask[i-1] | req[i-1] ;
   end
  endgenerate
   */
  
  //The above is equivalent to, doesn't simulate correctly in Aldec
  //and xilinx xsim
  //assign mask[0] = 1'b0;
  //assign mask[4-1:1] = mask[4-2:0] | req[4-2:0] ;
  
endmodule


module arbiter 
  (
    input  clk,rst,
    input  [4-1:0] req,
    output reg [4-1:0] gnt);
  
   wire [4-1:0]       req_masked,masked,unmasked,
                            gnt_masked, gnt_unmasked,pointer_reg_update;   
   reg [4-1:0]        pointer_reg;
                             
  assign req_masked = req & pointer_reg;
  
  priority_encode   masked_pri_enc (.req(req_masked),
                                                       .gnt(gnt_masked),
                                                       .mask(masked));
  
  priority_encode   unmasked_pri_enc (.req(req),
                                                         .gnt(gnt_unmasked),
                                                         .mask(unmasked));
  
  
  assign gnt = (|req_masked) ? gnt_masked : gnt_unmasked;
  
  always_ff @(posedge clk)
    if (rst) 
      pointer_reg <= {4{1'b0}};
  	else
      pointer_reg <= (|req_masked) ? masked :
      (|req) ? unmasked : pointer_reg;

endmodule

