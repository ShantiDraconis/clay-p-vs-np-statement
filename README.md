# P vs NP — enunciado formal em Lean 4 / Mathlib

Este repositório contém **o enunciado** do problema como uma proposição de Lean (`Prop`),
construída só com definições do Mathlib. **Não é uma solução**: o problema continua aberto
(`OPEN_MATH = true`).

- Enunciado: [`ClayPvsNP/Statement.lean`](ClayPvsNP/Statement.lean)
- Fonte do texto oficial: S. Cook, *The P versus NP Problem* (descrição oficial do Clay Mathematics Institute)
- Mathlib: commit `8fe7ce475b056f0b266d7107893f2c4d772c712f` (28/10/2026), Lean `v4.36.0-rc2`
- Sem `axiom`, `sorry`, `native_decide`, marcadores (`:= True`) ou correspondências inventadas.

## Teste de não vacuidade (provado no kernel)

`pair_injective`: a codificação ⟨w, c⟩ entregue ao verificador é injetiva, então o certificado é recuperável sem ambiguidade.

## Axiomas (`#print axioms`, saída real)

| Declaração | Axiomas |
|---|---|
| `ClayPvsNP.P_eq_NP` | `[propext, Classical.choice, Quot.sound]` |
| `ClayPvsNP.pair_injective` | `[propext]` |

`Classical.choice` vem do Mathlib, não deste arquivo: o próprio tipo `ℝ` já depende dele (`#print axioms Real` → `[propext, Classical.choice, Quot.sound]`), e o mesmo vale para `ℂ`, `Polynomial ℕ` e a máquina `TM2`. São os três axiomas padrão do Lean; nenhum axioma deste repositório aparece.

[`ClayPvsNP/Audit.lean`](ClayPvsNP/Audit.lean) fixa essas listas com `#guard_msgs`, e o CI roda
`lake build`: se surgir um axioma novo (ou `sorryAx`), a compilação falha.

## Compilar

```
lake exe cache get
lake build
```
