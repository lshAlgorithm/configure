# Outcomes
## gprof
```shell
Flat profile:

Each sample counts as 0.01 seconds.
  %   cumulative   self              self     total           
 time   seconds   seconds    calls   s/call   s/call  name    
 65.04      3.87     3.87        2     1.94     2.98  func1
 34.96      5.95     2.08        1     2.08     2.08  new_func1


			Call graph


granularity: each sample hit covers 4 byte(s) for 0.17% of 5.95 seconds

index % time    self  children    called     name
                3.87    2.08       2/2           main [2]
[1]    100.0    3.87    2.08       2         func1 [1]
                2.08    0.00       1/1           new_func1 [3]
-----------------------------------------------
                                                 <spontaneous>
[2]    100.0    0.00    5.95                 main [2]
                3.87    2.08       2/2           func1 [1]
-----------------------------------------------
                2.08    0.00       1/1           func1 [1]
[3]     35.0    2.08    0.00       1         new_func1 [3]
-----------------------------------------------


Index by function name

   [1] func1                   [3] new_func1
```
> Just one case for brief.

## VTune
```shell
Elapsed Time: 6.455s
    CPU Time: 6.260s
        Effective Time: 6.260s
        Spin Time: 0s
        Overhead Time: 0s
    Total Thread Count: 1
    Paused Time: 0s

Top Hotspots
Function   Module    CPU Time  % of CPU Time(%)
---------  --------  --------  ----------------
func1      test_new    2.210s             35.3%
func2      test_new    2.040s             32.6%
new_func1  test_new    2.000s             31.9%
main       test_new    0.010s              0.2%
Effective Physical Core Utilization: 0.0% (0.000 out of 10)
 | The metric value is low, which may signal a poor physical CPU cores
 | utilization caused by:
 |     - load imbalance
 |     - threading runtime overhead
 |     - contended synchronization
 |     - thread/process underutilization
 |     - incorrect affinity that utilizes logical cores instead of physical
 |       cores
 | Explore sub-metrics to estimate the efficiency of MPI and OpenMP parallelism
 | or run the Locks and Waits analysis to identify parallel bottlenecks for
 | other parallel runtimes.
 |
    Effective Logical Core Utilization: 15.2% (1.818 out of 12)
     | The metric value is low, which may signal a poor logical CPU cores
     | utilization. Consider improving physical core utilization as the first
     | step and then look at opportunities to utilize logical cores, which in
     | some cases can improve processor throughput and overall performance of
     | multi-threaded applications.
     |
Collection and Platform Info
    Application Command Line: /home/brianlee/Documents/asc/SHU_CAE/exp06-profiler/test_new 
    Operating System: 6.8.8-300.fc40.x86_64 
    Computer Name: fedora
    Result Size: 3.8 MB 
    Collection start time: 05:27:57 22/08/2024 UTC
    Collection stop time: 05:28:04 22/08/2024 UTC
    Collector Type: Driverless Perf per-process counting,User-mode sampling and tracing
    CPU
        Name: Intel(R) microarchitecture code named Alderlake-P
        Frequency: 2.611 GHz
        Logical CPU Count: 12
        Cache Allocation Technology
            Level 2 capability: not detected
            Level 3 capability: not detected
```
* align with `gprof`
  > More to see in `./exp06_result/r001hs`

## Tips
* When encountered `error while loading shared libraries: *.so: cannot open shared object file: No such file or directory`, try to
  * `ldconfig -p | grep [name of the library]` to check if the library is installed in the system and the path is correct.
    * If not,`export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/the/library` to add the library path to the environment variable.
    * If there is something similar to `lib[name of the library].so`, try to link symbolically by `ln -s /path/to/the/library/lib[name of the library].so /usr/lib64/` or `ln -s /path/to/the/library/lib[name of the library].so /usr/lib/`.