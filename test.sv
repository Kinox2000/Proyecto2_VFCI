class base_test extends uvm_test;
	`uvm_component_utils(base_test)
	function new(string nae = "base_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	environment e0;
	item_sequence seq;
	virtual mul_if vif;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		e0 = environment::type_id::create("e0", this);
		uvm_config_db#(virtual mul_if)::set(this, "e0.a0*", "mul_if", vif);
		seq = item_sequence::type_id::create("seq");
		seq.randomize();
	endfunction

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq.start(e0.a0.s0);
		#100
		phase.drop_objection(this);
	endtask

endclass
