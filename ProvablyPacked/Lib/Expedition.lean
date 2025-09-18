import ProvablyPacked.Lib.Narrow
import ProvablyPacked.Lib.HList
import ProvablyPacked.User.Domain

namespace Expedition
  open Narrow HList

  /-- A single context "dimension" pairing a base type with the list of allowed (equipped) values. -/
  structure Dim where
    τ : Type
    equipped : List τ

  /-- For a given dimension, the type of its expected values. -/
  abbrev ExpectedFor (d : Dim) : Type := List (Narrow.T d.τ d.equipped)

  /-- A variadic form of `Expedition.T` that can be instantiated with any number of context dimensions. -/
  structure T (dims : List Dim) where
    name : String
    expected : HList ExpectedFor dims
end Expedition
