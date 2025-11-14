![FPGA](https://img.shields.io/badge/FPGA-DE10--Lite-blue)
![Language](https://img.shields.io/badge/Language-Verilog-green)
![Communication](https://img.shields.io/badge/Communication-RealTerm-blue?logo=serialport)

# Final project — Home automation (FPGA DE10-Lite)

This repository documents the Final project using the DE10-Lite development board (MAX 10 10M50DAF484C7G).
The goal of this exercise is to design a Home automation system inclueding a temperature sensor, an LCD display, a gas sensor and a UART interface communication between the FPGA and a PC terminal to simulate a locking system.
 
<!-- Table of content -->
<nav>
  <h1>Table of Contents</h1>
  <ul>
    <li><a href="#Objective">Objective</a></li>
    <li><a href="#Design">Design and Logic</a></li>
    <li><a href="#Implementation">Implementation</a></li>
    <li><a href="#Demonstration">Demonstration </a></li>
    <li><a href="#Conclusions">Conclusions</a></li>
    <li><a href="#Future">Future Improvements</a></li>
  </ul>
</nav>

<h2 id="Objective">Objective</h2>
The objective of this project is to integrate different components and make them work as a Home automation system. Will be used the knowledge of previous labs and excercices. It includes a 1602A LCD Display, a DS18b20 Temperature sensor, a HC-SR04 Ultrasonic sensor, an MQ-2 Gas sensor and an LC234X UART interface device.


<h2 id="Design">Design, Logic and functionalities</h2>
The system is controlled using a FSM and individual blocks to control and analyze the data inputs. The different functionalitites are described as following:

- Fire detection: Using a gas detector, a Fire alarm system is implemented to show a message while some sort of gas is detected. The sensor used is the MQ-2 Gas sensor from Sunfounder. It has the avility to detect a varity of gases, but does not discriminate them on the signal. It works with 5V, requiring a voltage devider to make it compatible with the 3.3V of the DE-10 Lite. It also has a Analog signal and a Digital output. For the analog one, an ADC external module is requierid and it gives the avility to receive the exact amount of detection. In this cas, the digital output signal is used which utilize the potenctiometer on the boaerd to filter the signal detrection and activates the trigger. This feature is available at all times as it is a safety feature. The signal will set to 0 when detection as a security feature of the module.

- Light dimming: With the use of the HC-SR04 ultrasonic sensor, a presence and distance of an object from the FPGA is detected. This module works as it needs to recieve a trigger signal form the FPGA of about 10 ys and in a window of 60ms where the module sends a detection signal. The distance detection is represented as the duration of the signal recieved at converted with the formula D = ys / 58. This diatnce is easured in centimiters and for the porpouse of this project, a window of 13cm will be set por the detection. THis module also requires a voltage devider. This feature is only activated when the systme is unlocked. 

- Locking and unlocking process: As a safety system to protect Home, a password system is implemented using the UARt interface to implement a locking and unlocking process. When system is in IDLE position, meaning Home is unlocked, the user is able to press on button and with a count down of 5s the system will be locked. Whenever the user wants to get back aagin to IDLE state, a correct password needs to be send using the PC terminal. When an incorrect password is set, an incorrect state will be triggerd and the password will need to be entered from the start.

- Intruder feature:  Whenever the system is locked, after pressing the locking button, if a presence is detected using the ultrasonic sensor, an Intruder state is triggered to alert the user. Imediately the password is required to unlock the system and go back to Idle state.

- Display information: Because of a lack of time, the LCD display and the temperature sensor are not implemented on the project. Instead, the 7-segments displays and LEDR included on the FPGA are used to display information depending on the state. A pattern feature worked in class for the LEDR is also used. In case of Fire detection, the word "Fire" blinks on the 7-segment display. When locking the system, the word "locking" blinks and after the 5 seconds, the word remains steady. In case of intruder the word "robber" can be seen. And when entering the password, each character is also visible. When IDLE state is active, the temperature was ment to be seen both in Farenheid and Celsius.

- Voltage devider: To make the 5V modules compatible with the FPGA, two voltage devider are used. To reduce 5V to 3.3V, a 5kohm and a 3.3kohm resistors are used.

Image Block diagram

Image States diagram


<h2 id="Implementation">Implementation</h2>
This part will show the main code implementations and the RTL viewer. The full code is available on the Code folder.

- Ultra sonic detection:
As explained on the design, a signal needs to be triggerd for 10 ys in a cycle of 60ms. For the signal detection, a simple FSM is implemented to effitiently measure the counts and determine the precisse distance of the object.

Image trigger signals

Image FSM

- PWM for light dimming:
The implementation of the PWM is strait forward. Using the frequency of the signal, the human eye can interprete the brightness of the light.

Image PWM

- Main FSM
The main FSM determin the states depending on the different inputs.

State      | Input condition            | Next state    | Actions / outputs
-----------|--------------------------- |---------------|--------------------------------
S_IDLE     | Fire = 0                   | S_Fire        | Display Fire
S_Fire     | Fire = 1                   | S_Locked      | Display locked
S_IDLE     | Lock = 1                   | S_Locking     | Display locked blinking
S_Locking  | Count done                 | S_Locked      | Display locked
S_Locked   | Presence                   | S_Intruder    | Display intruder
S_Intruder | Password                   | S_PW          | Display character
S_Password | Wrong character            | S_wrong_PW    | Display worng password
S_wrong_PW | Count done                 | S_Locked      | Display locked
S_Password | Correct password           | S_IDLE        | Display temperature

RTL Viewer FSM

- Display controller
The display controller modules is an always statement that determine with priorities the message to show. The order would be determine of the safety requiremetns:
Fire --Z Locking --Z Entering PW --Z Intruder --Z Worng PW --Z Locked --Z Temperature (C and F)

Different mdoules as counters, timers, dbounce and UART interface are used form previous labs.


<h2 id="Demonstration">Demonstration</h2>

Gif Locking

Gif temperature

Gif Intruder

Gif password

gif Fire


<h2 id="Conclusions">Conclusions</h2>
To conclude, this project gave me the oportunity to implement different sensors and modules into a bigger implementation. Due to the lag of time, it was hard to complete all teh objectives stablished at the begining but the it made me straggle with it and simplified to get a final solution. The final result integrate multiple sensors and allows creativity to implement differnet fucnitonalities. Thanks to the this class I am able to implement a fucntional FSM to manage security and real-time conditions. Also, one of the segments of one displayed stopped owrki

<h2 id="Future">Future improvements</h2>
As of fututre improvements it would be needed to integrate the reaming sensor, as it was design form the first idea. I would also experiment with an SDC module to use the analog signal and have a better detection form the somke sensor, for example. I would also like to experiment with Bluethooth or Wi-Fi decvices to give this project another dimension. And another feature I would implement is to design a 3D printed housing to better enclose the modules and aproximate the project to a "real" home.
