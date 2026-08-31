# UVM-Based Functional Verification of an APB Peripheral

## Overview
This repository contains a SystemVerilog implementation of an APB-compliant peripheral and a UVM-based verification environment used to functionally verify the peripheral. The design and verification were developed and simulated using Cadence Xcelium.

The goal of the project is to demonstrate a complete verification flow for an AMBA APB (Advanced Peripheral Bus) peripheral using industry-standard UVM methodology: reusable UVM agents, sequences, and a scoreboard-based functional checking approach.

## Key features
- APB-compliant peripheral (SystemVerilog RTL)
- UVM-based verification environment (drivers, agents, monitors, scoreboards, sequences, tests)
- Directed and constrained-random tests to exercise APB transactions
- Functional coverage and assertions to check protocol compliance
- Simulated with Cadence Xcelium

## Repository layout
(If any folder names below don't match the repo, I can update this section once you tell me the exact layout.)

- hw/ or rtl/           - APB peripheral RTL sources
- tb/                   - Top-level testbench files
- uvm/                  - UVM environment: agents, drivers, monitors, sequences, tests
- sim/                  - Simulation scripts and runfiles (xrun scripts, makefile helpers)
- docs/                 - Design and verification documentation

## Requirements
- Cadence Xcelium (xrun) — for compiling and running simulations
- A SystemVerilog/UVM-capable simulator and UVM library
- GNU Make (optional) or provided run scripts

## How to run (example)
Below is a typical example command to run a UVM test with Cadence Xcelium. Adjust paths and test names to match this repository's testbench names.

xrun -sv -f filelist.f +UVM_TESTNAME=<test_name> +UVM_VERBOSITY=UVM_HIGH

Common steps:
1. Edit or generate a filelist that lists RTL and TB/UV files (filelist.f or similar).
2. Choose a test name (a test class implemented in the uvm/tests directory) and pass it via +UVM_TESTNAME.
3. Run the simulation and inspect transcript/log files and coverage reports.

If you want, I can add an example filelist.f, a run script (run.sh), or concrete xrun arguments tailored to the repository layout.

## Verification environment
The UVM environment typically contains the following components:

- Interface: APB interface definition (SystemVerilog interface)
- Driver: drives APB transactions to the DUT
- Monitor: observes the DUT interface and sends transactions to the scoreboard
- Agent: wraps the driver and monitor and provides configuration
- Sequences: directed and constrained-random sequences to generate APB transactions
- Scoreboard: functional checking, compares expected results with DUT behavior
- Environment (env): top-level UVM environment that instantiates agents and scoreboard

Assertions and functional coverage points are used to ensure protocol compliance and to measure verification completeness.

## Coverage and checking
- Functional coverage (covergroups / coverpoints) to track stimulus and DUT behavior
- Assertions (SVA or inline SystemVerilog assertions) to catch protocol violations early
- Scoreboard for transaction-level checking and comparison with a reference model

## Contributing / Extending
- Add new sequences to increase protocol corner-case coverage
- Add more directed tests for specific scenarios
- Integrate with a CI flow or coverage collection toolchain

## License
Specify a license for the repository (MIT, Apache-2.0, etc.). If you'd like, I can add a LICENSE file.

## Contact
For questions or updates, open an issue or contact the repo owner.

---

If you'd like, I can now:
- Update the README with exact folder names and example commands if you want me to inspect the repo layout,
- Add a run script (run.sh) that calls xrun with sensible defaults, or
- Add a filelist.f example generated from the repository structure.

Tell me which of these you want next and I'll update the repo accordingly.