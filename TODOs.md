- [ ] Write type-level "tests" in Examples.lean in this spirit:
    ```lean

    #eval def y : Nat = 5

    /-- error: type mismatch
    "Not a number" has type String
    but is expected to have type Nat -/
    #guard_msgs in
    def x : Nat := "Not a number"
    ```

- [INPROG] Implement Josh Bukoski System
    - [x] Draft it
    - [ ] Check it (has to be exact properties of his actual gear)
- [x] Write basic README
- [ ] Refine README
- [ ] Make a YouTube video demoing the library



## V2
- [ ] Instead of writing Lean directly in Examples.lean, create a simple EDSL out of macros


NICE TO HAVE:
- [ ] is propsToSigmaList? Can we remove this?
- [ ] Nix flake for setting up dev env to run this (assuming you already have your favorite editor and a Lean 4 extension)