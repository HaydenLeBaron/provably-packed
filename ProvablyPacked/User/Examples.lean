import ProvablyPacked.Lib.Narrow
import ProvablyPacked.Lib.PropertiesHListComparator
import ProvablyPacked.Models.Expedition
import ProvablyPacked.Models.Item
-- !!!!! IMPORTANT: Define your property types in User.Domain before using them in this file! !!!!!
import ProvablyPacked.User.Domain


/-! This file is a collection of examples that can be used to demonstrate and test the library. -/

namespace ATripWithGearExample
  def bugproofShirt : Item.T [Bugginess.T, Precipitation.T, Fashion.T] :=
  { name := "BugProof Shirt"
  , massG := 42
  , properties :=
          { values := [Bugginess.T.NoBugs, Bugginess.T.LightBugs, Bugginess.T.HeavyBugs] }
      ::: { values := [Precipitation.T.NoPrecip] }
      ::: { values := [Fashion.T.Casual] }
      ::: HNil
  }

  def clammyWaterproofJacket : Item.T [Bugginess.T, Precipitation.T, Fashion.T] :=
  { name := "Clammy Waterproof Jacket"
  , massG := 12
  , properties :=
          { values := [Bugginess.T.NoBugs, Bugginess.T.LightBugs] }
      ::: { values := [Precipitation.T.YesPrecip] } -- You wouldn't want to wear this with no precipitation
      ::: { values := [Fashion.T.Formal] }
      ::: HNil
  }

  def spork : Item.T [Bugginess.T, Precipitation.T, Fashion.T] :=
  { name := "Spork (No properties)"
  , massG := 3
  , properties :=
          { values := [] }
      ::: { values := [] }
      ::: { values := [] }
      ::: HNil
  }

  def gearList : List (Item.T [Bugginess.T, Precipitation.T, Fashion.T])
    := [bugproofShirt, clammyWaterproofJacket, spork]

  def myNewTrip : Expedition.T
    (actualItems := gearList)
    :=
    { name := "A Variadic Trip with Gear"
    , expectedProperties :=
          [ Narrow.T.mk Bugginess.T.LightBugs (by narrowTac), Narrow.T.mk Bugginess.T.HeavyBugs (by narrowTac) ]
      ::: [ Narrow.T.mk Precipitation.T.YesPrecip (by narrowTac) ]
      ::: [ Narrow.T.mk Fashion.T.Casual (by narrowTac), Narrow.T.mk Fashion.T.Formal (by narrowTac) ]
      ::: HNil
    , maxExpectedMassG := 57 -- If this was any lower it would fail to typecheck
    , has_valid_mass := by
        simp [ gearList,
              Item.unionList,
              Item.union,
              Item.empty,
              bugproofShirt,
              clammyWaterproofJacket,
              spork
              ];
    }

end ATripWithGearExample
