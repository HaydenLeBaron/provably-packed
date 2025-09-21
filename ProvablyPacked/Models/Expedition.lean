import ProvablyPacked.Lib.PropertiesHListComparator
import ProvablyPacked.Models.Item

/-
TODO: add a temperature range (C) patterned after maxExpectedMassG and has_valid_mass
to encode temperature ranges for an Expedition/(ItemModuleI)
-/

namespace Expedition

  /-- A `T` is a correct-by-construction representation of a trip (e.g. a thru-hike),
      that perform a type-level comparison between
      an HList of actual properties (e.g. of your packed items)
      and an HList of list of expected properties
      (e.g. what kinds of conditions do you expect to face)

      The successful construction of a `T` constitutes a formal proof that
      - the actual `properties` of your items are compatible with the `expectedProperties`
        (e.g. that you have at least one item that handles `Domain.Bugginess.T`, `Domain.Precipitation.T`, etc.
        --whatever you defined in `User.Domain.lean`.)
      - the total `actualMassG` of your items satisfies `has_valid_mass`. -/
  structure T {types : List Type}  (actualItems : List (Item.T types))
    extends PropertiesHListComparator.T (Item.unionList none actualItems).properties
    where
      name : String
      actualMassG : Int := (Item.unionList none actualItems).massG
      maxExpectedMassG : Int
      has_valid_mass : actualMassG <= maxExpectedMassG
end Expedition



namespace Examples
  -- TODO: write examples like in @HList.lean
end Examples
