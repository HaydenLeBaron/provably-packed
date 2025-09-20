import ProvablyPacked.Lib.HList
import ProvablyPacked.Lib.PropertyHList

-- TODO: I could make an ItemColl.T a monoid
namespace ItemColl

  /-- Mass in grams (negative mass intentionally allowed for hacky use-cases) --/
  abbrev Gram := Int

  /-
    A T is a representation of an item collection.
    e.g. it can represent an item or a combination of items (who have been unioned together)
  -/
  structure T
    (types : List Type) where
    name : String
    massG: Gram
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



    -- theorem empty_items_mass_eq_0 :
    --   (fun l : T => List.sum
    --     (l.items.map (fun item => item.mass)))
    --     ItemColl.empty = 0 := by
    --   simp [empty]


    namespace Lemmas
      def assertTotalMassIsLessThanOrEqual {types : List Type}
      (itemColl : T types)
      (mass : Gram) : Prop :=
        itemColl.massG <= mass
    end Lemmas


    -- -- Simple predicate call theorem
    -- theorem one_gram_items_mass_le_1 : Lemmas.assertTotalMassIsLessThanOrEqual oneGramLoadout 1 := by
    --   simp [Lemmas.assertTotalMassIsLessThanOrEqual]
    --   decide

end ItemColl

namespace Examples
  def empty : ItemColl.T [] := ItemColl.empty

  def oneGramItemColl : ItemColl.T [] :=
    { name := "graham cracker"
    , massG := 1
    , properties := PropertyHList.emptyProperties [] }

  def twoGramItemColl : ItemColl.T [] :=
    { name := "double graham cracker"
    , massG := 2
    , properties := PropertyHList.emptyProperties [] }

  def threeGramItemColl : ItemColl.T [] :=
    { name := "s'more"
    , massG := 3
    , properties := PropertyHList.emptyProperties [] }

  theorem one_gram_loadout_mass_le_1 :
  ItemColl.Lemmas.assertTotalMassIsLessThanOrEqual oneGramItemColl 1 := by
    simp [ItemColl.Lemmas.assertTotalMassIsLessThanOrEqual]
    decide


end Examples
