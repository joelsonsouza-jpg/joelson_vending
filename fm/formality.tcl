# ============================================================
# formality.tcl
# Equivalência Formal RTL x Netlist
# Vending Machine Controller
# ============================================================

# ============================================================
# 1. Biblioteca de células
# Mesma usada no Design Compiler
# ============================================================

read_db ../libs/saed32rvt_tt1p05v25c.db

# Habilita uso completo do guidance SVF
set synopsys_auto_setup true

# ============================================================
# 2. Carrega SVF gerado pelo Design Compiler
# DEVE vir antes dos read_verilog
# ============================================================

set_svf ../synth/reports/default.svf

# ============================================================
# 3. GOLDEN DESIGN (RTL)
# ============================================================

read_verilog -09 -r {
    ../rtl/vending_pkg.sv
    ../rtl/credit_reg.sv
    ../rtl/memory.sv
    ../rtl/comparator.sv
    ../rtl/subtractor.sv
    ../rtl/control_unit.sv
    ../rtl/vending_top.sv
}

set_top r:/WORK/vending_top

# ============================================================
# 4. REVISED DESIGN (NETLIST)
# ============================================================

read_verilog -09 -i  ../synth/vending_top_netlist.v

set_top i:/WORK/vending_top

# ============================================================
# 5. MATCH
# ============================================================

match

# ============================================================
# 6. Relatórios do guidance SVF
# ============================================================

report_svf_operation -status accepted > reports/formality_svf_accepted.rpt

report_svf_operation -status rejected > reports/formality_svf_rejected.rpt

# ============================================================
# 7. Relatórios de casamento
# ============================================================

report_matched_points > reports/formality_matched.rpt

report_unmatched_points > reports/formality_unmatched.rpt

# ============================================================
# 8. VERIFY
# ============================================================

verify

# ============================================================
# 9. Relatórios finais de sign-off
# ============================================================

redirect reports/formality_status.rpt {
report_status
}

report_passing_points > reports/formality_passing.rpt

report_failing_points > reports/formality_failing.rpt

report_unmatched_points > reports/formality_unmatched.rpt

exit
