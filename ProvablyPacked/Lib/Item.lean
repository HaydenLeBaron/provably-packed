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

  open HList

  /-- Union two `Property` values by concatenating lists. Note: does not deduplicate. -/
  def Property.union {α : Type} (p₁ p₂ : Property α) : Property α :=
    { values := p₁.values ++ p₂.values }

  /-- Pointwise union of two `HList` collections of properties over the same type index list. -/
  def unionProperties {types : List Type}
      (xs ys : HList.T Property types) : HList.T Property types :=
    match xs, ys with
    | .nil, .nil => .nil
    | .cons p₁ t₁, .cons p₂ t₂ => .cons (Property.union p₁ p₂) (unionProperties t₁ t₂)

  /-- The identity element for `unionProperties` at a given `types` shape:
      an `HList` of `Property`s whose `values` are all empty lists. -/
  def emptyProperties : (types : List Type) → HList.T Property types
  | [] => .nil
  | _ :: ts => .cons { values := [] } (emptyProperties ts)

  def unionPropertiesList {types : List Type}
      (xs : List (HList.T Property types)) : HList.T Property types :=
    match xs with
    | x :: xs => unionProperties x (unionPropertiesList xs)
    | [] => emptyProperties types

  /- Get a property from a T by type index -/
  -- def getValuesByType {types : List Type} (item : T types) {α : Type} (idx : α ∈ types) : Property α :=
  --   item.properties.get idx


end Item
