//receive the stimulus generated from the generator and drive to DUT by assigning transaction class values to interface signals.
class driver;
  
  	int no_transactions;
    //interfaz virtual
    virtual intf vif;
    //mailbox
    mailbox gen2driv;

    //constructor
    function new(virtual intf vif, mailbox gen2driv);
        this.vif=vif;
        this.gen2driv=gen2driv;
    endfunction

    //tarea de reset, no arguments
    task  reset;
      wait(vif.rst);
        $display("[driver]---- Reset started -----");
        vif.extInst <= 32'b0;        
        wait(!vif.rst);
      $display("[driver]---- Reset ended -------");
    endtask //

    task main;/////////////¿? drive
        forever begin
            transaction trans;
            gen2driv.get(trans);
            @(posedge vif.clk);/////////////¿?
            //vif.valid <= 1;
            vif.extInst <= trans.extInst; //de la transaccion a interfaz
            //vif.b <= trans.b;
            //vif.ALU_Ctl <= trans.ALU_Ctl;
           	//@(posedge vif.clk);
            //@(posedge vif.clk);
            //trans.display("[driver]");
            no_transactions++;
        end
    endtask
endclass