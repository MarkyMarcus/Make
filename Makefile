GLOBAL_CC           := clang
GLOBAL_LD           := ld
GLOBAL_RM           := rm
GLOBAL_MKDIR        := mkdir
GLOBAL_WFLAGS       := -Wall
GLOBAL_SYSROOT      := $(shell xcrun --show-sdk-path --sdk macosx)
GLOBAL_VERSION      := $(shell xcrun --show-sdk-version --sdk macosx)
GLOBAL_CFLAGS       += -isysroot $(GLOBAL_SYSROOT)
GLOBAL_LDFLAGS      += -syslibroot $(GLOBAL_SYSROOT) -lSystem
GLOBAL_WFLAGS       += -Werror
GLOBAL_BUILDDIR     := build
GLOBAL_EXPORTDIR    := export
GLOBAL_BASEDIR      := $(CURDIR)

define CREATE_PROGRAM
    NAME :=
    SOURCES :=
    HEADERS :=
    BUILDDIR :=
    TARGDIR :=

    include $(call APPENDPATH,$1,rules.mk)

    SOURCES := $(wildcard $(call APPENDPATH,$1,src)/*.c)
    HEADERS := $(wildcard $(call APPENDPATH,$1,include)/*.h)
    OBJECTS := $$(SOURCES:%.c=$(GLOBAL_BUILDDIR)/%.o)
    BUILDDIR := $(call APPENDPATH,$(GLOBAL_BUILDDIR),$1)
    TARGDIR := $(call APPENDPATH,$(GLOBAL_EXPORTDIR),$1)
    CFLAGS := $(GLOBAL_CFLAGS) -I $(call APPENDPATH,$1,include)

    $(GLOBAL_EXPORTDIR)/$$(NAME): $$(OBJECTS) $$(HEADERS) $$(TARGDIR)
		$(call PRINT, LINK, $$@)
		$(GLOBAL_LD) $(GLOBAL_LDFLAGS) -o $$@ $$(OBJECTS)

    $$(BUILDDIR)/src/%.o: $(call APPENDPATH,$1,src)/%.c $$(BUILDDIR)/src
		$(call PRINT, CC, $$@)
		$(GLOBAL_CC) -c $$(CFLAGS) -o $$@ $$<

    $$(BUILDDIR)/src: $$(BUILDDIR)
		$(call PRINT, MKDIR, $$@)
		$(GLOBAL_MKDIR) -p $$@

    $$(BUILDDIR):
		$(call PRINT, MKDIR, $$@)
		$(GLOBAL_MKDIR) -p $$@

    $$(TARGDIR):
		$(call PRINT, MKDIR, $$@)
		$(GLOBAL_MKDIR) -p $$@
endef

define CREATE_LIBRARY
    NAME :=

    include $(call APPENDPATH,$1,rules.mk)

    SOURCES := $(wildcard $(call APPENDPATH,$1,src)/*.c)
    HEADERS := $(wildcard $(call APPENDPATH,$1,include)/*.h)

endef

define CREATE_RULES
    TYPE :=

    include $(call APPENDPATH,$1,rules.mk)

    #$$(if $$(findstring $$(TYPE),Program),$(eval $(call CREATE_PROGRAM,$1)),)
    $$(if $$(findstring $$(TYPE),Library),$(eval $(call CREATE_LIBRARY,$1)),)
endef

define PRINT
    @echo "$1\t$2"
endef

define APPENDPATH
$(if $1,$(if $2,$1/$2,$1),$2)
endef

.PHONY: clean all

$(eval $(call CREATE_RULES,Lib1))

foo:
	@echo $(call APPENDPATH,test,)
	@echo $(call APPENDPATH,test,tmp)
	@echo $(call APPENDPATH,test,tmp/tmp)
	@echo $(findstring "foo","foo")

clean:
	$(call PRINT, CLEAN)
	$(RM) -rf $(GLOBAL_BUILDDIR) $(GLOBAL_EXPORTDIR)

print-%:
	@echo $*=$($*)

$(V).SILENT:
