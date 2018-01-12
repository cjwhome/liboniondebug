
# main compiler
CC := gcc
# CC := clang --analyze # and comment out the linker last line for sanity

# define the directories
SRCDIR := src
INCDIR := include
BUILDDIR := build
BINDIR := bin
LIBDIR := lib
PYLIBDIR := lib/python


# define common variables
SRCEXT := c
SOURCES := $(shell find $(SRCDIR) -maxdepth 1 -type f \( -iname "*.$(SRCEXT)" ! -iname "*main-*.$(SRCEXT)" \) )
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))
CFLAGS := -g -fPIC # -Wall
INC := $(shell find $(INCDIR) -maxdepth 1 -type d -exec echo -I {}  \;)

PYINC := "-I/usr/include/python2.7"
INC += $(PYINC)

# define specific binaries to create
# C libraries
LIBD := liboniondebug
SOURCE_LIBD := src/lib/onion-debug.$(SRCEXT)
OBJECT_LIBD := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCE_LIBD:.$(SRCEXT)=.o))
TARGET_LIBD := $(LIBDIR)/$(LIBD).so

all: resp $(TARGET_LIBD)


# libraries
$(TARGET_LIBD): $(OBJECT_LIBD)
	@echo " Compiling $@"
	@mkdir -p $(LIBDIR)
	$(CC) -shared -o $@  $^ $(LIB_LIBD)


# generic: build any object file required
$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(dir $@)
	@echo " $(CC) $(CFLAGS) $(INC) -c -o $@ $<"; $(CC) $(CFLAGS) $(INC) -c -o $@ $<

clean:
	@echo " Cleaning..."; 
	$(RM) -r $(BUILDDIR) $(BINDIR) $(LIBDIR)


resp:
	@echo "CC: $(CC)"
	@echo "CFLAGS: $(CFLAGS)"
	@echo "LDFLAGS: $(LDFLAGS)"
	@echo "LIB: $(LIB)"

# Spikes
#ticket:
#  $(CC) $(CFLAGS) spikes/ticket.cpp $(INC) $(LIB) -o bin/ticket

.PHONY: clean
