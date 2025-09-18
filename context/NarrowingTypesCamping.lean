namespace Bugginess

  inductive T where
    | NoBugs
    | LightBugs
    | HeavyBugs
  deriving Repr, BEq, DecidableEq

  inductive SubT (subset : List Bugginess) : Type where
    | noBugs  (h : NoBugs   ∈ subset) : SubT subset
    | lightBugs  (h : LightBugs   ∈ subset) : SubT subset
    | heavyBugs    (h : HeavyBugs ∈ subset) : SubT subset
  deriving Repr, DecidableEq


end Bugginess

-- namespace OperatingContext

--   structure T (α : Bugginess.SubT bug) where
--     name : String
--     bugginess : Bugginess.SubT bug

-- end OperatingContext

namespace OperatingContext
  structure T (subset : List Bugginess.T) where
    name : String
    bugginess : Bugginess.SubT subset
end OperatingContext


namespace May2026CampingTrip
  open Bugginess.T

  def expectedBuginess : List Bugginess.T := [NoBugs, LightBugs]

  abbrev ExpectedBugginessT  := Bugginess.SubT expectedBuginess

  structure T where
    name := "May 2026 Camping Trip"
    bugginess : ExpectedBugginessT


end May2026CampingTrip


open Bugginess.SubT
open Bugginess.T


-- def ex : May2026CampingTrip.T :=
-- {
--   name := "May 2026 Camping Trip",
--   bugginess := Bugginess.SubT.noBugs (by decide)
-- }


-- Works, with an automatic (compile-time) proof via `by decide`.
def ex : May2026CampingTrip.T :=
{
  name := "May 2026 Camping Trip"
, bugginess := Bugginess.SubT.noBugs (by decide)
}

-- If Lean ever needs help inferring the parameter, make it explicit:
def ex' : May2026CampingTrip.T :=
{ name := "May 2026 Camping Trip"
, bugginess := Bugginess.SubT.noBugs
    (subset := May2026CampingTrip.expectedBugginess) (by decide)
}




-- def ex1 : NarrowedShape allowedShapes :=
--   .square (by decide)   -- Lean evaluates `Square ∈ [Square, Circle]` to `True` and provides the proof

-- def ex2 : NarrowedShape allowedShapes :=
--   .circle (by decide)

-- def ex3 : AllowedShapesType := .square (by decide)

-- This fails at compile time:
-- def ex4bad : NarrowedShape allowed := .rect (by decide)


-- def printNarrowedShape (ns : NarrowedShape allowed) : IO Unit :=
--   match ns with
--   | .square _ => IO.println "Square"
--   | .circle _ => IO.println "Circle"
--   | .rect _   => IO.println "Rectangle"
--   | .trap _   => IO.println "Trapezoid"


-- def printAllowedShapesType (ns : AllowedShapesType) : IO Unit :=
--   match ns with
--   | .square _ => IO.println "Square"
--   | .circle _ => IO.println "Circle"




-- #eval printNarrowedShape ex1
-- #eval printNarrowedShape ex2
-- #eval printAllowedShapesType ex2
-- #eval printAllowedShapesType ex3
