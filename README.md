HiSPARC firmware
================

This repository contains the VHDL source code of the firmware for the
HiSPARC electronics.

Because of different versions of the electronics there are 3 branches
that contain the latest firmware version for each version of the
electronics:

- HiSPARC III, firmware needs to be loaded each time the power is cycled.
- HiSPARC II, firmware is loaded using a USB blaster on an internal port.
- HiSPARC II LED, special version that sends additional signals from the
  PMT Control to flash extra LEDs.
