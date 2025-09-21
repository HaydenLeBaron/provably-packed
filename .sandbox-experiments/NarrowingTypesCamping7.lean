set_option diagnostics true

/-! LIBRARY ----------------- -/
namespace Narrow
    /--
    Implements "narrowed sum types" by providing a type-level representation of subsets of sum types and utils.

    A `T` is a sum type whose set of `variants` form a subset of the variants of`α` .

    e.g.
    ```lean
    inductive MyBoolT where | MyFalse | MyTrue
    def OnlyMyTrueT := Narrow.T MyBoolT [MyBoolT.MyTrue]
    -- Next line typechecks because `MyBoolT.MyTrue` is a member of `OnlyMyTrueT`
    def myTrue : OnlyMyTrueT := .mk MyBoolT.MyTrue (by narrowTac)
    -- Next line fails to typecheck because `MyBoolT.MyFalse` is not a member of `OnlyMyTrueT`
    def myFalse : OnlyMyTrueT := .mk MyBoolT.MyFalse (by narrowTac)
    inductive OtherT where | Other
    -- Next line fails to typecheck because `OtherT.Other` is not a member of `MyBoolT`
    def MyBoolAndMore := Narrow.T MyBoolT [MyBoolT.MyTrue, MyBoolT.MyFalse, OtherT.Other]
    ```
  -/
  inductive T (α : Type) (variants : List α) : Type where
    | mk (a : α) (h : a ∈ variants) : T α variants

  open T

  /-- Tactic to prove that a variant of a sum type α is a member of a "narrowed" type T α subset -/
  syntax (name := narrowTac) "narrowTac" : tactic
  macro_rules
    | `(tactic| narrowTac) => `(tactic| first | decide | simp)
end Narrow


/-!  DOMAIN MODELING ----------------- -/
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

namespace Expedition
  open Bugginess Precipitation

  structure T (equippedBugginess : List Bugginess.T)
              (equippedPrecip   : List Precipitation.T) where
    name : String
    expectedBugginess     : List ( ( Narrow.T Bugginess.T ) equippedBugginess)
    expectedPrecipitation : List ( ( Narrow.T Precipitation.T) equippedPrecip )
end Expedition

namespace VariadicExpedition
  open Narrow

  /-- A single context "dimension" pairing a base type with the list of allowed (equipped) values. -/
  structure Dim where
    τ : Type
    equipped : List τ

  universe u v
  /- A heterogeneous list indexed by a list of indices (universe-polymorphic). -/
  inductive HList {ι : Type u} (β : ι → Type v) : List ι → Type (max u v) where
    | nil : HList β []
    | cons {i is} (head : β i) (tail : HList β is) : HList β (i :: is)

  infixr:67 " ::: " => HList.cons
  notation "HNil" => HList.nil

  /-- For a given dimension, the type of its expected values. -/
  abbrev ExpectedFor (d : Dim) : Type := List (Narrow.T d.τ d.equipped)

  /-- A variadic form of `Expedition.T` that can be instantiated with any number of context dimensions. -/
  structure T (dims : List Dim) where
    name : String
    expected : HList ExpectedFor dims
end VariadicExpedition

namespace Item
  structure T where
    name : String
    /-- These are the contexts in which is is ok to use this item
      (the contexts in which the item is equippable for)-/
    okBugginess : List Bugginess.T
    okPrecipitation : List Precipitation.T
    okFashion : List Fashion.T
end Item



/-! MODEL INSTANTIATION (TYPE CHECKING DEMO) ----------------- -/

