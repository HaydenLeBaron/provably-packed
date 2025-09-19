import ProvablyPacked.User.Domain
import ProvablyPacked.Lib.HList

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

  structure T (types : List Type) where
    name : String
    /-- Heterogeneous list of properties indexed by the type list -/
    properties : HList.T Property types

  /- Get a property from a T by type index -/
  -- def getValuesByType {types : List Type} (item : T types) {α : Type} (idx : α ∈ types) : Property α :=
  --   item.properties.get idx


end Item
