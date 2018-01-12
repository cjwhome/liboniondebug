
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

LIB0 := libonioni2c
SOURCE_LIB0 := src/lib/onion-i2c.$(SRCEXT)
OBJECT_LIB0 := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCE_LIB0:.$(SRCEXT)=.o))
TARGET_LIB0 := $(LIBDIR)/$(LIB0).so
LIB_LIB0 := -L$(LIBDIR) -loniondebug


all: resp $(TARGET_LIBD) $(TARGET_LIB0)


# libraries
$(TARGET_LIBD): $(OBJECT_LIBD)
	@echo " Compiling $@"
	@mkdir -p $(LIBDIR)
	$(CC) -shared -o $@  $^ $(LIB_LIBD)

$(TARGET_LIB0): $(OBJECT_LIB0)
	@echo " Compiling $@"
	@mkdir -p $(LIBDIR)
	$(CC) -shared -o $@  $^ $(LIB_LIB0)

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

# Tests
tester:
	$(CC) $(CFLAGS) test/tester.cpp $(INC) $(LIB) -o bin/tester

# Spikes
#ticket:
#  $(CC) $(CFLAGS) spikes/ticket.cpp $(INC) $(LIB) -o bin/ticket

.PHONY: clean
