import ProvablyPacked.Lib.Narrow
import ProvablyPacked.Lib.PropertiesHListComparator
import ProvablyPacked.Models.Expedition
import ProvablyPacked.Models.ItemColl
import ProvablyPacked.User.Domain

/-! MODEL INSTANTIATION (TYPE CHECKING DEMO) ----------------- -/


namespace Instantiated
    namespace ATripWithGearExample
      open Bugginess.T Precipitation.T

      def bugproofShirt : ItemColl.T [Bugginess.T, Precipitation.T, Fashion.T] :=
      { name := "BugProof Shirt"
      , massG := 42
      , properties :=
              { values := [Bugginess.T.NoBugs, Bugginess.T.LightBugs, Bugginess.T.HeavyBugs] }
          ::: { values := [Precipitation.T.NoPrecip] }
          ::: { values := [Fashion.T.Casual] }
          ::: HNil
      }

      def clammyWaterproofJacket : ItemColl.T [Bugginess.T, Precipitation.T, Fashion.T] :=
      { name := "Clammy Waterproof Jacket"
      , massG := 12
      , properties :=
              { values := [Bugginess.T.NoBugs, Bugginess.T.LightBugs] }
          ::: { values := [Precipitation.T.YesPrecip] } -- You wouldn't want to wear this with no precipitation
          ::: { values := [Fashion.T.Formal] }
          ::: HNil
      }

      def spork : ItemColl.T [Bugginess.T, Precipitation.T, Fashion.T] :=
      { name := "Spork (No properties)"
      , massG := 3
      , properties :=
              { values := [] }
          ::: { values := [] }
          ::: { values := [] }
          ::: HNil
      }

      def unionedEverything : ItemColl.T [Bugginess.T, Precipitation.T, Fashion.T]
      := ItemColl.unionList "Unioned Everything" [bugproofShirt, clammyWaterproofJacket, spork]

    def myNewTrip : Expedition.T unionedEverything
    :=
      { name := "A Variadic Trip with Gear"
        , expectedProperties :=
              [ Narrow.T.mk Bugginess.T.LightBugs (by narrowTac), Narrow.T.mk Bugginess.T.HeavyBugs (by narrowTac) ]
          ::: [ Narrow.T.mk Precipitation.T.YesPrecip (by narrowTac) ]
          ::: [ Narrow.T.mk Fashion.T.Casual (by narrowTac), Narrow.T.mk Fashion.T.Formal (by narrowTac) ]
          ::: HNil
        , actualMassG := unionedEverything.massG
        , maxExpectedMassG := 57 -- If this was any lower it would fail to typecheck
        , massBound := by
            simp [ unionedEverything,
                  ItemColl.unionList,
                  ItemColl.union,
                  ItemColl.empty,
                  bugproofShirt,
                  clammyWaterproofJacket,
                  spork
                  ];
      }

    end ATripWithGearExample

end Instantiated
