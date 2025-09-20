import ProvablyPacked.Lib.HList
import ProvablyPacked.Lib.PropertyHList

namespace ItemColl

  /-
    A T is a representation of an item collection.
    e.g. it can represent an item or a combination of items (who have been unioned together)
  -/
  structure T
  -- TODO: add these to T
  --(description : String)
  --(massG : Nat)
  (types : List Type) where
    name : String
    properties : PropertyHList.T types


end ItemColl
