import ProvablyPacked.Lib.Narrow
import ProvablyPacked.Lib.HList
import ProvablyPacked.Lib.Item
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

  /-- Pair up a base type with its `Item.Property` so that we can index `expected`
      by both the type and the concrete equipped values. -/
  abbrev SigmaProp := Σ (α : Type), Item.Property α

  /-- Convert an `HList` of `Item.Property` values (indexed by a list of types)
      into a value-level list of `(type, property)` pairs to index expectations. -/
  def propsToSigmaList {types : List Type}
      (props : HList.T Item.Property types) : List SigmaProp := by
    cases props with
    | nil =>
      exact []
    | cons head tail =>
      exact ⟨_, head⟩ :: propsToSigmaList tail

  /-- For a given `(type, property)` pair, the type of its expected values. -/
  abbrev ExpectedForSigma (sp : SigmaProp) : Type :=
    List (Narrow.T sp.1 sp.2.values)

  /-- An `Expedition.T` is indexed by the concrete properties available
      for each dimension (e.g., Bugginess, Precipitation, Fashion). The
      expected values are specified per-dimension as narrowed values that
      must belong to the corresponding property's equipped list. -/
  structure T {types : List Type} (properties : HList.T Item.Property types) where
    name : String
    expected : HList.T ExpectedForSigma (propsToSigmaList properties)
end Expedition
