/-!
This is an example of a user editable/creatable file where you can define the relevant properties of your expeditions/items.

TESTME: Note that this has currently only been tested with simple unparameterized sum types (enums) and sum types of sum types.
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
