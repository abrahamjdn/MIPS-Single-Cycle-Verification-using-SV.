class generator;
    rand transaction trans;
    //Numero para generar repeticiones
    int repeat_count;
    //mailbox 
    mailbox gen2driv;
    //evento para indicar el fin de la gen. de transacciones
    event ended;
    
    //Constructor, el mailbox se crea en entorno para enlazar entre generador y driver
    function new(mailbox gen2driv);
        this.gen2driv=gen2driv;
    endfunction //new()

    //tarea principal, genera transacciones aleatorias para enviarlas por mailbox
    task main();
        repeat(repeat_count) begin
            trans = new();
            if (!trans.randomize()) begin
                $fatal("Gen:: trans randomization failed");
            end
            //trans.display("[Generator]");
            gen2driv.put(trans);
        end
        -> ended; //triggering indicates the end of generation
    endtask

endclass //generator