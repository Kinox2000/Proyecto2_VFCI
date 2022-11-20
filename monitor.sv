class monitor extends uvm_monitor;//Se crea una clase monitor para revisar las salidas del DUT y enviarlas al scoreboard
	`uvm_component_utils(monitor)
	function new(string name = "monitor", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	uvm_analysis_port #(multiplication_item) mon_analysis_port;//Puerto para enviar datos al scoreboard
	virtual mul_if vif;//Interfaz para comunicarse con el DUT y obtener sus entradas y salidas

	virtual function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
	  if(!uvm_config_db#(virtual mul_if)::get(this, "", "mul_if", vif)) begin
		`uvm_fatal("Monitor", "No se pudo obtener la interfaz")
	  end
	  mon_analysis_port = new("mon_analysis_port", this);
        endfunction

	virtual task run_phase(uvm_phase phase);
	  super.run_phase(phase);

      forever @(vif.cb) begin
        multiplication_item mul_item = multiplication_item::type_id::create("mul_item");// Se crea un objeto y se guardan los valores de entrada y salida del DUT para enviarlos al scoreboard
	    mul_item.r_mode = vif.r_mode;
	    mul_item.fp_X = vif.fp_X;
	    mul_item.fp_Y = vif.fp_Y;
	    mul_item.fp_Z = vif.cb.fp_Z;
	    mul_item.ovrf = vif.cb.ovrf;
	    mul_item.udrf = vif.cb.udrf;
	    mul_item.mul_time = $time; 
	    mon_analysis_port.write(mul_item);
        `uvm_info("Monitor: ", $sformatf("r_mode fp_X fp_Y fp_Z:%h %h %h %h", mul_item.r_mode, mul_item.fp_X, mul_item.fp_Y, mul_item.fp_Z), UVM_MEDIUM);
	  end
  	endtask

endclass 
