/-!
# Narrow

Provides type-level narrowing of sum types by restricting variants to specific subsets.
This module enables creating types that only accept certain constructors from a parent sum type.
-/

namespace Narrow
  /-- Implements "narrowed sum types" by providing a type-level representation of subsets of sum types and utils.
      A `T` is a sum type whose set of `variants` form a subset of the variants of`α` . -/
  inductive T (α : Type) (variants : List α) : Type where
    | mk (a : α) (h : a ∈ variants) : T α variants

  open T

  /-- Tactic to prove that a variant of a sum type α is a member of a "narrowed" type T α subset -/
  syntax (name := nrrw) "nrrw" : tactic
  macro_rules
    | `(tactic| nrrw) => `(tactic| first | decide | simp)
end Narrow


namespace Examples

    private inductive MyBoolT where | MyFalse | MyTrue
    private def OnlyMyTrueT := Narrow.T MyBoolT [MyBoolT.MyTrue]

    /-- Typechecks because `MyBoolT.MyTrue` is a member of `OnlyMyTrueT` -/
    private def myTrue : OnlyMyTrueT := .mk MyBoolT.MyTrue (by nrrw)

    /-- Fails to typecheck because `MyBoolT.MyFalse` is not a member of `OnlyMyTrueT` -/
    --  def myFalse : OnlyMyTrueT := .mk MyBoolT.MyFalse (by nrrw)


    private inductive OtherT where | Other

    /- Next line failsto typecheck because `OtherT.Other` is not a member of `MyBoolT` -/
    -- def MyBoolAndMore := Narrow.T MyBoolT [MyBoolT.MyTrue, MyBoolT.MyFalse, OtherT.Other]

end Examples
