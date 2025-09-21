import ProvablyPacked.Lib.PropertiesHListComparator
import ProvablyPacked.Models.Item

namespace Expedition

  /--
    A T is a representation of a trip (e.g. a thru-hike), extending a PropertiesHListComparator.T to
      perform a type-level comparison between
        an HList of actual properties (e.g. of your packed items)
      with
        an HList of list of expected properties (e.g. what kinds of conditions do you expect to face)
  -/
  structure T {types : List Type}  (actualItems : List (Item.T types))
  extends PropertiesHListComparator.T (Item.unionList none actualItems).properties
  where
    name : String
    actualMassG : Int := (Item.unionList none actualItems).massG
    maxExpectedMassG : Int
    massBound : actualMassG <= maxExpectedMassG
end Expedition
