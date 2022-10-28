class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	function new(string name = "scoreboard", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	//uvm_seq_item_pull_imp
	bit [`LENGTH-8:0] X;
	bit [`LENGTH-8:0] Y;	
	bit [2*`LENGTH-16:0] Z;
	bit [7:0] e;
	bit sign_X;
	bit sign_Y;
	bit sign_Z;
	

	uvm_analysis_imp #(multiplication_item, scoreboard) m_analysis_imp;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m_analysis_imp =  new("m_analysis_imp", this);
	endfunction

	virtual function write(multiplication_item mul_item);
		//código de verificación
		`uvm_info("Scoreboard", $sformatf("Inició el scoreboard"), UVM_HIGH);

		e = mul_item.fp_X[`LENGTH-2:`LENGTH-9]+mul_item.fp_Y[`LENGTH-2:`LENGTH-9]-8'b0111_1111;
		sign_Z = sign_X^sign_Y;

		X =24'b1000_0000_0000_0000_0000_0000+ mul_item.fp_X[23:0];
		Y =24'b1000_0000_0000_0000_0000_0000+ mul_item.fp_Y[23:0];

		Z = X*Y;


		case(mul_item.r_mode)
			"000": begin
			end
			"001": begin
			end
			"010":begin
			end
			"011": begin
			end
			"100": begin
			end
		endcase
	endfunction
endclass

