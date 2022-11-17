class item_sequence extends uvm_sequence;
	`uvm_object_utils(item_sequence);
	function new(string name = "item_sequence");
		super.new(name);
	endfunction

	rand int num_items;

	constraint num_items_cons {num_items >= 2; num_items <= 10;}
	

	virtual task body();
		`uvm_info("Sequence", $sformatf("Número de onjetos generados: %b", num_items), UVM_LOW);
		for(int i = 0; i < num_items; i++)begin
			multiplication_item mul_item = multiplication_item::type_id::create("mul_item");
			start_item(mul_item);
			mul_item.randomize;
			`uvm_info("Sequence", $sformatf("Objeto: num %d fp_X %b fp_Y %b r_mode %b delay %d", i, mul_item.fp_X, mul_item.fp_Y, mul_item.r_mode, mul_item.delay), UVM_LOW);
			finish_item(mul_item);
		end
        endtask
endclass
