class monitor extends uvm_monitor;
	`uvm_component_utils(monitor)
	function new(string name = "monitor", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	uvm_analysis_port #(multiplication_item) mon_analysis_port;
	virtual mul_if vif;

	virtual function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
	  mon_analysis_port = new("mon_analysis_port", this);
        endfunction

	virtual task run_phase(uvm_phase phase);
	  super.run_phase(phase);

	  forever begin
		  @(vif.cb); begin
		    multiplication_item mul_item = multiplication_item::type_id::create("mul_item");
		    mul_item.r_mode = vif.cb.r_mode;
		    mul_item.fp_X = vif.cb.fp_X;
		    mul_item.fp_Y = vif.cb.fp_Y;
		    mul_item.fp_Z = vif.cb.fp_Z;
		    mul_item.ovrf = vif.cb.r_ovrf;
		    mul_item.udrf = vif.cb.udrf;
		    mon_analysis_port.write(mul_item);
		    `uvm_info("Monitor: ", $sfotmatf("Item: ", mul_item.do_print()), UVM_MEDIUM)
	    end
	  end
  endtask

endclass 
