import uvm_pkg::*;
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
	//	seq = item_sequence::type_id::create("seq");
	//	seq.randomize();
	endfunction

	//virtual task run_phase(uvm_phase phase);
	//	phase.raise_objection(this);
		//vif.r_mode=3'b000;
	      //  vif.fp_X=32'b0000_0000_0000_0000_0000_0000_0000_0000;
       	    //    vif.fp_Y=32'b0000_0000_0000_0000_0000_0000_0000_0000;
	        //vif.fp_Z=32'b0000_0000_0000_0000_0000_0000_0000_0000;
		//vif.ovrf=0;
		//vif.udrf=0;
		//seq.start(e0.a0.s0);
		//#100
		//phase.drop_objection(this);
	// 	endtask

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
  
  bit [31:0] operadores[2] = {32'hAAAAAAAA, 32'h55555555};
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
