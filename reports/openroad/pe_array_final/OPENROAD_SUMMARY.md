# OpenTransformer OpenROAD Physical Design Summary

## Design

- Design: `pe_array_4x4`
- Platform: Nangate45
- Flow: OpenROAD-flow-scripts Docker
- Clock target: 10 ns
- Scope: 4x4 physical systolic array compute core

This result is for the 4x4 PE-array core, not the full `matmul_16x16` top-level design.

## Completed OpenROAD Stages

The 4x4 PE-array core completed:

- RTL synthesis
- Floorplanning
- Tapcell / PDN
- Global placement
- Detailed placement
- Clock tree synthesis
- Global routing
- Detailed routing
- Filler insertion
- RC extraction
- Final report
- GDS generation

## Final Physical Results

| Metric | Result |
|---|---:|
| Final design area | 14,764 um^2 |
| Final utilization | 31% |
| Clock target | 10 ns |
| Reported clock period after global route | 1.149 ns |
| Reported slack after global route | 8.790 ns |
| Detail route violations | 0 |
| Antenna net violations | 0 |
| Antenna pin violations | 0 |
| Total routed wire length | 113,082 um |
| Total vias | 52,211 |

## Manual CTS Timing Check

| Metric | Result |
|---|---:|
| Manual CTS design area | 14,762 um^2 |
| Manual CTS utilization | 31% |
| Worst max slack | 8.82 ns |
| Worst min slack | 0.12 ns |
| TNS max | 0.00 |
| TNS min | 0.00 |

## Clock Tree

| Metric | Result |
|---|---:|
| Original clock sinks | 704 |
| Clustered sinks | 129 |
| Created clock buffers | 146 |
| Created clock nets | 146 |
| Max clock tree level | 4 |

## IR / Power Report

| Metric | VDD | VSS |
|---|---:|---:|
| Total power | 6.48e-03 W | 6.48e-03 W |
| Worstcase IR drop | 1.83e-03 V | 2.92e-03 V |
| Percentage drop | 0.17% | 0.27% |

## Cell Type Report

| Cell Type | Count | Area |
|---|---:|---:|
| Fill cell | 12,843 | 32,998.36 |
| Tap cell | 391 | 104.01 |
| Clock buffer | 200 | 239.93 |
| Timing repair buffer | 617 | 517.37 |
| Inverter | 290 | 154.81 |
| Clock inverter | 61 | 41.23 |
| Sequential cell | 704 | 3,745.28 |
| Multi-input combinational cell | 5,639 | 9,960.90 |
| Total | 20,745 | 47,761.90 |

## Important Note

The full `matmul_16x16` top-level OpenROAD run reached CTS but did not complete because the OpenROAD Docker run ended with an illegal-instruction crash. Therefore, the paper should report the full top-level OpenROAD result as partial only.

The completed routed/GDS OpenROAD result is for the 4x4 PE-array compute core.
