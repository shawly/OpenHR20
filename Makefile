#############
# Thermostat settings

# Switch to 1 to enable slave motor startup battery compensation
export MOTOR_COMPENSATE_BATTERY=0

#############
# Master settings

# Set the proper master type
#MASTERTYPE=JEENODE=1
#MASTERTYPE=NANODE=1

#############

default: HR20_uart_sww

all: HR20_uart_sww HR20_uart_hww HR25_uart_sww

clean:
	 $(MAKE) clean -C src TARGET=../$(DEST)/HR20_uart_sww/hr20 OBJDIR=HR20_uart_sww
	 $(MAKE) clean -C src TARGET=../$(DEST)/HR20_uart_hww/hr20 OBJDIR=HR20_uart_hww
	 $(MAKE) clean -C src TARGET=../$(DEST)/HR25_uart_sww/hr20 OBJDIR=HR25_uart_sww

beauty:
	 clang-format -i src/*.h src/*.c

check:
	 cppcheck --inline-suppr --force . >/dev/null

VER=

DEST=bin

HR20_uart_sww:
	 $(shell mkdir -p $(DEST)/$@ 2>/dev/null)
	 $(MAKE) -C src \
		TARGET=../$(DEST)/$@/hr20 \
		OBJDIR=$@ \
		HW_WINDOW_DETECTION=0 \
		REV=-DREVISION=\\\"$(REV)\\\"

HR20_uart_hww:
	 $(shell mkdir -p $(DEST)/$@ 2>/dev/null)
	 $(MAKE) -C src \
		TARGET=../$(DEST)/$@/hr20 \
		OBJDIR=$@ \
		HW_WINDOW_DETECTION=1 \
		REV=-DREVISION=\\\"$(REV)\\\"

HR25_uart_sww:
	 $(shell mkdir -p $(DEST)/$@ 2>/dev/null)
	 $(MAKE) -C src \
		TARGET=../$(DEST)/$@/hr20 \
		OBJDIR=$@ \
		HW_WINDOW_DETECTION=0 \
		HW=HR25 \
		REV=-DREVISION=\\\"$(REV)\\\"
