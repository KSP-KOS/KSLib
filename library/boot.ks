SWITCH TO 1.
DELETE boot.ks.
SWITCH TO 0.
COPY progpan.ks TO 1.
COPY ytosun.ks TO 1.
COPY nod2.ks TO 1.
SWITCH TO 1.

PRINT "booted up thanks!".
PRINT "here are the files I loaded for you:".
LIST FILES.