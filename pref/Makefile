ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = TNAPref
TNAPref_FILES = $(wildcard *.m)
TNAPref_INSTALL_PATH = /Library/PreferenceBundles
TNAPref_PRIVATE_FRAMEWORKS = Preferences
TNAPref_EXTRA_FRAMEWORKS = libhdev
TNAPref_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/TNAPref.plist$(ECHO_END)
