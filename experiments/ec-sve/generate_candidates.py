#!/usr/bin/env python3
"""Create isolated EC tuning candidates from a pinned, unmodified ISA-L tree."""
import argparse
import re
import shutil
from pathlib import Path

KERNEL = Path('erasure_code/aarch64/gf_nvect_dot_prod_sve.c')
HIGHLEVEL = Path('erasure_code/aarch64/ec_aarch64_highlevel_func.c')


def compact_helper(unroll=2):
    lines = ['''// Bound the live accumulator set for three or more output rows.
#ifdef __APPLE__
__attribute__((target("+sme"), always_inline))
#else
__attribute__((target("+sve"), always_inline))
#endif
static inline void
gf_nvect_dot_prod_sve_compact(int len, int vlen, unsigned char *gftbls,
                            unsigned char **src, unsigned char **dest, int nvect) ARM_STREAMING
{
        if (len < 16)
                return;
        const svbool_t all = svptrue_b8();
        // A coefficient contains two 16-byte tables, regardless of vector length.
        const svbool_t table_lanes = svwhilelt_b8_u64(0, 16);
        const svuint8_t mask = svdup_u8(15);
        const int width = svcntb();
        int is_all_one[7] = { 0 };
        int needs_tables = 0;
        for (int d = 0; d < nvect; d++) {
                is_all_one[d] = is_dest_coeff_all_one(gftbls, vlen, d);
                needs_tables |= !is_all_one[d];
        }
''']
    lines.append(f'        for (int pos = 0; pos < len; pos += width * {unroll}) {{')
    for b in range(unroll):
        lines.append(f'                const svbool_t p{b} = svwhilelt_b8_s32(pos + width * {b}, len);')
        for d in range(7):
            lines.append(f'                svuint8_t a{b}_{d} = svdup_u8(0);')
    lines.append('                for (int v = 0; v < vlen; v++) {')
    for b in range(unroll):
        lines.append(f'                        const svuint8_t s{b} = svld1_u8(p{b}, src[v] + pos + width * {b});')
        lines.append(f'                        svuint8_t lo{b} = svdup_u8(0), hi{b} = svdup_u8(0);')
    lines.append('                        if (needs_tables) {')
    for b in range(unroll):
        lines.extend([f'                                lo{b} = svand_x(p{b}, s{b}, mask);',
                      f'                                hi{b} = svlsr_x(p{b}, s{b}, 4);'])
    lines.extend(['                        }', '                        for (int d = 0; d < nvect; d++) {'])
    for b in range(unroll):
        lines.append(f'                                svuint8_t r{b};')
    lines.append('                                if (is_all_one[d]) {')
    for b in range(unroll):
        lines.append(f'                                        r{b} = s{b};')
    lines.extend(['                                } else {',
                  '                                        const unsigned char *t = gftbls + (d * vlen + v) * 32;',
                  '                                        const svuint8_t tl = svld1_u8(table_lanes, t);',
                  '                                        const svuint8_t th = svld1_u8(table_lanes, t + 16);'])
    for b in range(unroll):
        lines.append(f'                                        r{b} = sveor_x(p{b}, svtbl_u8(tl, lo{b}), svtbl_u8(th, hi{b}));')
    lines.extend(['                                }', '                                switch (d) {'])
    for d in range(7):
        lines.append(f'                                case {d}:')
        for b in range(unroll):
            lines.append(f'                                        a{b}_{d} = sveor_x(p{b}, a{b}_{d}, r{b});')
        lines.append('                                        break;')
    lines.extend(['                                }', '                        }', '                }',
                  '                switch (nvect) {'])
    for d in reversed(range(7)):
        lines.append(f'                case {d + 1}:')
        for b in range(unroll):
            lines.append(f'                        svst1_u8(p{b}, dest[{d}] + pos + width * {b}, a{b}_{d});')
        lines.append('                        /* fallthrough */' if d else '                        break;')
    lines.extend(['                }', '        }', '}', ''])
    return '\n'.join(lines)


def generate(source, output, variant):
    shutil.copytree(source, output, ignore=shutil.ignore_patterns('.git', '.libs', '*.o'), dirs_exist_ok=False)
    if variant.startswith('compact'):
        n = int(variant.removeprefix('compact'))
        path = output / KERNEL
        text = path.read_text()
        marker = '// Optimized wrapper functions'
        text = text.replace(marker, compact_helper(n) + '\n' + marker)
        text, count = re.subn(r'gf_nvect_dot_prod_sve_unrolled\((len, vlen, gftbls, src, dest, [3-7])\);',
                             r'gf_nvect_dot_prod_sve_compact(\1);', text)
        assert count == 10, count
        path.write_text(text)
    elif variant == 'group2':
        path = output / HIGHLEVEL
        text = path.read_text()
        for suffix in ('sve', 'sve2'):
            start = text.index(f'ec_encode_data_{suffix}_impl(')
            start = text.index('{', start)
            end = text.index('\n}\n', start) + 2
            body = f'''{{
        while (rows >= 2) {{
                gf_2vect_dot_prod_{suffix}(len, k, g_tbls, data, coding);
                g_tbls += 2 * k * 32;
                coding += 2;
                rows -= 2;
        }}
        if (rows)
                gf_vect_dot_prod_{suffix}(len, k, g_tbls, data, *coding);
}}'''
            text = text[:start] + body + text[end:]
        path.write_text(text)
    else:
        raise ValueError(variant)


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('source', type=Path)
    p.add_argument('output', type=Path)
    p.add_argument('variant', choices=['compact1', 'compact2', 'group2'])
    a = p.parse_args()
    generate(a.source, a.output, a.variant)

