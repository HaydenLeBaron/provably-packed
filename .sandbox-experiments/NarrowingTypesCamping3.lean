set_option diagnostics true

namespace Sub
  inductive T (α : Type) (subset : List α) : Type where
    | mk (a : α) (h : a ∈ subset) : T α subset

  syntax (name := subsetOfSumT) "subsetOfSumT" : tactic
  macro_rules
    | `(tactic| subsetOfSumT) => `(tactic| first | decide | simp)
end Sub

namespace Precipitation
  inductive T where
    | NoPrecip | YesPrecip
    deriving DecidableEq, Repr

  open T

  abbrev SubT (subset : List T) := Sub.T T subset
end Precipitation

namespace Bugginess

  inductive T where
    | NoBugs | LightBugs | HeavyBugs
    deriving DecidableEq, Repr

  open T

  abbrev SubT (subset : List T) := Sub.T T subset
end Bugginess

namespace OperatingContext
  structure T (allowedBug : List Bugginess.T) (allowedPrecip : List Precipitation.T) where
    name : String
    bugginess : Bugginess.SubT allowedBug
    precipitation : Precipitation.SubT allowedPrecip
end OperatingContext

namespace May2026CampingTrip
  open Bugginess.T
  open Precipitation.T

  def expectedBugginess : List Bugginess.T := [NoBugs, LightBugs]
  def expectedPrecipitation : List Precipitation.T := [NoPrecip, YesPrecip]
  def ExpectedBugginessT := Bugginess.SubT expectedBugginess
  def ExpectedPrecipitationT := Precipitation.SubT expectedPrecipitation

  structure T where
    name := "May 2026 Camping Trip"
    bugginess : List ExpectedBugginessT
    precipitation: List ExpectedPrecipitationT

end May2026CampingTrip


def ex : May2026CampingTrip.T :=
{ name := "May 2026 Camping Trip"
, bugginess :=
  [ .mk Bugginess.T.NoBugs (by subsetOfSumT)
  , .mk Bugginess.T.LightBugs (by subsetOfSumT)
  ]
, precipitation :=
  [.mk Precipitation.T.NoPrecip (by subsetOfSumT)
  , .mk Precipitation.T.YesPrecip (by subsetOfSumT)
  ]
}
