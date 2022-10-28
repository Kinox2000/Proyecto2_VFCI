class item_sequence extends uvm_sequence;
	`uvm_object_utils(item_sequence);
	function new(string name = "item_sequence");
		super.new(name);
	endfunction

	rand int num_items;

	constraint num_items_cons {num_items >= 10; num_items <= 500;}

	virtual task body();
		for(int i = 0; i < num_items; i++)begin
			multiplication_item mul_item = multiplication_item::type_id::create("mul_item");
			start_item(mul_item);
			mul_item.randomize;
			`uvm_info("Sequence: ", $sformatf("Objeto: %0d %s", num_items,mul_item.print()), UVM_LOW);
			finish_item(mul_item);
		end
        endtask;
endclass
