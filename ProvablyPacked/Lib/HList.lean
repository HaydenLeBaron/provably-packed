/-!
# HList

Provides heterogeneous lists indexed by a list of type indices.
This enables type-safe collections where each element can have a different type,
with the types determined by the index list.
-/

universe u v

namespace HList

  /- A heterogeneous list indexed by a list of indices (universe-polymorphic). -/
  inductive T {ι : Type u} (β : ι → Type v) : List ι → Type (max u v) where
    | nil : T β []
    | cons {i is} (head : β i) (tail : T β is) : T β (i :: is)

  /-- Get an element from an HList by membership proof -/
    --def get {ι : Type u} {β : ι → Type v} {is : List ι} {i : ι} (hl : HList β is) (mem : i ∈ is) : β i :=

  infixr:67 " ::: " => T.cons
  notation "HNil" => T.nil

end HList
