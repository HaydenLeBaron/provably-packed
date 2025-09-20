/-!
# HList

Provides heterogeneous lists indexed by a list of type indices.
This enables type-safe collections where each element can have a different type,
with the types determined by the index list.
-/

universe u v

namespace HList

  /- A heterogeneous list indexed by a list of indices (universe-polymorphic). -/
  inductive T {ι : Type u} (β : ι → Type v) : List ι → Type (max u v) where
    | nil : T β []
    | cons {i is} (head : β i) (tail : T β is) : T β (i :: is)

  infixr:67 " ::: " => T.cons
  notation "HNil" => T.nil

end HList


  /-- Example of an `HList` containing different types of values -/
  def exampleHList : HList.T (fun
    | 0 => Nat
    | 1 => String
    | 2 => Bool
    | _ => Unit) [0, 1, 2] :=
    42 ::: "hello" ::: true ::: HNil


namespace Examples

  private inductive Greeting where | GoodMorning  | GoodDay | GoodNight
  private inductive Saludo where | BuenosDias | BuenasNoches
  private inductive NeverUse where | NeverUsed
  private inductive Time where | Morning | Day | Night
  private def indexMap := (fun
    | Time.Morning => Greeting
    | Time.Day => Saludo
    | Time.Night => NeverUse
    )
  -- English in the morning, Spanish in the daytime, never speak at night
  private def morningENnightES : HList.T  indexMap [Time.Morning, Time.Day] :=
    Greeting.GoodMorning ::: Saludo.BuenasNoches ::: HNil

  /-
  Application type mismatch: The argument
    ?m.17 ::: HNil
  has type
    HList.T ?m.19 [?m.15]
  but is expected to have type
    HList.T indexMap []
  in the application
  -/
  -- private def unexpectedValAtIndex : HList.T indexMap [Time.Morning, Time.Day] :=
  --   Greeting.GoodMorning ::: Saludo.BuenasNoches ::: NeverUse.NeverUsed ::: HNil


  /-
  Application type mismatch: The argument
  Greeting.GoodNight
    has type
  Greeting
    but is expected to have type
  indexMap Time.Day
    in the application
  HList.T.cons Greeting.GoodNightLean 4
  -/
  -- private def wrongTypeValAtIndex : HList.T indexMap [Time.Morning, Time.Day] :=
  --   Greeting.GoodMorning ::: Greeting.GoodNight ::: HNil

end Examples
