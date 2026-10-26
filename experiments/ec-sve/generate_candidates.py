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
    elif variant in ('table4', 'table4_split2'):
        path = output / KERNEL
        text = path.read_text()
        text = text.replace('const svbool_t predicate_true = svptrue_b8();',
                            'const svbool_t predicate_true = svptrue_pat_b8(SV_VL16);', 1)
        text = text.replace('for (int d = 0; d < nvect && d < 7; d++) {',
                            'for (int d = 0; nvect <= 2 && d < nvect; d++) {', 1)
        text = text.replace('if (!is_all_one[d]) {', 'if (nvect > 2 || !is_all_one[d]) {', 1)
        text = text.replace('if (is_all_one[d]) {', 'if (nvect <= 2 && is_all_one[d]) {', 1)
        if variant == 'table4_split2':
            text = text.replace('unsigned char **dest, int nvect) ARM_STREAMING',
                                'unsigned char **dest, int nvect, int check_one) ARM_STREAMING', 1)
            text = text.replace('nvect <= 2 && d < nvect', 'check_one && d < nvect', 1)
            text = text.replace('nvect > 2 || !is_all_one[d]', '!check_one || !is_all_one[d]', 1)
            text = text.replace('nvect <= 2 && is_all_one[d]', 'check_one && is_all_one[d]', 1)
            text, count = re.subn(r'(gf_nvect_dot_prod_sve_unrolled\(len, vlen, gftbls, src, dest(?:_array)?, )([1-7])\);',
                                 lambda m: m[1] + m[2] + ', ' + ('1' if int(m[2]) <= 2 else '0') + ');', text)
            assert count == 14
            text, count = re.subn(r'        gf_nvect_dot_prod_sve_unrolled\(len, vlen, gftbls, src, dest, 2, 1\);', '''        if (len < 16)
                return;
        // Decide once per call, so the general GF loop has no XOR-path merge.
        if (is_dest_coeff_all_one(gftbls, vlen, 0) ||
            is_dest_coeff_all_one(gftbls, vlen, 1))
                gf_nvect_dot_prod_sve_unrolled(len, vlen, gftbls, src, dest, 2, 1);
        else
                gf_nvect_dot_prod_sve_unrolled(len, vlen, gftbls, src, dest, 2, 0);''', text)
            assert count == 2
        path.write_text(text)
    elif variant in ('adaptive', 'adaptive_fused'):
        path = output / KERNEL
        text = path.read_text()
        text = text.replace('int pos = 0;', '''int pos = 0;
        // Four batches are beneficial for one/two outputs. Larger output groups
        // need two batches to keep the live vector set within the register file.
        const int batches = nvect <= 2 ? 4 : 2;''', 1)
        text = text.replace('int is_all_one[7] = { 0 };', 'int is_all_one[7] = { 0 };\n        int needs_tables = 0;', 1)
        text = text.replace('is_all_one[d] = is_dest_coeff_all_one(gftbls, vlen, d);',
                            'is_all_one[d] = is_dest_coeff_all_one(gftbls, vlen, d);\n                needs_tables |= !is_all_one[d];', 1)
        start = text.index('                        for (int d = 0; d < nvect; d++) {')
        end = text.index('\n\n                        // Process each destination', start)
        original_extract = text[start:end]
        compact_extract = '''                        if (needs_tables) {
                                src_lo0 = svand_x(predicate_0, src_data0, mask0f);
                                src_hi0 = svlsr_x(predicate_0, src_data0, 4);
                                src_lo1 = svand_x(predicate_1, src_data1, mask0f);
                                src_hi1 = svlsr_x(predicate_1, src_data1, 4);
                                src_lo2 = svand_x(predicate_2, src_data2, mask0f);
                                src_hi2 = svlsr_x(predicate_2, src_data2, 4);
                                src_lo3 = svand_x(predicate_3, src_data3, mask0f);
                                src_hi3 = svlsr_x(predicate_3, src_data3, 4);
                        }'''
        text = text[:start] + '                        if (nvect > 2) {\n' + '\n'.join('        ' + line for line in compact_extract.splitlines()) + '\n                        } else {\n' + '\n'.join('        ' + line for line in original_extract.splitlines()) + '\n                        }' + text[end:]
        text, count = re.subn(r'(                        svst1_u8\(predicate_2,[^\n]+\n                        svst1_u8\(predicate_3,[^\n]+)',
                             lambda m: '                        if (batches == 4) {\n' + '\n'.join('        ' + line for line in m[1].splitlines()) + '\n                        }', text)
        assert count == 7
        text = text.replace('pos += sve_len * 4;', 'pos += sve_len * batches;')
        text = text.replace('const svbool_t predicate_true = svptrue_b8();', '''// TBL indices are nibbles: load exactly the 16-byte half-table,
        // including when the hardware vector length exceeds 128 bits.
        const svbool_t predicate_true = svptrue_pat_b8(SV_VL16);''', 1)
        path.write_text(text)
        if variant == 'adaptive_fused':
            path = output / HIGHLEVEL
            text = path.read_text()
            for suffix in ('sve', 'sve2'):
                start = text.index(f'ec_encode_data_{suffix}_impl(')
                end = text.index('\n}\n', start)
                section = text[start:end]
                section, count = re.subn(r'        case 7:\n.*?(?=        case 5:)', f'''        case 7:
                gf_7vect_dot_prod_{suffix}(len, k, g_tbls, data, coding);
                break;
        case 6:
                gf_6vect_dot_prod_{suffix}(len, k, g_tbls, data, coding);
                break;
''', section, flags=re.S)
                assert count == 1
                text = text[:start] + section + text[end:]
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
    p.add_argument('variant', choices=['compact1', 'compact2', 'adaptive', 'adaptive_fused', 'table4', 'table4_split2', 'group2'])
    a = p.parse_args()
    generate(a.source, a.output, a.variant)
