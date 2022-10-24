class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)
	function new(string name = "scoreboard", uvm_component parent = null);
		super.new(string, parent);
	endfunction

	bit [`LENGTH-1:0] X;
	bit [`LENGTH-1:0] Y;
	bit [`LENGTH-1:0] Z;

	

