VLOG = vlog -sv
VSIM = vsim -c

TOP  ?= tb_top
TEST ?= counter_test

.PHONY: all compile run clean

all: run

compile:
	vlib work
	vmap work work

	$(VLOG) -work work +incdir+include \
	    src/socetlib_counter.sv

	$(VLOG) -work work \
	    tb/counter_if.sv

	$(VLOG) -work work +incdir+tb \
	    tb/counter_pkg.sv

	$(VLOG) -work work +incdir+tb \
	    tb/counter_tb.sv

run: compile
	$(VSIM) work.$(TOP) \
	    +UVM_TESTNAME=$(TEST) \
	    -do "run -all; quit -f"

clean:
	rm -rf work transcript vsim.wlf
