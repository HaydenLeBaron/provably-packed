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

    TODO: try doing this with `//` subtyping
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

namespace BodyPart
  inductive T where
    | Head | Torso | Arms | Legs | Feet
    deriving DecidableEq, Repr

  def all : List T := [.Head, .Torso, .Arms, .Legs, .Feet]
end BodyPart

namespace Precipitation
  inductive T where
    | NoPrecip | YesPrecip
    deriving DecidableEq, Repr
end Precipitation

namespace Bugginess
  inductive T where
    | NoBugs | LightBugs | HeavyBugs
    deriving DecidableEq, Repr
end Bugginess

-- namespace ConditionWBodyPart
--   inductive T (α : Type) (bodyParts : List BodyPart.T) : Type where
--     | mk (a : α) (parts : List BodyPart.T): T α bodyParts
-- end ConditionWBodyPart

-- def ExConditionWBodyPart := (ConditionWBodyPart.T Precipitation.T [BodyPart.T.Head, BodyPart.T.Torso])
-- def exRainJacket : ExConditionWBodyPart := ConditionWBodyPart.T.mk Precipitation.T.YesPrecip [BodyPart.T.Torso, BodyPart.T.Arms]


namespace Expedition
  open Bugginess Precipitation

  --abbrev OkBugT   (allowed : (List (Bugginess.T × (List BodyPart.T))))    := Narrow.T (Bugginess.T × (Narrow.T BodyPart.T BodyPart.all)) allowed
  --abbrev OkBugT   (allowed : List (Bugginess.T × Narrow.T BodyPart.T BodyPart.all))    := Narrow.T (Bugginess.T × (Narrow.T BodyPart.T BodyPart.all)) allowed
  abbrev OkBugT   (allowed : List (Bugginess.T ×  List BodyPart.T))    := Narrow.T (Bugginess.T × (List BodyPart.T)) allowed
  abbrev OkPrecipT  (allowed : List Precipitation.T) := Narrow.T Precipitation.T allowed

  structure T (
              equippedBugginess : (List (Bugginess.T × List BodyPart.T)))
              --equippedBugginess : List (Bugginess.T × Narrow.T BodyPart.T BodyPart.all))
              (equippedPrecip   : List Precipitation.T) where
    name : String
    expectedBugginess     : List (OkBugT  equippedBugginess)
    expectedPrecipitation : List (OkPrecipT equippedPrecip)
end Expedition

namespace Item
  structure T where
    name : String
    /-- These are the contexts in which is is ok to use this item
      (the contexts in which the item is equippable for)-/
    okBugginess : List (Bugginess.T × (List BodyPart.T))
    --okBugginess : List (Bugginess.T × Narrow.T BodyPart.T BodyPart.all)
    okPrecipitation : List Precipitation.T
end Item



/-! MODEL INSTANTIATION (TYPE CHECKING DEMO) ----------------- -/

namespace Instantiated

  -- /- Your concrete “May 2026 Camping Trip”, obtained by *instantiating* the parameters. -/
  -- def May2026Expedition :
  --   -- Here you specify the interface
  --     Expedition.T
  --       (equippedBugginess:=[Bugginess.T.NoBugs, .LightBugs, --FIXME_IMPLICIT_PARAM,
  --       --.FIXME -- <- good this line doesn't compile
  --       ])
  --       (equippedPrecip:=[Precipitation.T.NoPrecip, Precipitation.T.YesPrecip]) :=
  --   -- Here you specify the satisfaction of the interface
  -- { name := "May 2026 Camping Trip"
  --   , expectedBugginess :=
  --   [ .mk Bugginess.T.NoBugs    (by narrowTac)
  --   , .mk Bugginess.T.LightBugs (by narrowTac)
  --   --, .mk FIXME_IMPLICIT_PARAM (by narrowTac)
  --   -- , .mk Bugginess.T.HeavyBugs (by narrowTac) -- type error (good)
  --   ]
  --   , expectedPrecipitation :=
  --   [ .mk Precipitation.T.NoPrecip (by narrowTac)
  --   , .mk Precipitation.T.YesPrecip (by narrowTac)
  --     ]
  --   }

  --   /- Example: a different trip with different allowed lists. -/
  --   def AnotherTrip :
  --     Expedition.T [Bugginess.T.LightBugs] [Precipitation.T.YesPrecip] :=
  --   {
  --     name := "Another Trip"
  --     expectedBugginess     := [ .mk Bugginess.T.LightBugs (by narrowTac) ]
  --   , expectedPrecipitation := [ .mk Precipitation.T.YesPrecip (by narrowTac) ]
  --   }

    namespace ATripWithGearExample
      open Bugginess.T Precipitation.T


      -- A *highly* contrived example to show that the type system can handle items that have different properties in different parts of the body
      def partiallyBugproofSleevelessDress : Item.T :=
        let bugproofCoverage := [BodyPart.T.Torso, BodyPart.T.Arms]
        let unbugproofCoverage := [BodyPart.T.Legs]
        let coverage := bugproofCoverage ++ unbugproofCoverage
        { name := "Bugproof Sleeveless Dress"
        , okBugginess := [
                          -- The entire dress can handle no bugs (though the torso's bugproofness is superfluous)
                          (Bugginess.T.NoBugs, coverage),
                          -- In situations with bugs, only the torso is bugproof. Leg-bugproofness will have to come from somewhere else
                          (Bugginess.T.LightBugs, bugproofCoverage),
                          (Bugginess.T.HeavyBugs, bugproofCoverage)]
        , okPrecipitation := [Precipitation.T.NoPrecip]
      }

      def bugproofTights : Item.T :=
        let coverage := [BodyPart.T.Legs]
        { name := "Bugproof Tights"
        , okBugginess := [
                          -- The tights are suitable for wearing in all bug situations, even though their bugproofness is sometimes superfluous
                          (Bugginess.T.NoBugs, coverage),
                          (Bugginess.T.LightBugs, coverage),
                          (Bugginess.T.HeavyBugs, coverage)]
        , okPrecipitation := [Precipitation.T.NoPrecip]
      }


      def clammyWaterproofJacket : Item.T :=
        let coverage := [BodyPart.T.Head, BodyPart.T.Torso, BodyPart.T.Arms] -- Has a hood
        { name := "Clammy Waterproof Jacket"
        , okBugginess := [(Bugginess.T.NoBugs, coverage),
                          (Bugginess.T.LightBugs, coverage)]
        , okPrecipitation := [Precipitation.T.YesPrecip] -- You wouldn't want to wear this with no precipitation
        }



      def unionedGearAttributes : Item.T :=
      { name := "Bugproof and Clammy Waterproof"
      , okBugginess :=
                      partiallyBugproofSleevelessDress.okBugginess
                      ++ bugproofTights.okBugginess
                      ++ clammyWaterproofJacket.okBugginess
      , okPrecipitation :=
                      partiallyBugproofSleevelessDress.okPrecipitation
                      ++ bugproofTights.okPrecipitation
                      ++ clammyWaterproofJacket.okPrecipitation
      }

      def trip : Expedition.T
        (equippedBugginess := unionedGearAttributes.okBugginess)
        (equippedPrecip := unionedGearAttributes.okPrecipitation) :=
      {
        name := "A Trip with Gear"
        expectedBugginess     := [Narrow.T.mk (Bugginess.T.LightBugs, [BodyPart.T.Head, BodyPart.T.Torso, BodyPart.T.Arms]) (by narrowTac),]
      , expectedPrecipitation := [ .mk Precipitation.T.YesPrecip (by narrowTac) ]
      }

    end ATripWithGearExample

end Instantiated
