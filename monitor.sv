
//Samples the interface signals, captures into transaction packet and send the packet to scoreboard.

class monitor;
  
  //creating virtual interface handle
  virtual intf vif;
  
  //creating mailbox handle
  mailbox mon2scb;
  
  //constructor
  function new(virtual intf vif,mailbox mon2scb);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction
  
  //Samples the interface signal and send the sample packet to scoreboard
  task main;
    forever begin
      transaction trans;
      trans = new();
      //@(posedge vif.clk);      
      //wait(vif.valid);      
      
      @(negedge vif.clk);
      //@(posedge vif.clk);
      trans.regmem_data   = vif.regmem_data;
      trans.datamem_data   = vif.datamem_data;
      trans.extInst   = vif.extInst;        
      trans.pc_current =vif.pc_current;
      trans.pc_next =vif.pc_next;
      trans.regf1 =vif.regf1;
      trans.regf2 =vif.regf2;
      //@(posedge vif.clk);
      mon2scb.put(trans);
      //trans.display("[ Monitor ]");
    end
  endtask
  
endclass