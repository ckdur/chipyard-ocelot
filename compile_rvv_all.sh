#!/bin/bash
set -e

export LLVM=$PWD/llvm-EPI-0.7-development-toolchain-cross
export PATH=$PATH:$LLVM/bin

# Get the toolchain if necessary
if ! test -f ${LLVM}/bin/clang; then
  if ! test -f llvm-EPI-0.7-development-toolchain-cross-latest.tar.bz2; then
    wget https://ssh.hca.bsc.es/epi/ftp/llvm-EPI-0.7-development-toolchain-cross-latest.tar.bz2
  fi
  tar -xvf llvm-EPI-0.7-development-toolchain-cross-latest.tar.bz2
fi

# Compile the riscv-vectorized-benchmark, just for health checks
#git submodule update --init --recursive tests/rvv/riscv-vectorized-benchmark-suite
export RVSUITE=$PWD/tests/rvv/riscv-vectorized-benchmark-suite
# make -C tests/rvv/riscv-vectorized-benchmark-suite all

# Get sure wt got the riscv-tests
RVTESTS=$PWD/toolchains/riscv-tools/riscv-tests
git submodule update --init --recursive toolchains/riscv-tools/riscv-tests

# Setup the compile environment
CFLAGS="-march=rv64g -mabi=lp64d -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -O2 -ffast-math -fno-common -fno-builtin-printf -O2 -I${RVTESTS}/env -I${RVSUITE} -I${RVSUITE}/_axpy/src"
LDFLAGS="-march=rv64g -mabi=lp64d -static -nostdlib -nostartfiles -O2 -lm -lc -T ${PWD}/tests/rvv/bringup_tests/bobcat_linker.ld"
#${PWD}/tests/rvv/bringup_tests/bobcat_linker.ld
#${RVTESTS}/benchmarks/common/test.ld

# Compile the axpy
AXPY=${RVSUITE}/_axpy
riscv64-unknown-elf-gcc ${CFLAGS} -fno-tree-loop-distribute-patterns -c -o ${RVTESTS}/benchmarks/common/crt.o ${RVTESTS}/benchmarks/common/crt.S
riscv64-unknown-elf-gcc ${CFLAGS} -fno-tree-loop-distribute-patterns -c -o ${RVTESTS}/benchmarks/common/syscalls.o ${RVTESTS}/benchmarks/common/syscalls.c
riscv64-unknown-elf-gcc ${CFLAGS} -fno-tree-loop-distribute-patterns -c -o ${PWD}/tests/rvv/sbrk.o ${PWD}/tests/rvv/sbrk.c
riscv64-unknown-elf-gcc ${CFLAGS} -fno-tree-loop-distribute-patterns -c -o ${PWD}/tests/rvv/gettimeofday.o ${PWD}/tests/rvv/gettimeofday.c
${LLVM}/bin/clang --target=riscv64-unknown-elf ${CFLAGS} -c -o ${AXPY}/src/utils.o ${AXPY}/src/utils.c
${LLVM}/bin/clang --target=riscv64-unknown-elf ${CFLAGS} -mepi -DUSE_RISCV_VECTOR -fno-vectorize -c -o ${AXPY}/src/axpy.o ${AXPY}/src/axpy.c
${LLVM}/bin/clang --target=riscv64-unknown-elf ${CFLAGS} -O2 -c -o ${AXPY}/src/main.o ${AXPY}/src/main.c
riscv64-unknown-elf-gcc ${CFLAGS} -o ${AXPY}/bin/axpy_vector.exe ${RVTESTS}/benchmarks/common/crt.o ${RVTESTS}/benchmarks/common/syscalls.o ${AXPY}/src/*.o ${PWD}/tests/rvv/*.o ${LDFLAGS}
rm ${AXPY}/src/*.o
${LLVM}/bin/llvm-objdump  --mattr=+m,+f,+d,+a,+c,+experimental-v -ds  ${AXPY}/bin/axpy_vector.exe > ${AXPY}/bin/axpy_vector.dump

# Compile the "other" axpy
KERNEL_AXPY=$PWD/tests/rvv/kernels/_axpy
${LLVM}/bin/clang --target=riscv64-unknown-elf ${CFLAGS} -c -o ${KERNEL_AXPY}/src/utils.o ${KERNEL_AXPY}/src/utils.c
${LLVM}/bin/clang --target=riscv64-unknown-elf ${CFLAGS} -mepi -DUSE_RISCV_VECTOR -fno-vectorize -c -o ${KERNEL_AXPY}/src/axpy.o ${KERNEL_AXPY}/src/axpy.c
${LLVM}/bin/clang --target=riscv64-unknown-elf ${CFLAGS} -O2 -c -o ${KERNEL_AXPY}/src/main.o ${KERNEL_AXPY}/src/main.c
riscv64-unknown-elf-gcc ${CFLAGS} -o ${KERNEL_AXPY}/bin/axpy_vector.exe ${RVTESTS}/benchmarks/common/crt.o ${RVTESTS}/benchmarks/common/syscalls.o ${KERNEL_AXPY}/src/*.o ${PWD}/tests/rvv/*.o ${LDFLAGS}
rm ${KERNEL_AXPY}/src/*.o
${LLVM}/bin/llvm-objdump  --mattr=+m,+f,+d,+a,+c,+experimental-v -ds  ${KERNEL_AXPY}/bin/axpy_vector.exe > ${KERNEL_AXPY}/bin/axpy_vector.dump

# Compile the individual S files
$PWD/compile_rvv.sh ./tests/rvv/bringup_tests/ms1_vmv_vi.S

