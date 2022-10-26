class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	function new(string name = "scoreboard", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	uvm_seq_item_pull_imp #(multiplication_item) seq_item_export;

	bit [`LENGTH-1:0] X;
	bit [`LENGTH-1:0] Y;
	bit [`LENGTH-1:0] Z;

	uvm_analysis_imp #(multiplication_item, scoreboard) m_analysis_imp;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m_analysis_imp =  new("m_analysis_imp", this);
	endfunction

	virtual function write(multiplication_item mul_item);
		//código de verificación
		`uvm_info("Scoreboard", $sformatf("Inició el scoreboard"), UVM_HIGH);
	endfunction
endclass


	

