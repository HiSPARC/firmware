HiSPARC firmware
================

This repository contains the VHDL source code of the firmware for the
FPGA in the HiSPARC electronics.

Because of different versions of the electronics there are 3 branches
that contain the latest firmware version for each version of the
electronics:

- HiSPARC III (`master`), firmware needs to be loaded each time the
  power is cycled.
- HiSPARC II (`hisparc_ii`), firmware is loaded using a USB blaster on
  an internal port.
- HiSPARC II LED (`hisparc_ii_led`), special version that sends
  additional signals from the PMT Control to flash extra LEDs.


Graphical HDL Design
--------------------

The `hisparc.ews` file (seen by git as a directory) can be worked on
with [EASE](http://www.hdlworks.com/products/ease/index.html).
This program produces output that can be used to make the firmware.


Fitting
-------

To make the final firmware file the
[Quartus II](http://www.altera.com/products/software/quartus-ii/about/qts-performance-productivity.html)
software can be used.

The files in the `synthesis` directory are also input for the fitting,
they contain information about what is connected to which pin of the
FPGA.
