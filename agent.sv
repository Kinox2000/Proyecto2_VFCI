class agent extends uvm_agent;//Se crea el agente que contiene al monitor (que se comunica con el scoreboard), al  driver(que se comunica con el dut) y al sequencer
	`uvm_component_utils(agent)
	function new(string name = "agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	driver d0;
	monitor m0;
	uvm_sequencer #(multiplication_item) s0;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		s0 = uvm_sequencer#(multiplication_item)::type_id::create("s0", this);//Se crea el sequencer
		d0 = driver::type_id::create("d0", this);//Se crea el driver
		m0 = monitor::type_id::create("m0", this);//Se crea el monitor
		
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		d0.seq_item_port.connect(s0.seq_item_export);//Se conecta el puerto del driver.sv con el puerto del sequencer por defecto de uvm
	endfunction
endclass
