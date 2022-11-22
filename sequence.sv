class item_sequence extends uvm_sequence;
	`uvm_object_utils(item_sequence);
	function new(string name = "item_sequence");
		super.new(name);
	endfunction

	rand int num_items;

  constraint num_items_cons {num_items >= 500; num_items <= 1000;}

	virtual task body();
		`uvm_info("Sequence", $sformatf("Número de objetos generados: %b", num_items), UVM_LOW);
		for(int i = 0; i < num_items; i++)begin
			multiplication_item mul_item = multiplication_item::type_id::create("mul_item");
			start_item(mul_item);
			mul_item.underflow.constraint_mode(0);
            		mul_item.overflow.constraint_mode(0);
			mul_item.NaN.constraint_mode(0);
			mul_item.inf.constraint_mode(0);
			mul_item.randomize;
			`uvm_info("Sequence", $sformatf("OBJETO NÚMERO %d ", i), UVM_LOW);
			`uvm_info("Sequence", $sformatf("Objeto: num %d fp_X %h fp_Y %h r_mode %b delay %d", i, mul_item.fp_X, mul_item.fp_Y, mul_item.r_mode, mul_item.delay), UVM_LOW);
			finish_item(mul_item);
		end
        endtask
endclass

//item para valores especificos como max alternancia
class item_sequence_sp extends uvm_sequence;
	`uvm_object_utils_begin(item_sequence_sp)
      `uvm_field_int(fp_X, UVM_DEFAULT)
      `uvm_field_int(fp_Y, UVM_DEFAULT)
      `uvm_field_int(r_mode, UVM_DEFAULT)
    `uvm_object_utils_end
  

	function new(string name = "item_sequence_sp");
		super.new(name);
	endfunction

	int num_items=1;
    bit [31:0] fp_X;
    bit [31:0] fp_Y;
    rand bit [2:0] r_mode;



	virtual task body();
        multiplication_item mul_item_sp = multiplication_item::type_id::create("mul_item_sp");
        mul_item_sp.underflow.constraint_mode(0);
        mul_item_sp.overflow.constraint_mode(0);
	mul_item_sp.NaN.constraint_mode(0);
	mul_item_sp.inf.constraint_mode(0);
        start_item(mul_item_sp);
        mul_item_sp.r_mode= this.r_mode;
        mul_item_sp.fp_X=this.fp_X;
        mul_item_sp.fp_Y=this.fp_Y;
        `uvm_info("Sequence: ", $sformatf("Objeto: %0d %s", num_items, mul_item_sp.print()), UVM_HIGH);
        finish_item(mul_item_sp);
    endtask
endclass

//item para casos de error underflow
class item_sequence_underflow extends uvm_sequence;
	`uvm_object_utils(item_sequence_underflow)

	function new(string name = "item_sequence_underflow");
		super.new(name);
	endfunction

	rand int num_items;


  constraint num_items_cons {num_items >= 100; num_items <= 200;}

	virtual task body();
		for(int i = 0; i < num_items; i++)begin
		  multiplication_item mul_item_underflow = multiplication_item::type_id::create("mul_item_underflow");
		  mul_item_underflow.underflow.constraint_mode(1);
		  mul_item_underflow.overflow.constraint_mode(0);
		  mul_item_underflow.NaN.constraint_mode(0);
		  mul_item_underflow.inf.constraint_mode(0);
		  mul_item_underflow.randomize;
		  start_item(mul_item_underflow);

		  `uvm_info("Sequence: ", $sformatf("Objeto: %0d %s", num_items, mul_item_underflow.print()), UVM_HIGH);
		  finish_item(mul_item_underflow);
		end
    endtask
endclass
class item_sequence_overflow extends uvm_sequence;
	`uvm_object_utils(item_sequence_overflow)

	function new(string name = "item_sequence_overflow");
		super.new(name);
	endfunction

	rand int num_items;


  constraint num_items_cons {num_items >= 100; num_items <= 200;}

	virtual task body();
		for(int i = 0; i < num_items; i++)begin
		  multiplication_item mul_item_overflow = multiplication_item::type_id::create("mul_item_overflow");
		  mul_item_overflow.underflow.constraint_mode(0);
		  mul_item_overflow.overflow.constraint_mode(1);
		  mul_item_overflow.NaN.constraint_mode(0);
		  mul_item_overflow.randomize;
		  start_item(mul_item_overflow);

		  `uvm_info("Sequence: ", $sformatf("Objeto: %0d %s", num_items, mul_item_overflow.print()), UVM_HIGH);
		  finish_item(mul_item_overflow);
		end
    endtask
endclass 


//item_sequence_NaN
class item_sequence_NaN extends uvm_sequence;
	`uvm_object_utils(item_sequence_NaN)
  
	function new(string name = "item_sequence_NaN");
		super.new(name);
	endfunction

	rand int num_items;

    constraint num_items_cons {num_items >= 100; num_items <= 200;}

	virtual task body();
		for(int i = 0; i < num_items; i++)begin
		  multiplication_item mul_item_NaN = multiplication_item::type_id::create("mul_item_NaN");
		  mul_item_NaN.underflow.constraint_mode(0);
		  mul_item_NaN.overflow.constraint_mode(0);
		  mul_item_NaN.NaN.constraint_mode(1);
		  mul_item_NaN.inf.constraint_mode(0);
		  mul_item_NaN.randomize;
		  start_item(mul_item_NaN);
		  `uvm_info("Sequence: ", $sformatf("Objeto: %0d %s", num_items, mul_item_NaN.print()), UVM_HIGH);
		  finish_item(mul_item_NaN);
		end
    endtask
endclass 



//item_sequence_inf
class item_sequence_inf extends uvm_sequence;
	`uvm_object_utils(item_sequence_inf)
  
	function new(string name = "item_sequence_inf");
		super.new(name);
	endfunction

	rand int num_items;

    constraint num_items_cons {num_items >= 100; num_items <= 200;}

	virtual task body();
		for(int i = 0; i < num_items; i++)begin
		  multiplication_item mul_item_inf = multiplication_item::type_id::create("mul_item_NaN");
		  mul_item_inf.underflow.constraint_mode(0);
		  mul_item_inf.overflow.constraint_mode(0);
		  mul_item_inf.NaN.constraint_mode(0);
		  mul_item_inf.inf.constraint_mode(1);
		  mul_item_inf.randomize;
		  start_item(mul_item_inf);
		  `uvm_info("Sequence: ", $sformatf("Objeto: %0d %s", num_items, mul_item_inf.print()), UVM_HIGH);
		  finish_item(mul_item_inf);
		end
    endtask
endclass 
//item_sequence_completo
class item_sequence_completo extends uvm_sequence;
	`uvm_object_utils(item_sequence_completo)
  
	function new(string name = "item_sequence_completo");
		super.new(name);
	endfunction

	rand int num_items;
	item_sequence seq1;
	item_sequence_sp seq2;
	item_sequence_overflow seq3;
	item_sequence_underflow seq4;
	item_sequence_NaN seq5;
	item_sequence_inf seq6;

	virtual task body();
		  `uvm_do(seq1);
		  `uvm_do(seq2);
		  `uvm_do(seq3);
		  `uvm_do(seq4);
		  `uvm_do(seq5);
		  `uvm_do(seq6);
       endtask
endclass 
