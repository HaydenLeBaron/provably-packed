import ProvablyPacked.Lib.Narrow
import ProvablyPacked.Lib.HList
import ProvablyPacked.User.Domain

/-!
# Expedition

Defines expeditions with variadic constraint dimensions and expected item lists.
An expedition represents a trip with specific constraint requirements (like weather conditions)
and lists of expected items needed for those constraints.
-/

namespace Expedition
  open Narrow HList

  /-- A single constraint "dimension" pairing a base type with the list of allowed (equipped) values. -/
  structure Dim where
    τ : Type
    equipped : List τ

  /-- For a given dimension, the type of its expected values. -/
  abbrev ExpectedFor (d : Dim) : Type := List (Narrow.T d.τ d.equipped)

  /-- A variadic form of `Expedition.T` that can be instantiated with any number of constraint dimensions. -/
  structure T (dims : List Dim) where
    name : String
    expected : HList ExpectedFor dims
end Expedition
