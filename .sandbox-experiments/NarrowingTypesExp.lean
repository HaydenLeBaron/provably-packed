inductive Shape where
  | Square
  | Circle
  | Rectangle
  | Trapezoid
deriving DecidableEq

open Shape

inductive NarrowedShape (allowed : List Shape) : Type where
  | square  (h : Square   ∈ allowed) : NarrowedShape allowed
  | circle  (h : Circle   ∈ allowed) : NarrowedShape allowed
  | rect    (h : Rectangle ∈ allowed) : NarrowedShape allowed
  | trap    (h : Trapezoid ∈ allowed) : NarrowedShape allowed

def allowedShapes : List Shape := [Square, Circle]

abbrev AllowedShapesType : Type := NarrowedShape allowedShapes

def ex1 : NarrowedShape allowedShapes :=
  .square (by decide)   -- Lean evaluates `Square ∈ [Square, Circle]` to `True` and provides the proof

def ex2 : NarrowedShape allowedShapes :=
  .circle (by decide)

def ex3 : AllowedShapesType := .square (by decide)

-- This fails at compile time:
-- def ex4bad : NarrowedShape allowed := .rect (by decide)


def printNarrowedShape (ns : NarrowedShape allowed) : IO Unit :=
  match ns with
  | .square _ => IO.println "Square"
  | .circle _ => IO.println "Circle"
  | .rect _   => IO.println "Rectangle"
  | .trap _   => IO.println "Trapezoid"


def printAllowedShapesType (ns : AllowedShapesType) : IO Unit :=
  match ns with
  | .square _ => IO.println "Square"
  | .circle _ => IO.println "Circle"




#eval printNarrowedShape ex1
#eval printNarrowedShape ex2
#eval printAllowedShapesType ex2
#eval printAllowedShapesType ex3
