ARCHS = armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = Hermes
Hermes_FILES = Hermes.mm
Hermes_INSTALL_PATH = /Library/PreferenceBundles
Hermes_FRAMEWORKS = UIKit CoreGraphics
Hermes_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Hermes.plist$(ECHO_END)
