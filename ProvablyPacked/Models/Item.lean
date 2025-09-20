import ProvablyPacked.Lib.HList
import ProvablyPacked.Lib.PropertyHList

namespace Item
  structure T
  -- TODO: add these to T
  --(description : String)
  --(massG : Nat)
  (types : List Type) where
    name : String
    properties : PropertyHList.T types
