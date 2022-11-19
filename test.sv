class base_test extends uvm_test;
	`uvm_component_utils(base_test)
	function new(string name = "base_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	environment e0;
	//item_sequence seq;
	virtual mul_if vif;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		e0 = environment::type_id::create("e0", this);
   		if (!uvm_config_db#(virtual mul_if)::get(this,"","_if",vif))
			`uvm_fatal("Test", "Error, no se encontró  vif")
		uvm_config_db#(virtual mul_if)::set(this, "e0.a0.*", "mul_if", vif);
		//seq = item_sequence::type_id::create("seq");
		//seq.randomize();
	endfunction

	//virtual task run_phase(uvm_phase phase);
	//	phase.raise_objection(this);
	//	seq.start(e0.a0.s0);
	//	#100
	//	phase.drop_objection(this);
	 //	endtask

endclass

class test_random extends base_test;
  `uvm_component_utils (test_random)
  function new(string name = "test_random", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    item_sequence trans_random = item_sequence::type_id::create("trans_random");
    trans_random.randomize();
    `uvm_info("Escenario_1", $sformatf("\n Test Uso Comun Random Test\n"), UVM_LOW)
    phase.raise_objection(this);
    trans_random.start(e0.a0.s0);
    #100
    phase.drop_objection(this);
  endtask
endclass

class test_max_alter extends base_test;
  `uvm_component_utils (test_max_alter)
  function new(string name = "test_max_alter", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  bit [31:0] operadores[2] = {32'h8b9e3f6e , 32'hb465c528};
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    
    foreach (operadores [i])begin
      foreach (operadores [j])begin
        item_sequence_sp trans_max_alter = item_sequence_sp::type_id::create("trans_max_alter");
        
        trans_max_alter.randomize();
        trans_max_alter.fp_X=operadores[i];
        trans_max_alter.fp_Y=operadores[j];
        `uvm_info("Escenario_1", $sformatf("\n Test Uso Comun max alternancia\n"), UVM_LOW)
        phase.raise_objection(this);
        trans_max_alter.start(e0.a0.s0);
        #100
        phase.drop_objection(this);
      end
    end
    
  endtask
endclass

class test_underflow extends base_test;
  `uvm_component_utils (test_underflow)
  function new(string name = "test_underflow", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  virtual task run_phase(uvm_phase phase);
    item_sequence_underflow trans_underflow = item_sequence_underflow::type_id::create("trans_underflow");
    trans_underflow.randomize();
    `uvm_info("Escenario_2", $sformatf("\n Test Uso Underflow\n"), UVM_LOW)
    phase.raise_objection(this);
    trans_underflow.start(e0.a0.s0);
    #100
    phase.drop_objection(this);
  endtask
endclass

class test_overflow extends base_test;
  `uvm_component_utils (test_overflow)
  function new(string name = "test_overflow", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  virtual task run_phase(uvm_phase phase);
    item_sequence_overflow trans_overflow = item_sequence_overflow::type_id::create("trans_overflow");
    trans_overflow.randomize();
    `uvm_info("Escenario_2", $sformatf("\n Test Uso overflow\n"), UVM_LOW)
    phase.raise_objection(this);
    trans_overflow.start(e0.a0.s0);
    #100
    phase.drop_objection(this);
  endtask
endclass

class test_NaN extends base_test;
  `uvm_component_utils (test_NaN)
  function new(string name = "test_NaN", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  virtual task run_phase(uvm_phase phase);
    item_sequence_NaN trans_NaN = item_sequence_NaN::type_id::create("trans_NaN");
    trans_NaN.randomize();
    `uvm_info("Escenario_2", $sformatf("\n Test Uso NaN\n"), UVM_LOW)
    phase.raise_objection(this);
    trans_NaN.start(e0.a0.s0);
    #100
    phase.drop_objection(this);
  endtask
endclass