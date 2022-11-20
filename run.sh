source /mnt/vol_NFS_rh003/estudiantes/archivos_config/synopsys_tools.sh;
rm -rfv `ls |grep -v ".*\.sv\|.*\.sh\|.*.csv"`;

vcs -Mupdate testbench.sv -o salida -full64 -debug_acc+all -debug_region+cell+encrypt -sverilog -l log_test -ntb_opts uvm +lint=TFIPC-L -cm line+tgl+cond+fsm+branch+assert;

./salida +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=test_NaN +ntb_random_seed =1
