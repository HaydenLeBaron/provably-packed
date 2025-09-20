import ProvablyPacked.Lib.Narrow
import ProvablyPacked.Lib.HList
import ProvablyPacked.Lib.PropertyHList

/-!
# PropertiesHListComparator

A type-level utility that can be used to check that an HList of actualProperties "satisfies" a list of expectedProperties.

TODO: define what "satisfy" means in this context
-/

namespace PropertiesHListComparator
  open Narrow HList

  /-- Pair up a base type with its `PropertyHList.Property` so that we can index `expected`
      by both the type and the concrete equipped values. -/
  abbrev SigmaProp := Σ (α : Type), PropertyHList.Property α

  /-- Convert an `HList` of `PropertyHList.Property` values (indexed by a list of types)
      into a value-level list of `(type, property)` pairs to index expectations. -/
  def propsToSigmaList {types : List Type}
      (props : HList.T PropertyHList.Property types) : List SigmaProp := by
    cases props with
    | nil =>
      exact []
    | cons head tail =>
      exact ⟨_, head⟩ :: propsToSigmaList tail

  /-- For a given `(type, property)` pair, the type of its expected values. -/
  abbrev ExpectedForSigma (sp : SigmaProp) : Type :=
    List (Narrow.T sp.1 sp.2.values)

  /-- An `PropertiesHListComparator.T` is indexed by the concrete properties available
      for each dimension (e.g., Bugginess, Precipitation, Fashion). The
      expected values are specified per-dimension as narrowed values that
      must belong to the corresponding property's equipped list. -/
  structure T {types : List Type} (actualProperties : HList.T PropertyHList.Property types) where
    expectedProperties : HList.T ExpectedForSigma (propsToSigmaList actualProperties)
end PropertiesHListComparator


namespace Examples



end Examples
