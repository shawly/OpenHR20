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

default: HR20_original_sww

all: HR20_original_sww HR20_original_hww HR25_original_sww
	 cp src/license.txt $(DEST)/

clean:
	 $(MAKE) clean -C src TARGET=../$(DEST)/HR20_original_sww/hr20 OBJDIR=HR20_original_sww
	 $(MAKE) clean -C src TARGET=../$(DEST)/HR20_original_hww/hr20 OBJDIR=HR20_original_hww
	 $(MAKE) clean -C src TARGET=../$(DEST)/HR25_original_sww/hr20 OBJDIR=HR25_original_sww
	@rm -f $(DEST)/license.txt

beauty:
	 clang-format -i src/*.h src/*.c common/*.h common/*.c

check:
	 cppcheck --inline-suppr --force . >/dev/null

VER=

DEST=bin

HR20_original_sww:
	 $(shell mkdir $(DEST)/$@ 2>/dev/null)
	 $(MAKE) -C src \
		TARGET=../$(DEST)/$@/hr20 \
		OBJDIR=$@ \
		HW_WINDOW_DETECTION=0 \
		REV=-DREVISION=\\\"$(REV)\\\"

HR20_original_hww:
	 $(shell mkdir $(DEST)/$@ 2>/dev/null)
	 $(MAKE) -C src \
		TARGET=../$(DEST)/$@/hr20 \
		OBJDIR=$@ \
		HW_WINDOW_DETECTION=1 \
		REV=-DREVISION=\\\"$(REV)\\\"

HR25_original_sww:
	 $(shell mkdir $(DEST)/$@ 2>/dev/null)
	 $(MAKE) -C src \
		TARGET=../$(DEST)/$@/hr20 \
		OBJDIR=$@ \
		HW_WINDOW_DETECTION=0 \
		HW=HR25 \
		REV=-DREVISION=\\\"$(REV)\\\"
