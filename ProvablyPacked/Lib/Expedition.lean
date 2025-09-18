import ProvablyPacked.Lib.Narrow
import ProvablyPacked.User.Domain

namespace Expedition
  open Narrow

  /-- A single context "dimension" pairing a base type with the list of allowed (equipped) values. -/
  structure Dim where
    τ : Type
    equipped : List τ

  universe u v
  /- A heterogeneous list indexed by a list of indices (universe-polymorphic). -/
  inductive HList {ι : Type u} (β : ι → Type v) : List ι → Type (max u v) where
    | nil : HList β []
    | cons {i is} (head : β i) (tail : HList β is) : HList β (i :: is)

  infixr:67 " ::: " => HList.cons
  notation "HNil" => HList.nil

  /-- For a given dimension, the type of its expected values. -/
  abbrev ExpectedFor (d : Dim) : Type := List (Narrow.T d.τ d.equipped)

  /-- A variadic form of `Expedition.T` that can be instantiated with any number of context dimensions. -/
  structure T (dims : List Dim) where
    name : String
    expected : HList ExpectedFor dims
end Expedition
