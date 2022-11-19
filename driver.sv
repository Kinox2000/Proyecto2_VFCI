class driver extends uvm_driver #(multiplication_item);
	 `uvm_component_utils(driver)
	 function new(string name = "driver", uvm_component parent = null);
		 super.new(name, parent);
	 endfunction

	 virtual mul_if vif;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual mul_if)::get(this, "", "mul_if", vif))
		  `uvm_fatal("Driver", "No se pudo obtener la interfaz")
	endfunction

	 virtual task run_phase(uvm_phase phase);
	 	super.run_phase(phase);
		forever begin
			multiplication_item mul_item;
			seq_item_port.get_next_item(mul_item);
			for (int i = 0; i<mul_item.delay; i++) begin
				#1;
			end
			mul_item.mul_time = $time;	
            drive_item(mul_item);
			//@(vif.clk);
			  //vif.r_mode = mul_item.r_mode;
			  //vif.fp_X = mul_item.fp_X;
			  //vif.fp_Y = mul_item.fp_Y;
			seq_item_port.item_done();
			`uvm_info("Driver", $sformatf("Objeto: r_mode %b fp_X %h fp_X %h delay %d tiempo %d", vif.r_mode, vif.fp_X, vif.fp_Y, mul_item.delay, mul_item.mul_time), UVM_LOW);
		end
	endtask
      
    virtual task drive_item(multiplication_item mul_item);
      @(vif.cb);
      vif.cb.r_mode <= mul_item.r_mode;
      vif.cb.fp_X <= mul_item.fp_X;
      vif.cb.fp_Y <= mul_item.fp_Y;
    endtask 
endclass
