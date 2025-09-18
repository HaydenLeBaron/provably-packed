/-!
# HList

Provides heterogeneous lists indexed by a list of type indices.
This enables type-safe collections where each element can have a different type,
with the types determined by the index list.
-/

universe u v
/- A heterogeneous list indexed by a list of indices (universe-polymorphic). -/
inductive HList {ι : Type u} (β : ι → Type v) : List ι → Type (max u v) where
  | nil : HList β []
  | cons {i is} (head : β i) (tail : HList β is) : HList β (i :: is)

infixr:67 " ::: " => HList.cons
notation "HNil" => HList.nil