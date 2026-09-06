# OpenROAD Full Top Partial Run

Design: matmul_16x16  
Platform: Nangate45  
Clock target: 10 ns  

Status: Partial OpenROAD run.

The full matmul_16x16 design passed earlier stages and reached clock tree synthesis.
During CTS, OpenROAD reported no setup violations and no hold violations, but the run ended with:

child killed: illegal instruction

This is recorded as a partial OpenROAD result, not a completed routed/signoff ASIC result.
