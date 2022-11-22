source /mnt/vol_NFS_rh003/estudiantes/archivos_config/synopsys_tools.sh
rm -rfv `ls |grep -v ".*\.sv\|.*\.sh"`;

vcs -Mupdate testbench.sv -o salida -full64 -kdb -debug_acc+all -debug_region+cell+encrypt -sverilog -l log_test -ntb_opts uvm +lint=TFIPC-L -cm line+tgl+cond+branch+assert;

for i in {1..20} 
do
	./salida +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=test_completo +ntb_random_seed =$i
done
./salida -cm line+tgl+cond+branch+assert;
dve -full64 -covdir salida.vdb &
Verdi -cov -covdir salida.vdb
