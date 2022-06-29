
`include "interface.sv"

`include "random_test.sv"


module tbench_top;
  
  bit clk;
  bit rst;

  always #10 clk = ~clk;

  initial begin
    rst = 1;
    #5 rst =0;
  end
  
  
  //creatinng instance of interface, inorder to connect DUT and testcase
  intf i_intf(clk,rst);
  
  //Testcase instance, interface handle is passed to test as an argument
  test t1(i_intf);
  
  //DUT instance, interface signals are connected to the DUT ports
  MIPS UUT (
    .clk(i_intf.clk),
    .rst(i_intf.rst),
    .extInst_en(1'b1),
    .extInst(i_intf.extInst),
    .to_reg_file(i_intf.regmem_data),//lw y R type
    .to_memdata(i_intf.datamem_data),
    .pc_current(i_intf.pc_current),
    .pc_next(i_intf.pc_next),
    .regf1(i_intf.regf1),
    .regf2(i_intf.regf2)
    );
  //assign i_intf.regmem_data =UUT.Mux3_w;
    //UUT.MIPS_register_file.reg_mem[i_intf.extInst[20:16]];//lw
  
  //assign i_intf.datamem_data = UUT.Reg2_w;
    //UUT.MIPS_data_memory.mem [{{16{i_intf.extInst[15]}}, i_intf.extInst[15:0]}+UUT.MIPS_register_file.reg_mem[i_intf.extInst[20:16]]];//sw
  
  

  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule







































/*





`timescale 1ns/1ns
module MIPS_tb;

reg clk_tb, rst_tb;
integer i;

  MIPS UUT (.clk(clk_tb), .rst(rst_tb), .extInst_en(0),.extInst(32'b0));


initial begin

    clk_tb = 0;//initialize clock
    rst_tb = 1;//activate reset
    #2;

    rst_tb = 0;//deactivate reset
    #280;
  
  for (i=0; i <32; i=i+1)
    $display("%d\t%d\t%d", i, UUT.MIPS_register_file.reg_mem[i], UUT.MIPS_data_memory.mem[i]);

    $finish();
end


always forever #1 clk_tb = ~clk_tb;


initial begin
  	$dumpvars(3,MIPS_tb);
    $dumpfile("dump.vcd");
end

endmodule

*/