History:

The PPS generator facility was added in kernel 2.6.38.

pps_gen_parport-prepatch.c is from kernel 2.6.39 (i.e. the last in the 2.6
series) and is identical apart from the removal of a setting only relevant
to realtime kernels. It is confirmed to build successfully as a module for
kernel 2.6.39.

pps_gen_parport-unpatched.c is from kernel 4.19.181, and effectively has
0-timespec64.patch applied.

pps_gen_parport-patched.c also has 1-polarity.patch and 2-iterations.patch
applied, which in principle should bring the module to a state where is can
run reliably at least for short periods. It is confirmed to build successfully
as a module for kernel 4.19.181.

The maximum delay parameter has been increased to 333 mSec, i.e. entered as
333000000 since it is specified in nSec, and there are extra NEVER_CLEAR and
TOGGLE defines internally, in combination these can be used to make the physical
signal more visible during testing.

Recent testing has been minimal, and is in no way sufficient to suggest that
this facility no longer be considered BROKEN by the kernel maintainers. But it
does work, at least for relatively short test runs.

I've also been looking at https://github.com/twteamware/raspberrypi-ptp which
is closely-related code, and used that to improve my understanding of what's
happening here. I mention this primarily because it has the major weakness
that there is no error message if it can't find an appropriate entry in the
device tree... in the longer term I might try to reconcile the two sources.

