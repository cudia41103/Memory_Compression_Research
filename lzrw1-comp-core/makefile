TESTVECTORSFLAGS =  --num_chars 256 --num_vectors 100 --manual_tv manual_tvs.txt --io_path test_vectors/
export VCS_ARCH_OVERRIDE=linux
VCS_FLAGS= -full64 -lca -sverilog +lint=all,noNS -timescale=1ns/1ns -debug_acc+all -kdb -fsdb -suppress=LCA_FEATURES_ENABLED
COMP_HDL_SRCS := $(shell find $(PWD)/compressor -name '*.sv')
DECOMP_HDL_SRCS := $(shell find $(PWD)/decompressor -name '*.sv')
export LD_LIBRARY_PATH=/custom/lib:$LD_LIBRARY_PATH


run_top_testbench: compile_testbench_sv
	./simv 

run_decompressor_testbench: compile_decompressor_sv 
	./simv_decompressor +NUM_AUTO_TESTS=100 

run_compressor_testbench: compile_compressor_sv
	./simv_compressor 

compile_testbench_sv:
	vcs $(VCS_FLAGS) TBandDesign/top.sv compressor/Comparator.sv compressor/compinput.sv compressor/hashFunction.sv compressor/tableofPtr.sv compressor/CompressedValues.sv compressor/compressor_top.sv decompressor/history_buffer.sv decompressor/decompressor_top.sv -o simv

# Add -fsdb and -debug_access+all for FSDB generation
compile_compressor_sv:
	vcs $(VCS_FLAGS) compressor/Comparator.sv compressor/compinput.sv compressor/hashFunction.sv compressor/tableofPtr.sv compressor/CompressedValues.sv compressor/compressor_top.sv compressor/compinput_tb.sv -o simv_compressor
compile_decompressor_sv:
	vcs $(VCS_FLAGS) decompressor/history_buffer.sv decompressor/decompressor_top.sv decompressor/decompressor_top_tb.sv -o simv_decompressor

create_test_vectors:
	python3 test_vectors/GenerateVectors.py $(TESTVECTORSFLAGS)

clean_test_vectors:
	rm test_vectors/*bin

clean:
	rm -rf simv* csrc DVEfiles ucli.key vcdplus.vpd
