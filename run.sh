source /mnt/vol_NFS_rh003/estudiantes/archivos_config/synopsys_tools.sh
rm -rfv `ls |grep -v ".*\.sv\|.*\.sh\|.*.csv"`;

vcs -Mupdate testbench.sv -o salida -full64 -kdb -debug_acc+all -debug_region+cell+encrypt -sverilog -l log_test -ntb_opts uvm +lint=TFIPC-L -cm line+tgl;

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
do
	./salida +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=test_underflow +ntb_random_seed =i
done
./salida -cm line+tgl+cond;
dve -full64 -covdir salida.vdb &
Verdi -cov -covdir salida.vdb
