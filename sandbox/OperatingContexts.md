# Operating Contexts

The situations

inductive TemperatureApprox
| Cneg10
| C0
| C10
| C20
| C30
| C40

inductive Precipitation
| NoPrecip
| LoPrecip
| HiPrecip

inductive Windiness
| NoWind
| LightWind
| HeavyWind

inductive Bugginess
| NoBugs
| LightBugs
| HeavyBugs

inductive Fashionability
| SemiFormal
| Casual

inductive Campability
| EmergencyOnly
| AdvisableOpenly
| AdvisableStealthRequired

inductive Escapability
| EscapeHatchIfNecessary
| PrepareForTheWorst

structure ExternalConditions where
  precipitation : Precipitation
  windiness : Windiness
  temperatureApprox : TemperatureApprox
  bugginess : Bugginess
  stealthiness : Stealthiness
  fashionability : Fashionability
  campability : Campability
  escapability : Escapability


inductive Shelteredness
| Sheltered
| Unsheltered

inductive Activity
| Sedentary
| Active

inductive MinToleratedComfort
| Survival
| MildAsceticism
| Glamping


structure AgentialState where 
    activity: Activity
    minToleratedComfort: MinimumToleratedComfort

structure Situation where
    externalConditions : ExternalConditions
    agentialState : AgentialState
    



