ARCHS := arm64  # arm64e
TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES := TrollSpeed

include $(THEOS)/makefiles/common.mk

GIT_TAG_SHORT := $(shell git describe --tags --always --abbrev=0)
APPLICATION_NAME := TrollSpeed

TrollSpeed_USE_MODULES := 0
TrollSpeed_FILES += $(wildcard *.mm *.m)
TrollSpeed_FILES += $(wildcard *.swift)
TrollSpeed_CFLAGS += -fobjc-arc
TrollSpeed_CFLAGS += -Iinclude
TrollSpeed_CFLAGS += -include hud-prefix.pch
TrollSpeed_CCFLAGS += -DNOTIFY_LAUNCHED_HUD=\"ch.xxtou.notification.hud.launched\"
TrollSpeed_CCFLAGS += -DNOTIFY_DISMISSAL_HUD=\"ch.xxtou.notification.hud.dismissal\"
TrollSpeed_CCFLAGS += -DNOTIFY_RELOAD_HUD=\"ch.xxtou.notification.hud.reload\"
MainApplication.mm_CCFLAGS += -std=c++14
TrollSpeed_FRAMEWORKS += CoreGraphics QuartzCore UIKit
TrollSpeed_PRIVATE_FRAMEWORKS += BackBoardServices GraphicsServices IOKit SpringBoardServices
ifeq ($(TARGET_CODESIGN),ldid)
TrollSpeed_CODESIGN_FLAGS += -Sent.plist
else
TrollSpeed_CODESIGN_FLAGS += --entitlements ent.plist $(TARGET_CODESIGN_FLAGS)
endif

include $(THEOS_MAKE_PATH)/application.mk

after-stage::
	$(ECHO_NOTHING)mkdir -p packages $(THEOS_STAGING_DIR)/Payload$(ECHO_END)
	$(ECHO_NOTHING)cp -rp $(THEOS_STAGING_DIR)/Applications/TrollSpeed.app $(THEOS_STAGING_DIR)/Payload$(ECHO_END)
	$(ECHO_NOTHING)cd $(THEOS_STAGING_DIR); zip -qr TrollSpeed_${GIT_TAG_SHORT}.tipa Payload; cd -;$(ECHO_END)
	$(ECHO_NOTHING)mv $(THEOS_STAGING_DIR)/TrollSpeed_${GIT_TAG_SHORT}.tipa packages/TrollSpeed_${GIT_TAG_SHORT}.tipa $(ECHO_END)
