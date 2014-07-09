ARCHS = armv7 arm64
include theos/makefiles/common.mk
export GO_EASY_ON_ME=1

TWEAK_NAME = HermesKik
HermesKik_FILES = Tweak.xm
HermesKik_FRAMEWORKS = UIKit
HermesKik_PRIVATE_FRAMEWORKS = BackBoardServices
HermesKik_CFLAGS=-fobjc-arc
HermesKik_LIBRARIES=objcipc
Hermes_LDFLAGS=-Objc++

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
