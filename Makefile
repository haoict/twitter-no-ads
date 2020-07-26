ARCHS = arm64 arm64e
TARGET = iphone:clang:12.2:10.0
INSTALL_TARGET_PROCESSES = Twitter Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = twitternoads
twitternoads_FILES = $(wildcard *.xm *.m)
twitternoads_EXTRA_FRAMEWORKS = libhdev
twitternoads_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += pref

include $(THEOS_MAKE_PATH)/aggregate.mk
