ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = HermesWhatsApp
HermesWhatsApp_FILES = Tweak.xm
HermesWhatsApp_FRAMEWORKS = UIKit
HermesWhatsApp_PRIVATE_FRAMEWORKS = BackBoardServices
HermesWhatsApp_CFLAGS = -fobjc-arc
HermesWhatsApp_LIBRARIES = objcipc
HermesWhatsApp_LDFLAGS = -Objc++

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
