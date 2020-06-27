.PHONY: all
all: design

VERILATOR=verilator
VERILATOR_ROOT ?= $(shell bash -c 'verilator -V|grep VERILATOR_ROOT | head -1 | sed -e "s/^.*=\s*//"')
DESIGN=ca_core

VINC := $(VERILATOR_ROOT)/include

obj_dir/V$(DESIGN).cpp: rtl/$(DESIGN).sv
	$(VERILATOR) --trace -Wall -cc rtl/$(DESIGN).sv

obj_dir/V$(DESIGN)__ALL.a: obj_dir/V$(DESIGN).cpp
	make --no-print-directory -C obj_dir -f V$(DESIGN).mk

design: verilator_tb/main.cpp obj_dir/V$(DESIGN)__ALL.a
	g++ -I$(VINC) -I obj_dir            \
		$(VINC)/verilated.cpp       \
		$(VINC)/verilated_vcd_c.cpp \
		verilator_tb/main.cpp obj_dir/V$(DESIGN)__ALL.a \
		-o $(DESIGN)

.PHONY: clean
clean:
	rm -rf obj_dir/ $(DESIGN) $(DESIGN)trace.vcd
