
- [ ] Clean up code and comments
- [ ] Rename Item.T to Properties.T. Trivially implement an Item.T as a Properties.T with a name, description, mass.
- [ ] Rename Expedition.T to PropertiesComparator.T. Trivially implement Expedition.T as a PropertiesComparator.T with a name, description, mass.

- [ ] Write type-level "tests" in Examples.lean in this spirit:
    ```lean

    #eval def y : Nat = 5

    /-- error: type mismatch
    "Not a number" has type String
    but is expected to have type Nat -/
    #guard_msgs in
    def x : Nat := "Not a number"
    ```
- [ ] Rename Examples.lean to ExampleScratchpad.lean
- [ ] Write a good README.md with instructions for usage
- [ ] Make a YouTube video demoing the library



## V2
- [ ] Instead of writing Lean directly in Examples.lean, create a simple EDSL out of macros


NICE TO HAVE:
- [ ] is propsToSigmaList? Can we remove this?