module branch_decoder(
  input beq, bne, zero,
  output ctrl
);
  
  assign ctrl = (bne&~zero) | (beq&zero);
  
endmodule