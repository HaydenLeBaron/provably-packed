import ProvablyPacked.Lib.PropertiesHListComparator
namespace Expedition
  structure T {types : List Type}  (actualProperties : HList.T PropertyHList.Property types)
  extends PropertiesHListComparator.T actualProperties
  where
    name : String
end Expedition
