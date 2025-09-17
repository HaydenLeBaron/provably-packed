import Mathlib.Analysis.Complex.Circle

-- abbrev DivBy3 := { x : Nat // x % 3 = 0 }
-- def nine : DivBy3 := ⟨9, by rfl⟩

inductive Color where
  | Red
  | Green
  | Blue
deriving Repr, BEq, DecidableEq

inductive CircleColor where
  | Blue
  | Green
deriving Repr, BEq, DecidableEq

def CircleColor.toColor : CircleColor → Color
  | .Blue => Color.Blue
  | .Green => Color.Green


inductive Shape where
  | Square (sideLength : Float) (color : Color)
  | Circle (radius : Float) (color : CircleColor)


-- def okCircle := ⟨ (Circle 1.0 { c := Color.Green }), by decide ⟩



def okCircle : Shape := Shape.Circle 1.0 CircleColor.Green

def mkCircle (r : Float) (c : Color) : Option Shape :=
  match c with
  | Color.Blue => some (Shape.Circle r CircleColor.Blue)
  | Color.Green => some (Shape.Circle r CircleColor.Green)
  | Color.Red => none

def mkCircle2 (r : Float) (c : CircleColor) : Shape :=
  Shape.Circle r c


-- -- A function to safely construct a circle, parameterized by radius and color.
-- -- It returns `none` if the color is invalid for a circle.
-- def makeCircle (radius : Float) (color : Color) : Option Shape :=
--   if h : color = .Blue ∨ color = .Green then
--     -- If the color is valid, `h` is a proof of that fact.
--     -- We use `h` to construct the CircleColor subtype.
--     some (Shape.Circle radius ⟨color, h⟩)
--   else
--     -- If the color is not valid, return none.
--     none

-- #eval makeCircle 10.0 .Green -- some (Shape.Circle 10.0 ⟨Color.Green, _⟩)
-- #eval makeCircle 5.0 .Red    -- none
