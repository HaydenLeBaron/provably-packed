import ProvablyPacked.Lib.PropertiesHListComparator

namespace Expedition

  /--
    A T is a representation of a trip (e.g. a thru-hike), extending a PropertiesHListComparator.T to
      perform a type-level comparison between
        an HList of actual properties (e.g. of your packed items)
      with
        an HList of list of expected properties (e.g. what kinds of conditions do you expect to face)
  -/
  structure T {types : List Type}  (actualProperties : HList.T PropertyHList.Property types)
  extends PropertiesHListComparator.T actualProperties
  where
    name : String

  -- TODO: add a type

end Expedition
