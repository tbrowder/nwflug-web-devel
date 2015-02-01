PROGS   := on-server-copy-websites   on-server-copy-httpdconf
SRC     := $(patsubst %, %.c, $(PROGS))
SHPROGS := $(patsubst %, %.sh, $(PROGS))

BITS := 64

all: $(PROGS)

%: %.c
	gcc -m$(BITS) -o $@ $<

clean:
	-rm -f $(PROGS)

xfer:
	scp $(PROGS) $(SHPROGS) am1:
