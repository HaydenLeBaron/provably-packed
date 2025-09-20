import Lean.Data.Lsp.Window
set_option diagnostics true

abbrev Gram := Nat


namespace Loadout

  structure Item where
    name : String
    mass : Gram

  structure T where
    name : String
    items : List Item

end Loadout

def emptyLoadout : Loadout.T := {
  name := "Empty Loadout",
  items := []
}

def oneGramLoadout : Loadout.T := {
  name := "One Gram Loadout",
  items := [{name := "Graham Cracker", mass := 1}]
}

def heavyLoadout : Loadout.T := {
  name := "Heavy Loadout",
  items := [{name := "Graham Cracker", mass := 1},
            {name := "Graham Cracker", mass := 1},
            {name := "S'more", mass := 3}]
}

-- Simple inline theorem
theorem empty_loadout_mass_eq_0 :
  (fun l : Loadout.T => List.sum
    (l.items.map (fun item => item.mass)))
    emptyLoadout = 0 := by
  simp [emptyLoadout]

@[simp]
def totalMass (loadout : Loadout.T) : Gram :=
  List.sum (loadout.items.map (fun item => item.mass))
namespace Lemmas
  def assertTotalMassIsLessThanOrEqual (loadout : Loadout.T) (mass : Gram) : Prop :=
    totalMass loadout <= mass
end Lemmas

-- Simple predicate call theorem
theorem one_gram_loadout_mass_le_1 : Lemmas.assertTotalMassIsLessThanOrEqual oneGramLoadout 1 := by
  simp [Lemmas.assertTotalMassIsLessThanOrEqual]
  decide

-- This is a false theorem that doesn't typecheck. Uncomment to see the error.
-- theorem contradiciton_heavy_loadout_is_weightless : totalMass heavyLoadout <= 0 := by
--   simp [totalMass, heavyLoadout]
