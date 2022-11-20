class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	function new(string name = "scoreboard", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	bit [23:0] X;
	bit [23:0] Y;	
	bit [47:0] frc_Z_full;
	bit [26:0] frc_Z_norm;
	bit [23:0] Z;
	bit [23:0] Z_plus;
	bit [22:0] frc_Z;
	bit [31:0] out_Z;
	bit [7:0] e;
	bit sign_X;
	bit sign_Y;
	bit sign_Z;
	bit ovrf;
	bit udrf;
    	bit [8:0]sum_e;
   	bit NaN;
	int salida; 
	int errores;
	

	uvm_analysis_imp #(multiplication_item, scoreboard) m_analysis_imp;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m_analysis_imp =  new("m_analysis_imp", this);
	endfunction

	virtual function write(multiplication_item mul_item);
		//código de verificación
		`uvm_info("Scoreboard", $sformatf("-----------------------------------------------------------------------------------------------------------------"), UVM_LOW);
		`uvm_info("Scoreboard", $sformatf("Objeto recibido: %s", mul_item.print()), UVM_HIGH);
		sign_X = mul_item.fp_X[31];
		sign_Y = mul_item.fp_Y[31];
        	sum_e =mul_item.fp_X[30:23]+mul_item.fp_Y[30:23];
      //Definir el tipo de trans
      if ((mul_item.fp_X[30:23]==8'b1111_1111) | (mul_item.fp_Y[30:23]==8'b1111_1111))begin //verifica si es un caso Nan
          ovrf = 1'b0; 
          udrf = 1'b0;
	  if (mul_item.fp_X != 0 & mul_item.fp_Y != 0)begin
          	NaN = 1'b1; //activa bandera de NaN
	  end
        end
        else if((sum_e<=8'b0111_1111) | mul_item.fp_X[22:0]==0 | mul_item.fp_Y[22:0]==0 )begin // verifica si es un caso de underflow
			udrf = 1'b1; //activa bandera de underflow
			ovrf = 1'b0;
            		NaN = 1'b0;
	 	end
        else if((sum_e>=(8'b0111_1111+8'b1111_1111)) & (mul_item.fp_X[30:23]!=8'b1111_1111) & (mul_item.fp_Y[30:23]!=8'b1111_1111))begin //verifica si es un caso overflow
          ovrf = 1'b1; //activa bandera de overflow
          udrf = 1'b0;
          NaN = 1'b0;
		end

        else begin //  Caso común
          e = sum_e-8'b0111_1111;
          ovrf = 1'b0;
          udrf = 1'b0;
          NaN = 1'b0;
        end
		
	 sign_Z = sign_X^sign_Y; // calcula el signo del resultado
      
        X =24'b1000_0000_0000_0000_0000_0000+ mul_item.fp_X[22:0]; //Le suma un 1 a las entradas
	Y =24'b1000_0000_0000_0000_0000_0000+ mul_item.fp_Y[22:0];
		
	frc_Z_full = X*Y; //calcula la multiplicacion

        if(frc_Z_full[47] == 1'b1) begin //normaliza el dato
			frc_Z_norm = frc_Z_full[47:21];
			e = e+1'b1;
		end
		else if (frc_Z_full[47] == 1'b0) begin
			frc_Z_full = frc_Z_full << 1'b1;
			frc_Z_norm = frc_Z_full[47:21];
		end
		
		if(|frc_Z_full[21:0] == 1) begin
			frc_Z_norm[0] = 1'b1;
		end
		else begin
			frc_Z_norm[0] = 1'b0;
		end

		Z = frc_Z_norm[26:3];
		Z_plus = Z+1'b1;


      case(mul_item.r_mode)//redondeo
		
			000: begin
				if(frc_Z_norm[2] == 1'b0) begin
					frc_Z = Z[22:0];
				end
				else if((frc_Z_norm[2]==1)&&((frc_Z_norm[1]||frc_Z_norm[0])==1)) begin
					frc_Z = Z_plus[22:0];
				end
				else if((frc_Z_norm[2])&&!(frc_Z_norm[1]|| frc_Z_norm[0])) begin
					if(Z[0] == 0) begin
						frc_Z = Z[22:0];
					end
					else begin
						frc_Z = Z_plus[22:0];
					end
				end

			end

			1: begin
				frc_Z = Z[22:0];
			end

			2:begin
				if(sign_Z == 1'b0) begin
					frc_Z = Z[22:0];
				end
				else begin
					frc_Z = Z_plus[22:0];
				end
			end

			3: begin
				if(sign_Z == 1'b0) begin
					frc_Z = Z_plus[22:0];
				end
				else if(sign_Z == 1'b1) begin
					frc_Z = Z[22:0];
				end
			end

 			4: begin
				if(frc_Z_norm[2] == 1'b0) begin
					frc_Z = Z[22:0];

				end
				else begin
					frc_Z = Z_plus[22:0];
				end
			end

			default: begin
				if(frc_Z_norm[2] == 1'b0) begin
					frc_Z = Z[22:0];
				end
				if((frc_Z_norm[2])&&(frc_Z_norm[1]|| frc_Z_norm[0])) begin
					frc_Z = Z_plus[22:0];
				end
				if((frc_Z_norm[2])&&!(frc_Z_norm[1]|| frc_Z_norm[0])) begin
					if(Z[0] == 0) begin
						frc_Z = Z[22:0];
					end
					else begin
						frc_Z = Z_plus[22:0];
					end
				end
			end
		endcase

		out_Z = {sign_Z, e, frc_Z};
      if (udrf == 1'b1) begin
        out_Z[30:23]=8'b0000_0000;
        out_Z[22:0]=23'b000_0000_0000_0000_0000_0000;
      end
      else if (ovrf == 1'b1)begin
        out_Z[30:23]=8'b1111_1111;
        out_Z[22:0]=23'b000_0000_0000_0000_0000_0000;
      end
      else if ((mul_item.fp_X[30:23]==8'b1111_1111&mul_item.fp_X[22:0]==0) | (mul_item.fp_Y[30:23]==8'b1111_1111&mul_item.fp_Y[22:0]==0))begin
        out_Z[30:23]=8'b1111_1111;
        out_Z[22:0]=23'b000_0000_0000_0000_0000_0000;
      end
      else if (NaN == 1'b1)begin
        out_Z[30:23]=8'b1111_1111;
        out_Z[22:0]=23'b100_0000_0000_0000_0000_0000;
      end

		if(out_Z == mul_item.fp_Z) begin
		  `uvm_info("Scoreboard", $sformatf("Correcto"), UVM_LOW);
		  `uvm_info("Scoreboard", $sformatf("Salida esperada : %h", out_Z), UVM_HIGH);
		  `uvm_info("Scoreboard", $sformatf("Salida esperada dut: %h", mul_item.fp_Z), UVM_HIGH);
		end

		if(udrf == 1'b1) begin
			out_Z[30:0] = 31'b0000_0000_0000_0000_0000_0000_0000_000;
          		`uvm_info("Scoreboard", $sformatf("Exp underflow udrf: %b %b flag_dut", udrf, mul_item.udrf), UVM_HIGH);
			if(mul_item.udrf != 1) begin
				`uvm_error("Scoreboard", "No se activó la bandera de underflow")
				`uvm_info("Scoreboard", $sformatf("udrf: %b", mul_item.udrf), UVM_HIGH);
				errores = $fopen("errores_formato_csv.csv", "a");
				$fwrite(errores, "\nError de Underflow");
				$fwrite(errores, "\nRespuesta recibida X=%h Y=%h Z=%h udr_dut=%h", mul_item.fp_X, mul_item.fp_Y, mul_item.fp_Z, mul_item.udrf);
				$fwrite(errores, "\nRespuesta esperada X=%h Y=%h Z=%h udr_esperado=%h", mul_item.fp_X, mul_item.fp_Y, out_Z, udrf);
				$fwrite(errores, "\n-----------------------------------------------------------------------------------------------------------");
			end
			if(out_Z[30:0]!=mul_item.fp_Z[30:0])begin
                 		`uvm_error("Error", " udrf: Scoreboard y DUT no coinciden")
				errores = $fopen("errores_formato_csv.csv", "a");
       				`uvm_info("Scoreboard: ", $sformatf("Udrf: Salida esperada: Salida del DUT: %d %d", out_Z, mul_item.fp_Z), UVM_HIGH);
				$fwrite(errores, "\nError de Underflow");
				$fwrite(errores, "\nRespuesta recibida X=%h Y=%h Z=%h udr_dut%h", mul_item.fp_X, mul_item.fp_Y, mul_item.fp_Z, mul_item.udrf);
				$fwrite(errores, "\nRespuesta esperada X=%h Y=%h Z=%h udr_esperado=%h", mul_item.fp_X, mul_item.fp_Y, out_Z, udrf);
				$fwrite(errores, "\n-----------------------------------------------------------------------------------------------------------");
			end
		end
		else if(ovrf == 1'b1) begin
			out_Z[30:0] = 31'b1111_1111_0000_0000_0000_0000_0000_000;
			`uvm_info("Scoreboard", $sformatf("Exp overflow ovrf: %b", ovrf), UVM_HIGH);
			if(mul_item.ovrf != 1) begin
				`uvm_error("Scoreboard", "No se activó la bandera de overflow")
                 		`uvm_info("Scoreboard", $sformatf("ovrf: %b", mul_item.ovrf), UVM_HIGH);
				$fwrite(errores, "\nError de Overflow");
				errores = $fopen("errores_formato_csv.csv", "a");
				$fwrite(errores, "\nRespuesta recibida X=%h Y=%h Z=%h ovrf_dut%h", mul_item.fp_X, mul_item.fp_Y, mul_item.fp_Z, mul_item.ovrf);
				$fwrite(errores, "\nRespuesta esperada X=%h Y=%h Z=%h ovrf_esperado=%h", mul_item.fp_X, mul_item.fp_Y, out_Z, ovrf);
				$fwrite(errores, "\n-----------------------------------------------------------------------------------------------------------");
			end
			if(out_Z[30:0]!=mul_item.fp_Z[30:0])begin
				`uvm_error("Error", "Ovrf: Scoreboard y DUT no coinciden")
                 		`uvm_info("Scoreboard", $sformatf("ovrf: Salida esperada: Salida del DUT: %b %b", out_Z, mul_item.fp_Z), UVM_LOW);
				errores = $fopen("errores_formato_csv.csv", "a");
				$fwrite(errores, "\nError de Overflow");
				$fwrite(errores, "\nRespuesta recibida X=%h Y=%h Z=%h ovrf_dut%h", mul_item.fp_X, mul_item.fp_Y, mul_item.fp_Z, mul_item.ovrf);
				$fwrite(errores, "\nRespuesta esperada X=%h Y=%h Z=%h ovrf_esperado=%h", mul_item.fp_X, mul_item.fp_Y, out_Z, ovrf);
				$fwrite(errores, "\n-----------------------------------------------------------------------------------------------------------");
			end
		end
		else if(NaN == 1'b1 & mul_item.fp_Y[22:0]!=23'b000_0000_0000_0000_0000_0000 & mul_item.fp_X[22:0]!=23'b000_0000_0000_0000_0000_0000) begin
		    out_Z[30:0] = 31'b1111_1111_1000_0000_0000_0000_0000_000;
		     if(out_Z[31:0]!=mul_item.fp_Z[31:0])begin
		       `uvm_error("Error", " NaN: Scoreboard y DUT no coinciden")
		       `uvm_info("Scoreboard: ", $sformatf("NaN: Salida esperada: Salida del DUT: %d %d", out_Z, mul_item.fp_Z), UVM_HIGH);
			errores = $fopen("errores_formato_csv.csv", "a");
			$fwrite(errores, "\nError de NaN");
			$fwrite(errores, "\nRespuesta recibida X=%h Y=%h Z=%h", mul_item.fp_X, mul_item.fp_Y, mul_item.fp_Z);
			$fwrite(errores, "\nRespuesta esperada X=%h Y=%h Z=%h", mul_item.fp_X, mul_item.fp_Y, out_Z);
			$fwrite(errores, "\n-----------------------------------------------------------------------------------------------------------");
		     end

        end


        if (out_Z != mul_item.fp_Z & NaN != 1'b1 & ovrf != 1'b1 & udrf != 1'b1) begin
			`uvm_error("Error", "Scoreboard y DUT no coinciden-----")
			`uvm_info("Scoreboard", $sformatf("Redondeo: %b", mul_item.r_mode), UVM_HIGH);
			`uvm_info("Scoreboard", $sformatf("Signo: %b", sign_Z), UVM_HIGH);
			`uvm_info("Scoreboard", $sformatf("Z[22:0]: %b", Z[22:0]), UVM_HIGH);
			`uvm_info("Scoreboard", $sformatf("Z_plus[22:0]: %b", Z_plus[22:0]), UVM_HIGH);
			`uvm_info("Scoreboard", $sformatf("frc_Z_norm[2:0]: %b", frc_Z_norm[2:0]), UVM_HIGH);
			`uvm_info("Scoreboard", $sformatf("e_esperado: e_DUT: %b %b", out_Z[30:23], mul_item.fp_Z[30:23]), UVM_HIGH);
			`uvm_info("Scoreboard", $sformatf("fp_X: %b", mul_item.fp_X), UVM_HIGH);
			`uvm_info("Scoreboard", $sformatf("fp_Y: %b", mul_item.fp_Y), UVM_HIGH);
			`uvm_info("Scoreboard", $sformatf("Salida esperada: Salida del DUT: %b %b", out_Z, mul_item.fp_Z), UVM_HIGH);
			errores = $fopen("errores_formato_csv.csv", "a");
			$fwrite(errores, "\nRespuesta recibida X=%h Y=%h Z=%h", mul_item.fp_X, mul_item.fp_Y, mul_item.fp_Z);
			$fwrite(errores, "\nRespuesta esperada X=%h Y=%h Z=%h", mul_item.fp_X, mul_item.fp_Y, out_Z);
			$fwrite(errores, "\n-----------------------------------------------------------------------------------------------------------");

		end
			//Código para generar el reporte en formato .csv
			salida = $fopen("salida_formato_csv.csv", "a");
			$fwrite(salida, "\nRespuesta recibida X=%h Y=%h Z=%h", mul_item.fp_X, mul_item.fp_Y, mul_item.fp_Z);
			$fwrite(salida, "\nRespuesta esperada X=%h Y=%h Z=%h", mul_item.fp_X, mul_item.fp_Y, out_Z);
			$fwrite(salida, "\n-----------------------------------------------------------------------------------------------------------");
		  	`uvm_info("Scoreboard", $sformatf("Salida esperada : %h", out_Z), UVM_HIGH);
		  	`uvm_info("Scoreboard", $sformatf("Salida dut      : %h", mul_item.fp_Z), UVM_HIGH);

	endfunction
endclass

