![FPGA](https://img.shields.io/badge/FPGA-DE10--Lite-blue)
![Language](https://img.shields.io/badge/Language-Verilog-green)
![Simulator](https://img.shields.io/badge/Tool-Logisim-orange)
# Lab 2 — Numbers and Displays (FPGA DE10-Lite)

This repository documents the second FPGA lab using the DE10-Lite (MAX 10 10M50DAF484C7G).  
The goal is to designing combinational circuits that can perform binary-to-decimal number conversion and binary-coded-decimal (BCD) addition.

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
Display the value from the switches in binary. The circuit will display digits for 0 to 9 and the valuations form 1010 to 1111's as don't cares.


### Logic / Design
A module is created as a 7 segment decoder to display the digits 0 to 9. With a 4-bit input the digits displayed correspond to the input in binary.

Figure 1.1 — 7-segment decoder Design

<img src="IMG/Part_I_7seg_dec_Design.gif" width="600">

To define the logic, a Look Up Table (LUT) is needed. The 7 segment displays are NOT active in high, whenever are required to be off, will be set to 1.

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
Display the values from the switches in binary. The circuit will display digits for 0 to 15 using a convination of two 7-segments display.


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

In paralel of the comparison, a first block named 'Circuit A' converts the binary number signal to extract the first figit of the number. The logic would be than when the number is 10, the first diplay would show the first digit beeng 0. And consequently, 11-->1, 12-->2, etc.

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

With the output signal of the comparison block, another moduled named 'Circuit B' will determine when to display the second digit of the input, in this cas a '1'.

Figure 2.3 — Circuit B module LUT

| Input (i_z) | Output (o_seg[7..0]) |
|-------------|----------------------|
| 0           | 11111111             |
| 0           | 11111001             |

Using four 2-to-1 1bit multiplexeres (from previous Lab) the signal will be toggled to display correctly the first digit of the signal using the 7-segment display module from previous parts.

*Figure 2.4 — Main block Implementation*

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
