# 8-Bit Posit Arithmetic Based FIR Filter

## Project Overview

This project presents the design and verification of a **4-tap Finite Impulse Response (FIR) filter using 8-bit Posit arithmetic**, implemented using Verilog HDL.

The project explores the use of Posit number representation as an alternative to conventional floating-point arithmetic in digital signal processing applications.

The design consists of custom Posit arithmetic modules, including Posit encoding, decoding, addition and multiplication, integrated into a four-tap FIR filter architecture.

## Objectives

- Design a four-tap FIR filter using Verilog HDL.
- Implement 8-bit Posit arithmetic operations.
- Develop custom Posit addition and multiplication modules.
- Integrate arithmetic modules into the FIR filter architecture.
- Verify functionality using Verilog testbenches.
- Perform RTL synthesis using Yosys.

## FIR Filter Architecture

A Finite Impulse Response filter generates its output using the current input sample and a finite number of previous input samples.

The general FIR equation is:

\[
y[n] = \sum_{k=0}^{N-1} h[k]x[n-k]
\]

For this project, a four-tap FIR filter is implemented with the coefficients:

**h = [1, 2, 2, 1]**

The output is calculated as:

\[
y[n] = x[n] + 2x[n-1] + 2x[n-2] + x[n-3]
\]

The filter uses delay registers, Posit multipliers and Posit adders to generate the output.

## Posit Arithmetic Implementation

The design includes the following arithmetic modules:

- **Posit Decoder:** Converts an 8-bit Posit representation into an internal numerical representation.
- **Posit Encoder:** Converts the internal result back into an 8-bit Posit representation.
- **Posit Adder:** Performs addition using the decoded values and re-encodes the result.
- **Posit Multiplier:** Performs multiplication using the decoded values and re-encodes the product.

## Tools and Technologies

| Tool | Purpose |
|---|---|
| Verilog HDL | RTL design |
| Icarus Verilog | Simulation and verification |
| GTKWave | Waveform analysis |
| Yosys | RTL synthesis |
| Git and GitHub | Version control |

## Verification

The design includes multiple testbenches to evaluate its functionality:

- Main testbench for FIR filter operation.
- Exhaustive testbench for arithmetic verification.
- Random testbench for testing different input combinations.
- Reset testbench for checking reset functionality.

Simulation waveforms and verification results will be documented in the results directory.

## Synthesis

Yosys is used to synthesize the Verilog RTL design and generate a synthesized netlist.

The synthesis results can be used to study the hardware structure and implementation characteristics of the design.

## Repository Structure

```text
Posit8-FIR-Filter/
├── src/
├── testbench/
├── synthesis/
├── results/
├── docs/
├── README.md
└── .gitignore
```

## Future Improvements

- Compare Posit arithmetic with fixed-point and floating-point implementations.
- Evaluate area, timing and power characteristics.
- Explore optimized Posit arithmetic architectures.
- Investigate FPGA implementation.

## Author

**Vibha Joshi**

Electronics and Communication Engineering

GitHub: [vibha2007](https://github.com/vibha2007)
