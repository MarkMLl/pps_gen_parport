THIS IS UPLOADED FOR THE PURPOSE OF DISCUSSION ONLY.

This builds and installs using DKMS, debugging messages show the expected
control flow but there is no physical output.

-----

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

