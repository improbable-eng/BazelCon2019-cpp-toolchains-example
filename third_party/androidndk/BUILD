package(default_visibility = ["//visibility:public"])

load("@//:android_toolchain_config.bzl", "android_cc_toolchain_config")

filegroup(
    name = "all_files",
    srcs = glob(["**/*"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "gdbserver_x86",
    srcs = ["prebuilt/android-x86/gdbserver/gdbserver"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "gdbserver_x86_64",
    srcs = ["prebuilt/android-x86_64/gdbserver/gdbserver"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "gdbserver_arm",
    srcs = ["prebuilt/android-arm/gdbserver/gdbserver"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "gdbserver_arm64",
    srcs = ["prebuilt/android-arm64/gdbserver/gdbserver"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "libcpp-arm64_v8a-dynamic-runtime-libraries",
    srcs = glob(["sources/cxx-stl/llvm-libc++/libs/arm64-v8a/*.so"]),
)

filegroup(
    name = "libcpp-arm64_v8a-static-runtime-libraries",
    srcs = glob(["sources/cxx-stl/llvm-libc++/libs/arm64-v8a/*.a"]),
)

filegroup(
    name = "libcpp-armeabi_v7a-dynamic-runtime-libraries",
    srcs = glob(["sources/cxx-stl/llvm-libc++/libs/armeabi-v7a/*.so"]),
)

filegroup(
    name = "libcpp-armeabi_v7a-static-runtime-libraries",
    srcs = glob(["sources/cxx-stl/llvm-libc++/libs/armeabi-v7a/*.a"]),
)

filegroup(
    name = "libcpp-x86-android-dynamic-runtime-libraries",
    srcs = glob(["sources/cxx-stl/llvm-libc++/libs/x86/*.so"]),
)

filegroup(
    name = "libcpp-x86-android-static-runtime-libraries",
    srcs = glob(["sources/cxx-stl/llvm-libc++/libs/x86/*.a"]),
)

filegroup(
    name = "libcpp-x86_64-android-dynamic-runtime-libraries",
    srcs = glob(["sources/cxx-stl/llvm-libc++/libs/x86_64/*.so"]),
)

filegroup(
    name = "libcpp-x86_64-android-static-runtime-libraries",
    srcs = glob(["sources/cxx-stl/llvm-libc++/libs/x86_64/*.a"]),
)

filegroup(
    name = "armeabi_v7a-all_files",
    srcs = glob([
        "toolchains/llvm/**",
        "toolchains/llvm/prebuilt/linux-x86_64/bin/**",
        "platforms/android-24/arch-arm/**/*",
        "sources/android/support/include/**/*",
        "sources/cxx-stl/llvm-libc++/include/**/*",
        "sources/cxx-stl/llvm-libc++abi/include/**/*",
        "sysroot/**/*",
        "toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/**/*",
    ]) + [
        ":libcpp-armeabi_v7a-dynamic-runtime-libraries",
        ":libcpp-armeabi_v7a-static-runtime-libraries",
    ],
)

filegroup(
    name = "arm64_v8a-all_files",
    srcs = glob([
        "toolchains/llvm/**",
        "toolchains/llvm/prebuilt/linux-x86_64/bin/**",
        "platforms/android-24/arch-arm64/**/*",
        "sources/android/support/include/**/*",
        "sources/cxx-stl/llvm-libc++/include/**/*",
        "sources/cxx-stl/llvm-libc++abi/include/**/*",
        "sysroot/**/*",
        "toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/**/*",
    ]) + [
        ":libcpp-arm64_v8a-dynamic-runtime-libraries",
        ":libcpp-arm64_v8a-static-runtime-libraries",
    ],
)

filegroup(
    name = "x86_64-android-all_files",
    srcs = glob([
        "toolchains/llvm/**",
        "toolchains/llvm/prebuilt/linux-x86_64/bin/**",
        "platforms/android-24/arch-x86_64/**/*",
        "sources/android/support/include/**/*",
        "sources/cxx-stl/llvm-libc++/include/**/*",
        "sources/cxx-stl/llvm-libc++abi/include/**/*",
        "sysroot/**/*",
        "toolchains/x86_64-4.9/prebuilt/linux-x86_64/**/*",
    ]) + [
        ":libcpp-x86_64-android-dynamic-runtime-libraries",
        ":libcpp-x86_64-android-static-runtime-libraries",
    ],
)

filegroup(
    name = "x86-android-all_files",
    srcs = glob([
        "toolchains/llvm/**",
        "toolchains/llvm/prebuilt/linux-x86_64/bin/**",
        "platforms/android-24/arch-x86/**/*",
        "sources/android/support/include/**/*",
        "sources/cxx-stl/llvm-libc++/include/**/*",
        "sources/cxx-stl/llvm-libc++abi/include/**/*",
        "sysroot/**/*",
        "toolchains/x86-4.9/prebuilt/linux-x86_64/**/*",
    ]) + [
        ":libcpp-x86-android-dynamic-runtime-libraries",
        ":libcpp-x86-android-static-runtime-libraries",
    ],
)

cc_toolchain_suite(
    name = "toolchain-android",
    toolchains = {
        "arm64_v8a": ":arm64_v8a-android",
        "armeabi_v7a": ":armeabi_v7a-android",
        "x86_64-android": ":x86_64-android",
        "x86-android": ":x86-android",
    },
)

android_cc_toolchain_config(
    name = "config-arm64_v8a-android",
    arch = "arm64",
    extra_dbg_compile_flags = ["-UNDEBUG"],
    ndk_version = "24",
)

cc_toolchain(
    name = "arm64_v8a-android",
    all_files = ":arm64_v8a-all_files",
    ar_files = ":arm64_v8a-all_files",
    compiler_files = ":arm64_v8a-all_files",
    dwp_files = ":arm64_v8a-all_files",
    dynamic_runtime_lib = ":libcpp-arm64_v8a-dynamic-runtime-libraries",
    linker_files = ":arm64_v8a-all_files",
    objcopy_files = ":arm64_v8a-all_files",
    static_runtime_lib = ":libcpp-arm64_v8a-static-runtime-libraries",
    strip_files = ":arm64_v8a-all_files",
    supports_param_files = 1,
    toolchain_config = ":config-arm64_v8a-android",
)

android_cc_toolchain_config(
    name = "config-armeabi_v7a-android",
    arch = "armeabi",
    extra_compile_flags = [
        "-fno-integrated-as",
        "-march=armv7-a",
        "-mfloat-abi=softfp",
        "-mfpu=vfpv3-d16",
    ],
    extra_dbg_compile_flags = [
        "-UNDEBUG",
        "-fno-strict-aliasing",
    ],
    extra_link_flags = ["-Wl,--fix-cortex-a8"],
    extra_opt_compile_flags = ["-mthumb"],
    ndk_version = "24",
)

cc_toolchain(
    name = "armeabi_v7a-android",
    all_files = ":armeabi_v7a-all_files",
    ar_files = ":armeabi_v7a-all_files",
    compiler_files = ":armeabi_v7a-all_files",
    dwp_files = ":armeabi_v7a-all_files",
    dynamic_runtime_lib = ":libcpp-armeabi_v7a-dynamic-runtime-libraries",
    linker_files = ":armeabi_v7a-all_files",
    objcopy_files = ":armeabi_v7a-all_files",
    static_runtime_lib = ":libcpp-armeabi_v7a-static-runtime-libraries",
    strip_files = ":armeabi_v7a-all_files",
    supports_param_files = 1,
    toolchain_config = ":config-armeabi_v7a-android",
)

android_cc_toolchain_config(
    name = "config-x86_64-android",
    arch = "x86_64",
    ndk_version = "24",
)

cc_toolchain(
    name = "x86_64-android",
    all_files = ":x86_64-android-all_files",
    ar_files = ":x86_64-android-all_files",
    compiler_files = ":x86_64-android-all_files",
    dwp_files = ":x86_64-android-all_files",
    dynamic_runtime_lib = ":libcpp-x86_64-android-dynamic-runtime-libraries",
    linker_files = ":x86_64-android-all_files",
    objcopy_files = ":x86_64-android-all_files",
    static_runtime_lib = ":libcpp-x86_64-android-static-runtime-libraries",
    strip_files = ":x86_64-android-all_files",
    supports_param_files = 1,
    toolchain_config = ":config-x86_64-android",
)

android_cc_toolchain_config(
    name = "config-x86-android",
    arch = "x86",
    ndk_version = "24",
)

cc_toolchain(
    name = "x86-android",
    all_files = ":x86-android-all_files",
    ar_files = ":x86-android-all_files",
    compiler_files = ":x86-android-all_files",
    dwp_files = ":x86-android-all_files",
    dynamic_runtime_lib = ":libcpp-x86-android-dynamic-runtime-libraries",
    linker_files = ":x86-android-all_files",
    objcopy_files = ":x86-android-all_files",
    static_runtime_lib = ":libcpp-x86-android-static-runtime-libraries",
    strip_files = ":x86-android-all_files",
    supports_param_files = 1,
    toolchain_config = ":config-x86-android",
)
