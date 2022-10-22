class multiplication_item extends uvm_sequence_item;
	`uvm_object_utils( multiplication_item)
	rand bit [2:0] r_mode;
	rand bit [31:0] fp_X;
	rand bit [31:0] fp_Y;
	
	output bit [31:0] fp_Z;
	output bit ovrf;
	output bit udrf;

	function new(string name = "multiplication_item");
		super.new(name);
	endfunction

	constraint r {r_mode >= 0; r_mode <= 3}
	constraint X {fp_X >= 0; fp_X < 4294967296;}
	constraint Y {fp_Y >= 0; fp_Y < 4294967296;}


endclass
