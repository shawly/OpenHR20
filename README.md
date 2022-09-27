# OpenHR20

![Development Status](https://img.shields.io/badge/development%20status-WIP-orange) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/shawly/openhr20/CI%20Build?logo=github) ![GitHub](https://img.shields.io/github/license/shawly/openhr20)

This is a fork of [OpenHR20](https://github.com/OpenHR20/OpenHR20) with RFM and Thermotronic support completely removed.

The goal of this fork is to provide a clean firmware with UART support for controlling the HR20 thermostats through external devices. Therefore RFM is obsolete and Thermotronic doesn't support UART, so support for both has been removed.

**Why remove RFM support?**

I am mainly interested in controlling my HR20's through an ESP8266 directly through the pin headers via UART. Since it will be powered through a DC adapter anyway, the increased power consumption doesn't matter as I won't be using batteries anyway.

## Features

- All original HR20/HR25 features
- UART control through pin header
- ~~Wireless control through RFM radio module~~ (removed)

### Planned

- Migrate build to [PlatformIO](https://platformio.org/) with [MegaCore](https://registry.platformio.org/tools/platformio/framework-arduino-avr-megacore) (as soon as [ATmega169 support](https://github.com/platformio/platform-atmelavr/pull/287) has been merged)
- Guide for flashing
- ESPHome module for integration with Home Assistant

## Compiling

To compile the sources, avr compatible gcc crosscompiler is required. On many linux distributions, you can install this via packages, e.g. on debian based distros, installing "gcc-avr" package should install the whole required toolchain. For flashing, "avrdude" package is also required.

### Prerequisites

#### Arch Linux based distributions

```bash
sudo pacman -Sy base-devel avr-gcc avr-binutils avr-libc cppcheck
```

#### Debian based distributions

```bash
sudo apt install build-essential gcc-avr binutils-avr avr-libc cppcheck
```

### Compile the firmware

To compile the default configuration - HR20 version:

`make`

To compile with predefined REVision ID

`make REV=-DREVISION="123456_XYZ"`

To compile with hardware window open contact

`make HW_WINDOW_DETECTION=1`

### OpenHR20 SW variants

```
*_sww - software window detection
*_hww - hardware window contact PE2<->GND (closed = connected, open=open)
```

#### Binaries

```
*.bin *.hex - flash on BIN and HEX format
*.eep - initial EEPROM content
*.elf - flash, eeprom and fuses combination
*.txt - info about compilation
```

## Flashing

### PINOUT HR20

The externally accesible connector on HR20/25 thermostats allows direct connection to the MCU for flashing via JTAG, or for wired communication. The connector layout is:

| ATmega169PV | <Func>(<Port,Pin>/<No.>) |             |             |              |
| ----------- | ------------------------ | ----------- | ----------- | ------------ |
| Vcc         | RXD(PE0/02)              | TDO(PF6/55) | TMS(PF5/56) | /RST(PG5/20) |
| GND         | TDI(PF7/54)              | TXD(PE1/03) | TCK(PF4/57) | (PE2/04)     |

### Connection to JTAG

| HR20 | JTAG  |
| ---- | ----- |
| Vcc  | Vcc   |
| GND  | GND   |
| RxD  | -     |
| TDI  | TDI   |
| TDO  | TDO   |
| TxD  | -     |
| TMS  | TMS   |
| TCK  | TCK   |
| /RST | NSRST |
| PE2  | -     |

I used an AVR-JTAG-USB programmer from Olimex. AVR-JTAG-J (from Olimex), AVR DRAGON or AVR JTAG ICE (MKI & MKII) will work as well.

### How to flash?

You can use the following commands to flash the firmware

```bash
# set your programmer:
#   jtag1 = AVR JTAG ICE MKI
#   jtag2 = AVR JTAG ICE MKII
#   dragon_jtag = AVR DRAGON in JTAG mode
#   or execute "avrdude -c ?" if you got another jtag programmer
export PROGRAMMER=jtag1

# the port of your programmer
export PORT=/dev/ttyUSB0

# the directory where backups will be stored (e.g. /your/current/directory/backups/2022-09-27_19:13:22)
export BACKUP_DIR=$(pwd)/backups/$(date "+%F_%T")

# backup fuse values
avrdude -p m169p -c $PROGRAMMER -P $PORT -U lfuse:r:${BACKUP_DIR}/lfuse.hex:h -U hfuse:r:${BACKUP_DIR}/hfuse.hex:h -U efuse:r:${BACKUP_DIR}/efuse.hex:h

# backup flash and eeprom (make sure to save these somewhere for the original firmware)
avrdude -p m169p -c $PROGRAMMER -P $PORT -U flash:r:${BACKUP_DIR}/hr20.hex:i -U eeprom:r:${BACKUP_DIR}/hr20.eep:i

# set fuses
avrdude -p m169p -c $PROGRAMMER -P $PORT -U hfuse:w:0x9B:m -U lfuse:w:0xE2:m

# change into the directory with the compiled firmware that you want to flash
cd bin/HR20_uart_sww

# write flash and eeprom
avrdude -p m169p -c $PROGRAMMER -P $PORT -e -B 12 -U flash:w:hr20.hex -U eeprom:w:hr20.eep
```
