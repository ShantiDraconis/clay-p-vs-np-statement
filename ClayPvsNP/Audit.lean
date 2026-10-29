import ClayPvsNP.Statement

/-!
# Auditoria de axiomas

Cada `#guard_msgs` fixa a saída de `#print axioms`. Se aparecer qualquer axioma diferente
(inclusive `sorryAx`), a compilação falha.

`Classical.choice`, quando aparece, vem do Mathlib: `#print axioms Real` já dá
`[propext, Classical.choice, Quot.sound]` (idem `ℂ`, `Polynomial ℕ`, `Turing.TM2`).
-/

/-- info: 'ClayPvsNP.P_eq_NP' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ClayPvsNP.P_eq_NP

/-- info: 'ClayPvsNP.pair_injective' depends on axioms: [propext] -/
#guard_msgs in #print axioms ClayPvsNP.pair_injective
