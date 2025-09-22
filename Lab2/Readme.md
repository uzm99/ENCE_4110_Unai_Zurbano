![FPGA](https://img.shields.io/badge/FPGA-DE10--Lite-blue)
![Language](https://img.shields.io/badge/Language-Verilog-green)
![Simulator](https://img.shields.io/badge/Tool-Logisim-orange)
# Lab 2 — Numbers and Displays (FPGA DE10-Lite)

This repository documents the second FPGA lab using the DE10-Lite (MAX 10 10M50DAF484C7G).  
The goal is to design combinational circuits that can perform binary-to-decimal number conversion and binary-coded-decimal (BCD) addition.

<!-- Table of content -->
<nav>
  <h1>Table of Contents</h2>
  <ul>
    <li><a href="#Part I">Part I</a></li>
    <li><a href="#Part II">Part II</a></li>
    <li><a href="#Part III">Part III</a></li>
    <li><a href="#Part IV">Part IV</a></li>
    <li><a href="#Part V">Part V</a></li>
    <li><a href="#Part VI">Part VI</a></li>
    <li><a href="#Part VII">(extra) Part VII</a></li>
  </ul>
</nav>


<!-- Sections -->
<h2 id="Part I">Part I — Display 4-bit values from switches [0..9]</h2>  

### Objective
Display the value from the switches in binary from 0–9. Inputs from 1010 to 1111 are treated as ‘don’t care’ conditions.


### Logic / Design
A module is created as a 7 segment decoder to display the digits 0 to 9. With a 4-bit input the digits displayed correspond to the input in binary.

Figure 1.1 — 7-segment decoder Design

<img src="IMG/Part_I_7seg_dec_Design.gif" width="600">

To define the logic, a Look Up Table (LUT) is needed. The 7-segment display is active low: segments turn on with 0 and off with 1.

Figure 1.2 — 7-segment LUT

| Input (i_m[3..0]) | Output (o_seg[7..0]) | Note |
|-------------------|----------------------|------|
| 0000              | 11000000             | 0    |
| 0001              | 11111001             | 1    |
| 0010              | 10100100             | 2    |
| 0011              | 10110000             | 3    |
| 0100              | 10011001             | 4    |
| 0101              | 10010010             | 5    |
| 0110              | 10000010             | 6    |
| 0111              | 11111000             | 7    |
| 1000              | 10000000             | 8    |
| 1001              | 10010000             | 9    |
| 1010              | 1-------             | -    |
| 1011              | 1-------             | -    |
| 1100              | 1-------             | -    |
| 1101              | 1-------             | -    |
| 1110              | 1-------             | -    |
| 1111              | 1-------             | -    |


### Implementation

*Figure 1.3 — 7-segment decoder Implementation*

<img src="IMG/Part_I_seg7_dec_logic.png" width="800">

*Figure 1.4 — Main block Implementation*

<img src="IMG/Part_I_main_logic.png" width="300">


### Demonstration

*Figure 1.5 — 7-segment decoder Demonstration*

<img src="IMG/Part_I_Demonstration.gif" width="500">



<h2 id="Part II">Part II — Display 4-bit values from switches [0..15]</h2>  

### Objective
Display values from the switches (0–15). The circuit uses a combination of two 7-segment displays to show two-digit numbers.


### Logic / Design
Using the module 7-segment decoder of the previous part a comparison needs to be made to extract an auxiliary signal to activate the second display for the values highers that 9. 

Figure 2.1 — Comparison module LUT

| Input (i_v[3..0]) | Output (o_z) |
|-------------------|--------------|
| 0000              | 0            |
| 0001              | 0            |
| 0010              | 0            |
| 0011              | 0            |
| 0100              | 0            |
| 0101              | 0            |
| 0110              | 0            |
| 0111              | 0            |
| 1000              | 0            |
| 1001              | 0            |
| 1010              | 1            |
| 1011              | 1            |
| 1100              | 1            |
| 1101              | 1            |
| 1110              | 1            |
| 1111              | 1            |

In parallel with the comparator, a block named Circuit A converts the binary input to determine the first digit of the decimal number. For example, when the input is 10, Circuit A outputs 0 for the first display. Similarly, 11→1, 12→2, etc..

Figure 2.2 — Circuit A module LUT

| Input (i_v[3..0]) | Output (o_a[3..0]) |
|-------------------|--------------------|
| 0000              | 0000               |
| 0001              | 0001               |
| 0010              | 0010               |
| 0011              | 0011               |
| 0100              | 0100               |
| 0101              | 0101               |
| 0110              | 0110               |
| 0111              | 0111               |
| 1000              | 1000               |
| 1001              | 1001               |
| 1010              | 0000               |
| 1011              | 0001               |
| 1100              | 0010               |
| 1101              | 0011               |
| 1110              | 0100               |
| 1111              | 0101               |

With the output signal of the comparison block, another module, Circuit B, determines when to activate the second display (showing ‘1’) for numbers ≥10.

Figure 2.3 — Circuit B module LUT

| Input (i_z) | Output (o_seg[7..0]) |
|-------------|----------------------|
| 0           | 11111111             |
| 0           | 11111001             |

Using four 2-to-1 1bit multiplexeres (from previous Lab) the signal will be toggled to display correctly the first digit of the signal using the 7-segment display module from previous parts.

*Figure 2.4 — Binary to decimal module Design*

<img src="IMG/Part_II_bin2dec_Design.gif" width="800">


### Implementation

*Figure 2.5 — Circuit A module Implementation*

<img src="IMG/Part_II_circA.png" width="500">

*Figure 2.6 — Circuit B module Implementation*

<img src="IMG/Part_II_circB.png" width="300">

*Figure 2.7 — Comparison module Implementation*

<img src="IMG/Part_II_comp.png" width="500">

*Figure 2.8 — Binary to decimal module Implementation*

<img src="IMG/Part_II_b2d.png" width="500">

*Figure 2.9 — Main module Implementation*

<img src="IMG/Part_II_main.png" width="500">


### Demonstration

*Figure 2.10 — Binary to decimal Demonstration*

<img src="IMG/Part_II_Demonstration.gif" width="500">



<h2 id="Part III">Part III — Full adder and 4-bit Ripple-carry adder</h2>  

### Objective
Add two binary numbers and a carry-in, and display the result in the LEDs.


### Logic / Design
A full adder module needs to be created, adding two bits and a carry in. It outputs two values: the sum bit and the carry-out. These are first displayed using LEDs.

Figure 3.1 — FA module LUT

| Input (i_a, i_b, i_c) | Output (o_c, o_s) |
|-----------------------|-------------------|
| 0       0       0     | 0       0         |
| 0       0       1     | 0       1         |
| 0       1       0     | 0       1         |
| 0       1       1     | 1       0         |
| 1       0       0     | 0       1         |
| 1       0       1     | 1       0         |
| 1       1       0     | 1       0         |
| 1       1       1     | 1       1         |

With four of this FA module a 4-bit ripple-carry will be made connecting the carry out of each module to the carry-in of the next one. The output is a 4-bit sum plus a carry-out.

*Figure 3.2 — 4-bit adder (ripple-carry) Design*

<img src="IMG/Part_III_4-bit_Ripple-carry_Design.gif" width="700">


### Implementation

*Figure 3.3 — FA module Implementation*

<img src="IMG/Part_III_FA.png" width="700">

*Figure 3.4 — 4-bit adder (ripple-carry) module Implementation*

<img src="IMG/Part_III_4bit_adder.png" width="500">

*Figure 3.5 — Main module Implementation*

<img src="IMG/Part_III_main.png" width="500">


### Demonstration

*Figure 3.6 — FA Demonstration*

<img src="IMG/Part_III_FA_Demonstration.gif" width="500">

*Figure 3.7 — 4-bit adder (ripple-carry) Demonstration*

<img src="IMG/Part_III_4bit_adder_Demonstration.gif" width="500">



<h2 id="Part IV">Part IV — 8-bit Ripple-carry adder</h2>  

### Objective
Add two decimal numbers (8 bits each) and a carry-in, and display numbers and the result in the 7-segment displays.


### Logic / Design
The logic from previous parts can be used but adapted. A third 'circuit C' module is created into the previous binary to decimal module to contemplate the numbers highers than 15 when a carry-in is active. This conversion adjusts the input so that values above 15 are correctly displayed. For example, 16 becomes 6, 17→7, up to 19→9. This is equivalent to adding 6 when a carry-in is active.

Figure 4.1 — Circuit C module LUT

|Input (i_a, i_cin) | Output (o_a) |
|-------------------|--------------|
| 0000      0       |   0000       |   
| 0000      1       |   0110       |   
| 0001      0       |   0001       |   
| 0001      1       |   0111       |   
| 0010      0       |   0010       |
| 0010      1       |   1000       |
| 0011      0       |   0011       |
| 0011      1       |   1001       |
| 0100      0       |   0100       |
| 0100      1       |   0110       |
| 0101      0       |   0101       |
| 0101      1       |   0111       |
| 0110      0       |   0110       |
| 0110      1       |   1100       |
| 0111      0       |   0111       |
| 0111      1       |   1101       |
| 1000      0       |   1000       |
| 1000      1       |   1110       |
| 1001      0       |   1001       |
| 1001      1       |   1111       |
| 1010      0       |   1010       |
| 1010      1       |   1000       |
| 1011      0       |   1011       |
| 1011      1       |   1001       |
| 1100      0       |   1100       |
| 1100      1       |   1110       |
| 1101      0       |   1101       |
| 1101      1       |   1111       |
| 1110      0       |   1110       |
| 1110      1       |   1100       |
| 1111      0       |   1111       |
| 1111      1       |   1101       |   

For the check binary functionality, a new module is created to verify if the input values are higher than 9, using the module 'comparison' from previous parts. And including OR gates to implement the carry-in bit into the multiplexers, the module to convert binary to decimal now contemplates up to 19.

*Figure 4.2 — Binary to decimal module Design*

<img src="IMG/Part_IV_bin2dec_Design.gif" width="800">

And a descriptive picture of how the main module is designed.

*Figure 4.3 — Binary to decimal module Design*

<img src="IMG/Part_IV_main_design.png" width="500">


### Implementation

*Figure 4.4 — Circuit C module Implementation*

<img src="IMG/Part_IV_circC.png" width="500">

*Figure 4.5 — Check BCD module Implementation*

<img src="IMG/Part_IV_checkBCd.png" width="300">

*Figure 4.6 — Binary to decimal module Implementation*

<img src="IMG/Part_IV_b2d.png" width="500">

*Figure 4.7 — Main module Implementation*

<img src="IMG/Part_IV_main.png" width="500">


### Demonstration

*Figure 4.8 — 8-bit adder (ripple-carry) Demonstration*

<img src="IMG/Part_IV_Demonstration.gif" width="500">



<h2 id="Part V">Part V — Two digit BCD numbers adder</h2>  

### Objective
Add two two-digit BCD numbers (8 bits each) and display both operands and the result on 7-segment displays.


### Logic / Design
The 4-bit Adder logic from previous parts can be used. In this case, with only 10 switches in the DE10-Lite FPGA avaliable to use it as inputs, one of the BDC number will be constant. 
One first adder will add the firts digit of the BCD numbers and another the second one. The carry-out signal of the first one will be connected to the carry-in input of the second one. And again, the 'CheckBCD' module will indicate if any of the digits of the input is higher than 9.

*Figure 5.1 — BCD adder module Design*

<img src="IMG/Part_V_BCDAdder_Design.gif" width="500">


### Implementation

*Figure 5.2 — Main module Implementation*

<img src="IMG/Part_V_main.png" width="500">


### Demonstration

*Figure 5.3 — Two digit BCD adder Demonstration*

<img src="IMG/Part_V_Demonstration.gif" width="500">



<h2 id="Part VI">Part VI — Two digit BCD numbers adder with logic approach</h2>  

### Objective
Add two digit BDC numbers (8 bits each) and display numbers and the result in the 7-segments dsiplays using logic statements.


### Logic / Design
Instead of reusing the earlier modules, this part implements the design directly with behavioral Verilog (using conditional statements).

*Figure 6.1 — Statements logic*

<img src="IMG/Part_VI_StatementLogic.png" width="150">

Using the logic give in the excercice, a new set of reg variables are declared to operate them. When adding the digits form the BCD numbers independently, a comparison checks if the digit is >9. If so, 6 is added to the value to ensure a valid BCD representation. And the carry out will be added to the second digit operation. Then the operation results will be displayed in the 7-segment displays. In this case, a constant of 50 will be used to demonstrate the funcitolanlity and again, the 'CheckBCD' module will indicate if the input number is higher than 99.

With the RTL Viewer, it can be stablished that the logic from this part matches the one from previous parts, consecuently the functionality will remain the same.

*Figure 6.2 — RTL Viewer*

<img src="IMG/Part_VI_RTLViewer.png" width="800">


### Implementation

*Figure 6.3 — Main module Implementation*

<img src="IMG/Part_VI_main.png" width="400">


### Demonstration

*Figure 6.4 — Two digit BCD adder with logic approach Demonstration*

<img src="IMG/Part_VI_Demonstration.gif" width="500">



<h2 id="Part VII">(extra) Part VII — 6-bit binary number to BCD</h2>  

### Objective
Display a 6-bit binary number into a 7-segments display in BCD.


### Logic / Design
To display a 6-bit binary number as BCD, division (/) and modulo (%) operations are used to separate the tens and units digits.


### Implementation

*Figure 7.1 — Main module Implementation*

<img src="IMG/Part_VII_main.png" width="500">


### Demonstration

*Figure 7.2 — 6-bit binary number to BCD Demonstration*

<img src="IMG/Part_VII_Demonstration.gif" width="500">
