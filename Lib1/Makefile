NAME	:= lib1
CC		:= clang
LD		:= ld
RM		:= rm
HEADERS = $(wildcard include/*.h)
SOURCES = $(wildcard src/*.c)
OBJECTS = $(SOURCES:.c=.o)
WFLAGS	= -Wall
SYSROOT = $(shell xcrun --show-sdk-path --sdk macosx)
VERSION	= $(shell xcrun --show-sdk-version --sdk macosx)
CFLAGS	+= -isysroot $(SYSROOT) -I include
LDFLAGS += -syslibroot $(SYSROOT) -lSystem -dylib

%.o: %.c $(HEADERS)
	$(call print, CC, $@)
	$(CC) -c $(CFLAGS) -o $@ $<

$(NAME): $(OBJECTS) $(HEADERS)
	$(call print, LINK, $@)
	$(LD) $(LDFLAGS) -o $@ $(OBJECTS)

.PHONY: clean

clean:
	$(call print, CLEAN)
	$(RM) -f $(NAME) $(OBJECTS)

print-%:
	@echo $*=$($*)

define print
	@echo "$1\t$2"
endef

$(V).SILENT:
