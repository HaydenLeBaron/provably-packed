- [ ] Write type-level "tests" in Examples.lean in this spirit:
    ```lean

    #eval def y : Nat = 5

    /-- error: type mismatch
    "Not a number" has type String
    but is expected to have type Nat -/
    #guard_msgs in
    def x : Nat := "Not a number"
    ```
- [ ] Write a good README.md with instructions for usage
- [ ] Make a YouTube video demoing the library



## V2
- [ ] Instead of writing Lean directly in Examples.lean, create a simple EDSL out of macros


NICE TO HAVE:
- [ ] is propsToSigmaList? Can we remove this?