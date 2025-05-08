# 4-bit RPN Calculator
*Author: Phạm Lê Ngọc Sơn*  
*EE4449 - HCMUT*

## Project Overview

This project implements a 4-bit Reverse Polish Notation (RPN) Calculator using SystemVerilog on an Altera DE10 board. The calculator supports basic arithmetic operations (addition and subtraction) and provides an interface through the onboard switches and buttons.

### What is RPN?

Reverse Polish Notation (also known as postfix notation) is a mathematical notation where every operator follows all its operands. For example, the expression `3 + 4` in infix notation is written as `3 4 +` in RPN. RPN has the advantage of not requiring parentheses to define operation precedence.

### Calculator Features

- Input numbers (0-9) and operators (+, -)
- Display input and calculation results on the 7-segment display
- Support for multi-digit numbers (up to 2 digits)
- Visual indicators for result display and input errors

## Project Structure

The project consists of several SystemVerilog modules that work together:

- **ChipInterface.sv**: Top-level module that interfaces with the DE10 board hardware
- **rpn_calculator.sv**: Main calculator logic module
- **stack.sv**: Implements a stack data structure for RPN operations
- **control_unit.sv**: Controls the calculator operation flow and input processing
- **alu.sv**: Arithmetic Logic Unit for performing calculations
- **register.sv**: Storage for operands and operators
- **reg_start.sv**: Register to control calculation start
- **bcdtohex.sv**: Binary Coded Decimal to 7-segment display conversion
- **mux_sel.sv**: Multiplexer for selecting display output
- **clock_divider.sv**: Divides the system clock to a usable frequency
- **tb.sv**: Testbench for simulation

## How to Use

### Hardware Requirements
- Altera DE10 FPGA Board

### Input Interface
- **KEY0**: Reset/Clear - Clears all inputs and resets the calculator
- **KEY1**: Input - Press to confirm the current switch configuration as input
- **SW0-SW3**: 4-bit input switches used to specify numbers and operations

### Input Mapping
| Binary  | Value | Binary  | Value | Binary  | Value | Binary  | Value |
|---------|-------|---------|-------|---------|-------|---------|-------|
| 0000    | 0     | 0100    | 4     | 1000    | 8     | 1100    | NULL  |
| 0001    | 1     | 0101    | 5     | 1001    | 9     | 1101    | NULL  |
| 0010    | 2     | 0110    | 6     | 1010    | "+"   | 1110    | "="   |
| 0011    | 3     | 0111    | 7     | 1011    | "-"   | 1111    | NULL  |

### Output Interface
- **HEX0-HEX5**: 7-segment displays showing input numbers and calculation results
- **LEDR0**: Lights up when displaying the result
- **LEDR1**: Lights up when invalid input is detected

### Example Calculation
To calculate 99 + 102 = 201:
1. SW[3:0] = 1001 (9) and press KEY1 → Display: 9
2. SW[3:0] = 1001 (9) and press KEY1 → Display: 99
3. SW[3:0] = 1010 (+) and press KEY1 → Display: 99
4. SW[3:0] = 0001 (1) and press KEY1 → Display: 1
5. SW[3:0] = 0000 (0) and press KEY1 → Display: 10
6. SW[3:0] = 0010 (2) and press KEY1 → Display: 102
7. SW[3:0] = 1110 (=) and press KEY1 → Display: 201

## Implementation Details

### RPN Calculation Process
1. The calculator employs a stack-based architecture to process RPN expressions
2. Numbers are pushed onto the stack as they are entered
3. When an operator is encountered, the necessary operands are popped from the stack
4. The calculation is performed, and the result is pushed back onto the stack
5. The final result is displayed when "=" is pressed

### Limitations
- Maximum of 2 operations and 3 numbers per calculation
- Input numbers limited to 2 digits
- Result cannot be negative
- Only supports addition and subtraction operations

## Building and Testing

1. Open the project in Quartus Prime
2. Compile the project
3. Program the Altera DE10 FPGA board
4. Use the switches and buttons as described above to operate the calculator

To test without hardware:
1. Run the testbench file (tb.sv) using ModelSim or Questa
2. The simulation will verify the calculator's core functionality

## Future Improvements

Potential enhancements for this project:
- Support for multiplication and division operations
- Handling of negative numbers
- Adding more digits of precision
- Implementing parentheses for complex expressions
- Adding floating-point capabilities
