C_SRC := ./src
C_INC := ./include

BUILD_DIR := ./build
SRCS = $(C_SRC)/client.c \
       $(C_SRC)/server.c \
       $(C_SRC)/src_cli_fifo.c \
       $(C_SRC)/utils.c 

OBJS = $(patsubst $(C_SRC)/%.c, $(BUILD_DIR)/%.o, $(SRCS))
CC := gcc

CFLAGS :=
LDFLAGS := -o 
test: $(OBJS)
	echo "compiled succ"
# Target to build the server executable
Server: $(OBJS) $(C_INC)
	$(CC)  $(BUILD_DIR)/server.o $(BUILD_DIR)/src_cli_fifo.o $(BUILD_DIR)/utils.o -I$(C_INC) -o server
Client: $(OBJS) $(C_INC)
	$(CC)  $(BUILD_DIR)/client.o $(BUILD_DIR)/src_cli_fifo.o $(BUILD_DIR)/utils.o -I$(C_INC) -o client


# Rule to compile .c files to .o files in the build directory
$(OBJS): ./build/%.o: $(C_SRC)/%.c
	$(CC)  -I$(C_INC) -c $< -o $@

# Create the build directory if it doesn't exist


.PHONY: clean
clean:
	rm  $(BUILD_DIR)/*

# Installation target
install: Server
	@if [ -w "/usr/local/bin/" ]; then \
		install $(BUILD_DIR)/Server /usr/local/bin/scheduler; \
		echo "Installation successful!"; \
	else \
		echo "Error: Insufficient privileges to install in /usr/local/bin/. Please run 'make install' with elevated privileges (sudo)."; \
		exit 1; \
	fi
