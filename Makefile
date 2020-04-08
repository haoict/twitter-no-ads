ARCHS = arm64 arm64e
TARGET = iphone:clang:12.2:12.2
DEBUG = 0
THEOS_DEVICE_IP = 192.168.1.21

INSTALL_TARGET_PROCESSES = Twitter

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = twitternoads

twitternoads_FILES = Tweak.xm
twitternoads_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

