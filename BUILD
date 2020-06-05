package(default_visibility = ["//visibility:public"])

load(":unix_toolchain_config.bzl", "CLANG_OPTIONS", "unix_cc_toolchain_config")

filegroup(
    name = "empty",
    srcs = [],
)

cc_toolchain_suite(
    name = "toolchain",
    toolchains = {
        "k8-gcc": ":k8-gcc",
        "k8-clang": ":k8-clang",
    },
)

unix_cc_toolchain_config(
    name = "config-gcc",
    abi_version = "local",
    compile_flags = [
        "-Wall",
        "-Wextra",
        "-Werror",
        "-Wpedantic",
        "-fdiagnostics-color=always",

        # Keep stack frames for debugging, even in opt mode.
        "-fno-omit-frame-pointer",

        # Security hardening on by default.
        # Conservative choice; -D_FORTIFY_SOURCE=2 may be unsafe in some cases.
        # We need to undef it before redefining it as some distributions now have
        # it enabled by default.
        "-U_FORTIFY_SOURCE",
        "-D_FORTIFY_SOURCE=1",
        "-fstack-protector",

        # Do not export symbols by default.
        "-fvisibility=hidden",
        "-fno-common",
    ],
    cxx_flags = [
        "-std=c++11",
        # Do not export symbols by default.
        "-fvisibility-inlines-hidden",
    ],
    dbg_compile_flags = [
        "-O0",
        "-g",
    ],
    include_directories = [
        "/usr/lib/gcc",
        "/usr/include",
    ],
    link_flags = [
        "-lstdc++",
        # Anticipated future default.
        "-no-canonical-prefixes",
        # Have gcc return the exit code from ld.
        "-pass-exit-codes",
        "-latomic",
        # Security hardening on by default.
        "-Wl,-z,relro,-z,now",
        # ALL THE WARNINGS AND ERRORS - even during linking.
        "-Wall",
        "-Wextra",
        "-Werror",
        "-Wpedantic",
    ],
    opt_compile_flags = [
        "-g0",
        # Conservative choice for -O.
        # -O3 can increase binary size and even slow down the resulting binaries.
        # Profile first and / or use FDO if you need better performance than this.
        "-O2",
        # Disable assertions.
        "-DNDEBUG",
        # Removal of unused code and data at link time (can this increase binary size in some cases?).
        "-ffunction-sections",
        "-fdata-sections",
    ],
    opt_link_flags = ["-Wl,--gc-sections"],
    target_cpu = "k8-gcc",
    target_system_name = "x86_64-gcc_libstdcpp-linux",
    tool_paths = {
        "ar": "/usr/bin/ar",
        "compat-ld": "/usr/bin/ld",
        "cpp": "/usr/bin/cpp",
        "dwp": "/usr/bin/dwp",
        "gcc": "/usr/bin/gcc",
        "gcov": "/usr/bin/gcov",
        "ld": "/usr/bin/ld",
        "nm": "/usr/bin/nm",
        "objcopy": "/usr/bin/objcopy",
        "objdump": "/usr/bin/objdump",
        "strip": "/usr/bin/strip",
    },
    toolchain_identifier = "k8-gcc",
    unfiltered_compile_flags = [
        "-no-canonical-prefixes",
        "-fno-canonical-system-headers",
        "-Wno-builtin-macro-redefined",
        "-D__DATE__=\"redacted\"",
        "-D__TIMESTAMP__=\"redacted\"",
        "-D__TIME__=\"redacted\"",
    ],
)

cc_toolchain(
    name = "k8-gcc",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
    toolchain_config = ":config-gcc",
    toolchain_identifier = "k8-gcc",
)

toolchain(
    name = "cc-toolchain-linux-x86_64-gcc",
    exec_compatible_with = [
        "@bazel_tools//platforms:linux",
        "//tools:gcc",
    ],
    target_compatible_with = [
        "@bazel_tools//platforms:linux",
        "@bazel_tools//platforms:x86_64",
    ],
    toolchain = ":k8-gcc",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

unix_cc_toolchain_config(
    name = "config-clang",
    abi_version = "local",
    compile_flags = CLANG_OPTIONS["compile_flags"],
    cxx_flags = CLANG_OPTIONS["cxx_flags"],
    dbg_compile_flags = CLANG_OPTIONS["dbg_compile_flags"],
    include_directories = [
        "/usr/lib/clang",
        "/usr/include",
    ],
    link_flags = CLANG_OPTIONS["link_flags"],
    opt_compile_flags = CLANG_OPTIONS["opt_compile_flags"],
    opt_link_flags = CLANG_OPTIONS["opt_link_flags"],
    target_cpu = "k8-clang",
    target_system_name = "x86_64-clang_libstdcpp-linux",
    tool_paths = {
        "ar": "/usr/bin/ar",
        "compat-ld": "/usr/bin/llvm-ld",
        "cpp": "/usr/bin/cpp",
        "dwp": "/usr/bin/llvm-dwp",
        "gcc": "/usr/bin/clang",
        "gcov": "/usr/bin/gcov",
        "ld": "/usr/bin/llvm-ld",
        "nm": "/usr/bin/llvm-nm",
        "objcopy": "/usr/bin/objcopy",
        "objdump": "/usr/bin/objdump",
        "strip": "/usr/bin/strip",
    },
    toolchain_identifier = "k8-clang",
    unfiltered_compile_flags = CLANG_OPTIONS["unfiltered_compile_flags"],
)

cc_toolchain(
    name = "k8-clang",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
    toolchain_config = ":config-clang",
    toolchain_identifier = "k8-clang",
)

toolchain(
    name = "cc-toolchain-linux-x86_64-clang",
    exec_compatible_with = [
        "@bazel_tools//platforms:linux",
        "//tools:clang",
    ],
    target_compatible_with = [
        "@bazel_tools//platforms:linux",
        "@bazel_tools//platforms:x86_64",
    ],
    toolchain = ":k8-clang",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
    name = "cc-toolchain-android-arm64_v8a-clang",
    exec_compatible_with = [
        "@bazel_tools//platforms:linux",
        "//tools:clang",
    ],
    target_compatible_with = [
        "@bazel_tools//platforms:android",
        "@bazel_tools//platforms:aarch64",
    ],
    toolchain = "@androidsdk_ndk-bundle//:arm64_v8a-android",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
    name = "cc-toolchain-android-armeabi_v7a-clang",
    exec_compatible_with = [
        "@bazel_tools//platforms:linux",
        "//tools:clang",
    ],
    target_compatible_with = [
        "@bazel_tools//platforms:android",
        "@bazel_tools//platforms:arm",
    ],
    toolchain = "@androidsdk_ndk-bundle//:armeabi_v7a-android",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
    name = "cc-toolchain-android-x86_64-clang",
    exec_compatible_with = [
        "@bazel_tools//platforms:linux",
        "//tools:clang",
    ],
    target_compatible_with = [
        "@bazel_tools//platforms:android",
        "@bazel_tools//platforms:x86_64",
    ],
    toolchain = "@androidsdk_ndk-bundle//:x86_64-android",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
    name = "cc-toolchain-android-x86-clang",
    exec_compatible_with = [
        "@bazel_tools//platforms:linux",
        "//tools:clang",
    ],
    target_compatible_with = [
        "@bazel_tools//platforms:android",
        "@bazel_tools//platforms:x86_32",
    ],
    toolchain = "@androidsdk_ndk-bundle//:x86-android",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)
