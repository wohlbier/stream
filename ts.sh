#!/bin/bash
export PATH=$PET_HOME/pkgs/threadspotter-1.3.10/bin:$PATH
sample_ts -r ./stream_f.exe
report_ts -i sample.smp
view-static_ts -i report.tsr
