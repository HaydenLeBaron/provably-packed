import ProvablyPacked.Lib.Narrow
import ProvablyPacked.Lib.HList
import ProvablyPacked.User.Domain

/-!
# Expedition

Defines expeditions with variadic constraint dimensions and expected item lists.
An expedition represents a trip with specific constraint requirements (like weather conditions)
and lists of expected items needed for those constraints.

TODO: I could probably name this to be abstract (type-level list comparator). An Expedition is a type Comparator
that takes a list of dims in the universe of trip constaints and a a list of expected conditions (dims)
-/

namespace Expedition
  open Narrow HList

  /-- A single constraint "dimension" pairing a base type with the list of allowed (equipped) values. -/
  structure Dim where
    τ : Type
    equipped : List τ

  /-- For a given dimension, the type of its expected values. -/
  abbrev ExpectedFor (d : Dim) : Type := List (Narrow.T d.τ d.equipped)

  /-- A `T` can be instantiated with any number of constraint dimensions. -/
  structure T (dims : List Dim) where
    name : String
    expected : HList.T ExpectedFor dims
end Expedition
