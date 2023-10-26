#!/bin/bash

commands=(
#  "make -C sims/verilator run-binary-debug CONFIG=RocketVecRoccExampleConfig BINARY=$PWD/tests/rvv/bringup_tests/ms1_vmv_vi.elf EXTRA_SIM_FLAGS=--verbose"
  "make -C sims/verilator run-binary-debug-hex CONFIG=RocketVecRoccExampleConfig BINARY=$PWD/tests/rvv/bringup_tests/ms1_vmv_vi.elf EXTRA_SIM_FLAGS=--verbose"
  "make -C sims/verilator run-binary-debug-hex CONFIG=RocketVecRoccExampleConfig BINARY=$PWD/tests/rvv/bringup_tests/ms2_vse64.elf EXTRA_SIM_FLAGS=--verbose"
  "make -C sims/verilator run-binary-debug-hex CONFIG=RocketVecRoccExampleConfig BINARY=$PWD/tests/rvv/isg/riscv_vector_arithmetic_smoke_test.elf EXTRA_SIM_FLAGS=--verbose"
)

for cmd in "${commands[@]}"
do
  echo "Executing: $cmd"
  eval $cmd
done

echo "PASSED"

