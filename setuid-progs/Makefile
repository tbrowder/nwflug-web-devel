PROGS := on-server-copy-websites   on-server-copy-httpdconf
SRC   := $(patsubst %, %.c, $(PROGS))

BITS := 32

all: $(PROGS)

%: %.c
	gcc -m$(BITS) -o $@ $<

clean:
	-rm -f $(PROGS)
