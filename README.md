# provably-packed

- Have YOU ever wanted to know if you’re prepared to hike the [Continental Divide Trail](https://en.wikipedia.org/wiki/Continental_Divide_Trail) at COMPILE time?!
- Are you an [ULTRALIGHT](https://www.reddit.com/r/Ultralight/) backpacker who wants a correct-by-construction packing list? 
- Do you have an upcoming wedding you need to be provably dressed for?

Do you want to do ALL of this without leaving the comfort of [your favorite Lean-compatible text-editor](https://www.google.com/search?q=lean+4+supported+text+editors&num=10&sca_esv=8c2b0058ed4277b2&sxsrf=AE3TifP2vbUtwDLOUUn5EfrH7F6GSNzf0A:1758419155909&ei=01jPaMymN7_1kPIP7pLBiQ4&ved=0ahUKEwiM3J3p3eiPAxW_OkQIHW5JMOEQ4dUDCBM&uact=5&oq=lean+4+supported+text+editors&gs_lp=Egxnd3Mtd2l6LXNlcnAiHWxlYW4gNCBzdXBwb3J0ZWQgdGV4dCBlZGl0b3JzMgUQIRigATIFECEYoAEyBRAhGKABMgUQIRigAUjjAlCCAViCAXABeAGQAQCYAYsBoAGLAaoBAzAuMbgBA8gBAPgBAZgCAqACkAHCAgoQABiwAxjWBBhHmAMAiAYBkAYIkgcDMS4xoAe8BLIHAzAuMbgHjgHCBwMwLjLIBwI&sclient=gws-wiz-serp)?


Well you have come to the right place.

---

`provably-packed` is a Lean 4 library for declaratively describing a correct-by-construction packing list using the power of dependent types. 

Describe:
- your environment/conditions as custom sum types (e.g., `Bugginess.T`, `Precipitation.T`, `Fashion.T`),
- each item’s capabilities as a heterogeneous-list of lists of variants of your conditions,
- each item of gear you will carry, including its mass (looking at you my fellow [gram counters](https://www.reddit.com/r/ultralight_jerk/comments/7pqp8c/cutting_toothbrush_weight_tips/) )
- and the conditions you expect to face plus a weight limit.

Lean then checks—at compile time—that your gear can satisfy every expected condition and that your total mass is within bounds. If you see a red squiggly in your editor, you're not ready for your trip.

## How it works (Curry-Howard for hikers)

Thanks to the [Curry-Howard Isomorphism](https://en.wikipedia.org/wiki/Curry%E2%80%93Howard_correspondence), types can encode proofs. Constructing an `Expedition.T` constitutes a proof that your packing list meets its spec.

- `ProvablyPacked/Lib/HList.lean` provides `HList.T`, a heterogeneous list indexed by types, used to hold per-dimension properties.
- `ProvablyPacked/Lib/Narrow.lean` provides `Narrow.T α variants`, a type that only accepts a specified subset of a sum type’s constructors, plus a small tactic `narrowTac` to discharge subset proofs.
- `ProvablyPacked/Lib/PropertyHList.lean` defines a generic `Property α` with a list of equipped values and operations to union properties across items.
- `ProvablyPacked/Lib/PropertiesHListComparator.lean` defines a comparator where expectations are typed against the gear’s actual properties:
  - `propsToSigmaList` turns an `HList` of properties into a value-level index.
  - `ExpectedForSigma sp := List (Narrow.T sp.1 sp.2.values)` ensures each expected value is drawn from precisely the equipped variants.
  - `PropertiesHListComparator.T actualProperties` stores `expectedProperties` with a shape tied to the actual gear.
- `ProvablyPacked/Models/Item.lean` defines `Item.T types` with `massG`, an `HList` of `properties`, and `union/unionList` to combine multiple items’ mass and properties.
- `ProvablyPacked/Models/Expedition.lean` defines `Expedition.T actualItems`, which:
  - extends the comparator for the unioned gear properties,
  - exposes `actualMassG`,
  - requires a `maxExpectedMassG`, and
  - includes a proof `has_valid_mass : actualMassG <= maxExpectedMassG`.

When Lean accepts your `Expedition.T` value, you’ve proven that:

- every expected condition is a subset of your gear’s capabilities,
- you aren’t expecting something your items can’t handle, and
- your packed weight is within the declared limit.

## Try it locally

Prereqs: Install Lean 4 and Lake. See the official instructions: https://lean-lang.org/get_started/

```sh
lake update
```

Then open `ProvablyPacked/User/Example/ExampleScratchpad1.lean` in your editor (Lean 4 VS Code extension recommended). Watch Lean check the following:

- Item definitions with property lists per dimension (e.g., which `Bugginess.T` and `Precipitation.T` variants each item can handle).
- The unioned gear properties and total mass via `Item.unionList`.
- An `Expedition.T` that specifies `expectedProperties` per dimension using `Narrow.T … (by narrowTac)` and a `maxExpectedMassG` with a proof `has_valid_mass`.

Try changing things and see the type checker help you:

- lower `maxExpectedMassG` to a value less than `actualMassG` → the `has_valid_mass` proof won’t compile,
- expect a value your gear doesn’t support → `narrowTac` can’t find a proof and the file won’t typecheck.

## Customize your own system

1. Define your domain of conditions (enums work great) in something like `ProvablyPacked/User/MyDomain.lean`.
2. Create items as `Item.T [YourType1, YourType2, …]` with their equipped values per dimension.
3. Combine items with `Item.unionList` into a gear list.
4. Construct an `Expedition.T (actualItems := gearList)` with your `expectedProperties` and `maxExpectedMassG`.

If it compiles, you have a machine-checked proof that your packing list meets the spec you wrote.

## Status & roadmap

- More examples and docs coming (e.g., parameterized properties, richer comparators, more complex example packing lists).
