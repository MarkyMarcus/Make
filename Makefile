GLOBAL_CC			:= clang
GLOBAL_LD			:= ld
GLOBAL_RM			:= rm
GLOBAL_MKDIR		:= mkdir
GLOBAL_WFLAGS		:= -Wall
GLOBAL_SYSROOT		:= $(shell xcrun --show-sdk-path --sdk macosx)
GLOBAL_VERSION		:= $(shell xcrun --show-sdk-version --sdk macosx)
GLOBAL_CFLAGS		+= -isysroot $(GLOBAL_SYSROOT) -I include
GLOBAL_LDFLAGS		+= -syslibroot $(GLOBAL_SYSROOT) -lSystem
GLOBAL_WFLAGS		+= -Werror
GLOBAL_BUILDDIR		:= build
GLOBAL_EXPORTDIR	:= export
GLOBAL_BASEDIR		:= $(CURDIR)

.PHONY: clean all

define CREATE_RULES
    include $(1)/rules.mk

    ifeq "$$(NAME)" ""
        $$(error NAME must be defined in $(1)/rules.mk)
    endif

    ifeq "$$(TYPE)" ""
        $$(error TYPE must be defined in $(1)/rules.mk)
    endif

    HEADERS		:= $(wildcard $(1)/include/*.h)
    SOURCES		:= $(wildcard $(1)/src/*.c)
    EXPORTDIR	:= $(GLOBAL_EXPORTDIR)/$$(NAME)
    BUILDDIR	:= $(GLOBAL_BUILDDIR)/$$(NAME)
    OBJECTS		:= $$(SOURCES:./%.c=$$(BUILDDIR)/%.o)
    LDFLAGS		:= $(GLOBAL_LDFLAGS) $$(LDFLAGS)
    CFLAGS		:= $(GLOBAL_CFLAGS) $$(CFLAGS)
    WFLAGS		:= $(GLOBAL_WFLAGS) $$(WFLAGS)

    ifeq "$$(TYPE)" "Program"
        BINNAME	:= $$(NAME)
    endif

    ifeq "$$(TYPE)" "SharedLibrary"
        BINNAME	:= lib$$(NAME).dylib
    endif

    ifeq "$$(TYPE)" "StaticLibrary"
        BINNAME	:= lib$$(NAME).a
    endif

    ifeq "$(1)" "."
        all: $$(EXPORTDIR)/$$(BINNAME)
    endif

    $$(EXPORTDIR)/$$(BINNAME): $$(OBJECTS) $$(HEADERS) $$(EXPORTDIR)
		$(call PRINT, LINK, $$@)
		$$(GLOBAL_LD) $$(LDFLAGS) -o $$@ $$(OBJECTS)

    $$(BUILDDIR)/%.o: %.c $$(HEADERS) $$(BUILDDIR)/src
		$(call PRINT, CC, $$@)
		$$(GLOBAL_CC) -c $$(CFLAGS) -o $$@ $$<

    $$(BUILDDIR)/src:
		$(call PRINT, MKDIR, $$@)
		$(GLOBAL_MKDIR) -p $$@

    $$(EXPORTDIR):
		$(call PRINT, MKDIR, $$@)
		$(GLOBAL_MKDIR) -p $$@

    $(foreach PROJ,$(SUBPROJS), $(eval $(call CREATE_RULES,$(PROJ))))
endef

define PRINT
	@echo "$1\t$2"
endef

$(eval $(call CREATE_RULES,.))

clean:
	$(call PRINT, CLEAN)
	$(RM) -rf $(BUILDDIR) $(EXPORTDIR)

print-%:
	@echo $*=$($*)

$(V).SILENT:

