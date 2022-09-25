# OpenHR20

This is a fork of [OpenHR20](https://github.com/OpenHR20/OpenHR20) with RFM and Thermotronic support completely removed.

The goal of this fork is to provide a clean firmware with UART support for controlling the HR20 thermostats through external devices. Therefore RFM is obsolete and Thermotronic doesn't support UART, so support for both has been removed.

## Compiling

As installing this firmware needs flashing a program to the thermostat MCU with hardware programmer, at least basic understanding of working with AVR MCUs and some additional hardware is required.

To compile the sources, avr compatible gcc crosscompiler is required. On many linux distributions, you can install this via packages, e.g. on debian based distros, installing "gcc-avr" package should install the whole required toolchain. For flashing, "avrdude" package is also required.

To compile the default configuration - HR20 version:

`make`

To compile with predefined REVision ID

`make REV=-DREVISION=\\\"123456_XYZ\\\"`

To compile with hardware window open contact

`make HW_WINDOW_DETECTION=1`

### OpenHR20 SW variants

\*\_sww - software window detection

\*\_hww - hardware window contact PE2<->GND (closed = connected, open=open)

#### Binaries

_.bin _.hex - flash on BIN and HEX format

\_.eep - initial EEPROM content

\_.elf - flash, eeprom and fuses combination

\*.txt - info about compilation

## PINOUT HR20

The externally accesible connector on HR20/25 thermostats allows direct connection to the MCU for flashing via JTAG, or for wired communication. The connector layout is:

| ATmega169PV | <Func>(<Port,Pin>/<No.>) |             |             |              |
| ----------- | ------------------------ | ----------- | ----------- | ------------ |
| Vcc         | RXD(PE0/02)              | TDO(PF6/55) | TMS(PF5/56) | /RST(PG5/20) |
| GND         | TDI(PF7/54)              | TXD(PE1/03) | TCK(PF4/57) | (PE2/04)     |
