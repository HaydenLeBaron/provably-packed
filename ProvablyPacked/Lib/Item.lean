import ProvablyPacked.User.Domain

/-!
# Item

Defines the structure for items that can be packed in expeditions.
Each item has context requirements specifying the conditions under which it can be used.
-/

namespace Item
  structure T where
    name : String
    /-- These are the contexts in which is is ok to use this item
      (the contexts in which the item is equippable for)-/
    okBugginess : List Bugginess.T
    okPrecipitation : List Precipitation.T
    okFashion : List Fashion.T
end Item
