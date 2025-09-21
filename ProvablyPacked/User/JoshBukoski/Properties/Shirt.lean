
namespace Shirt

  inductive Insulation where
  | Needed | NoNeed
  -- Each type needs to be decidable or the narrowing tactics will fail
  deriving DecidableEq, Repr

  inductive Wind where
  | ProofNeeded | ResistNeeded | NoNeed
  deriving DecidableEq, Repr

  inductive Vent where
  | AbleNeeded | NoNeed
  deriving DecidableEq, Repr

  inductive Breathe where
  | AbleNeeded | NoNeed
  deriving DecidableEq, Repr

  inductive QuickDry where
  | IsNeeded | NotNeeded
  deriving DecidableEq, Repr

  inductive Mosquito where
  | ProofNeeded | NoNeed
  deriving DecidableEq, Repr

  inductive Durable where
  | IsNeeded | NotNeeded
  deriving DecidableEq, Repr

  inductive Sun where
  | ProofNeeded | NoNeed
  deriving DecidableEq, Repr

  inductive Style where
  | Casual | Formal
  deriving DecidableEq, Repr

end Shirt
