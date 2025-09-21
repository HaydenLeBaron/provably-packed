import ProvablyPacked.Lib.HList
import ProvablyPacked.Lib.PropertyHList

-- TODO: I could make an Item.T a monoid
namespace Item

  /--
    A T is a representation of an item.

    Items can be unioned together to form an item with the combined properties of the items.
  -/
  structure T
    (types : List Type) where
    name : Option String
    -- Mass in grams (negative mass intentionally allowed for hacky use-cases)
    massG: Int
    properties : PropertyHList.T types


    /-- The identity for `union` -/
    def empty {types : List Type} : T types where
      name := "empty"
      massG := 0
      properties := PropertyHList.emptyProperties types

    /-- `union` two `Item`s by summing their masses and unioning their properties. -/
    def union {types : List Type} (name : Option String) (i₁ i₂ : T types) : T types where
      name := name
      massG := i₁.massG + i₂.massG
      properties := PropertyHList.unionProperties i₁.properties i₂.properties

    /-- `union` a list of `Item`s. -/
    def unionList {types : List Type} (name : Option String) (items : List (T types)) : T types :=
      items.foldl (union name) (empty)

end Item


namespace Examples
  -- TODO: write examples like in @HList.lean
end Examples
