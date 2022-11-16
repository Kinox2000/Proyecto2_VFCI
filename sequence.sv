class item_sequence extends uvm_sequence;
	`uvm_object_utils(item_sequence);
	function new(string name = "item_sequence");
		super.new(name);
	endfunction

	rand int num_items;

	constraint num_items_cons {num_items >= 10; num_items <= 20;}

	virtual task body();
		for(int i = 0; i < num_items; i++)begin
			multiplication_item mul_item = multiplication_item::type_id::create("mul_item");
			start_item(mul_item);
			mul_item.randomize;
			`uvm_info("Sequence: ", $sformatf("Objeto: %0d %s", num_items, mul_item.print()), UVM_HIGH);
			finish_item(mul_item);
		end
        endtask
endclass
class item_sequence_sp extends uvm_sequence;
	`uvm_object_utils_begin(item_sequence_sp)
      `uvm_field_int(fp_X, UVM_DEFAULT)
      `uvm_field_int(fp_Y, UVM_DEFAULT)
      `uvm_field_int(r_mode, UVM_DEFAULT)
    `uvm_object_utils_end
  

	function new(string name = "item_sequence_sp");
		super.new(name);
	endfunction

	rand int num_items;
    bit [31:0] fp_X;
    bit [31:0] fp_Y;
    rand bit [2:0] r_mode;

  constraint num_items_cons {num_items >= 3; num_items <= 6;}

	virtual task body();
		for(int i = 0; i < num_items; i++)begin
          multiplication_item mul_item_sp = multiplication_item::type_id::create("mul_item_sp");
          start_item(mul_item_sp);
          mul_item_sp.r_mode= this.r_mode;
          mul_item_sp.fp_X=this.fp_X;
          mul_item_sp.fp_Y=this.fp_Y;
          `uvm_info("Sequence: ", $sformatf("Objeto: %0d %s", num_items, mul_item_sp.print()), UVM_HIGH);
          finish_item(mul_item_sp);
		end
    endtask
endclass