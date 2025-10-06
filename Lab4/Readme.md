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
A module is created as a T Flip-flop. With T (Set), R (Reset), and clk (clock) as inputs, it will display the stored value.
- If both S and clk are active, the output is set to 1 and remains stored.
- If both R and clk are active, the output is reset to 0

Figure 1.1 — Gated SR Latch Design

<img src="IMG/Part_I_SRLatch_Design.gif" width="500">

The RTL Viewer confirms that the logic matches the Verilog code; consequently, the functionality is preserved.

Figure 1.2 — Gated SR Latch RTL Viewer

<img src="IMG/Part_I_SRLatch_RTLViewer.png" width="700">

To be able to observe the internal signals when compiled, it is necesary to include the compiler directive ("/* synthesis keep /*").


### Implementation

*Figure 1.3 — SR Latch Implementation*

<img src="IMG/Part_I_SRLatch_logic.png" width="400">

*Figure 1.4 — Main block Implementation*

<img src="IMG/Part_I_main_logic.png" width="500">


### Demonstration

*Figure 1.5 — SR Latch Demonstration*

<img src="IMG/Part_I_Demonstration.gif" width="500">



