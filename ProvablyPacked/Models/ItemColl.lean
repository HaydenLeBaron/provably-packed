import ProvablyPacked.Lib.HList
import ProvablyPacked.Lib.PropertyHList

namespace ItemColl

  /-
    A T is a representation of an item collection.
    e.g. it can represent an item or a combination of items (who have been unioned together)
  -/
  structure T
    (types : List Type) where
    name : String
    -- Mass in grams (negative mass intentionally allowed for hacky use-cases)
    massG: Float
    properties : PropertyHList.T types


    -- FIXME: figure out how to do the statically-knowable `massG` addition at compile-time

    /-- The identity for `union` -/
    def empty {types : List Type} : T types where
      name := "empty"
      massG := 0
      properties := PropertyHList.emptyProperties types

    /-- `union` two `ItemColl`s by summing their masses and unioning their properties. -/
    def union {types : List Type} (name : String) (i₁ i₂ : T types) : T types where
      name := name
      massG := i₁.massG + i₂.massG
      properties := PropertyHList.unionProperties i₁.properties i₂.properties

    /-- `union` a list of `ItemColl`s. -/
    def unionList {types : List Type} (name : String) (items : List (T types)) : T types :=
      items.foldl (union name) (empty)

  end ItemColl


/-
TODO: I could make this a monoid
-/
