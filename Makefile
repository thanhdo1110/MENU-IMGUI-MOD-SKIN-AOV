THEOS_DEVICE_IP = 192.168.1.9
#export THEOS=/home/thanh/theos/
TARGET = iphone:latest
ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1
TARGET = iphone:latest:16.5
THEOS_PACKAGE_SCHEME = rootless
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = 34306jit
#If you want to change TWEAK_NAME just change up here. It will automatically change these below, don't need to change it by hand anymore!

$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation Security QuartzCore CoreGraphics CoreText AVFoundation Accelerate GLKit SystemConfiguration GameController MobileCoreServices UniformTypeIdentifiers
#$(TWEAK_NAME)_LDFLAGS += MODVIP/libmonostring.a
$(TWEAK_NAME)_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-value

#Add dobby hook

$(TWEAK_NAME)_FILES = ImGuiDrawView.mm config.mm $(wildcard Esp/*.mm) $(wildcard Esp/*.m) $(wildcard IMGUI/*.cpp) $(wildcard IMGUI/*.mm) $(wildcard mod/*.m) 
$(TWEAK_NAME)_LDFLAGS += SSZipArchive/lib.a
#$(TWEAK_NAME)_LIBRARIES += substrate
# GO_EASY_ON_ME = 1

include $(THEOS_MAKE_PATH)/tweak.mk