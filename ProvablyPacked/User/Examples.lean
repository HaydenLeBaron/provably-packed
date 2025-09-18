import ProvablyPacked.Lib.Narrow
import ProvablyPacked.Lib.Expedition
import ProvablyPacked.Lib.Item
import ProvablyPacked.User.Domain

/-! MODEL INSTANTIATION (TYPE CHECKING DEMO) ----------------- -/

namespace Instantiated

  /- Your concrete "May 2026 Camping Trip", obtained by *instantiating* the parameters. -/
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
