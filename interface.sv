interface mul_if(input bit clk);
	logic [2:0] r_mode;
	logic [31:0] fp_X;
    logic [31:0] fp_Y;
	logic [31:0] fp_Z;
	logic ovrf;
	logic udrf;
    clocking cb @(posedge clk);
      default input #1step output #3ns;
          input fp_Z;  
          input ovrf;  
          input udrf;  
          output r_mode; 
          output fp_X; 
          output fp_Y; 
    endclocking 
	//clocking cb @(posedge clk);
	//	default input #1step output #3ns;
	//	input r_mode;
	//        input fp_X;
       	//        input fp_Y;
	//        output fp_Z;
	//	output ovrf;
	//	output udrf;
	//endclocking
endinterface
