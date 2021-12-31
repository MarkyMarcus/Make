NAME		:= main
CC			:= clang
LD			:= ld
RM			:= rm
HEADERS		= $(wildcard include/*.h)
SOURCES		= $(wildcard src/*.c)
OBJECTS		= $(addprefix $(BUILDDIR)/, $(SOURCES:.c=.o))
WFLAGS		= -Wall
SYSROOT		= $(shell xcrun --show-sdk-path --sdk macosx)
VERSION		= $(shell xcrun --show-sdk-version --sdk macosx)
CFLAGS		+= -isysroot $(SYSROOT) -I include
LDFLAGS		+= -syslibroot $(SYSROOT) -lSystem
SUBPROJ		+= Lib1 Lib2
BUILDDIR	= build
EXPORTDIR	= export

all: $(NAME)

$(NAME): $(OBJECTS) $(HEADERS) $(EXPORTDIR)
	$(call print, LINK, $@)
	$(LD) $(LDFLAGS) -o $(EXPORTDIR)/$@ $(OBJECTS)

$(BUILDDIR)/%.o: %.c $(HEADERS) $(BUILDDIR)/src
	$(call print, CC, $@)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILDDIR)/src:
	$(call print, MKDIR, $@)
	mkdir -p $@

$(EXPORTDIR):
	$(call print, MKDIR, $@)
	mkdir -p $@

.PHONY: clean all

clean:
	$(call print, CLEAN)
	$(RM) -rf $(BUILDDIR) $(EXPORTDIR)

print-%:
	@echo $*=$($*)

define print
	@echo "$1\t$2"
endef

$(V).SILENT:
