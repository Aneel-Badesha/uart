# Universal Asynchronous Receiver and Transmitter (UART)

A complete UART implementation in VHDL designed for FPGA deployment. This project implements both transmitter and receiver components with comprehensive testbenches for verification.

## Features

- **Full-duplex communication**: Separate transmitter and receiver modules
- **Configurable baud rate**: Default 1200 bps (configurable via clock divider)
- **8-bit data transmission**: Standard 8-bit data frames
- **Parity support**: Configurable parity bit generation and checking
- **Start/stop bit handling**: Standard UART framing
- **State machine implementation**: Robust finite state machine design
- **Clock domain management**: Proper clock divider for baud rate generation

## Architecture

### Components

- **[`receiver.vhd`](uart/receiver.vhd)**: UART receiver module with state machine (IDLE, T_START, T_DATA, T_STOP, T_DONE)
- **[`transmitter.vhd`](uart/transmitter.vhd)**: UART transmitter module for serial data output
- **[`UART.vhd`](uart/UART.vhd)**: Top-level UART module combining transmitter and receiver
- **[`transmitter_tb.vhd`](uart/transmitter_tb.vhd)**: Comprehensive testbench for transmitter verification

### Key Features from Implementation

- **Baud rate generation**: 50MHz system clock divided down to 1200 bps
- **Data buffering**: 8-bit data holding registers
- **Parity calculation**: Built-in parity bit generation and verification
- **Error detection**: Frame error detection and handling
- **Flow control**: Start signal generation for data ready indication

## Simulation & Testing

The project includes comprehensive testbenches verified using **ModelSim**:

- Transmitter functionality testing
- Timing verification at specified baud rates
- Data integrity verification
- Edge case testing

## FPGA Deployment

Designed for synthesis and deployment on FPGA platforms with:
- Standard IEEE libraries (`ieee.std_logic_1164`, `ieee.numeric_std`)
- Synthesizable VHDL constructs
- Configurable clock frequencies

## Getting Started

1. Load the VHDL files into your FPGA development environment
2. Run the testbenches in ModelSim to verify functionality
3. Synthesize the design for your target FPGA
4. Configure clock constraints for your desired baud rate

## Configuration

The UART can be configured by modifying:
- `clkcount`: Clock divider for baud rate (currently set for 1200 bps from 50MHz)
- Data width: Currently 8-bit, expandable
- Parity settings: Enable/disable parity checking
