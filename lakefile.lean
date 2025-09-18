import Lake
open Lake DSL

package «provably-packed» where
  -- add package configuration options here
  require mathlib from git "https://github.com/leanprover-community/mathlib4.git" @ "master"
  require batteries from git "https://github.com/leanprover-community/batteries.git" @ "main"



lean_lib «ProvablyPacked» where
  -- add library configuration options here

@[default_target]
lean_exe «provably-packed» where
  root := `Main
