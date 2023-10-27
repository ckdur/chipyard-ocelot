#!/bin/bash

commands=(
  "make -C sims/verilator run-binary-debug-hex CONFIG=RocketVecRoccExampleConfig BINARY=$PWD/tests/rvv/bringup_tests/ms1_vmv_vi.elf EXTRA_SIM_FLAGS=--verbose"
#  "make -C sims/verilator run-binary-debug-hex CONFIG=RocketVecRoccExampleConfig BINARY=$PWD/tests/rvv/bringup_tests/ms2_vse64.elf EXTRA_SIM_FLAGS=--verbose"
#  "make -C sims/verilator run-binary-debug-hex CONFIG=RocketVecRoccExampleConfig BINARY=$PWD/tests/rvv/isg/riscv_vector_arithmetic_smoke_test.elf EXTRA_SIM_FLAGS=--verbose"
#  "make -C sims/verilator run-binary-debug-hex CONFIG=SmallBobcatConfig BINARY=$PWD/tests/rvv/kernels/axpy/axpy-vector.elf SIM_FLAGS=+cosim"
#  "make -C sims/verilator run-binary-debug-hex CONFIG=RocketVecRoccExampleConfig BINARY=$PWD/tests/rvv/kernels/axpy/axpy-vector.elf EXTRA_SIM_FLAGS=--verbose"
#  "make -C sims/verilator run-binary-debug-hex CONFIG=RocketVecRoccExampleConfig BINARY=$PWD/tests/rvv/riscv-vectorized-benchmark-suite/_axpy/bin/axpy_vector.exe EXTRA_SIM_FLAGS=--verbose"
  "make -C sims/verilator run-binary-debug-hex CONFIG=RocketVecRoccExampleConfig BINARY=$PWD/tests/rvv/kernels/_axpy/bin/axpy_vector.exe EXTRA_SIM_FLAGS=--verbose"
)

for cmd in "${commands[@]}"
do
  echo "Executing: $cmd"
  eval $cmd
done

echo "PASSED"

