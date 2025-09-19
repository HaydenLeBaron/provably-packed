Right now In @Item.lean , an Item.T is defined as an HList of List of types. You can see how in @Examples.lean  and item is instantiated like this:

```lean
      def clammyWaterproofJacket : Item.T [Bugginess.T, Precipitation.T, Fashion.T] :=
      { name := "Clammy Waterproof Jacket"
      , properties :=
              { values := [Bugginess.T.NoBugs, Bugginess.T.LightBugs] }
          ::: { values := [Precipitation.T.YesPrecip] }
          ::: { values := [Fashion.T.Formal] }
          ::: HNil
      }
```

I would like to change @Item.lean so that an item can be instantiated in @Examples.lean something like this:
```lean
      def clammyWaterproofJacket : Item.T [Bugginess.T, Precipitation.T, Fashion.T] :=
      { name := "Clammy Waterproof Jacket"
      , properties :=
              Bugginess.T.NoBugs
          ::: Bugginess.T.LightBugs
          ::: Precipitation.T.YesPrecip
          ::: Fashion.T.Formal
          ::: HNil
      }
```
