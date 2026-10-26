# XMODEM CRC16 Benchmark Makefile
# Targets:
#   make all          - build everything
#   make test         - correctness tests
#   make bench        - performance benchmarks
#   make clean        - remove binaries

CC       := gcc
CFLAGS   := -O2 -Wall -Wextra
ASFLAGS  :=

# Binaries
BENCH_ORIG   := crc16_bench
BENCH_PMULL  := crc16_xmodem_bench

# Source files
SRC_ORIG     := crc16_bench.c
SRC_PMULL_C  := crc16_xmodem_bench.c crc16_xmodem_dispatch.c
SRC_PMULL_S  := crc16_xmodem_pmull.S crc16_xmodem_pmull_opt.S crc16_xmodem_pmull_8way.S crc16_xmodem_short.S

# Both
SRC     := $(SRC_PMULL_C) $(SRC_PMULL_S)
OBJ_ORIG    := $(SRC_ORIG:.c=.o)
OBJ_PMULL_C := $(SRC_PMULL_C:.c=.o)
OBJ_PMULL_S := $(SRC_PMULL_S:.S=.o)

.PHONY: all test bench clean help ebpf distclean

all: $(BENCH_ORIG) $(BENCH_PMULL)

# ---- eBPF tracer ----
ebpf: $(BENCH_PMULL)
	$(MAKE) -C ebpf
	@echo ""
	@echo "=== eBPF tracer built ==="
	@echo "Run with:  sudo ./ebpf/crc16_len_dist ./$(BENCH_PMULL)"

# ---- Link rules ----
$(BENCH_ORIG): $(OBJ_ORIG)
	$(CC) $(CFLAGS) -o $@ $^

$(BENCH_PMULL): $(OBJ_PMULL_C) $(OBJ_PMULL_S)
	$(CC) $(CFLAGS) -o $@ $^

# ---- Compile rules ----
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

crc16_xmodem_bench.o: crc16_xmodem_constants.h

%.o: %.S
	$(CC) $(CFLAGS) -c -o $@ $<

# ---- Tests ----
test: $(BENCH_PMULL)
	@echo "=== Correctness Tests ==="
	./$(BENCH_PMULL) --test

# ---- Benchmarks ----
bench: $(BENCH_ORIG) $(BENCH_PMULL)
	@echo "=== Original CRC16 Benchmark ==="
	./$(BENCH_ORIG)
	@echo ""
	@echo "=== PMULL-Optimized CRC16 Benchmark ==="
	./$(BENCH_PMULL)

# ---- Clean ----
clean:
	rm -f $(BENCH_ORIG) $(BENCH_PMULL) $(OBJ_ORIG) $(OBJ_PMULL_C) $(OBJ_PMULL_S)
	$(MAKE) -C ebpf clean

distclean: clean
	$(MAKE) -C ebpf distclean

# ---- Help ----
help:
	@echo "XMODEM CRC16 Benchmark"
	@echo ""
	@echo "Targets:"
	@echo "  all     build all binaries (default)"
	@echo "  test    run correctness tests"
	@echo "  bench   run all benchmarks"
	@echo "  clean   remove binaries"
	@echo "  help    this message"
