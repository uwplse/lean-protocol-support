/-
This module defines operations for simplifying equalities between natural numbers.

After importing this, simp should reduce all ground number equalities
to true or false.
-/

namespace nat

/- Simplify 0 = succ n to false -/
@[simp]
theorem not_zero_eq_succ (x : ℕ) : ¬ (0 = succ x) :=
begin
  contradiction,
end

@[simp]
theorem succ_eq_zero (x : ℕ) : (succ x = 0) ↔ false :=
begin
  simp [bit0],
  induction x,
  contradiction,
  contradiction
end

/- Simplify succ n = 0 to false -/
@[simp]
theorem not_succ_eq_zero (n : ℕ) : ¬ (nat.succ n = 0) :=
begin
  contradiction,
end

-- Simplify successor of two values.
@[simp]
theorem succ_eq_succ (x y : ℕ): succ x = succ y ↔ x = y :=
begin
  apply iff.intro,
  { intro p,
    apply @nat.no_confusion _ _ _ p,
    exact id,
  },
  { intro p,
    rw [p]
  }
end

/- Lemmas comparing operations with zero. -/
section zero_comparison

/- Simplify comparison of sum of two naturals with 0. -/
theorem add_is_zero_iff (m n : ℕ) : m + n = 0 ↔ m = 0 ∧ n = 0 :=
begin
  cases n,
  case zero { simp, },
  case succ n ind { simp [add_succ], },
end

/- Simplify comparison of product of two naturals with 0. -/
theorem mul_is_zero_iff (m n : ℕ) : m * n = 0 ↔ m = 0 ∨ n = 0 :=
begin
  induction n,
  case zero { simp, },
  case succ n ind {
    simp [mul_succ, add_is_zero_iff, ind],
    by_cases m = 0 with h,
    all_goals { simp [h], },
  }
end

/- Simplify comparison of power of two naturals with 0. -/
theorem pow_is_zero_iff (m n : ℕ) : m ^ n = 0 ↔ m = 0 ∧ n ≠ 0 :=
begin
  induction n,
  case zero { simp, },
  case succ n ind {
    simp [pow, mul_is_zero_iff, ind],
    by_cases m = 0 with h,
    all_goals { simp [h], },
  }
end

end zero_comparison

-- Commute bit0 and succ
protected
theorem bit0_succ (x : ℕ) : bit0 (succ x) = succ (succ (bit0 x)) :=
begin
  simp [bit0, add_succ, succ_add]
end

-- Commute bit1 and succ
protected
theorem bit1_succ (x : ℕ) : bit1 (succ x) = succ (succ (bit1 x)) :=
begin
  simp [bit1, nat.bit0_succ],
end

-- Commute succ and bit1.
protected
lemma succ_bit1 (x:ℕ) : succ (bit1 x) = bit0 (succ x) :=
begin
  induction x,
  case zero { simp, },
  case succ x ind {
    simp [nat.bit0_succ, nat.bit1_succ, bit1, succ_add],
  }
end

section literal_simplification_literals

@[simp]
theorem zero_eq_bit0_reduce  (x : ℕ) : (0 = bit0 x) ↔ 0 = x :=
begin
  cases x,
  refl,
  simp [nat.bit0_succ]
end

@[simp]
theorem zero_eq_bit1_reduce  (x : ℕ) : (0 = bit1 x) ↔ false :=
begin
  simp [bit1, nat.add_succ]
end

@[simp]
theorem one_eq_bit0_reduce  (x : ℕ) : (1 = bit0 x) ↔ false :=
begin
  simp [bit0],
  cases x,
  contradiction,
  simp [succ_eq_succ],
end

@[simp]
theorem one_eq_bit1_reduce  (x : ℕ) : (1 = bit1 x) ↔ 0 = x :=
begin
  simp [bit1, succ_add, succ_eq_succ],
end

@[simp]
theorem bit0_eq_zero_reduce (x : ℕ) : (bit0 x = 0) ↔ x = 0 :=
begin
  cases x,
  refl,
  simp [nat.bit0_succ]
end

@[simp]
theorem bit0_eq_one_reduce  (x : ℕ) : (bit0 x = 1) ↔ false :=
begin
  cases x,
  simp,
  simp [nat.bit0_succ, succ_eq_succ]
end

@[simp]
theorem bit0_eq_bit0_reduce (x y : ℕ) : (bit0 x = bit0 y) ↔ x = y :=
begin
  revert y,
  induction x with x ind,
  { simp },
  { intros y,
    cases y,
    simp [nat.bit0_succ],
    simp [nat.bit0_succ, succ_eq_succ, ind],
  }
end

@[simp]
theorem bit0_eq_bit1_reduce (x y : ℕ) : (bit0 x = bit1 y) ↔ false :=
begin
  revert y,
  induction x with x ind,
  { simp },
  { intros y,
    cases y,
    simp [nat.bit0_succ, bit1, succ_eq_succ],
    simp [nat.bit0_succ, nat.bit1_succ, succ_eq_succ, ind],
  }
end

@[simp]
theorem bit1_eq_zero_reduce (x : ℕ)   : (bit1 x = 0) ↔ false :=
begin
  simp [bit1, bit0, add_succ],
end

@[simp]
theorem bit1_eq_one_reduce  (x : ℕ)   : (bit1 x = 1) ↔ x = 0 :=
begin
  simp [bit1, bit0, add_succ, succ_eq_succ],
  cases x,
  refl,
  simp
end

@[simp]
theorem bit1_eq_bit0_reduce (x y : ℕ) : (bit1 x = bit0 y) ↔ false :=
begin
  revert y,
  induction x with x ind,
  { simp },
  { intros y,
    cases y,
    simp,
    simp [nat.bit1_succ, nat.bit0_succ, succ_eq_succ, ind],
  }
end

@[simp]
theorem bit1_eq_bit1_reduce (x y : ℕ) : (bit1 x = bit1 y) ↔ x = y :=
begin
  revert y,
  induction x with x ind,
  { simp },
  { intros y,
    cases y,
    simp,
    simp [nat.bit1_succ, succ_eq_succ, ind],
  }
end

end literal_simplification_literals

end nat
