ARCHS = armv7 arm64
include theos/makefiles/common.mk
export GO_EASY_ON_ME=1	

TWEAK_NAME = HermesSkype
HermesSkype_FILES = Tweak.xm
HermesSkype_FRAMEWORKS = UIKit
HermesSkype_PRIVATE_FRAMEWORKS = BackBoardServices
HermesSkype_CFLAGS=-fobjc-arc
HermesSkype_LIBRARIES=objcipc
HermesSkype_LDFLAGS=-Objc++

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
