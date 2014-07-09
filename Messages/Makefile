ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = HermesMessages
HermesMessages_FILES = Tweak.xm
HermesMessages_FRAMEWORKS = UIKit CoreGraphics MessageUI CoreTelephony Foundation Security
HermesMessages_PRIVATE_FRAMEWORKS = AppSupport ChatKit CoreTelephony IMCore BackBoardServices
HermesMessages_CFLAGS = -fobjc-arc
HermesMessages_LDFLAGS=-Objc++
HermesMessages_LIBRARIES=objcipc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
