
  inductive Body where
    | Torso | Arms | Lower | Head | Feet | Hands
    deriving DecidableEq, Repr

  inductive Insulation (b : Body) where
  | Needed (b : Body) | NoNeed (b : Body)
  -- Each type needs to be decidable or the narrowing tactics will fail
  deriving DecidableEq, Repr

  inductive Wind (b : Body) where
  | ProofNeeded (b : Body) | ResistNeeded (b : Body) | NoNeed (b : Body)
  deriving DecidableEq, Repr

  inductive Vent (b : Body) where
  | AbleNeeded (b : Body) | NoNeed (b : Body)
  deriving DecidableEq, Repr

  inductive Breathe (b : Body) where
  | AbleNeeded (b : Body) | NoNeed (b : Body)
  deriving DecidableEq, Repr

  inductive QuickDry (b : Body) where
  | IsNeeded (b : Body) | NotNeeded (b : Body)
  deriving DecidableEq, Repr

  inductive Mosquito (b : Body) where
  | ProofNeeded (b : Body) | NoNeed (b : Body)
  deriving DecidableEq, Repr

  inductive Durable (b : Body) where
  | IsNeeded (b : Body) | NotNeeded (b : Body)
  deriving DecidableEq, Repr

  inductive Sun (b : Body) where
  | ProofNeeded (b : Body) | NoNeed (b : Body)
  deriving DecidableEq, Repr

  inductive Hydrophobic (b : Body) where
  | Yes (b : Body) | No (b : Body)
  deriving DecidableEq, Repr

  inductive AiryAndLofty (b : Body) where
  | Yes (b : Body) | No (b : Body)
  deriving DecidableEq, Repr

  inductive Waterproof (b : Body) where
  | Yes (b : Body) | Resist | No (b : Body)
  deriving DecidableEq, Repr

  inductive Oversized (b : Body) where
  | Yes (b : Body) | No (b : Body)
  deriving DecidableEq, Repr

  inductive LooseFitting (b : Body) where
  | Yes (b : Body) | No (b : Body)
  deriving DecidableEq, Repr

  inductive Compressible (b : Body) where
  | Yes (b : Body) | No (b : Body)
  deriving DecidableEq, Repr

  inductive Dexterous (b : Body) where
  | Yes (b : Body) | No (b : Body)
  deriving DecidableEq, Repr

  inductive AntiBlister (b : Body) where
  | Yes (b : Body) | No (b : Body)
  deriving DecidableEq, Repr

  /-- Style is intentionally not parameterized by body
      because I am convinced that it takes only one
      article of clothing to make a whole outfit.
      (All you need to be ready for a wedding is a tie, right?) -/
  inductive Style (spiff : Int) where
  | Casual  | Formal (spiff : Int)
  deriving DecidableEq, Repr
