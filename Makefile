GO_EASY_ON_ME = 1
SDKVERSION = 8.0
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = AutoHDREnabler
AutoHDREnabler_FILES = AutoHDREnabler.xm
AutoHDREnabler_LIBRARIES = MobileGestalt

include $(THEOS_MAKE_PATH)/tweak.mk
