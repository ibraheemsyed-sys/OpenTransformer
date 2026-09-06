# OpenTransformer

OpenTransformer is an independent hardware design project exploring how matrix-multiply workloads used in machine learning can be mapped into digital hardware.

The current milestone is a **4x4 physical systolic array** built in SystemVerilog. The 4x4 array is reused through a tile controller to perform a larger **16x16 matrix multiplication** workload.

Important distinction: this is **not** a physical 16x16 array. It is a 4x4 hardware array that executes a 16x16 matrix multiply through tiling and reuse.

## Final Status

| Area | Status |
|---|---|
| 4x4 systolic array RTL | Complete |
| 16x16 tiled matrix multiply | Passing simulation |
| Verilator lint | Passing, no warnings/errors in final lint log |
| Yosys synthesis | Passing |
| Tang Nano 9K FPGA artifact | Generated |
| Final evidence bundle | Saved in `reports/final/` |

## Architecture Summary

The design is built from small hardware blocks:

- `mac.sv` — multiply-accumulate unit
- `pe.sv` — processing element built around the MAC
- `pe_array_4x4.sv` — physical 4x4 systolic array with 16 PEs
- `tile_controller.sv` — controller for tiled execution
- `matmul_16x16.sv` — top-level 16x16 tiled matrix multiply design
- `fpga_top.sv` — FPGA-facing wrapper

Data moves through the 4x4 array in a systolic pattern. Instead of building 256 physical processing elements for a full 16x16 array, the design reuses 16 processing elements across multiple tiles.

## Verification

The final 16x16 matrix multiplication test was run with Verilator.

Final result:

| Test | Result |
|---|---|
| 16x16 matrix multiply | PASS |
| Output checks | 256/256 correct |

The final simulation log is saved here:

- `reports/final/final_sim_16x16.log`

## Lint and Synthesis

Final lint was run with Verilator.

- `reports/final/final_lint.log`

Final synthesis was run with Yosys.

- `reports/final/final_yosys_synth.log`

Yosys successfully synthesized the hierarchy:

- `matmul_16x16`
  - `pe_array_4x4`
    - 16 processing elements
      - MAC units
  - `tile_controller`

Final Yosys design hierarchy statistics:

| Metric | Value |
|---|---:|
| Wires | 5,983 |
| Wire bits | 58,258 |
| Public wires | 1,169 |
| Public wire bits | 16,341 |
| Memories | 0 |
| Memory bits | 0 |
| Processes | 0 |
| Cells | 38,170 |

Yosys reported array-to-register conversion warnings for internal unpacked bus structures in the 4x4 array. These warnings do not indicate a functional failure.

## FPGA Evidence

FPGA artifacts were generated for the Tang Nano 9K.

Final FPGA evidence is saved in:

- `reports/final/final_fpga_summary.md`
- `reports/final/opent_final.fs`
- `reports/final/opent_synth_final.json`
- `reports/final/opent_pnr_final.json`
- `reports/final/tangnano9k_final.cst`

Resource counts extracted from `opent_pnr.json`:

| Resource group | Count |
|---|---:|
| LUT group | 4,703 |
| DFF group | 843 |
| RAM16SDP4 | 168 |
| MULT9X9 | 16 |
| IO | 4 |

The 16 `MULT9X9` blocks match the 16 processing elements in the 4x4 physical systolic array.

## Repository Structure

    rtl/
      mac.sv
      pe.sv
      pe_array_4x4.sv
      tile_controller.sv
      matmul_16x16.sv
      fpga_top.sv
      alu_8bit.sv
      reg_file.sv
      mmu_fsm.sv

    tb/
      tb_mac.sv
      tb_pe.sv
      tb_pe_array_4x4.sv
      tb_matmul_16x16.sv

    sim/
      Makefile

    fpga/
      tangnano9k.cst

    reports/final/
      final_sim_16x16.log
      final_lint.log
      final_yosys_synth.log
      final_fpga_summary.md
      opent_final.fs
      opent_synth_final.json
      opent_pnr_final.json
      tangnano9k_final.cst

    notes/
      daily_log.md

## Tools Used

- SystemVerilog
- Verilator
- Yosys
- Tang Nano 9K FPGA flow
- GTKWave / WaveTrace
- GNU Make
- Linux / Codespaces

## Project Goal

The goal of OpenTransformer is to learn hardware acceleration by building real digital systems step by step.

This project started from basic digital logic and grew into a tiled matrix-multiply accelerator. The focus is not just writing RTL, but verifying it, synthesizing it, testing it on FPGA, and documenting the engineering evidence clearly.

## Current Milestone

OpenTransformer has reached a working hardware-accelerator milestone:

A 4x4 physical systolic array with 16 processing elements successfully performs a 16x16 matrix multiplication workload through tiling and reuse.
