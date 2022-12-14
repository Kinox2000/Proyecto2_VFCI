//`timescale 1ns/ps
//Se inluyen los archivos necesarios para correr la verificación
`include "uvm_macros.svh"
`define LENGTH 32
import uvm_pkg::*;
`include "multiplicador_32_bits_FP_IEEE_debugeado.sv"
`include "interface.sv"
`include "sequence_item.sv"
`include "sequence.sv"
`include "monitor.sv"
`include "driver.sv"
`include "scoreboard.sv"
`include "agent.sv"
`include "environment.sv"
`include "test.sv"

module tb;
	reg clk;

	mul_if _if(.clk(clk));//Interfaz para comunicarse con el DUT

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	top u0 (.clk(_if.clk),
		 .r_mode(_if.r_mode), 
		 .fp_X(_if.fp_X), 
		 .fp_Y(_if.fp_Y), 
		 .fp_Z(_if.fp_Z), 
		 .ovrf(_if.ovrf), 
		 .udrf(_if.udrf));
	 initial begin
       		 //uvm_top.set_report_verbosity_level(UVM_HIGH);
		 uvm_config_db #(virtual mul_if)::set(null, "uvm_test_top", "_if", _if);//Se guarda la interfaz en la base de datos
		 run_test("test_completo");
		 //run_test("test_random");
		 //run_test("test_underflow");
		 //run_test("test_overflow");
		 //run_test("test_NaN");
		 //run_test("test_inf");
		 //run_test("test_max_alter");
	 end

endmodule
