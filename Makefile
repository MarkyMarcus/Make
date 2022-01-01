CC			:= clang
LD			:= ld
RM			:= rm
MKDIR		:= mkdir
WFLAGS		:= -Wall
SYSROOT		:= $(shell xcrun --show-sdk-path --sdk macosx)
VERSION		:= $(shell xcrun --show-sdk-version --sdk macosx)
CFLAGS		+= -isysroot $(SYSROOT) -I include
LDFLAGS		+= -syslibroot $(SYSROOT) -lSystem
BUILDDIR	:= build
EXPORTDIR	:= export
BASEDIR		:= $(CURDIR)

.PHONY: clean all

define CREATE_RULES
	TGT_NAME		:= 
	TGT_HEADERS		:=
	TGT_SOURCES		:=
	TGT_EXPDIR		:=
	TGT_BLDDIR		:=
	TGT_OBJECTS		:=
	TGT_LDFLAGS		:=
	TGT_CFLAGS		:=
    TGT_SUBPROJS    :=

    $(if $(1), include $(1)/rules.mk, include rules.mk)

    TGT_HEADERS		:= $(if $(1), $(wildcard $(1)/include/*.h), $(wildcard include/*.h))
    TGT_SOURCES		:= $(if $(1), $(wildcard $(1)/src/*.c), $(wildcard src/*.c))
    TGT_EXPDIR		:= $(EXPORTDIR)/$$(TGT_NAME)
    TGT_BLDDIR		:= $(BUILDDIR)/$$(TGT_NAME)
    TGT_OBJECTS		:= $$(TGT_SOURCES:%.c=$$(TGT_BLDDIR)/%.o)
    TGT_LDFLAGS     := $(LDFLAGS) $$(TGT_LDFLAGS)
    TGT_CFLAGS      := $(CFLAGS) $$(TGT_CFLAGS)

    all: $$(TGT_EXPDIR)/$$(TGT_NAME)

    $$(TGT_NAME)_foo:
		@echo $$(TGT_NAME)
		@echo $$(TGT_HEADERS)
		@echo $$(TGT_SOURCES)
		@echo $$(TGT_EXPDIR)
		@echo $$(TGT_BLDDIR)
		@echo $(1)
		@echo $$(TGT_OBJECTS)

    $$(TGT_EXPDIR)/$$(TGT_NAME): $$(TGT_OBJECTS) $$(TGT_HEADERS) $$(TGT_EXPDIR)
		$(call PRINT, LINK, $$@)
		$$(LD) $$(TGT_LDFLAGS) -o $$@ $$(TGT_OBJECTS)

    $$(TGT_BLDDIR)/%.o: %.c $$(TGT_HEADERS) $$(TGT_BLDDIR)/src
		$(call PRINT, CC, $$@)
		$$(CC) -c $$(TGT_CFLAGS) -o $$@ $$<

    $$(TGT_BLDDIR)/src:
		$(call PRINT, MKDIR, $$@)
		$(MKDIR) -p $$@

    $$(TGT_EXPDIR):
		$(call PRINT, MKDIR, $$@)
		$(MKDIR) -p $$@

    $(foreach PROJ,$$(TGT_SUBPROJS),\
        $(eval $(call CREATE_RULES,$(PROJ))))
endef

define PRINT
	@echo "$1\t$2"
endef

$(eval $(call CREATE_RULES))

clean:
	$(call PRINT, CLEAN)
	$(RM) -rf $(BUILDDIR) $(EXPORTDIR)

print-%:
	@echo $*=$($*)

$(V).SILENT:

