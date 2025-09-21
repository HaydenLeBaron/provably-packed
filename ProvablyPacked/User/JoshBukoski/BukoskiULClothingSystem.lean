import ProvablyPacked.Lib.Narrow
import ProvablyPacked.Lib.PropertiesHListComparator
import ProvablyPacked.Models.Expedition
import ProvablyPacked.Models.Item


-- Import Domains
import ProvablyPacked.User.JoshBukoski.Properties.Shirt

/-!
  An implementation of Josh Bukoski's 3 Season Clothing System according to the
  notes in `@ProvablyPacked/User/JoshBukoski/README.md` (I recommend reading that first) -/
namespace Core

  namespace Shirt
    open Shirt

    def shirtPropTypes :=
      [Shirt.Insulation, Shirt.Wind, Shirt.Vent,
      Shirt.Breathe, Shirt.QuickDry,
      Shirt.Mosquito, Shirt.Durable, Shirt.Sun, Shirt.Style]


    def shirt : Item.T (shirtPropTypes) :=
      { name := "Bukoski Shirt"
      , massG := 42 -- TODO: find his actual shirt's weight
      , properties :=
              { values : List Shirt.Insulation := [.NoNeed, .Needed]}
          ::: { values := [Shirt.Wind.NoNeed, Shirt.Wind.ResistNeeded] }
          ::: { values := [Shirt.Vent.NoNeed, Shirt.Vent.AbleNeeded] }
          ::: { values := [Shirt.Breathe.NoNeed, Shirt.Breathe.AbleNeeded] }
          ::: { values := [Shirt.QuickDry.NotNeeded, Shirt.QuickDry.IsNeeded] }
          ::: { values := [Shirt.Mosquito.NoNeed, Shirt.Mosquito.ProofNeeded] }
          -- The shirt always needs to be durable
          ::: { values := [Shirt.Durable.IsNeeded] }
          ::: { values := [Shirt.Sun.NoNeed, Shirt.Sun.ProofNeeded] }
          -- The shirt style just so happens to be casual, though his interface doesn't require it
          ::: { values := [Shirt.Style.Casual]}
          ::: HNil
      }

    open PropertyHList in
    /-- Bukoski doesn't really pack a tie, but let's imagine he packs one in case
        he wants to cold-approach a trail-cutie. -/
    def tie : Item.T (shirtPropTypes) :=
      { name := "Hypothetical Tie"
      , massG := 0
      , properties :=
          /- HLists are type-indexed to ensure decidability of
             element comparisons (type-equality is undecidable),
             so we need to provide a value for each type-index. I
             don't really know what I'm talking about btw, so
             if you know a way to do HList comparison without checking
             for type-equality at compile time and without increasing
             the proof-burden at call-location, please let me know!
          -/
          PHNil ::: PHNil ::: PHNil ::: PHNil ::: PHNil ::: PHNil ::: PHNil ::: PHNil
          ::: { values := [Shirt.Style.Formal] }
          ::: HNil
      }

  /-- We'll think of the shirt and tie as being a part of the same module since they are a package deal --/
  def shirtModule : List (Item.T
    shirtPropTypes)
    := [shirt, tie]

  open Narrow in
  def shirtModuleInterface : Expedition.T
    (actualItems := shirtModule)
    :=
    { name := "Bukoski Ideal Shirt"
    , expectedProperties :=
          [.mk Shirt.Insulation.Needed (by nrrw)]
      ::: [.mk Shirt.Wind.ResistNeeded (by nrrw)]
      ::: [.mk Shirt.Vent.AbleNeeded (by nrrw)]
      ::: [.mk Shirt.Breathe.AbleNeeded (by nrrw)]
      ::: [.mk Shirt.QuickDry.IsNeeded (by nrrw)]
      ::: [.mk Shirt.Mosquito.ProofNeeded (by nrrw)]
      ::: [.mk Shirt.Durable.IsNeeded (by nrrw)]
      ::: [.mk Shirt.Sun.ProofNeeded (by nrrw)]
      /- Check that he's prepared to meet a trail-cutie.
        We're not requiring `Style.Casual` in the interface because there
        is no such thing as over-dressed in the backcountry. -/
      ::: [.mk Shirt.Style.Formal (by nrrw)]
      ::: HNil
    , maxExpectedMassG := 42 -- TODO: find an actually reasonable minimum weight
    , has_valid_mass := by
        simp [ shirtModule,
              Item.unionList,
              Item.union,
              Item.empty,
              shirt , tie
              ];
    }

  /- TODO: maybe I should rename "Expedition" to be "ItemCollectionModule" or something.
  -- TODO: maybe I should add the ability to union `Expedition.T`s so that you can have
  -- check modules by weight and narrowed properties and then union them together and check the whole setup.
  -/

  end Shirt

end Core
