CC = gcc
CFLAGS = -Wall -Wextra -Wpedantic -Werror -g
CPPFLAGS = -Iinclude

SAN_FLAGS = -fsanitize=address,undefined,leak

SRC_DIR = src
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj

BIN = $(BUILD_DIR)/bin/hello-c

SRCS = $(shell find $(SRC_DIR)/ -type f -name "*.c")
OBJS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRCS))

.PHONY: all run debug_build format tidy clean

all: $(BIN)

run: $(BIN)
	$(BIN)

$(BIN): $(OBJS)
	mkdir -p $(@D)

ifeq "$(DEBUG)" "YES"
	$(CC) $(CFLAGS) $(CPPFLAGS) $(SAN_FLAGS) $(OBJS) -o $(BIN)_debug
endif

	$(CC) $(CFLAGS) $(CPPFLAGS) $(OBJS) -o $(BIN)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

format:
	clang-format -i $(SRCS) $(wildcard include/*.h)

tidy:
	clang-tidy $(SRCS) -checks='bugprone-*,readability-*,modernize-*' -- $(CPPFLAGS)

clean:
	rm -rf build
