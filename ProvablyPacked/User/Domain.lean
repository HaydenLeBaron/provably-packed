/-
This is a user editable file where you can define the relevant properties of your expeditions/items.
-/

namespace Precipitation
  inductive T where
    | NoPrecip | YesPrecip
    deriving DecidableEq, Repr
  open T
end Precipitation

namespace Bugginess
  inductive T where
    | NoBugs | LightBugs | HeavyBugs
    deriving DecidableEq, Repr
  open T
end Bugginess

namespace Fashion
  inductive T where
    | Casual | Formal
    deriving DecidableEq, Repr
  open T
end Fashion
