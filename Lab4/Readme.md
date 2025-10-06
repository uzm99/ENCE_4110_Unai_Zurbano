![FPGA](https://img.shields.io/badge/FPGA-DE10--Lite-blue)
![Language](https://img.shields.io/badge/Language-Verilog-green)
![Simulator](https://img.shields.io/badge/Tool-Logisim-orange)
# Lab 4 — Counters (FPGA DE10-Lite)

This repository documents the fourth FPGA lab using the DE10-Lite (MAX 10 10M50DAF484C7G).  
The purpose of this exercise is to build and use counters.

<!-- Table of content -->
<nav>
  <h1>Table of Contents</h2>
  <ul>
    <li><a href="#Part I">Part I</a></li>
    <li><a href="#Part II">Part II</a></li>
    <li><a href="#Part III">Part III</a></li>
    <li><a href="#Part IV">Part IV</a></li>
    <li><a href="#Part V">Part V</a></li>
  </ul>
</nav>


<!-- Sections -->
<h2 id="Part I">Part I — T Flip-Flop counter</h2>  

### Objective
Create a 4-bit synchronous counter wich uses four T-type flip-flops. 


### Logic / Design
A module is created as a T Flip-flop. With T (Set) and clk (clock) as inputs, and a D Flip-flop with two AND gates and a OR gate. It toggles the value.
- If both T and clk are active, the output is toggled from 1 to 0. or 0 to 1.
With a 1-bit T Flip-Flop, a counter can be created instantiating the modules. In this case, an 8-bit counter will be implemented. But for fucntionality verification porpuses using Logisim, a 4-bit counter will has been designed.

*Figure 1.1 — T-Flip-flop 1-bit Design*

<img src="IMG/Part_I_TFlipFlop_1bit_Design.gif" width="500">

*Figure 1.2 — T-Flip-flop 4-bit Counter Design*

<img src="IMG/Part_I_TFlipFlop_4bit_counter_Design.gif" width="500">

The RTL Viewer confirms that the logic matches the Verilog code; consequently, the functionality is preserved.

*Figure 1.3 — T-Flip-flop 1-bit RTL Viewer*

<img src="IMG/Part_I_TFlipflop_1bit_RTLViewer.png" width="700">

*Figure 1.4 — T-Flip-flop 8-bit RTL Viewer*

<img src="IMG/Part_I_TFlipflop_8bit_RTLViewer.png" width="700">

From this excercices and go on, to aviod double bounce with the switches and the buttons as a harware issue, a 1s counter from previous excercices has been implemented to act as a clock (clk) signal. 


### Implementation

*Figure 1.5 — T-Flip-flop 1-bit Implementation*

<img src="IMG/Part_I_TFlipflop_1bit_logic.png" width="400">

*Figure 1.6 — T-Flip-flop 1-bit Main block Implementation*

<img src="IMG/Part_I_TFlipflop_1bit_main_logic.png" width="500">

*Figure 1.7 — T-Flip-flop 8-bit Implementation*

<img src="IMG/Part_I_TFlipflop_8bit_logic.png" width="400">

*Figure 1.8 — T-Flip-flop 8-bit Main block Implementation*

<img src="IMG/Part_I_TFlipflop_8bit_main_logic.png" width="500">

*Figure 1.9 — T-Flip-flop 8-bit to 7-segment display Main block Implementation*

<img src="IMG/Part_I_TFlipflop_8bit_HEX_main_logic.png" width="500">


### Demonstration

*Figure 1.10 — T-Flip-flop 1-bit Demonstration*

<img src="IMG/Part_I_TFlipflop_Demonstration.gif" width="500">

*Figure 1.11 — T-Flip-flop 8-bit Counter Demonstration*

<img src="IMG/Part_I_TFlipflop_8bitCounter_Demonstration.gif" width="500">

*Figure 1.12 — T-Flip-flop 8-bit Counter to 7-segment display Demonstration*

<img src="IMG/Part_I_TFlipflop_8bitCounter_HEX_Demonstration.gif" width="500">



<h2 id="Part II">Part II — 16-bit Counter</h2>  

### Objective
Create a 16-bit synchronous counter using a register and adding 1 to its value. 


### Logic / Design
A module is created as an adder using secuential logic and the expresion Q <= Q + 1.

The RTL Viewer shows again a D Flip-flop implemented with the output carried into the D signal with an Add block.

*Figure 2.1 — 16-bit Counter RTL Viewer*

<img src="IMG/Part_II_counter_16bit_RTLViewer.png" width="500">


### Implementation

*Figure 2.2 — 16-bit Counter Implementation*

<img src="IMG/Part_II_counter_16bit_logic.png" width="400">

*Figure 2.3 — Main block Implementation*

<img src="IMG/Part_II_main_logic.png" width="500">


### Demonstration

*Figure 2.4 — 16-bit Counter Demonstration*

<img src="IMG/Part_II_Demonstration.gif" width="500">



<h2 id="Part III">Part III — 16-bit Counter with an LPM </h2>  

### Objective
Create a 16-bit synchronous counter using an LPM module from the Library of Parameterized modules. 


### Logic / Design
An LPM modules is generated with an enable and synchronous clear to be consistent with the same design from previous parts




### Implementation

*Figure 3.2 — Main module Implementation*

<img src="IMG/Part_III_main_logic.png" width="400">


### Demonstration

*Figure 3.3 — 16-bit LPM Counter Demonstration*

<img src="IMG/Part_III_Demonstration.gif" width="500">
