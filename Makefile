ARCHS = armv7 arm64
include theos/makefiles/common.mk
export THEOS_PACKAGE_DIR_NAME=debs

TWEAK_NAME = Hermes
Hermes_FILES = Tweak.xm
Hermes_FRAMEWORKS = UIKit CoreGraphics QuartzCore MobileCoreServices MediaPlayer AudioToolbox MessageUI CoreTelephony Foundation Security
Hermes_PRIVATE_FRAMEWORKS = AppSupport ChatKit CoreTelephony XPCKit IMCore BackBoardServices
Hermes_CFLAGS = -fobjc-arc
Hermes_LDFLAGS=-Objc++
#Hermes_CODE_SIGN_ENTITLEMENTS=Hermes.entitlements
Hermes_LIBRARIES=objcipc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard; killall -9 Messages; killall -9 backboardd"
SUBPROJECTS += Settings
SUBPROJECTS += Daemon
SUBPROJECTS += Kik
include $(THEOS_MAKE_PATH)/aggregate.mk
