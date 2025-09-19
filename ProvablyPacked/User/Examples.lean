import ProvablyPacked.Lib.Narrow
import ProvablyPacked.Lib.Expedition
import ProvablyPacked.Lib.Item
import ProvablyPacked.User.Domain

/-! MODEL INSTANTIATION (TYPE CHECKING DEMO) ----------------- -/


namespace Instantiated
    namespace ATripWithGearExample
      open Bugginess.T Precipitation.T

      def bugproofShirt : Item.T [Bugginess.T, Precipitation.T, Fashion.T] :=
      { name := "Bugproof Shirt"
      , properties :=
              { values := [Bugginess.T.NoBugs, Bugginess.T.LightBugs, Bugginess.T.HeavyBugs] }
          ::: { values := [Precipitation.T.NoPrecip] }
          ::: { values := [Fashion.T.Casual] }
          ::: HNil
      }

      def clammyWaterproofJacket : Item.T [Bugginess.T, Precipitation.T, Fashion.T] :=
      { name := "Clammy Waterproof Jacket"
      , properties :=
              { values := [Bugginess.T.NoBugs, Bugginess.T.LightBugs] }
          ::: { values := [Precipitation.T.YesPrecip] } -- You wouldn't want to wear this with no precipitation
          ::: { values := [Fashion.T.Formal] }
          ::: HNil
      }

      -- FIXME: This isn't really unioning gear attributes, it's just listing all the values
      -- def unionedGearAttributes : Item.T :=
      -- { name := "Bugproof and Clammy Waterproof"
      -- , properties :=
      --     [ ⟨Bugginess.T, { values := [Bugginess.T.NoBugs, Bugginess.T.LightBugs, Bugginess.T.HeavyBugs] ++ [Bugginess.T.NoBugs, Bugginess.T.LightBugs] }⟩
      --     , ⟨Precipitation.T, { values := [Precipitation.T.NoPrecip] ++ [Precipitation.T.YesPrecip] }⟩
      --     , ⟨Fashion.T, { values := [Fashion.T.Casual] ++ [Fashion.T.Formal] }⟩
      --     ]
      -- }

      -- TODO: we need to be plugging in the actually unioned gear attributes. Then after we do this, we need to move this
      ---- unioning gear concern to Expedition.lean
      /-- The same trip specified via the variadic form by packaging each context as a `Dim`. -/
      def variadicDims : List Expedition.Dim :=
      [ { τ := Bugginess.T,     equipped := [Bugginess.T.NoBugs, Bugginess.T.LightBugs, Bugginess.T.HeavyBugs, Bugginess.T.NoBugs, Bugginess.T.LightBugs] }
      , { τ := Precipitation.T, equipped := [Precipitation.T.NoPrecip, Precipitation.T.YesPrecip] }
      , { τ := Fashion.T,       equipped := [Fashion.T.Casual, Fashion.T.Formal] }
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