namespace Instantiated

  /- Your concrete “May 2026 Camping Trip”, obtained by *instantiating* the parameters. -/
  def May2026Expedition :
    -- Here you specify the interface
      Expedition.T
        (equippedBugginess:=[Bugginess.T.NoBugs, .LightBugs, --FIXME_IMPLICIT_PARAM,
        --.FIXME -- <- good this line doesn't compile
        ])
        (equippedPrecip:=[Precipitation.T.NoPrecip, Precipitation.T.YesPrecip]) :=
    -- Here you specify the satisfaction of the interface
  { name := "May 2026 Camping Trip"
    , expectedBugginess :=
    [ .mk Bugginess.T.NoBugs    (by narrowTac)
    , .mk Bugginess.T.LightBugs (by narrowTac)
    --, .mk FIXME_IMPLICIT_PARAM (by narrowTac)
    -- , .mk Bugginess.T.HeavyBugs (by narrowTac) -- type error (good)
    ]
    , expectedPrecipitation :=
    [ .mk Precipitation.T.NoPrecip (by narrowTac)
    , .mk Precipitation.T.YesPrecip (by narrowTac)
      ]
    }

    /- Example: a different trip with different allowed lists. -/
    def AnotherTrip :
      Expedition.T [Bugginess.T.LightBugs] [Precipitation.T.YesPrecip] :=
    {
      name := "Another Trip"
      expectedBugginess     := [ .mk Bugginess.T.LightBugs (by narrowTac) ]
    , expectedPrecipitation := [ .mk Precipitation.T.YesPrecip (by narrowTac) ]
    }

    namespace ATripWithGearExample
      open Bugginess.T Precipitation.T

      def bugproofShirt : Item.T :=
      { name := "Bugproof Shirt"
      , okBugginess := [Bugginess.T.NoBugs, Bugginess.T.LightBugs, Bugginess.T.HeavyBugs]
      , okPrecipitation := [Precipitation.T.NoPrecip]
      , okFashion := [Fashion.T.Casual]
      }

      def clammyWaterproofJacket : Item.T :=
      { name := "Clammy Waterproof Jacket"
      , okBugginess := [Bugginess.T.NoBugs, Bugginess.T.LightBugs]
      , okPrecipitation := [Precipitation.T.YesPrecip] -- You wouldn't want to wear this with no precipitation
      , okFashion := [Fashion.T.Formal]
      }


      def unionedGearAttributes : Item.T :=
      { name := "Bugproof and Clammy Waterproof"
      , okBugginess := bugproofShirt.okBugginess ++ clammyWaterproofJacket.okBugginess
      , okPrecipitation := bugproofShirt.okPrecipitation ++ clammyWaterproofJacket.okPrecipitation
      , okFashion := bugproofShirt.okFashion ++ clammyWaterproofJacket.okFashion
      }

      def trip : Expedition.T
        (equippedBugginess := unionedGearAttributes.okBugginess)
        (equippedPrecip := unionedGearAttributes.okPrecipitation) :=
      {
        name := "A Trip with Gear"
      , expectedBugginess     := [ .mk Bugginess.T.LightBugs (by narrowTac) ]
      , expectedPrecipitation := [ .mk Precipitation.T.YesPrecip (by narrowTac) ]
      }

      open VariadicExpedition

      /-- The same trip specified via the variadic form by packaging each context as a `Dim`. -/
      def variadicDims : List VariadicExpedition.Dim :=
      [ { τ := Bugginess.T,     equipped := unionedGearAttributes.okBugginess }
      , { τ := Precipitation.T, equipped := unionedGearAttributes.okPrecipitation }
      , { τ := Fashion.T,     equipped := unionedGearAttributes.okFashion }
      ]

      def variadicTrip : VariadicExpedition.T variadicDims :=
      { name := "A Variadic Trip with Gear"
      , expected :=
          [ .mk Bugginess.T.LightBugs (by narrowTac), .mk Bugginess.T.HeavyBugs (by narrowTac) ]
        ::: [ .mk Precipitation.T.YesPrecip (by narrowTac) ]
        ::: [ .mk Fashion.T.Casual (by narrowTac), .mk Fashion.T.Formal (by narrowTac) ]
        ::: HNil
      }

    end ATripWithGearExample

end Instantiated

-- NEXT:
-- - create new repo, separate parts into different files, and then implement many examples of expeditions
