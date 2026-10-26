# ebpf/ — eBPF tracer for crc16_xmodem() len distribution
#
# Prerequisites (Debian / Ubuntu on AARCH64):
#   sudo apt install -y clang llvm libbpf-dev linux-tools-$(uname -r) \
#                       linux-headers-$(uname -r) libelf-dev zlib1g-dev
#
# Build:
#   make                       # build the compiled tracer
#
# Run (compiled version):
#   sudo ./crc16_len_dist ../crc16_xmodem_bench
#   sudo ./crc16_len_dist ../crc16_xmodem_bench crc16_xmodem_pmull 5
#
# Run (bpftrace quick version):
#   sudo bpftrace crc16_len_dist.bt ../crc16_xmodem_bench

CLANG       := clang
BPFTOOL     := bpftool
CC          := gcc

CFLAGS      := -O2 -Wall -Wextra -g
BPF_CFLAGS  := -O2 -g -target bpf \
               -D__TARGET_ARCH_arm64 \
               -I. \
               $(shell pkg-config --cflags libbpf 2>/dev/null)

LDFLAGS     := $(shell pkg-config --libs libbpf 2>/dev/null || echo "-lbpf") \
               -lelf -lz

TARGET      := crc16_len_dist
BPF_SRC     := crc16_len_dist.bpf.c
BPF_OBJ     := crc16_len_dist.bpf.o
SKEL_H      := crc16_len_dist.skel.h
VMLINUX_H   := vmlinux.h

.PHONY: all clean vmlinux bpftrace-check distclean

all: $(TARGET)

# ---- Generate vmlinux.h from running kernel's BTF ----
$(VMLINUX_H):
	@echo "Generating $@ from kernel BTF (requires bpftool + BTF)..."
	$(BPFTOOL) btf dump file /sys/kernel/btf/vmlinux format c > $@

vmlinux: $(VMLINUX_H)

# ---- Compile BPF object ----
$(BPF_OBJ): $(BPF_SRC) $(VMLINUX_H)
	$(CLANG) $(BPF_CFLAGS) -c -o $@ $<

# ---- Generate skeleton header ----
$(SKEL_H): $(BPF_OBJ)
	$(BPFTOOL) gen skeleton $< > $@

# ---- Compile userspace loader ----
$(TARGET): crc16_len_dist.c $(SKEL_H)
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

# ---- Clean ----
clean:
	rm -f $(TARGET) $(BPF_OBJ) $(SKEL_H)

# Remove vmlinux.h too (regenerate on next build)
distclean: clean
	rm -f $(VMLINUX_H)

# ---- Check bpftrace availability ----
bpftrace-check:
	@command -v bpftrace >/dev/null 2>&1 \
		&& echo "bpftrace found: $$(bpftrace --version)" \
		|| echo "bpftrace NOT found — install with: sudo apt install bpftrace"
