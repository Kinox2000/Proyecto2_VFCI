class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	function new(string name = "scoreboard", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	bit [23:0] X;
	bit [23:0] Y;	
	bit [47:0] frc_Z_full;
	bit [26:0] frc_Z_norm; //frc_Z_full truncado
	bit [23:0] Z;
	bit [23:0] Z_plus;
	bit [22:0] frc_Z;
	bit [31:0] out_Z;
	bit [7:0] e;
	bit sign_X;
	bit sign_Y;
	bit sign_Z;
	

	uvm_analysis_imp #(multiplication_item, scoreboard) m_analysis_imp;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m_analysis_imp =  new("m_analysis_imp", this);
		`uvm_info("Scoreboard", $sformatf("Inició el scoreboard"), UVM_HIGH);
	endfunction

	virtual function write(multiplication_item mul_item);
		//código de verificación
		
		`uvm_info("Scoreboard: ", $sformatf("Objeto: %s", mul_item.print()), UVM_HIGH);

		e = mul_item.fp_X[`LENGTH-2:`LENGTH-9]+mul_item.fp_Y[`LENGTH-2:`LENGTH-9]-8'b0111_1111;
		sign_Z = sign_X^sign_Y;

		X =24'b1000_0000_0000_0000_0000_0000+ mul_item.fp_X[23:0];
		Y =24'b1000_0000_0000_0000_0000_0000+ mul_item.fp_Y[23:0];
		
		//`uvm_info("Scoreboard: ", $sformatf("fp_X dec hex bin: %d %h %b", mul_item.fp_X[23:0], mul_item.fp_X[23:0], mul_item.fp_X[23:0]), UVM_HIGH);
		//`uvm_info("Scoreboard: ", $sformatf("fp_X+1 dec hex bin: %d %h %b", X, X, X), UVM_HIGH);
		//`uvm_info("Scoreboard: ", $sformatf("fp_Y dec hex bin: %d %h %b", mul_item.fp_Y[23:0], mul_item.fp_Y[23:0], mul_item.fp_Y[23:0]), UVM_HIGH);
		//`uvm_info("Scoreboard: ", $sformatf("fp_Y+1dec hex bin: %d %h %b" , Y, Y, Y), UVM_HIGH);

		frc_Z_full = X*Y;

		if(frc_Z_full[47] == 1'b1) begin
			frc_Z_norm = frc_Z_full[47:21];
			`uvm_info("Scoreboard: ", $sformatf("Primer bit uno = %b", frc_Z_full[47]), UVM_HIGH);
		end
		else if (frc_Z_full[47] == 1'b0) begin
			frc_Z_norm = frc_Z_full[47:21] << 1'b1;
			`uvm_info("Scoreboard: ", $sformatf("Primer bit cero = %b", frc_Z_full[47]), UVM_HIGH);
		end
		
		if(|frc_Z_full[47:24] == 1) begin
			frc_Z_norm[0] = 1'b1;
		end
		else begin
			frc_Z_norm[0] = 1'b0;
		end
		
		`uvm_info("Scoreboard: ", $sformatf("frc_Z_full dec hex bin: %d %h %b", frc_Z_full, frc_Z_full, frc_Z_full), UVM_HIGH);
		`uvm_info("Scoreboard: ", $sformatf("frc_Z_norm dec hex bin: %d %h %b", frc_Z_norm, frc_Z_norm, frc_Z_norm), UVM_HIGH);

		Z = frc_Z_norm[26:2];
		Z_plus = Z+1'b1;
		
		`uvm_info("Scoreboard: ", $sformatf("Redondeo: %b", mul_item.r_mode), UVM_HIGH);
		case(mul_item.r_mode)

			000: begin
				if(frc_Z_norm[2] == 1'b0) begin
					frc_Z = Z >> 1'b1;
				end
				if((frc_Z_norm[2])&&(frc_Z_norm[1]|| frc_Z_norm[0])) begin
					frc_Z = Z_plus >> 1'b1 >> 1'b1;
				end
				if((frc_Z_norm[2])&&!(frc_Z_norm[1]|| frc_Z_norm[0])) begin
					if(Z[0] == 0) begin
						frc_Z = Z >> 1'b1;
					end
					else begin
						frc_Z = Z_plus >> 1'b1;
					end
				end

			end
			001: begin
				frc_Z = Z >> 1'b1;
			end

			010:begin
				if(sign_Z == 1'b0) begin
					frc_Z = Z >> 1'b1;
				end
				else
					frc_Z = Z_plus >> 1'b1;
				end
			end

			011: begin
				if(sign_Z == 1'b0) begin
					frc_Z = Z_plus >> 1'b1;
				end
				else
					frc_Z = Z >> 1'b1;
				end
			end

			100: begin
				if(frc_Z_norm[2] == 1'b0) begin
					frc_Z = Z >> 1'b1;
				end
				else
					frc_Z = Z_plus >> 1'b1;
				end
			end
		endcase

		`uvm_info("Scoreboard: ", $sformatf("frc_Z: %b", frc_Z), UVM_HIGH);
		`uvm_info("Scoreboard: ", $sformatf("fp_Z: %b", mul_item.fp_Z), UVM_HIGH);
		out_Z = {sign_Z, e, frc_Z};
		`uvm_info("Scoreboard: ", $sformatf("out_Z dec hex bin: %d %h %b", out_Z, out_Z, out_Z), UVM_HIGH);

	endfunction
endclass

