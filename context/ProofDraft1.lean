-- Define the Dimensions module
namespace Dimensions

  def Range (α : Type) := α × α  -- Min, Max

-- def rValue := Float



end Dimensions

-- Define the Item module
namespace Item

  open Dimensions

  -- def Cents := Int

  namespace Product

    structure SpecificR where
      brand : String
      model : String
      url   : Option String
      mass  : Int
      cost  : Int

    structure GenericR where
      description : String
      mass        : Int
      cost        : Int

    inductive T
    | Specific : SpecificR → T
    | Generic  : GenericR → T

  end Product

  namespace Ownership

    inductive InventoryS
    | Count : Int → InventoryS
    | Grams : InventoryS

    inductive OnDemandS
    | Recurring
    | AdHoc

    inductive ActivityS
    | Active
    | Retired

    inductive StatusS
    | ToBuy
    | MaybeBuy
    | OnDemand : OnDemandS → StatusS
    | Owned    : ActivityS → InventoryS → StatusS

  end Ownership

  inductive ConditionS
    | FullyOperational
    | ImpairedOperational : List String → ConditionS
    | NotOperational      : List String → ConditionS

  structure T where
    ownershipStatus : Ownership.StatusS
    product         : Product.T
    condition       : Option ConditionS := none
    rValue          : Option Float := none
    isUL            : Option Bool := none

  end Item

  namespace Item

  @[simp, reducible]
  def getMass (item : Item.T) : Int :=
    match item.product with
    | Product.T.Specific s => s.mass
    | Product.T.Generic g  => g.mass
end Item


open Item

-- Define specific items
def inflatableSleepingPad : Item.T :=
  {
    ownershipStatus := Ownership.StatusS.Owned Ownership.ActivityS.Active (Ownership.InventoryS.Count 1),
    product := Product.T.Specific {
      brand := "Therm-a-Rest",
      model := "NeoAir XLite",
      url   := some "https://www.example.com/inflatableSleepingPad",
      mass  := 340,
      cost  := 19999
    },
    rValue := some 4.2,
    isUL   := some true
  }

def ultralightQuilt : Item.T :=
  {
    ownershipStatus := Ownership.StatusS.Owned Ownership.ActivityS.Active (Ownership.InventoryS.Count 1),
    product := Product.T.Specific {
      brand := "Enlightened Equipment",
      model := "Revelation Quilt",
      url   := some "https://www.example.com/ultralightQuilt",
      mass  := 620,
      cost  := 25000
    }
  }

def groundTarp : Item.T :=
  {
    ownershipStatus := Ownership.StatusS.Owned Ownership.ActivityS.Active (Ownership.InventoryS.Count 1),
    product := Product.T.Specific {
      brand := "Generic",
      model := "Ground Tarp",
      url   := none,
      mass  :=  300,
      cost  := 1500
    }
  }

def tent : Item.T :=
  {
    ownershipStatus := Ownership.StatusS.Owned Ownership.ActivityS.Active (Ownership.InventoryS.Count 1),
    product := Product.T.Specific {
      brand := "Big Agnes",
      model := "Copper Spur HV UL2",
      url   := some "https://www.example.com/tent",
      mass  :=  1400,
      cost  := 45000
    }
  }

def merinoWoolBaseLayer : Item.T :=
  {
    ownershipStatus := Ownership.StatusS.Owned Ownership.ActivityS.Active (Ownership.InventoryS.Count 1),
    product := Product.T.Specific {
      brand := "Icebreaker",
      model := "Merino Wool Base Layer",
      url   := some "https://www.example.com/merinoWoolBaseLayer",
      mass  :=  200,
      cost  := 10000
    }
  }

def warmJacket : Item.T :=
  {
    ownershipStatus := Ownership.StatusS.Owned Ownership.ActivityS.Active (Ownership.InventoryS.Count 1),
    product := Product.T.Specific {
      brand := "Patagonia",
      model := "Down Sweater Jacket",
      url   := some "https://www.example.com/downJacket",
      mass  :=  370,
      cost  := 27900
    }
  }

def umbrella : Item.T :=
  {
    ownershipStatus := Ownership.StatusS.Owned Ownership.ActivityS.Active (Ownership.InventoryS.Count 1),
    product := Product.T.Specific {
      brand := "Repel",
      model := "Trekking Umbrella",
      url   := some "https://www.example.com/umbrella",
      mass  :=  220,
      cost  := 3000
    }
  }

def windbreaker : Item.T :=
  {
    ownershipStatus := Ownership.StatusS.Owned Ownership.ActivityS.Active (Ownership.InventoryS.Count 1),
    product := Product.T.Specific {
      brand := "Arc'teryx",
      model := "Squamish Hoody",
      url   := some "https://www.example.com/windbreaker",
      mass  :=  155,
      cost  := 15900
    }
  }

def woobiePoncho : Item.T :=
  {
    ownershipStatus := Ownership.StatusS.Owned Ownership.ActivityS.Active (Ownership.InventoryS.Count 1),
    product := Product.T.Specific {
      brand := "USGI",
      model := "Woobie Poncho Liner",
      url   := some "https://www.example.com/woobiePoncho",
      mass  :=  900,
      cost  := 4000
    }
  }

def rainPoncho : Item.T :=
  {
    ownershipStatus := Ownership.StatusS.Owned Ownership.ActivityS.Active (Ownership.InventoryS.Count 1),
    product := Product.T.Specific {
      brand := "Generic",
      model := "Rain Poncho",
      url   := some "https://www.example.com/rainPoncho",
      mass  :=  300,
      cost  := 2500
    }
  }

def rainPonchoAndParacord : Item.T :=
  {
    ownershipStatus := Ownership.StatusS.Owned Ownership.ActivityS.Active (Ownership.InventoryS.Count 1),
    product := Product.T.Specific {
      brand := "Generic",
      model := "Rain Poncho and Paracord",
      url   := none,
      mass  :=  500,
      cost  := 3500
    }
  }

-- Define interfaces for each system
structure SleepSystem where
  groundInsulator  : Item.T
  bodyHeatRetainer : Item.T

structure ShelterSystem where
  groundInsulation : Item.T
  wall             : Item.T

structure ClothingSystem where
  baseLayer        : Item.T
  midLayer         : Item.T
  waterProtection  : Item.T
  windProtection   : Item.T




structure UnipurposeULItemLoadout extends SleepSystem, ShelterSystem, ClothingSystem where
  mass_wall_lt_1401 : Item.getMass wall < 1401

structure MultipurposeItemLoadout extends SleepSystem, ShelterSystem, ClothingSystem where
  mass_wall_lt_3500 : Item.getMass wall < 3500



def unipurposeULItemLoadout : UnipurposeULItemLoadout :=
  {
    groundInsulator  := inflatableSleepingPad,
    bodyHeatRetainer := ultralightQuilt,
    groundInsulation := groundTarp,
    wall             := tent,
    baseLayer        := merinoWoolBaseLayer,
    midLayer         := warmJacket,
    waterProtection  := umbrella,
    windProtection   := windbreaker,
    mass_wall_lt_1401 := by decide
  }

-- Example Solution B
def multipurposeItemLoadout : MultipurposeItemLoadout :=
  {
    groundInsulator  := inflatableSleepingPad,
    bodyHeatRetainer := woobiePoncho,
    groundInsulation := groundTarp,
    wall             := rainPonchoAndParacord,
    baseLayer        := merinoWoolBaseLayer,
    midLayer         := woobiePoncho,
    waterProtection  := rainPoncho,
    windProtection   := rainPoncho,
    mass_wall_lt_3500 := by decide
  }
