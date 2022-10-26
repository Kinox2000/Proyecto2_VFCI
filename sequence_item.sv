class multiplication_item extends uvm_sequence_item;
	`uvm_object_utils( multiplication_item)
	rand bit [2:0] r_mode;
	rand bit [31:0] fp_X;
	rand bit [31:0] fp_Y;
	
	bit [31:0] fp_Z;
	bit ovrf;
	bit udrf;

	function new(string name = "multiplication_item");
		super.new(name);
	endfunction

	constraint r {r_mode >= 0; r_mode <= 3}
	constraint X {fp_X >= 0; fp_X < 4294967296;}
	constraint Y {fp_Y >= 0; fp_Y < 4294967296;}

	function void do_print(printer);
		super.do_print(printer);
		printer.print_field_int("r_mode: ", r_mode, $bits(r_mode), UVM_HEX);
		printer.print_field_int("fp_X: ", fp_X, $bits(fp_X), UVM_HEX);
		printer.print_field_int("fp_Y: ", fp_Y, $bits(fp_Y), UVM_HEX);
	endfunction
endclass
