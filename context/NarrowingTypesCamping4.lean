set_option diagnostics true

namespace Sub
  inductive T (α : Type) (subset : List α) : Type where
    | mk (a : α) (h : a ∈ subset) : T α subset

  open T

  syntax (name := subsetOfSumT) "subsetOfSumT" : tactic
  macro_rules
    | `(tactic| subsetOfSumT) => `(tactic| first | decide | simp)
end Sub

namespace Precipitation
  inductive T where
    | NoPrecip | YesPrecip
    deriving DecidableEq, Repr
  open T
  abbrev SubT (subset : List T) := Sub.T T subset
end Precipitation

namespace Bugginess
  inductive T where
    | NoBugs | LightBugs | HeavyBugs
    deriving DecidableEq, Repr
  open T
  abbrev SubT (subset : List T) := Sub.T T subset
end Bugginess

namespace CampingTrip
  open Bugginess Precipitation

  abbrev OkBugT   (allowed : List Bugginess.T)    := Bugginess.SubT allowed
  abbrev OkPrecipT  (allowed : List Precipitation.T) := Precipitation.SubT allowed

  structure T (expectedBugginess : List Bugginess.T)
              (expectedPrecip   : List Precipitation.T) where
    name : String := "Camping Trip"
    bugginess     : List (OkBugT  expectedBugginess)
    precipitation : List (OkPrecipT expectedPrecip)
end CampingTrip

namespace Item
  structure T where
    name : String
    /- These are the contexts in which is is ok to use this item -/
    okBugginess : List Bugginess.T
    okPrecipitation : List Precipitation.T
end Item


namespace Instantiated

  --open Bugginess.T Precipitation.T

  /- Your concrete “May 2026 Camping Trip”, obtained by *instantiating* the parameters. -/
  def May2026CampingTrip :
    -- Here you specify the interface
      CampingTrip.T
        (expectedBugginess:=[Bugginess.T.NoBugs, .LightBugs, --FIXME_IMPLICIT_PARAM,
        --.FIXME -- <- good this line doesn't compile
        ])
        (expectedPrecip:=[Precipitation.T.NoPrecip, Precipitation.T.YesPrecip]) :=
    -- Here you specify the satisfaction of the interface
  { name := "May 2026 Camping Trip"
    , bugginess :=
    [ .mk Bugginess.T.NoBugs    (by simp)
    , .mk Bugginess.T.LightBugs (by subsetOfSumT)
    --, .mk FIXME_IMPLICIT_PARAM (by subsetOfSumT)
    -- , .mk Bugginess.T.HeavyBugs (by subsetOfSumT) -- type error (good)
    ]
    , precipitation :=
    [ .mk Precipitation.T.NoPrecip (by subsetOfSumT)
    , .mk Precipitation.T.YesPrecip (by subsetOfSumT)
      ]
    }

    /- Example: a different trip with different allowed lists. -/
    def AnotherTrip :
      CampingTrip.T [Bugginess.T.LightBugs] [Precipitation.T.YesPrecip] :=
    { bugginess     := [ .mk Bugginess.T.LightBugs (by subsetOfSumT) ]
    , precipitation := [ .mk Precipitation.T.YesPrecip (by subsetOfSumT) ]
    }

    namespace ATripWithGearExample

      def bugproofShirt : Item.T :=
      { name := "Bugproof Shirt"
      , okBugginess := [Bugginess.T.NoBugs, Bugginess.T.LightBugs, Bugginess.T.HeavyBugs]
      , okPrecipitation := [Precipitation.T.NoPrecip]
      }

      def clammyWaterproofJacket : Item.T :=
      { name := "Clammy Waterproof Jacket"
      , okBugginess := [Bugginess.T.NoBugs, Bugginess.T.LightBugs]
      , okPrecipitation := [Precipitation.T.YesPrecip] -- You wouldn't want to wear this with no precipitation
      }


      def unionedGearAttributes : Item.T :=
      { name := "Bugproof and Clammy Waterproof"
      , okBugginess := bugproofShirt.okBugginess ++ clammyWaterproofJacket.okBugginess
      , okPrecipitation := bugproofShirt.okPrecipitation ++ clammyWaterproofJacket.okPrecipitation
      }


    -- FIXME?: In this example I am using the union of the allowed attributes of the gear
    --         to define the properties my gear will satisfy together. "expected" is kind of a misnomer in this context because I was thinking of it backwards.
    -- If my attributes don't cover my bases then it will not type-check (good)
      def trip : CampingTrip.T
        (expectedBugginess := unionedGearAttributes.okBugginess)
        (expectedPrecip := unionedGearAttributes.okPrecipitation) :=
      { bugginess     := [ .mk Bugginess.T.LightBugs (by subsetOfSumT) ]
      , precipitation := [ .mk Precipitation.T.YesPrecip (by subsetOfSumT) ]
      }

    end ATripWithGearExample

end Instantiated
