# ARM 交叉编译证据

这里只生成汇编，未执行 ARM 代码，也未测量鲲鹏 950 性能。

编译器：本机 Clang 23.1.3，LLVM commit `0d261d1ca552c95a8f007e061c787ac7132fbcbc`。

在 `D:/codex/ISA-L` 执行的等价命令：

```text
clang --target=aarch64-none-elf -ffreestanding -O3 -S -march=armv8-a upstream/isa-l/erasure_code/aarch64/gf_nvect_dot_prod_sve.c -o analysis/asm/gf_nvect_dot_prod_sve.clang.s
clang --target=aarch64-none-elf -ffreestanding -O3 -S -march=armv8-a releases/isa-l-v2.32.1/erasure_code/aarch64/gf_nvect_dot_prod_sve.c -o analysis/asm/gf_nvect_dot_prod_sve.v2.32.1.clang.s
```

文件内的 `target("+sve")` / `target("+sve+sve2")` 属性负责启用对应函数的 ISA。

主干输出中，`gf_3vect_dot_prod_sve`、`gf_4vect_dot_prod_sve` 及对应 SVE2 函数可见循环内 `str z...` / `ldr z...` 栈溢出和重载；因此“降低寄存器压力、调整展开倍数”有静态证据支撑。只看函数入口保存 ABI 要求的 `d8` 等寄存器不能得出这个结论。

`spill-summary.csv` 统计编译器标注为 Spill/Reload 且涉及 Z 寄存器的静态指令行数。它既不是动态执行次数，也不是内存流量或性能预测。

该目标是 freestanding ELF，不包含服务器发行版、生产编译器版本及其 `-mcpu/-mtune` 配置。开始优化前，必须在实际 GCC/毕昇/Clang 构建的 Linux 目标文件中重新反汇编，确认热点与收益。
