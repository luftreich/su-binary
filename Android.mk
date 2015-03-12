LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := su
LOCAL_SRC_FILES := su.c db.c activity.c utils.c

LOCAL_STATIC_LIBRARIES := \
    liblog \
    libc \

LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng debug
LOCAL_FORCE_STATIC_EXECUTABLE := true


SU_INSTALL_DIR := $(TARGET_OUT)/xbin
SU_BINARY := $(SU_INSTALL_DIR)/su
# taken from busybox-android
$(SU_BINARY)-post: su
	@echo "Setting SUID/GUID to su-binary..."
	chmod ug+s $(TARGET_OUT_OPTIONAL_EXECUTABLES)/su

SU_CMD := su
SYMLINKS := $(addprefix $(TARGET_OUT_EXECUTABLES)/,$(SU_CMD))
$(SYMLINKS): $(LOCAL_INSTALLED_MODULE) $(SU_BINARY)-post $(LOCAL_PATH)/Android.mk
	@echo "Symlink: $@ -> /system/xbin/$(SU_CMD)"
	@mkdir -p $(dir $@)
	@rm -rf $@
	@ln -sf /system/xbin/$(SU_CMD) $@

ALL_DEFAULT_INSTALLED_MODULES += $(SU_BINARY)-post $(SYMLINKS)

include $(BUILD_EXECUTABLE)