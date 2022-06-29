module Adder
  #(parameter size=32)
  (input [size-1:0]SrcA,SrcB,
   output [size-1:0]Result);
  
  assign Result=SrcA+SrcB;
  
endmodule