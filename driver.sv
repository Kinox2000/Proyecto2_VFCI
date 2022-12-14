class driver extends uvm_driver #(multiplication_item);
	 `uvm_component_utils(driver)
	 function new(string name = "driver", uvm_component parent = null);
		 super.new(name, parent);
	 endfunction
	 int salida; int i = 0;
	 virtual mul_if vif;//Interfaz para comunicarse con el DUT

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual mul_if)::get(this, "", "mul_if", vif))
		  `uvm_fatal("Driver", "No se pudo obtener la interfaz")
	endfunction

	 virtual task run_phase(uvm_phase phase);
	 	super.run_phase(phase);
		forever begin
			multiplication_item mul_item;
			seq_item_port.get_next_item(mul_item);//Se recibe un item desde el sequencer
			for (int i = 0; i<mul_item.delay; i++) begin//Se ejecuta el delay que está definido para el mul_item en el sequence.sv
				#1;
			end
			mul_item.mul_time = $time;//Se guarda el tiempo en el que llega el objeto al driver
            		drive_item(mul_item);//Se llama a la función "drive_item" para los valores que vienen desde el sequencer a la interfaz que se conecta con el DUT
			//@(vif.clk);
			  //vif.r_mode = mul_item.r_mode;
			  //vif.fp_X = mul_item.fp_X;
			  //vif.fp_Y = mul_item.fp_Y;
			seq_item_port.item_done();//Sen envía el objeto al DUT 
			`uvm_info("Driver", $sformatf("Objeto: r_mode %b fp_X %h fp_X %h delay %d tiempo %d", vif.r_mode, vif.fp_X, vif.fp_Y, mul_item.delay, mul_item.mul_time), UVM_LOW);	
		//Código para generar el reporte en formato .csv
		salida = $fopen("salida_formato_csv.csv", "a");//Se abre o se crea un archivo en formato .csv en donde se almacena cada objeto enviado
		$fwrite(salida, "\n-----------------------------------------------------------------------------------------------------------");
		$fwrite(salida, "\nOperando número %d", i);
		i = i+1;
		$fwrite(salida, "\nOperando Enviado   X=%h Y=%h Z=%h", mul_item.fp_X, mul_item.fp_Y, mul_item.fp_Z);
		end
	endtask
      
    virtual task drive_item(multiplication_item mul_item);//Esta funcion se encarga de pasar los valores que vienen desde el sequencer a la interfaz que se conecta con el DUT
      @(vif.cb);
      vif.cb.r_mode <= mul_item.r_mode;
      vif.cb.fp_X <= mul_item.fp_X;
      vif.cb.fp_Y <= mul_item.fp_Y;
    endtask 
endclass
