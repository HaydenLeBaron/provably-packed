import ProvablyPacked.User.Domain

/-!
# Item

Defines the structure for items that can be packed in expeditions.
Each item has context requirements specifying the conditions under which it can be used.
-/

namespace Item
  /-- A generic property that can hold a list of values of any type -/
  structure Property (α : Type) where
    values : List α
    deriving DecidableEq, Repr

  structure T where
    name : String
    /-- Variadic list of properties - each property can hold any inductive type
        These represent the contexts in which this item is ok to use
        (the contexts in which the item is equippable for) -/
    properties : List (Σ α : Type, Property α)
end Item
