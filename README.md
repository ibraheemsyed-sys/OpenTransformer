# OpenTransformer

A personal hardware design project exploring how transformer-based machine learning workloads can be mapped into digital hardware using SystemVerilog.

## Motivation

I started OpenTransformer to better understand the connection between machine learning algorithms and the hardware that executes them. My goal is to learn computer architecture and hardware acceleration by building digital components step by step, starting from basic logic and gradually moving toward more complex hardware systems.

This project focuses on understanding how data moves through hardware, how designs are verified, and the architectural decisions involved in building efficient computing systems.

## Current Progress

This project is being developed incrementally, starting from basic digital logic and moving toward more complex hardware systems. Progress updates, implementation details, debugging notes, and simulation results are documented in the [Development Log](notes/daily_log.md).

## Tools Used

- **Hardware Description Language:** SystemVerilog
- **Simulation & Linting:** Verilator
- **Waveform Analysis:** WaveTrace (VS Code Extension)
- **Build System:** GNU Make
- **Development Environment:** Linux (WSL2/Codespaces)

## Repository Structure

```text
.
├── rtl/
│   ├── alu_pkg.sv        # Shared ALU operation definitions
│   ├── alu_8bit.sv       # 8-bit combinational ALU module
│   └── and_gate.sv       # Initial toolchain verification module
│
├── tb/
│   ├── tb_alu_8bit.sv    # ALU verification testbench
│   └── tb_and_gate.sv    # AND gate verification testbench
│
├── sim/
│   └── Makefile          # Simulation build commands
│
├── notes/
│   └── daily_log.md      # Development notes and troubleshooting
│
└── README.md
```

## Development Roadmap

OpenTransformer is being developed incrementally, starting with fundamental digital logic and gradually moving toward more advanced hardware architectures used in machine learning accelerators.

Planned development areas include:

### SystemVerilog & Verification Foundations
- Build stronger SystemVerilog design practices
- Explore sequential logic, registers, and state machines
- Learn interfaces, modports, clocking blocks, and structured testbench design
- Develop more advanced verification environments

### Hardware Design Components
- Implement reusable hardware blocks such as:
  - FIFOs and memory structures
  - Communication interfaces
  - Control logic and finite state machines
  - Arithmetic datapath components

### Machine Learning Accelerator Exploration
- Design fixed-point arithmetic units for ML workloads
- Explore multiply-accumulate (MAC) structures
- Study matrix computation architectures
- Investigate systolic array designs and matrix tiling approaches used in neural network accelerators

### Hardware Implementation
- Learn ASIC synthesis concepts using tools such as Yosys
- Explore hardware optimization and netlist generation
- Experiment with FPGA synthesis and deployment using the Tang Nano 9K (GW1NR-9)

### Verification & Documentation
- Build Python-based verification tools
- Create reproducible simulation workflows
- Document design decisions, benchmarks, and experiments

## Long-Term Goals

The long-term goal of OpenTransformer is to develop a deeper understanding of how machine learning workloads are transformed into efficient hardware implementations.

Through this project, I aim to explore:

- Computer architecture
- Digital design and verification
- Hardware/software co-design
- FPGA-based acceleration
- Efficient computing systems for machine learning

The focus is on learning through implementation: designing, testing, debugging, and improving hardware components while gradually moving toward larger accelerator architectures.
