import ProvablyPacked.Lib.Narrow
import ProvablyPacked.Lib.Expedition
import ProvablyPacked.Lib.Item
import ProvablyPacked.User.Domain

/-! MODEL INSTANTIATION (TYPE CHECKING DEMO) ----------------- -/


namespace Instantiated
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

      /-- The same trip specified via the variadic form by packaging each context as a `Dim`. -/
      def variadicDims : List Expedition.Dim :=
      [ { τ := Bugginess.T,     equipped := unionedGearAttributes.okBugginess }
      , { τ := Precipitation.T, equipped := unionedGearAttributes.okPrecipitation }
      , { τ := Fashion.T,     equipped := unionedGearAttributes.okFashion }
      ]

      def variadicTrip : Expedition.T variadicDims :=
      { name := "A Variadic Trip with Gear"
      , expected :=
          [ .mk Bugginess.T.LightBugs (by narrowTac), .mk Bugginess.T.HeavyBugs (by narrowTac) ]
        ::: [ .mk Precipitation.T.YesPrecip (by narrowTac) ]
        ::: [ .mk Fashion.T.Casual (by narrowTac), .mk Fashion.T.Formal (by narrowTac) ]
        ::: HNil
      }

    end ATripWithGearExample

end Instantiated
