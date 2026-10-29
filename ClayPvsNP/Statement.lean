import Mathlib.Computability.TuringMachine.Computable

/-!
# P vs NP — enunciado limpo

Fonte do enunciado: S. Cook, *The P versus NP Problem* (descrição oficial do Clay
Mathematics Institute). Linguagens sobre o alfabeto `{0,1}`; `P` = decidíveis em tempo
polinomial por máquina de Turing determinística; `NP` = verificáveis em tempo polinomial com
certificado de tamanho polinomial. O problema é decidir se `P = NP`.

Modelo de máquina: `Turing.TM2ComputableInPolyTime` de Mathlib (máquina com número finito de
pilhas, controle finito, alfabeto de entrada finito; a contagem de passos é limitada por um
polinômio no tamanho da entrada). Os símbolos que podem aparecer nas pilhas internas vêm de
`push` com argumento no conjunto finito de estados, então o alfabeto efetivo é finito. Esse
modelo e a máquina de Turing de uma fita se simulam com perda polinomial, logo definem a mesma
classe `P`.

Sem axiomas, `sorry` ou marcadores. `OPEN_MATH = true`.
-/

namespace ClayPvsNP

open Turing

/-- Palavras binárias. -/
abbrev Word := List Bool

/-- Linguagens sobre `{0,1}`. -/
abbrev Language := Set Word

/-- `f` é computada em tempo polinomial por uma máquina TM2 de Mathlib: a entrada é a própria
palavra e a saída é a lista de um símbolo `[f w]`. -/
def PolyTimeComputable (f : Word → Bool) : Prop :=
  Nonempty (TM2ComputableInPolyTime (αΓ := Bool) (βΓ := Bool) id (fun b : Bool => [b]) f)

/-- `L ∈ P`: existe um decisor de tempo polinomial. -/
def InP (L : Language) : Prop :=
  ∃ f : Word → Bool, PolyTimeComputable f ∧ ∀ w, w ∈ L ↔ f w = true

/-- Codificação de pares `⟨w, c⟩` como palavra binária: cada bit `b` de `w` vira `1 b`,
depois um `0` separa, depois vem `c`. É injetiva (`pair_injective`) e decodificável em tempo
linear. -/
def pair (w c : Word) : Word := (w.flatMap fun b => [true, b]) ++ false :: c

/-- `L ∈ NP`: existe um verificador `V ∈ P` e um polinômio `q` tais que `w ∈ L` se e somente
se algum certificado `c` com `|c| ≤ q(|w|)` faz `V` aceitar `⟨w, c⟩`. -/
def InNP (L : Language) : Prop :=
  ∃ (V : Language) (q : Polynomial ℕ), InP V ∧
    ∀ w, w ∈ L ↔ ∃ c : Word, c.length ≤ q.eval w.length ∧ pair w c ∈ V

/-- A classe P. -/
def P : Set Language := {L | InP L}

/-- A classe NP. -/
def NP : Set Language := {L | InNP L}

/-- A proposição `P = NP`. O problema do Clay é provar esta proposição ou a sua negação
(espera-se `P ≠ NP`). Note que `P_eq_NP ∨ ¬ P_eq_NP` é uma tautologia e não resolve nada. -/
def P_eq_NP : Prop := P = NP

@[simp] theorem pair_nil (c : Word) : pair [] c = false :: c := rfl

@[simp] theorem pair_cons (b : Bool) (w c : Word) :
    pair (b :: w) c = true :: b :: pair w c := by
  simp [pair]

/-- Teste: a codificação de pares é injetiva, então o verificador recebe `w` e `c` sem
ambiguidade. -/
theorem pair_injective :
    ∀ (w₁ c₁ w₂ c₂ : Word), pair w₁ c₁ = pair w₂ c₂ → w₁ = w₂ ∧ c₁ = c₂ := by
  intro w₁
  induction w₁ with
  | nil =>
    intro c₁ w₂ c₂ h
    cases w₂ with
    | nil => simp_all
    | cons b w₂ => simp at h
  | cons b w₁ ih =>
    intro c₁ w₂ c₂ h
    cases w₂ with
    | nil => simp at h
    | cons b' w₂ =>
      simp only [pair_cons, List.cons.injEq, true_and] at h
      obtain ⟨rfl, h⟩ := h
      obtain ⟨rfl, rfl⟩ := ih c₁ w₂ c₂ h
      exact ⟨rfl, rfl⟩

end ClayPvsNP
