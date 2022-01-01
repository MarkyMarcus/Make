CC			:= clang
LD			:= ld
RM			:= rm
MKDIR		:= mkdir
WFLAGS		:= -Wall
SYSROOT		:= $(shell xcrun --show-sdk-path --sdk macosx)
VERSION		:= $(shell xcrun --show-sdk-version --sdk macosx)
CFLAGS		+= -isysroot $(SYSROOT) -I include
LDFLAGS		+= -syslibroot $(SYSROOT) -lSystem
SUBPROJS	:= Lib1
BUILDDIR	:= build
EXPORTDIR	:= export
BASEDIR		:= $(CURDIR)

.PHONY: clean all

define CREATE_RULES
	NAME		:= 
	HEADERS		:=
	SOURCES		:=
	EXPDIR		:=
	BLDDIR		:=
	OBJECTS		:=

    $(if $(1), include $(1)/rules.mk, include rules.mk)

    NAME		?= $(notdir $(abspath $1))
    HEADERS		:= $(if $(1), $(wildcard $(1)/include/*.h), $(wildcard include/*.h))
    SOURCES		:= $(if $(1), $(wildcard $(1)/src/*.c), $(wildcard src/*.c))
    EXPDIR		:= $(EXPORTDIR)/$$(NAME)
    BLDDIR		:= $(BUILDDIR)/$$(NAME)
    OBJECTS		:= $$(SOURCES:%.c=$$(BLDDIR)/%.o)

    all: $$(EXPDIR)/$$(NAME)

    foo:
		echo $$(NAME)
		echo $$(HEADERS)
		echo $$(SOURCES)
		echo $$(EXPDIR)
		echo $$(BLDDIR)
		echo $(1)
		echo $$(OBJECTS)

    $$(EXPDIR)/$$(NAME): $$(OBJECTS) $$(HEADERS) $$(EXPDIR)
		$(call PRINT, LINK, $$@)
		$$(LD) $$(LDFLAGS) -o $$@ $$(OBJECTS)

    $$(BLDDIR)/%.o: %.c $$(HEADERS) $$(BLDDIR)/src
		$(call PRINT, CC, $$@)
		$$(CC) -c $$(CFLAGS) -o $$@ $$<

    $$(BLDDIR)/src:
		$(call PRINT, MKDIR, $$@)
		$(MKDIR) -p $$@

    $$(EXPDIR):
		$(call PRINT, MKDIR, $$@)
		$(MKDIR) -p $$@
endef

define PRINT
	@echo "$1\t$2"
endef

$(eval $(call CREATE_RULES))

$(foreach PROJ,$(SUBPROJS),\
    $(eval $(call CREATE_RULES,$(PROJ))))

clean:
	$(call PRINT, CLEAN)
	$(RM) -rf $(BUILDDIR) $(EXPORTDIR)

print-%:
	@echo $*=$($*)

$(V).SILENT:

