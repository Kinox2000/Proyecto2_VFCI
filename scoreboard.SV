class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	function new(string name = "scoreboard", uvm_component parent = null);
		super.new(string, parent);
	endfunction

	uvm_seq_item_pull_imp #(multiplication_item) seq_item_export;

	bit [`LENGTH-1:0] X;
	bit [`LENGTH-1:0] Y;
	bit [`LENGTH-1:0] Z;

	uvm_analysys_imp #(multiplication_item muk_item) m_analysys_imp;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m_analysys_imp =  new("m_analysys_imp", this);
	endfunction

	virtual function write(multiplication_item mul_item);
		//código de verificación
	endfunction


	

