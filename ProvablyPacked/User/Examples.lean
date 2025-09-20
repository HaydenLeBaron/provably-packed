import ProvablyPacked.Lib.Narrow
import ProvablyPacked.Lib.PropertiesHListComparator
import ProvablyPacked.Models.Expedition
import ProvablyPacked.Models.Item
import ProvablyPacked.User.Domain

/-! MODEL INSTANTIATION (TYPE CHECKING DEMO) ----------------- -/


namespace Instantiated
    namespace ATripWithGearExample
      open Bugginess.T Precipitation.T

      def bugproofShirt : Item.T [Bugginess.T, Precipitation.T, Fashion.T] :=
      { name := "BugProof Shirt"
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

      def spork : Item.T [Bugginess.T, Precipitation.T, Fashion.T] :=
      { name := "Spork (No properties)"
      , properties :=
          { values := [] }
          ::: { values := [] }
          ::: { values := [] }
          ::: HNil
      }

      /-- Example: union the properties of two propertyHLists pointwise across dimensions. -/
      def unionedShirtAndJacket : Item.T [Bugginess.T, Precipitation.T, Fashion.T] :=
      { name := "Unioned Bugproof + Clammy Waterproof"
      , properties := PropertyHList.unionProperties bugproofShirt.properties clammyWaterproofJacket.properties
      }

      def unionedEverything : Item.T [Bugginess.T, Precipitation.T, Fashion.T] :=
      { name := "Unioned Everything"
      , properties := PropertyHList.unionPropertiesList [bugproofShirt.properties, clammyWaterproofJacket.properties, spork.properties] }

    def myNewTrip : Expedition.T unionedEverything.properties
    :=
      { name := "A Variadic Trip with Gear"
      --, actualProperties := unionedEverything.properties
      , expectedProperties :=
          [ Narrow.T.mk Bugginess.T.LightBugs (by narrowTac), Narrow.T.mk Bugginess.T.HeavyBugs (by narrowTac) ]
        ::: [ Narrow.T.mk Precipitation.T.YesPrecip (by narrowTac) ]
        ::: [ Narrow.T.mk Fashion.T.Casual (by narrowTac), Narrow.T.mk Fashion.T.Formal (by narrowTac) ]
        ::: HNil
      }

    end ATripWithGearExample

end Instantiated
