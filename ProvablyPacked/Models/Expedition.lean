import ProvablyPacked.Lib.PropertiesHListComparator
import ProvablyPacked.Models.ItemColl

namespace Expedition

  /--
    A T is a representation of a trip (e.g. a thru-hike), extending a PropertiesHListComparator.T to
      perform a type-level comparison between
        an HList of actual properties (e.g. of your packed items)
      with
        an HList of list of expected properties (e.g. what kinds of conditions do you expect to face)
  -/
  structure T {types : List Type}  (actualItems : ItemColl.T types)
  extends PropertiesHListComparator.T actualItems.properties
  where
    name : String
    actualMassG : Int := actualItems.massG
    expectedMassG : Int
    massBound : actualMassG <= expectedMassG
end Expedition
