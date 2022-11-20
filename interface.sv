interface mul_if(input bit clk);//Interface para comunicarse con el DUT
	logic [2:0] r_mode;//Variable que almacena el modo de redondeo 
	logic [31:0] fp_X;//Variable que almacena el dato X de entrada 
    	logic [31:0] fp_Y;//Variable que almacena el dato Y de entrada
	logic [31:0] fp_Z;//Variable que almacena el dato Z de salida
	logic ovrf;//Variable para almacenar la bandera de overflow
	logic udrf;//variable para almacenar la bandera de underflow

    clocking cb @(posedge clk);
      default input #1step output #3ns;
          input fp_Z;  
          input ovrf;  
          input udrf;  
          output r_mode; 
          output fp_X; 
          output fp_Y; 
    endclocking 
endinterface
