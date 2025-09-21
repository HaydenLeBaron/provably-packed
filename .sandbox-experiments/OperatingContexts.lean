set_option diagnostics true

inductive TemperatureApprox
  | Cneg10
  | C0
  | C10
  | C20
  | C30
  | C40
deriving Repr, BEq, DecidableEq

inductive Precipitation
  | NoPrecip
  | LoPrecip
  | HiPrecip
deriving Repr, BEq, DecidableEq

def PrecipitationSubset (subPrecipitation : List Precipitation) := { l : List Precipitation // l.all (· ∈ subPrecipitation) }
deriving Repr, BEq, DecidableEq

inductive Windiness
  | NoWind
  | LightWind
  | HeavyWind
deriving Repr, BEq, DecidableEq

inductive Bugginess
  | NoBugs
  | LightBugs
  | HeavyBugs
deriving Repr, BEq, DecidableEq

inductive Fashionability
  | SemiFormal
  | Casual
deriving Repr, BEq, DecidableEq

inductive Campability
  | AdvisableOpenly
  | TolerableWithStealth
  | EmergencyOnly
deriving Repr, BEq, DecidableEq

inductive Escapability
  | EscapeHatchIfNecessary
  | PrepareForTheWorst
deriving Repr, BEq, DecidableEq

-- structure ExternalConditions where
--   precipitation : Precipitation
--   windiness : Windiness
--   temperatureApprox : TemperatureApprox
--   bugginess : Bugginess
--   fashionability : Fashionability
--   campability : Campability
--   escapability : Escapability
-- deriving Repr


structure ExternalConditions (α : Type u) where
  precipitation : Precipitation
  windiness : Windiness
  temperatureApprox : TemperatureApprox
  bugginess : Bugginess
  fashionability : Fashionability
  campability : Campability
  escapability : Escapability
deriving Repr


inductive Shelteredness
  | Sheltered
  | Unsheltered
deriving Repr, BEq, DecidableEq

inductive Activity
  | Sedentary
  | Active
deriving Repr, BEq, DecidableEq

inductive MinToleratedComfort
  | Survival
  | MildAsceticism
  | Glamping
deriving Repr, BEq, DecidableEq


structure AgentialState where
    activity: Activity
    minToleratedComfort: MinToleratedComfort
deriving Repr, BEq, DecidableEq

structure ArraySized (α : Type u) (length : Nat)  where
  array : Array α
  size_eq_length : array.size = length


-- structure OperatingContext where
--     externalConditions : ExternalConditions
--     agentialState : AgentialState
-- deriving Repr


-- structure ContextTemplate where
--     precipitation : List Precipitation
--     windiness : List Windiness
--     temperatureApprox : List TemperatureApprox
--     bugginess : List Bugginess
--     fashionability : List Fashionability
--     campability : List Campability
--     escapability : List Escapability
--     activity : List Activity
--     minToleratedComfort : List MinToleratedComfort
--   deriving Repr, BEq, DecidableEq

-- def expandTemplate (template : ContextTemplate) : List OperatingContext :=
--   template.precipitation.flatMap fun precip =>
--   template.windiness.flatMap fun wind =>
--   template.temperatureApprox.flatMap fun temp =>
--   template.bugginess.flatMap fun bugs =>
--   template.fashionability.flatMap fun fashion =>
--   template.campability.flatMap fun camp =>
--   template.escapability.flatMap fun escape =>
--   template.activity.flatMap fun act =>
--   template.minToleratedComfort.map fun comfort =>
--   { externalConditions := {
--       precipitation := precip,
--       windiness := wind,
--       temperatureApprox := temp,
--       bugginess := bugs,
--       fashionability := fashion,
--       campability := camp,
--       escapability := escape
--     },
--     agentialState := {
--       activity := act,
--       minToleratedComfort := comfort
--     }
--   }


-- TODO: define this as a macro or syntax extension, not a function, then delete expandTemplate
/- ATTENTION:
-- Operating Context Shorthand syntax for defining sets of operating contexts concisely
{
  operatingContext := {
    externalConditions := {
      precipitation := Precipitation.NoPrecip,
      windiness := Windiness.NoWind | Windiness.LightWind,
      temperatureApprox := TemperatureApprox.C10 | TemperatureApprox.C20, -- 10-20C
      bugginess := Bugginess.HeavyBugs, --  Prepare for heavy bugs
      fashionability := Fashionability.Casual, -- I don't care about fashion on this trip
      campability := Campability.AdvisableOpenly, -- I'm in the back country so I don't worry about stealth
      escapability := Escapability.PrepareForTheWorst -- I won't have an excape hatch (e.g. AirBnb instead of camping)
    },
    agentialState := {
      activity := Activity.Sedentary | Activity.Active, -- Multi-day backpacking trip
      minToleratedComfort := MinToleratedComfort.Survival -- I'm not trying to be comfy
    }
  }

}

-/

/-
  Where is this all going?

  One I have a static set of operating contexts (maybe I should just define them inline),
  `actualOperatingContexts`

  - I can use subtyping predicates to check for membership in `actualOperatingContexts` at compile time.
    - In other words, I can write the requirements for clothing as a type-level function of `actualOperatingContexts`
      - If there exists `Bugginess.LightBugs | Bugginess.HeavyBugs` in the `actualOperatingContexts`, then the
        - `BugProof` will be a required property of BugProofable clothing
        - types can depend on values

-/

-- Example usage: Define a backpacking trip context template
-- def backpackingTrip : ContextTemplate := {
--   precipitation := [Precipitation.NoPrecip],
--   windiness := [Windiness.NoWind, Windiness.LightWind],
--   temperatureApprox := [TemperatureApprox.C10, TemperatureApprox.C20], -- 10-20C
--   bugginess := [Bugginess.HeavyBugs], -- Prepare for heavy bugs
--   fashionability := [Fashionability.Casual], -- Don't care about fashion
--   campability := [Campability.AdvisableOpenly], -- Backcountry camping
--   escapability := [Escapability.PrepareForTheWorst], -- No escape hatch
--   activity := [Activity.Sedentary, Activity.Active], -- Multi-day backpacking
--   minToleratedComfort := [MinToleratedComfort.Survival] -- Not trying to be comfy
-- }

def backpackingTrip : ContextTemplate := {
  precipitation := [Precipitation.NoPrecip],
  windiness := [Windiness.NoWind, Windiness.LightWind],
  temperatureApprox := [TemperatureApprox.C10, TemperatureApprox.C20], -- 10-20C
  bugginess := [Bugginess.HeavyBugs], -- Prepare for heavy bugs
  fashionability := [Fashionability.Casual], -- Don't care about fashion
  campability := [Campability.AdvisableOpenly], -- Backcountry camping
  escapability := [Escapability.PrepareForTheWorst], -- No escape hatch
  activity := [Activity.Sedentary, Activity.Active], -- Multi-day backpacking
  minToleratedComfort := [MinToleratedComfort.Survival] -- Not trying to be comfy
}

-- Generate all 8 possible operating contexts (2 windiness × 2 temp × 2 activity)
#check expandTemplate backpackingTrip

#eval expandTemplate backpackingTrip
