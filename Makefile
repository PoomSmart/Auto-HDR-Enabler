GO_EASY_ON_ME = 1
SDKVERSION = 7.1
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TOOL_NAME = AutoHDRInstaller AutoHDRRemover

AutoHDRInstaller_FILES = Installer.m
AutoHDRInstaller_OBJCFLAGS = -I$(THEOS_PROJECT_DIR) -F$(THEOS_PROJECT_DIR)

AutoHDRRemover_FILES = Remover.m
AutoHDRRemover_OBJCFLAGS = -I$(THEOS_PROJECT_DIR) -F$(THEOS_PROJECT_DIR)

TWEAK_NAME = AutoHDREnabler
AutoHDREnabler_FILES = AutoHDREnabler.xm
#AutoHDREnabler_FRAMEWORKS = CoreMedia UIKit
#AutoHDREnabler_PRIVATE_FRAMEWORKS = Celestial

include $(THEOS_MAKE_PATH)/tool.mk
include $(THEOS_MAKE_PATH)/tweak.mk
