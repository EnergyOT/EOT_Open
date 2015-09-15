## EOT Open Hardware

#### BOM

- **energyot_open_BOM.xlsx** - Bill of Materials

#### Schematic

- **energyot_open_schematic.pdf** - Schematic

#### Layout

- **energyot_open_top_layout.pdf** - PCB TOP
- **energyot_open_bottom_layout.pdf** - PCB BOTTOM
- **energyot_open_all_layout.pdf** - PCB COMPLETE

#### Programming Details

- **programming pads.png**
- **programming usb.png**

##TO PROGRAM

You will need an USB to serial converter (like FTDI or Prolific). Then there are two ways that you can program this hardware:

 - You can use the programming pads in the bottom side with pogopins or a custom made cable (check programming pads.png). 
 - You can close the solder jumpers in the bottom (J1, J2 and J3) and use the uUSB cable to program. Notice that after programming you should open the solder jumpers again check programming usb.png).
 
Notice that the usb to serial converter should be 3.3V and during the programming phase you will need to pull the GPIO0 pin to ground.
