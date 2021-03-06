
DTOP=.
BOARD=vc709
PREFIX?=/usr/local
DMAC_DIR?=../src

BSCFLAGS_COMMON = $(BSV_FLAGS_DMAC) -D BOARD_$(BOARD)
BSCFLAGS_COMMON += +RTS -K46777216 -RTS -show-schedule
BSCPATHFLAGS=  -bdir $(DTOP)/obj-$(BOARD) -vdir $(DTOP)/verilog -simdir $(DTOP)/obj-$(BOARD) -info-dir $(DTOP)/obj-$(BOARD)
BSCFLAGS_COMMON += $(BSCWARNFLAGS) $(BSCOPTFLAGS) $(BSCPATHFLAGS) --wait-for-license

all: testdma-$(BOARD) bits

clean:
	rm -fr *.so bsim testdma-bluesim testdma-vc709 obj verilog vc709 vivado.* *.o

.PHONY: ConnectalProjectConfig.bsv

ConnectalProjectConfig.bsv: 
	if [ -f $(DMAC_DIR)/template/ConnectalProjectConfig.bsv ] ; then cp -v $(DMAC_DIR)/template/ConnectalProjectConfig.bsv .; fi
	sed -i s/DmaTopPins/DmaComponentPins/ ConnectalProjectConfig.bsv

ifneq ($(BOARD),bluesim)
bits: mkComponent.bit

run: testdma-$(BOARD) mkComponent.bit
	fpgajtag mkComponent.bit
	LD_LIBRARY_PATH=$(PREFIX)/lib NOPROGRAM=1 ./testdma-$(BOARD)

mkComponent.bit: verilog/mkComponent.v ipcore
	rm -fr vc709
	DMAC_DIR=$(DMAC_DIR) vivado -mode batch -source impl.tcl
	cp -v vc709/vc709.runs/impl_1/mkComponent.bit mkComponent.bit

verilog/mkComponent.v: Component.bsv ConnectalProjectConfig.bsv
	mkdir -p obj-$(BOARD) verilog
	bsc $(BSCFLAGS_COMMON) -u -g mkComponent Component.bsv
	$(Q)sed -i 's|// On .*|// timestamp removed|' verilog/*.v
	$(Q)sed -i 's|  wire.*PROBE[,;]|(* mark_debug="true" *)&|' verilog/*.v 
	$(Q)sed -i 's|  wire.*PROBE_VALID[,;]|(* mark_debug="true" *)&|' verilog/*.v 
else
bits: bsim

run: testdma-$(BOARD) bsim
	PATH=.:$(PATH) LD_LIBRARY_PATH=.:../src catchsegv ./testdma-bluesim

obj-$(BOARD)/mkComponent.ba: Component.bsv ConnectalProjectConfig.bsv
	mkdir -p obj-$(BOARD) verilog
	bsc $(BSCFLAGS_COMMON) -sim -u -g mkComponent Component.bsv

bsim: obj-$(BOARD)/mkComponent.ba
	bsc $(BSCFLAGS_COMMON) -sim -u -e mkComponent -o bsim -L $(DMAC_DIR) -l dmac-bluesim obj-$(BOARD)/mkComponent.ba 

endif

testdma.o: testdma.cpp
	g++ -O -g -I../src -c testdma.cpp


testdma-$(BOARD): testdma.o $(DMAC_DIR)/libdmac-$(BOARD).a
	g++ -O -g -o testdma-$(BOARD) testdma.o -L$(DMAC_DIR) -ldmac-$(BOARD) -lpthread

include $(DMAC_DIR)/Makefile.dmac
