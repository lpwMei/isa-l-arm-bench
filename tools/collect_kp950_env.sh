#!/usr/bin/env bash
# Read-only collection. Run on the target Linux server: bash collect_kp950_env.sh
set -u

section() { printf '\n--- %s ---\n' "$1"; }

section 'OS and CPU'
uname -a
if [ -r /etc/os-release ]; then cat /etc/os-release; fi
if command -v lscpu >/dev/null 2>&1; then lscpu; fi
if command -v numactl >/dev/null 2>&1; then numactl --hardware; fi

section 'CPU identity and exposed instructions'
if [ -r /proc/cpuinfo ]; then
    awk '/^(processor|CPU implementer|CPU architecture|CPU variant|CPU part|CPU revision|Features)[[:space:]]*:/ {print} /^$/ {exit}' /proc/cpuinfo
fi
if [ -r /sys/devices/system/cpu/cpu0/regs/identification/midr_el1 ]; then
    cat /sys/devices/system/cpu/cpu0/regs/identification/midr_el1
fi
if [ -r /proc/sys/abi/sve_default_vector_length ]; then
    printf 'Default SVE vector length (bytes): '
    cat /proc/sys/abi/sve_default_vector_length
fi

section 'Compiler and runtime versions'
for tool in gcc clang cc as make autoconf automake libtoolize perf; do
    if command -v "$tool" >/dev/null 2>&1; then
        "$tool" --version 2>&1 | head -n 2
    fi
done
if command -v ldd >/dev/null 2>&1; then ldd --version 2>&1 | head -n 1; fi
if command -v openssl >/dev/null 2>&1; then openssl version; fi
if command -v pkg-config >/dev/null 2>&1; then
    for package in zlib openssl; do
        printf '%s: ' "$package"
        pkg-config --modversion "$package" 2>/dev/null || true
    done
fi

section 'Frequency and scheduling context'
for item in \
    /sys/devices/system/cpu/online \
    /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor \
    /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq \
    /proc/sys/kernel/perf_event_paranoid; do
    if [ -r "$item" ]; then printf '%s: ' "$item"; cat "$item"; fi
done
if command -v taskset >/dev/null 2>&1; then taskset -pc $$; fi

section 'Process auxv and current thread SVE length (optional Python 3 probe)'
if command -v python3 >/dev/null 2>&1; then
    python3 - <<'PY'
import ctypes
import os
import platform

if platform.system() != "Linux" or platform.machine().lower() not in ("aarch64", "arm64"):
    print("AArch64 Linux probe skipped on this architecture")
else:
    libc = ctypes.CDLL(None, use_errno=True)
    libc.getauxval.argtypes = [ctypes.c_ulong]
    libc.getauxval.restype = ctypes.c_ulong
    hwcap = libc.getauxval(16)   # AT_HWCAP
    hwcap2 = libc.getauxval(26)  # AT_HWCAP2
    print(f"AT_HWCAP=0x{hwcap:x} AT_HWCAP2=0x{hwcap2:x}")
    libc.prctl.argtypes = [ctypes.c_int] + [ctypes.c_ulong] * 4
    libc.prctl.restype = ctypes.c_int
    vl = libc.prctl(51, 0, 0, 0, 0)  # PR_SVE_GET_VL; read only
    if vl < 0:
        print("PR_SVE_GET_VL:", os.strerror(ctypes.get_errno()))
    else:
        print(f"Current probe thread SVE VL={vl & 0xffff} bytes; raw=0x{vl:x}")
    print("Measure VL again inside the benchmark thread if it changes SVE configuration.")
PY
else
    printf 'python3 unavailable; use lscpu Features and a native getauxval/prctl probe.\n'
fi
