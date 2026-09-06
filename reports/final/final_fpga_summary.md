# Final FPGA Evidence Summary

Target board: Tang Nano 9K
Constraint file: fpga/tangnano9k.cst
Bitstream: opent.fs
Synthesis JSON: opent.json
Place-and-route JSON: opent_pnr.json

## Resource Counts from opent_pnr.json

| Resource group | Count |
|---|---:|
| LUT group | 4703 |
| DFF group | 843 |
| RAM16SDP4 | 168 |
| MULT9X9 | 16 |
| IO | 4 |

## Evidence Hashes

opent.fs:
5fa8bc17caee12f05e0ae430eb3894a369f49e54698d846a23b96ca6232afc20

opent.json:
4b310bd00aa0b0ce87322b9ef05254a2defd04bf53856357afb491d69096efd6

opent_pnr.json:
1ecfaca31c32955a314ca57c5dde7483ef62e9d0332124aff486b233627d77c0

fpga/tangnano9k.cst:
38e824ff8c2172962d36c91da273be64b9b28d8f25962f2409494ee778240830

## Notes

The design uses a 4x4 physical systolic array with 16 processing elements and 16 MULT9X9 blocks.

The larger 16x16 matrix multiplication is performed through tiling/reuse of the 4x4 array.
