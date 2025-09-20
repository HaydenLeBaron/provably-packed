# Implementation Plan


## Goal

Given:

1) a list of gear
2) a expedition description

Prove that:

you are prepared or unprepared for the trip


## Models

```reasonml

module PropertiesHListComparator {
    type t = {
        name: string,
        durationDays: int,
        totalKm: int,
        hiTempAwake: int,
        loTempAwake: int,
        loTempSleep: int,
    };
};
```
