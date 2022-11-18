class multiplication_item extends uvm_sequence_item;
	`uvm_object_utils(multiplication_item)
	randc bit [2:0] r_mode;
	randc bit [31:0] fp_X;
	randc bit [31:0] fp_Y;
	
	rand int delay;
	int mul_time;
	
	bit [31:0] fp_Z;
	bit ovrf;
	bit udrf;
	
	
	function new(string name = "multiplication_item");
		super.new(name);
	endfunction

	constraint r {r_mode >= 0; r_mode <= 3;}
	constraint X {fp_X[22:0] >= 0; fp_X[22:0] < 8388608;}
	constraint X_e{fp_X[30:23] >= 0; fp_X[30:23] < 256;}
	constraint X_s{fp_X[31] >= 0; fp_X[31] <= 1;}
	constraint Y {fp_Y[22:0] >= 0; fp_Y[22:0] < 8388608;}
	constraint Y_e{fp_Y[30:23] >= 0; fp_Y[30:23] < 256;}
	constraint Y_s{fp_Y[31] >= 0; fp_Y[31] <= 1;}
	constraint d {delay>=0; delay <= 20;}
    constraint underflow { fp_Y[30:0]==0 | fp_X[30:0]==0; }	

	virtual function string print();
		return $sformatf("Redondeo: %0b, X: %0h, Y: %0h", r_mode, fp_X, fp_Y);
	endfunction

endclass

