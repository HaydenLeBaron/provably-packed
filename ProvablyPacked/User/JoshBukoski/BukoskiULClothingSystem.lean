import ProvablyPacked.Lib.Narrow
import ProvablyPacked.Lib.PropertiesHListComparator
import ProvablyPacked.Models.Expedition
import ProvablyPacked.Models.Item


-- Import Domains
import ProvablyPacked.User.JoshBukoski.Properties.Shared

/-!
  An implementation of Josh Bukoski's 3 Season Clothing System according to the
  notes in `@ProvablyPacked/User/JoshBukoski/README.md` (I recommend reading that first) -/
namespace Core

  namespace Shirt
    open Body


    def shirtPropTypes :=
      [
        /- FIXME: unexpected behavior: no matter what variant I put for Body, it doesn't change anything
          I was hoping to put `Body` here but as a workaroudn I will have to put a variant of `Body` instead -/
        Insulation Arms,
        Wind Torso,
        Vent Torso,
        Breathe Torso,
        QuickDry Torso,
        Mosquito Torso,
        Durable Torso,
        Sun Torso,
        Style 0
      ]

    def shirt : Item.T (shirtPropTypes) :=
      { name := "Bukoskis Actual Shirt"
      , massG := 42 -- TODO: find his actual shirt's weight
      , properties :=
              { values : List (Insulation Arms) := [.NoNeed Torso, .Needed Torso, .Needed Arms ]}
          -- The shirt is comfortable in either wind or no wind
          ::: { values := [Wind.NoNeed Torso, Wind.ResistNeeded Torso, Wind.NoNeed Arms, Wind.ResistNeeded Arms] }
          ::: { values := [Vent.NoNeed Torso, Vent.AbleNeeded Torso, Vent.NoNeed Arms, Vent.AbleNeeded Arms] }
          ::: { values := [Breathe.AbleNeeded Torso, Breathe.AbleNeeded Arms] }
          ::: { values := [QuickDry.NotNeeded Torso, QuickDry.IsNeeded Torso, QuickDry.NotNeeded Arms, QuickDry.IsNeeded Arms] }
          ::: { values := [Mosquito.NoNeed Torso, Mosquito.ProofNeeded Torso, Mosquito.NoNeed Arms, Mosquito.ProofNeeded Arms] }
          -- The shirt is persistently durable (except around the arms, which are made of a thinner fabric and are prone to getting snagged)
          ::: { values := [Durable.IsNeeded Torso, Durable.NotNeeded Arms] }
          ::: { values := [Sun.NoNeed Torso, Sun.ProofNeeded Torso, Sun.NoNeed Arms, Sun.ProofNeeded Arms] }
          -- The shirt style just so happens to be casual, though his interface doesn't require it
          ::: { values := [Style.Casual]}
          ::: HNil
      }

    open PropertyHList in
    /-- Bukoski doesn't really pack a tie, but let's imagine he packs one in case
        he wants to cold-approach a trail-cutie. -/
    def tie : Item.T (shirtPropTypes) :=
      { name := "Spiffy Tie"
      /- Worn weight doesn't count (RIGHT!?).
        Let's say he never takes it off so it always never counts. Yeah.
        (source: [UL-math](https://www.reddit.com/r/Ultralight/comments/195tjgh/how_much_does_worn_weight_matter/))
      -/
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
          PHNil
          ::: PHNil
          ::: PHNil ::: PHNil ::: PHNil ::: PHNil ::: PHNil ::: PHNil
          ::: { values := [ Style.Formal 11 ] }
          ::: HNil
      }

  /-- We'll think of the shirt and tie as being a part of the same module since they are a package deal --/
  def shirtModule : List (Item.T
    shirtPropTypes)
    := [shirt, tie]

  open Narrow Body in

  /-- If this type-checks then whatever was passed into it satisfies the interface
      described in the body --/
  def shirtModuleInterface : Expedition.T
    (actualItems := shirtModule)
    :=
    { name := "Bukoski Ideal Shirt"
    , expectedProperties :=
          [ .mk (Insulation.Needed Torso) (by nrrw)
          , .mk (.Needed Arms) (by nrrw) ]
      ::: [ .mk (Wind.ResistNeeded Torso) (by nrrw)
          , .mk (.ResistNeeded Arms) (by nrrw) ]
      ::: [ .mk (Vent.AbleNeeded Torso) (by nrrw)
          , .mk (.AbleNeeded Arms) (by nrrw) ]
      ::: [ .mk (Breathe.AbleNeeded Torso) (by nrrw)
          , .mk (.AbleNeeded Arms) (by nrrw) ]
      ::: [ .mk (QuickDry.IsNeeded Torso) (by nrrw)
          , .mk (.IsNeeded Arms) (by nrrw) ]
      ::: [ .mk (Mosquito.ProofNeeded Torso) (by nrrw)
          , .mk (.ProofNeeded Arms) (by nrrw) ]
      ::: [ .mk (Durable.IsNeeded Torso) (by nrrw) ]
      ::: [ .mk (Sun.ProofNeeded Torso) (by nrrw)
            , .mk (Sun.ProofNeeded Arms) (by nrrw) ]
      /- Check that he's turned the spiffiness up to (exactly) 11
        so he's prepared to meet a trail-cutie.
        We're not requiring `Style.Casual` in the interface because
        there's no such thing as over-dressed in the backcountry. -/
      ::: [ .mk (Style.Formal 11) (by nrrw) ]
      ::: HNil
    , maxExpectedMassG := 42 -- TODO: find an actually reasonable minimum weight

    /- Here we need to pass in all of the statically-known information necessary
       for Lean to do compile time addition and <= comparison of integers.
       TOOD: figure out a way to abstract some of this, maybe with a custom tactic -/
    , has_valid_mass := by
        simp [ shirtModule,
              Item.unionList,
              Item.union,
              Item.empty,
              shirt , tie
              ];
    }

  /- TODO: maybe I should rename "Expedition" to be "ItemModuleI" or something.
  -- TODO: maybe I should add the ability to union `Expedition.T`s so that you can have
  -- check modules by weight and narrowed properties and then union them together and check the whole setup.
  -/

  end Shirt

  -- TODO: implement the rest of his system according to the notes in `./User/JoshBukoski/README.md`

  namespace Pant
    open Body

    def pantPropTypes :=
      [
        Insulation Lower,
        Wind Lower,
        Vent Lower,
        Breathe Lower,
        QuickDry Lower,
        Mosquito Lower,
        Durable Lower,
        Sun Lower
      ]

    def sandFlyPants : Item.T (pantPropTypes) :=
      { name := "Ex Officio Sandfly Pants"
      , massG := 180 -- Typical weight for ultralight hiking pants
      , properties :=
              { values : List (Insulation Lower) := [.NoNeed Lower, .Needed Lower ]}
          -- Wind resistant when needed
          ::: { values := [Wind.NoNeed Lower, Wind.ResistNeeded Lower] }
          -- Ventable for temperature regulation
          ::: { values := [Vent.NoNeed Lower, Vent.AbleNeeded Lower] }
          -- Breathable fabric
          ::: { values := [Breathe.AbleNeeded Lower] }
          -- Quick-drying synthetic fabric
          ::: { values := [QuickDry.IsNeeded Lower] }
          -- Mosquito-proof tight weave
          ::: { values := [Mosquito.ProofNeeded Lower] }
          -- Durable construction for hiking
          ::: { values := [Durable.IsNeeded Lower] }
          -- Sun protection with UPF rating
          ::: { values := [Sun.ProofNeeded Lower] }
          ::: HNil
      }

    def pantModule : List (Item.T pantPropTypes) := [sandFlyPants]

    open Narrow Body in

    def pantModuleInterface : Expedition.T
      (actualItems := pantModule)
      :=
      { name := "Bukoski Ideal Pants"
      , expectedProperties :=
            [ .mk (Insulation.Needed Lower) (by nrrw) ]
        ::: [ .mk (Wind.ResistNeeded Lower) (by nrrw) ]
        ::: [ .mk (Vent.AbleNeeded Lower) (by nrrw) ]
        ::: [ .mk (Breathe.AbleNeeded Lower) (by nrrw) ]
        ::: [ .mk (QuickDry.IsNeeded Lower) (by nrrw) ]
        ::: [ .mk (Mosquito.ProofNeeded Lower) (by nrrw) ]
        ::: [ .mk (Durable.IsNeeded Lower) (by nrrw) ]
        ::: [ .mk (Sun.ProofNeeded Lower) (by nrrw) ]
        ::: HNil
      , maxExpectedMassG := 180
      , has_valid_mass := by
          simp [ pantModule,
                Item.unionList,
                Item.union,
                Item.empty,
                sandFlyPants
                ];
      }

  end Pant

  namespace Fleece
    open Body

    def fleecePropTypes :=
      [
        Insulation Torso,
        QuickDry Torso,
        Breathe Torso,
        Hydrophobic Torso,
        AiryAndLofty Torso
      ]

    def polarTechAlphaFleece : Item.T (fleecePropTypes) :=
      { name := "Polartech Alpha Direct Fleece"
      , massG := 200 -- Typical weight for ultralight fleece
      , properties :=
              { values : List (Insulation Torso) := [.Needed Torso]}
          -- Quick-drying synthetic insulation
          ::: { values := [QuickDry.IsNeeded Torso] }
          -- Breathable for active use
          ::: { values := [Breathe.AbleNeeded Torso] }
          -- Hydrophobic treatment
          ::: { values := [Hydrophobic.Yes Torso] }
          -- Airy and lofty construction
          ::: { values := [AiryAndLofty.Yes Torso] }
          ::: HNil
      }

    def fleeceModule : List (Item.T fleecePropTypes) := [polarTechAlphaFleece]

    open Narrow Body in

    def fleeceModuleInterface : Expedition.T
      (actualItems := fleeceModule)
      :=
      { name := "Bukoski Active Insulating Layer"
      , expectedProperties :=
            [ .mk (Insulation.Needed Torso) (by nrrw) ]
        ::: [ .mk (QuickDry.IsNeeded Torso) (by nrrw) ]
        ::: [ .mk (Breathe.AbleNeeded Torso) (by nrrw) ]
        ::: [ .mk (Hydrophobic.Yes Torso) (by nrrw) ]
        ::: [ .mk (AiryAndLofty.Yes Torso) (by nrrw) ]
        ::: HNil
      , maxExpectedMassG := 200
      , has_valid_mass := by
          simp [ fleeceModule,
                Item.unionList,
                Item.union,
                Item.empty,
                polarTechAlphaFleece
                ];
      }

  end Fleece

  namespace UpperShell
    open Body

    def upperShellPropTypes :=
      [
        Insulation Torso,
        Vent Torso,
        Waterproof Torso,
        Wind Torso,
        Oversized Torso
      ]

    def froggToggsJacket : Item.T (upperShellPropTypes) :=
      { name := "Frogg Toggs Ultra-Lite2 Jacket"
      , massG := 165 -- Typical weight for this jacket
      , properties :=
              { values : List (Insulation Torso) := [.Needed Torso]} -- Traps air for insulation
          -- Ventable with pit zips
          ::: { values := [Vent.AbleNeeded Torso] }
          -- Waterproof protection
          ::: { values := [Waterproof.Yes Torso] }
          -- Windproof shell
          ::: { values := [Wind.ProofNeeded Torso] }
          -- Oversized for layering
          ::: { values := [Oversized.Yes Torso] }
          ::: HNil
      }

    def upperShellModule : List (Item.T upperShellPropTypes) := [froggToggsJacket]

    open Narrow Body in

    def upperShellModuleInterface : Expedition.T
      (actualItems := upperShellModule)
      :=
      { name := "Bukoski Upper Shell"
      , expectedProperties :=
            [ .mk (Insulation.Needed Torso) (by nrrw) ]
        ::: [ .mk (Vent.AbleNeeded Torso) (by nrrw) ]
        ::: [ .mk (Waterproof.Yes Torso) (by nrrw) ]
        ::: [ .mk (Wind.ProofNeeded Torso) (by nrrw) ]
        ::: [ .mk (Oversized.Yes Torso) (by nrrw) ]
        ::: HNil
      , maxExpectedMassG := 165
      , has_valid_mass := by
          simp [ upperShellModule,
                Item.unionList,
                Item.union,
                Item.empty,
                froggToggsJacket
                ];
      }

  end UpperShell

  namespace LowerShell
    open Body

    def lowerShellPropTypes :=
      [
        Insulation Lower,
        Vent Lower,
        Waterproof Lower,
        Wind Lower,
        Oversized Lower,
        LooseFitting Lower
      ]

    def shellPants : Item.T (lowerShellPropTypes) :=
      { name := "Ultralight Shell Pants"
      , massG := 120 -- Typical weight for ultralight shell pants
      , properties :=
              { values : List (Insulation Lower) := [.Needed Lower]} -- Traps air for insulation
          -- Ventable with side zips
          ::: { values := [Vent.AbleNeeded Lower] }
          -- Waterproof protection
          ::: { values := [Waterproof.Yes Lower] }
          -- Windproof shell
          ::: { values := [Wind.ProofNeeded Lower] }
          -- Oversized for layering
          ::: { values := [Oversized.Yes Lower] }
          -- Loose fitting for comfort
          ::: { values := [LooseFitting.Yes Lower] }
          ::: HNil
      }

    def lowerShellModule : List (Item.T lowerShellPropTypes) := [shellPants]

    open Narrow Body in

    def lowerShellModuleInterface : Expedition.T
      (actualItems := lowerShellModule)
      :=
      { name := "Bukoski Lower Shell"
      , expectedProperties :=
            [ .mk (Insulation.Needed Lower) (by nrrw) ]
        ::: [ .mk (Vent.AbleNeeded Lower) (by nrrw) ]
        ::: [ .mk (Waterproof.Yes Lower) (by nrrw) ]
        ::: [ .mk (Wind.ProofNeeded Lower) (by nrrw) ]
        ::: [ .mk (Oversized.Yes Lower) (by nrrw) ]
        ::: [ .mk (LooseFitting.Yes Lower) (by nrrw) ]
        ::: HNil
      , maxExpectedMassG := 120
      , has_valid_mass := by
          simp [ lowerShellModule,
                Item.unionList,
                Item.union,
                Item.empty,
                shellPants
                ];
      }

  end LowerShell

  namespace Hat
    open Body

    def hatPropTypes :=
      [
        QuickDry Head,
        Sun Head
      ]

    def ultraLightHat : Item.T (hatPropTypes) :=
      { name := "Ultralight Sun Hat"
      , massG := 30 -- Typical weight for ultralight hat
      , properties :=
              { values : List (QuickDry Head) := [.IsNeeded Head]}
          -- Sun protection
          ::: { values := [Sun.ProofNeeded Head] }
          ::: HNil
      }

    def hatModule : List (Item.T hatPropTypes) := [ultraLightHat]

    open Narrow Body in

    def hatModuleInterface : Expedition.T
      (actualItems := hatModule)
      :=
      { name := "Bukoski Hat"
      , expectedProperties :=
            [ .mk (QuickDry.IsNeeded Head) (by nrrw) ]
        ::: [ .mk (Sun.ProofNeeded Head) (by nrrw) ]
        ::: HNil
      , maxExpectedMassG := 30
      , has_valid_mass := by
          simp [ hatModule,
                Item.unionList,
                Item.union,
                Item.empty,
                ultraLightHat
                ];
      }

  end Hat

  namespace Puffy
    open Body

    def puffyPropTypes :=
      [
        Insulation Torso,
        Compressible Torso
      ]

    def downJacket : Item.T (puffyPropTypes) :=
      { name := "Ultralight Down Puffy"
      , massG := 250 -- Typical weight for ultralight down jacket
      , properties :=
              { values : List (Insulation Torso) := [.Needed Torso]} -- High loft insulation
          -- Compressible for packing
          ::: { values := [Compressible.Yes Torso] }
          ::: HNil
      }

    def puffyModule : List (Item.T puffyPropTypes) := [downJacket]

    open Narrow Body in

    def puffyModuleInterface : Expedition.T
      (actualItems := puffyModule)
      :=
      { name := "Bukoski Puffy Insulation"
      , expectedProperties :=
            [ .mk (Insulation.Needed Torso) (by nrrw) ]
        ::: [ .mk (Compressible.Yes Torso) (by nrrw) ]
        ::: HNil
      , maxExpectedMassG := 250
      , has_valid_mass := by
          simp [ puffyModule,
                Item.unionList,
                Item.union,
                Item.empty,
                downJacket
                ];
      }

  end Puffy

end Core
