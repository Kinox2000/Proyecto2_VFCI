class environment extends uvm_env;//Se crea una clase de ambiente que contendrá al scoreboard y al agente
	`uvm_component_utils(environment);
	function new(string name = "environment", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	agent a0;
	scoreboard sb0;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		a0 = agent::type_id::create("a0", this);//Se crea el agente 
		sb0 = scoreboard::type_id::create("sb0", this);//Se crea el scoreboard
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		a0.m0.mon_analysis_port.connect(sb0.m_analysis_imp);//Se conecta el puero del monitor con el puerto del scoreboard
	endfunction

endclass
