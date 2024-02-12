#!/usr/bin/env bash
wget https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz
tar -xf gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz

mv gcc* gcc
rm *.xz

CC=gcc/bin/arm-linux-gnueabihf-gcc
CXX=gcc/bin/arm-linux-gnueabihf-g++

git clone https://github.com/llvm/llvm-project --depth 1 -b release/15.x
mkdir -p llvm-project/bhost
mkdir -p llvm-project/build

cd llvm-project/bhost
cmake -G Ninja ./llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="ARM;X86" -DLLVM_ENABLE_PROJECTS="lld;clang;compiler-rt"
ninja -j4

echo $GITHUB_WORKSPACE


#cmake -G Ninja ../llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="ARM;X86" -DLLVM_DEFAULT_TARGET_TRIPLE=arm-linux-gnueabihf -DLLVM_TARGET_ARCH=ARM -DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX -DLLVM_ENABLE_PIC=False -DLLVM_ENABLE_PROJECTS="lld;clang;compiler-rt" -DLLVM_TABLEGEN=llvm-project/bhost/bin/llvm-tblgen -DCLANG_TABLEGEN=llvm-project/bhost/bin/clang-tblgen -DLLVM_PARALLEL_LINK_JOBS=1 -DLLVM_BUILD_LLVM_DYLIB=On -DLLVM_LINK_LLVM_DYLIB=On -DLLVM_INSTALL_TOOLCHAIN_ONLY=On -DCMAKE_INSTALL_PREFIX=arm-install 