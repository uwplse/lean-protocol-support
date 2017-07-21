/- This file contains lemmas for take and drop -/
import galois.nat.simplify_le
import init.data.list.basic

universe variable u

namespace list

variable {α : Type u}

/- take theorems -/

@[simp]
theorem take_zero (xs : list α) : take 0 xs = [] := rfl

@[simp]
theorem take_nil : ∀ (n : ℕ), take n list.nil = @list.nil α
| 0 := by refl
| (nat.succ n) := by refl

@[simp]
theorem take_succ_cons (n : ℕ) (x : α) (xs : list α) : take (nat.succ n) (x :: xs) = x :: take n xs := rfl

theorem take_ge {n : ℕ} {l : list α} (pr : length l ≤ n): take n l = l :=
begin
  revert l,
  induction n with n ind,
  {
    intros l pr,
    cases l with a l,
    { simp },
    { simp [nat.add_succ, nat.succ_le_zero_iff_false] at pr,
      contradiction,
    }
  },
  { intros l pr,
    cases l with v l,
    { simp },
    { simp [nat.add_succ, nat.succ_le_succ_iff] at pr,
      simp [ind pr]
    }
  },
end

@[simp]
theorem take_length_self (l : list α) : take (length l) l = l := take_ge (nat.le_refl _)

@[simp]
theorem take_append : ∀(n : ℕ) (xs ys : list α), take n (xs ++ ys) = take n xs ++ take (n - length xs) ys
| 0 xs ys := by simp [nat.zero_sub, take_zero]
| (nat.succ n) nil ys :=
begin
  simp [nil_append, take_nil]
 end
| (nat.succ n) (x :: xs) ys :=
begin
  simp [cons_append, take_succ_cons],
  simp [take_append, cons_append, nat.succ_add],
 end

/- drop theorems -/

@[simp]
theorem drop_zero (l : list α)
: drop 0 l = l := rfl

@[simp]
theorem drop_nil
: ∀ (n : ℕ), drop n nil = (nil : list α)
| 0 := rfl
| (nat.succ n) := rfl

@[simp]
theorem drop_succ_cons (n : ℕ) (e : α) (l : list α)
: drop (nat.succ n) (e :: l) = drop n l := rfl

@[simp]
theorem drop_length_self : ∀ (xs : list α), drop (length xs) xs = []
| nil := by refl
| (cons x xs) := by simp [nat.add_succ, drop_succ_cons, drop_length_self]

@[simp]
theorem drop_append : ∀(n : ℕ) (xs ys : list α), drop n (xs ++ ys) = drop n xs ++ drop (n - length xs) ys
| 0 xs ys := by simp [nat.zero_sub, drop_zero]
| (nat.succ n) nil ys :=
begin
  simp [nil_append, drop_nil]
 end
| (nat.succ n) (x :: xs) ys :=
begin
  simp [cons_append, drop_succ_cons],
  simp [drop_append, nat.succ_add],
end

/- Combination -/

theorem take_append_drop_self : ∀ (n : ℕ) (l : list α), take n l ++ drop n l = l
| 0            l          := rfl
| (nat.succ n) nil        := rfl
| (nat.succ n) (cons a l) := congr_arg (cons a) (take_append_drop_self n l)

theorem append_take_drop : ∀ (n : ℕ) (l : list α), take n l ++ drop n l = l
| 0            l          := rfl
| (nat.succ n) nil        := rfl
| (nat.succ n) (cons a l) := congr_arg (cons a) (append_take_drop n l)

theorem append_eq_take_drop (a x y : list α)
: a ++ x = y ↔ a = take (length a) y ∧ x = drop (length a) y :=
begin
  apply iff.intro,
  {
    intro h,
    simp [eq.symm h, nat.sub_self]
  },
  {
    intro h,
    rw [and.right h, and.left h, length_take],
    apply dite (length a ≤ length y),
    { intro le_pr,
      simp [min_eq_left le_pr, take_append_drop_self (length a) y ],
    },
    { intro lt_pr,
      have le_pr := le_of_not_le lt_pr,
      simp [min_eq_right le_pr, take_ge le_pr],
    }
  }
end

end list
