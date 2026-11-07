VLOG = vlog -sv
VSIM = vsim -c

TOP  ?= tb_top
TEST ?= counter_test

.PHONY: all compile run regress clean

all: run

compile:
	vlib work
	vmap work work

	$(VLOG) -work work +incdir+include \
	    src/counter.sv

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
	rm -rf work transcript vsim.wlf logs

# Run randomized + directed tests and fail if the UVM summary is not clean.
regress: compile
	@mkdir -p logs
	@set -e; for t in counter_test counter_reset_test counter_count_test counter_clear_test counter_overflow_test; do \
	    echo "========== $$t =========="; \
	    $(VSIM) -l logs/$$t.log work.$(TOP) +UVM_TESTNAME=$$t -do "run -all; quit -f"; \
	    grep -Eq 'UVM_ERROR[[:space:]]*:[[:space:]]*0([[:space:]]|$$)' logs/$$t.log || { echo "FAIL: $$t has UVM errors or no UVM summary"; exit 1; }; \
	    grep -Eq 'UVM_FATAL[[:space:]]*:[[:space:]]*0([[:space:]]|$$)' logs/$$t.log || { echo "FAIL: $$t has UVM fatals or no UVM summary"; exit 1; }; \
	    echo "PASS: $$t"; \
	done

