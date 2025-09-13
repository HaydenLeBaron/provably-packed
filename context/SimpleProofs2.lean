import Lean.Data.Lsp.Window
set_option diagnostics true

abbrev Gram := Nat

inductive Coffee
| Greek
| Turkish

namespace Loadout

  structure Food where
    name : String
    kCal : Nat

  inductive Liquid
  | Water
  | CrudeOil

  structure Shelter where
    name : String
    isWaterproof : Bool

  structure T where
    name : String
    food : Food
    liquid : { l : Liquid // l = Liquid.Water }
    shelter : Option Shelter
    coffee : Coffee
    right_coffee : coffee = Coffee.Turkish

end Loadout


namespace ParticularLoadouts

  def perfectLoadout : Loadout.T :=
    {
      name := "Forgot Something Loadout",
      food := {name := "Greek Yogurt", kCal := 1},
      liquid := ⟨ Loadout.Liquid.Water, rfl ⟩,
      shelter := some {name := "GoreTex Tent", isWaterproof := true},
      coffee := Coffee.Turkish,
      right_coffee := rfl
    }


  -- This loadout doesn't typecheck because it brings the wrong Coffee
  -- def wrongCoffeeLoadout : Loadout.T :=
  --   {
  --     name := "Forgot Something Loadout",
  --     food := {name := "Graham Cracker", kCal := 1},
  --     liquid := ⟨ Loadout.Liquid.Water, rfl ⟩,
  --     shelter := {name := "GoreTex Tent", isWaterproof := true},
  --     coffee := some Coffee.Greek,
  --     --right_coffee := sorry
  --     right_coffee := rfl
  --   }

  -- This loadout doesn't typecheck because it brings the wrong Liquid (Crude Oil) doesn't hydrate
  -- def wrongLiquidLoadout : Loadout.T :=
  --   {
  --     name := "Forgot Something Loadout",
  --     food := {name := "Greek Yogurt", kCal := 1},
  --     liquid := ⟨ Loadout.Liquid.CrudeOil, rfl ⟩,
  --     shelter := {name := "GoreTex Tent", isWaterproof := true},
  --     coffee := Coffee.Turkish,
  --     right_coffee := rfl
  --   }

  -- Error: this loadout forgets to specify the shelter
  -- def forgotSomethingLoadout : Loadout.T :=
  --   {
  --     name := "Forgot a Shelter Loadout",
  --     food := {name := "Greek Yogurt", kCal := 1},
  --     liquid := ⟨ Loadout.Liquid.Water, rfl ⟩,
  --     coffee := Coffee.Turkish,
  --     right_coffee := rfl
  --   }

  def cowboyCampingloadout : Loadout.T :=
    {
      name := "Cowboy Camping Loadout",
      food := {name := "Greek Yogurt", kCal := 1},
      liquid := ⟨ Loadout.Liquid.Water, rfl ⟩,
      shelter := none,
      coffee := Coffee.Turkish,
      right_coffee := rfl
    }
end ParticularLoadouts



theorem perfectLoadoutHasRightCoffee : ParticularLoadouts.perfectLoadout.right_coffee = rfl := by
  simp [ParticularLoadouts.perfectLoadout]

-- Proof by contradiction that wrongCoffeeLoadout has the wrong coffee. Set right_coffee := sorry in the loadout to be able to run
-- theorem wrongCoffeeLoadoutHasWrongCoffee : wrongCoffeeLoadout.coffee ≠ Coffee.Greek := by
--   -- We assume the opposite for the sake of contradiction.
--   intro h
--   -- `h` is a hypothesis: `wrongCoffeeLoadout.coffee = Coffee.Turkish`
--   -- We unfold `wrongCoffeeLoadout` in the hypothesis `h`.
--   simp [wrongCoffeeLoadout] at h
--   -- After `simp`, `h` becomes `Coffee.Greek = Coffee.Turkish`, which is a contradiction.
