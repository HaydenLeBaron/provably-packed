

namespace CampingTrip

  structure T where
    name : String
    highTempC : Nat
    lowTempC : Nat
    willRain : Bool

end CampingTrip




namespace Item

  inductive WaterAbility
  | Waterproof
  | WaterResistant

  structure T where
    name : String
    groundInsulateRValue : Option Nat := none
    wearableAsOuterLayer : Bool := false
    waterAbility : Option WaterAbility := none
    pitchableAsOuterShelter : Bool := false

end Item


namespace SleepSystem

  structure T where
    name : String



end SleepSystem


-- Sleeping Pads

namespace ParticularItems


  namespace SingleFunction

    ---- Sleeping Pads

    def loRPad: Item.T := {
      name := "Inflatable Sleeping Pad",
      groundInsulateRValue := some 1,
    }

    def medRPad: Item.T := {
      name := "Inflatable Sleeping Pad",
      groundInsulateRValue := some 3,
    }

    def hiRPad: Item.T := {
      name := "Inflatable Sleeping Pad",
      groundInsulateRValue := some 5
    }

    ---- Shelter

    def tent : Item.T := {
      name := "Tent",
      waterAbility := Item.WaterAbility.Waterproof,
      pitchableAsOuterShelter := true
    }

    def fairWeatherBivy : Item.T := {
      name := "Fair Weather Bivy",
      waterAbility := Item.WaterAbility.WaterResistant,
      pitchableAsOuterShelter := true,
    }


  end SingleFunction

  namespace Multifunction

    def emergencyPoncho : Item.T := {
      name := "Emergency Poncho",
      waterAbility := Item.WaterAbility.Waterproof,
      wearableAsOuterLayer := true,
    }

    def ponchoShelter : Item.T := {
      name := "Poncho Shelter",
      wearableAsOuterLayer := true,
      waterAbility := Item.WaterAbility.Waterproof,
      pitchableAsOuterShelter := true
    }

  end Multifunction






end ParticularItems
