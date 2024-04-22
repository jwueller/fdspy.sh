TOOL_SRC_DIR := tools/src
TOOL_BIN_DIR := tools/bin

# Automatically list all C files in the source directory and derive corresponding binaries
TOOL_SOURCES := $(wildcard $(TOOL_SRC_DIR)/*.c)
TOOL_TARGETS := $(patsubst $(TOOL_SRC_DIR)/%.c,$(TOOL_BIN_DIR)/%,$(TOOL_SOURCES))

.PHONY: all clean test tools

all: test

clean:
	rm -f $(TOOL_TARGETS)

test:
	shellspec

tools: $(TOOL_TARGETS)

$(TOOL_BIN_DIR)/%: $(TOOL_SRC_DIR)/%.c
	$(CC) $(CFLAGS) -o $@ $<
