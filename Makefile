GO_EASY_ON_ME = 1

include theos/makefiles/common.mk
export ARCHS = armv7 armv7s arm64
TOOL_NAME = AutoHDRInstaller AutoHDRRemover

AutoHDRInstaller_FILES = Installer.m
AutoHDRInstaller_OBJCFLAGS = -I$(THEOS_PROJECT_DIR) -F$(THEOS_PROJECT_DIR)

AutoHDRRemover_FILES = Remover.m
AutoHDRRemover_OBJCFLAGS = -I$(THEOS_PROJECT_DIR) -F$(THEOS_PROJECT_DIR)

TWEAK_NAME = AutoHDREnabler
AutoHDREnabler_FILES = AutoHDREnabler.xm
AutoHDREnabler_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tool.mk
include $(THEOS_MAKE_PATH)/tweak.mk
