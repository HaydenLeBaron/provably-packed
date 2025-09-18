import ProvablyPacked.User.Domain

namespace Item
  structure T where
    name : String
    /-- These are the contexts in which is is ok to use this item
      (the contexts in which the item is equippable for)-/
    okBugginess : List Bugginess.T
    okPrecipitation : List Precipitation.T
    okFashion : List Fashion.T
end Item
