# Custom C++ Toolchain Examples

This repository contains the example code used in the Custom C++ Toolchains talk at BazelCon 2019,
slides can be found [here](https://docs.google.com/presentation/d/1M9n2_qOYYTm4a98SB-AmLeTlNErQTy9JfKsop0gWsoo/edit?usp=sharing).

## Custom Linux Toolchain

There are two Linux toolchains, one for gcc and clang respectively. They are defined in the `BUILD` file at the root of the repo.

Try it out:
```
# GCC
bazel build //main/... --crosstool_top //:toolchain --cpu=k8-gcc

# Clang
bazel build //main/... --crosstool_top //:toolchain --cpu=k8-clang
```

## Custom Android Toolchain

If you're working with non-standard compilers, e.g. in the embedded or mobile space, you may be able to hermetically download the complete set of files required using Bazel.
This is illustrated by the Android toolchain, which downloads the NDK using an `http_archive` defined in the `WORKSPACE` and then defines a C++ toolchain using the downloaded compiler, linker, and header files.

You can run it using:
```
bazel build //main/... --crosstool_top @androidsdk_ndk-bundle//:toolchain-android --cpu=x86_64-android
```