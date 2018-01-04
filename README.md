The stream benchmark with modifications and performance engineering
annotations.

Using uncore imc counters to count memory traffic and compare the results
to the stream measured value.

Using Tau manual istrumentation to measure the same uncore counters and compare
the results.

Triad.
Stream measured: 16339 MiB/s
Uncore counted:  16575 MiB/s
Tau measured:    16554 MiB/s

All within 1.5%.
