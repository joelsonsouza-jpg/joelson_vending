# ============================================================
# Script de Síntese - Vending Machine
# ============================================================

# ------------------------------------------------------------
# Carregar configuração do ambiente
# ------------------------------------------------------------
source synth/.synopsys_dc.setup

# ------------------------------------------------------------
# Ler RTL
# ------------------------------------------------------------
analyze -format sverilog rtl/vending_pkg.sv
analyze -format sverilog rtl/credit_reg.sv
analyze -format sverilog rtl/memory.sv
analyze -format sverilog rtl/comparator.sv
analyze -format sverilog rtl/subtractor.sv
analyze -format sverilog rtl/control_unit.sv
analyze -format sverilog rtl/vending_top.sv

# ------------------------------------------------------------
# Elaborar top-level
# ------------------------------------------------------------
elaborate vending_top
link

# ------------------------------------------------------------
# Constraints
# ------------------------------------------------------------
source synth/vending.sdc

# ------------------------------------------------------------
# Verificação do design
# ------------------------------------------------------------
puts "\n=================================================="
puts "CHECK DESIGN"
puts "=================================================="

check_design

# ------------------------------------------------------------
# Relatórios pré-síntese
# ------------------------------------------------------------
redirect synth/area_pre.rpt {
report_area -hierarchy
}

redirect synth/timing_pre.rpt {
report_timing -max_paths 10
}

# ------------------------------------------------------------
# Síntese
# ------------------------------------------------------------
puts "\n=================================================="
puts "INICIANDO SÍNTESE"
puts "=================================================="

compile_ultra -no_autoungroup

# ------------------------------------------------------------
# Relatórios pós-síntese
# ------------------------------------------------------------
redirect synth/area_pos.rpt {
report_area -hierarchy
}

redirect synth/timing_report.rpt {
report_timing -max_paths 10
}

redirect synth/power.rpt {
report_power
}

redirect synth/violations.rpt {
report_constraint -all_violators
}

# ------------------------------------------------------------
# Exportar netlist
# ------------------------------------------------------------
write -format verilog -hierarchy -output synth/vending_syn.v
write -format ddc -hierarchy -output synth/vending_syn.ddc

# ------------------------------------------------------------
# Salvar sessão DC
# ------------------------------------------------------------
write_file -format ddc -hierarchy -output synth/vending.ddc

puts "\n=================================================="
puts "SÍNTESE CONCLUÍDA"
puts "=================================================="
puts "Arquivos gerados:"
puts "  synth/area_pos.rpt"
puts "  synth/timing_report.rpt"
puts "  synth/power.rpt"
puts "  synth/violations.rpt"
puts "  synth/vending_syn.v"
puts "  synth/vending_syn.ddc"
puts "=================================================="