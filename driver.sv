class driver extends uvm_driver #(multiplication_item);
	 `uvm_component_utils(driver)
	 function new(string name = "driver", uvm_component parent = null);
		 super.new(name, parent);
	 endfunction

	 virtual mul_if vif;
	 uvm_seq_item_pull_port #(multiplication_item) seq_item_port;

	 virtual task run_phase(uvm_phase phase);
	 	super.run_phase(phase);
		forever begin
			multiplication_item mul_item;
			`uvm_info("Driver: ", $sformatf("Esperando un sequence_item desde el secuenciador"), UVM_HIGH);
			seq_item_port.get_next_item(mul_item);
			@(vif.cb);
			  vif.r_mode = mul_item.r_mode;
			  vif.fp_X = mul_item.fp_X;
			  vif.fp_Y = mul_item.fp_Y;
			//mul_item.do_print();
			seq_item_port.item_done();
		end
	endtask
endclass
