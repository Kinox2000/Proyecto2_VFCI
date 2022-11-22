class multiplication_item extends uvm_sequence_item;
	`uvm_object_utils(multiplication_item)
	rand bit [2:0] r_mode;
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

	constraint r {r_mode >= 0; r_mode < 5;}//Constraint para randomizar el modo de redondeo 
	constraint X {fp_X[22:0] >= 0; fp_X[22:0] < 8388608;}//Constraint para randomizar los bits 22 a 0 para el test random
	constraint X_e{fp_X[30:23] >= 0; fp_X[30:23] < 256;}//Constraint para randomizar los bits del exponente para el test random
	constraint X_s{fp_X[31] >= 0; fp_X[31] <= 1;}//Constraint para randomizar el signo de la entrada
	constraint Y {fp_Y[22:0] >= 0; fp_Y[22:0] < 8388608;}//Constraint para randomizar los bits 22 a 0 para el test random
	constraint Y_e{fp_Y[30:23] >= 0; fp_Y[30:23] < 256;}//Constraint para randomizar los bits del exponente para el test random
	constraint Y_s{fp_Y[31] >= 0; fp_Y[31] <= 1;}//Constraint para randomizar el signo de la entrada
	constraint d {delay>=0; delay <= 20;}//Constraint para randomizar el delay
    	constraint underflow { (fp_X[30:23] + fp_Y[30:23] <=127) | (fp_X[30:0]==0 | fp_Y[30:0]==0) ; }//Constraint para randomizar las entrada para el test de underflow
    	constraint overflow {fp_X[30:23] + fp_Y[30:23] >= 382;}//Constraint para randomizar las entrada para el test de overflow
    	constraint NaN {((fp_X[30:23]==8'b1111_1111)&fp_X[22:0] != 0) | ((fp_Y[30:23]==8'b1111_1111)&fp_Y[22:0] != 0) ;}//Constraint para randomizar las entrada para el test de NaN
	constraint inf {fp_X[30:23]==8'b1111_1111; fp_X[22:0] == 0;}//Constraint para randomizar las entrada para el test de inf

	virtual function string print();
		return $sformatf("Redondeo: %0b, X: %0h, Y: %0h", r_mode, fp_X, fp_Y);
	endfunction

endclass

