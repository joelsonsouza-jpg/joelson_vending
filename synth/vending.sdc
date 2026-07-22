# ============================================================
# Constraints - Vending Machine
# ============================================================
# Clock principal (50 MHz -> 20 ns)
# ============================================================

# 20 ns -> 50 MHz
create_clock -name clk -period 20 [get_ports clk]

# Incerteza do clock
set_clock_uncertainty 0.5 [get_clocks clk]


# ============================================================
# Input delay (entradas chegam antes do clock)
# ============================================================
# Esse comando define o atraso de entrada para todos os sinais de entrada, exceto para o clock.
# O atraso é definido como 1.0 ns após a subida do clock, e o clock é removido da coleção
# de entradas usando o comando remove_from_collection.
set_input_delay 3 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]

# ============================================================
# Output delay  (saídas vistas depois do clock)
# ============================================================
set_output_delay 3 -clock clk [all_outputs]

# ------------------------------------------------------------
# Driving cell (simplificado)
# ------------------------------------------------------------

set_driving_cell -lib_cell INVX1_RVT [all_inputs]

# ------------------------------------------------------------
# Load (carga típica de saída)
# ------------------------------------------------------------

set_load 0.1 [all_outputs]
