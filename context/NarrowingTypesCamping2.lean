set_option diagnostics true

namespace Precipitation
  inductive T where
    | NoPrecip | YesPrecip

   open T

  -- `subset : List T` (not `List Bugginess`)
  inductive SubT (subset : List T) : Type where
    | noPrecip    (h : NoPrecip   ∈ subset) : SubT subset
    | loPrecip (h : YesPrecip ∈ subset) : SubT subset
end Precipitation

namespace Bugginess

  inductive T where
    | NoBugs | LightBugs | HeavyBugs

  open T
  -- `subset : List T` (not `List Bugginess`)
  inductive SubT (subset : List T) : Type where
    | noBugs    (h : NoBugs   ∈ subset) : SubT subset
    | lightBugs (h : LightBugs ∈ subset) : SubT subset
    | heavyBugs (h : HeavyBugs ∈ subset) : SubT subset

end Bugginess

namespace OperatingContext
  structure T (subset : List Bugginess.T) where
    name : String
    bugginess : Bugginess.SubT subset
end OperatingContext

namespace May2026CampingTrip
  open Bugginess
  open Bugginess.T

  def expectedBugginess : List Bugginess.T := [NoBugs, LightBugs]
  abbrev ExpectedBugginessT := Bugginess.SubT expectedBugginess

  -- -- Smart values: no proofs at call sites
  --  @[inline] def noBugs    : ExpectedBugginessT := .noBugs (by simp [May2026CampingTrip.expectedBugginess])
  --  @[inline] def lightBugs : ExpectedBugginessT := .lightBugs (by simp [May2026CampingTrip.expectedBugginess])
  -- --@[inline] def heavyBugs : ExpectedBugginessT := .heavyBugs (by simp [May2026CampingTrip.expectedBugginess])

  structure T where
    name := "May 2026 Camping Trip"
    bugginess : List ExpectedBugginessT

end May2026CampingTrip

syntax (name := subsSumTac) "subsetOfSumT" : tactic
macro_rules
  | `(tactic| subsetOfSumT) => `(tactic| simp [May2026CampingTrip.expectedBugginess])




def ex : May2026CampingTrip.T :=
{ name := "May 2026 Camping Trip"
, bugginess :=
    [Bugginess.SubT.noBugs (by subsetOfSumT), Bugginess.SubT.lightBugs (by subsetOfSumT)]
}
