load(":unix_toolchain_config.bzl", "unix_cc_toolchain_config")

WORKSPACE_NAME = "androidsdk_ndk-bundle"

ANDROID_COMPILE_OPTIONS = {
    "compile_flags": [
        "-Wall",
        "-Wextra",
        "-Werror",
        "-Wpedantic",
        "-ffunction-sections",
        "-funwind-tables",
        "-fstack-protector-strong",
        "-fpic",
        "-no-canonical-prefixes",
        # Include directories.
        "-isystem",
        "external/{ws_name}/sources/android/support/include".format(ws_name = WORKSPACE_NAME),
        "-isystem",
        "external/{ws_name}/sources/cxx-stl/llvm-libc++/include".format(ws_name = WORKSPACE_NAME),
        "-isystem",
        "external/{ws_name}/sources/cxx-stl/llvm-libc++abi/include".format(ws_name = WORKSPACE_NAME),
        "-isystem",
        "external/{ws_name}/sysroot/usr/include".format(ws_name = WORKSPACE_NAME),
    ],
    "dbg_compile_flags": [
        "-O0",
        "-g",
    ],
    "opt_compile_flags": [
        "-g0",
        # Conservative choice for -O.
        # -O3 can increase binary size and even slow down the resulting binaries.
        # Profile first and / or use FDO if you need better performance than this.
        "-O2",
        # Disable assertions.
        "-DNDEBUG",
    ],
    "unfiltered_compile_flags": [
        # Make compilation deterministic. Use linkstamping instead of these compiler symbols.
        "-no-canonical-prefixes",
        "-Wno-builtin-macro-redefined",
        "-D__DATE__=\"redacted\"",
        "-D__TIMESTAMP__=\"redacted\"",
        "-D__TIME__=\"redacted\"",
    ],
    "cxx_flags": [
        "-std=c++11",
        "-DANDROID",
    ],
    "link_flags": [
        "-no-canonical-prefixes",
        "-lm",
        "-ldl",
        "-llog",
        "-lc++",
    ],
    "dbg_link_flags": [],
    "opt_link_flags": [],
}

_TOOL_PATHS = {
    "ar": "{base_dir}-ar",
    "cpp": "{base_dir}-cpp",
    "gcc": "toolchains/llvm/prebuilt/linux-x86_64/bin/clang",
    "gcov": "{base_dir}-gcov",
    "ld": "{base_dir}-ld",
    "nm": "{base_dir}-nm",
    "objdump": "{base_dir}-objdump",
    "strip": "{base_dir}-strip",
}

NDK_VERSION = "24"

ARCH_SPECIFIC_SETTINGS = {
    "arm64": {
        # <ndk root>/sources/cxx-stl/llvm-libc++/libs/<abi_version>
        "abi_version": "arm64-v8a",
        # <ndk root>/platforms/android-<ndk_version>/<android_arch>
        "android_arch": "arch-arm64",
        # <ndk root>/toolchains/<target_system_toolchain>/prebuilt/linux-x86_64/bin/<target_system_name>
        "target_system_name": "aarch64-linux-android",
        # <ndk root>/toolchains/<target_system_toolchain>
        "target_system_toolchain": "aarch64-linux-android-4.9",
        # value of -target.
        "target_flag": "aarch64-none-linux-android",
    },

    "armeabi": {
        "abi_version": "armeabi-v7a",
        "android_arch": "arch-arm",
        "target_system_name": "arm-linux-androideabi",
        "target_system_toolchain": "arm-linux-androideabi-4.9",
        "target_flag": "armv7-none-linux-androideabi",
    },

    "x86_64": {
        "abi_version": "x86_64",
        "android_arch": "arch-x86_64",
        "target_system_name": "x86_64-linux-android",
        "target_system_toolchain": "x86_64-4.9",
        "target_flag": "x86_64-none-linux-android",
    },

    "x86": {
        "abi_version": "x86",
        "android_arch": "arch-x86",
        "target_system_name": "i686-linux-android",
        "target_system_toolchain": "x86-4.9",
        "target_flag": "i686-none-linux-android",
    },
}

def android_cc_toolchain_config(name, arch, ndk_version, extra_compile_flags = [], extra_dbg_compile_flags = [], extra_opt_compile_flags = [], extra_link_flags = [], **kwargs):
    settings = ARCH_SPECIFIC_SETTINGS[arch]

    gcc_toolchain_flag = [
        "-gcc-toolchain",
        "external/{ws_name}/toolchains/{toolchain_name}/prebuilt/linux-x86_64".format(
            ws_name = WORKSPACE_NAME,
            toolchain_name = settings["target_system_toolchain"],
        ),
    ]

    target_flag = [
        "-target",
        settings["target_flag"],
    ]

    # All NDK toolchain binaries have the format <target_system_name>-<tool_name>. This variable
    # contains the entire path up to and including the file name prefix, s.t. you just have to
    # append `-<tool_name>`.
    tool_base_path = "toolchains/{target_system_toolchain}/prebuilt/linux-x86_64/bin/{target_system_name}".format(
        target_system_toolchain = settings["target_system_toolchain"],
        target_system_name = settings["target_system_name"],
    )

    unix_cc_toolchain_config(
        name = name,
        abi_version = settings["abi_version"],
        compile_flags = ANDROID_COMPILE_OPTIONS["compile_flags"] +
                        gcc_toolchain_flag +
                        target_flag +
                        extra_compile_flags +
                        ["-D__ANDROID_API__=" + ndk_version],
        cxx_flags = ANDROID_COMPILE_OPTIONS["cxx_flags"],
        dbg_compile_flags = ANDROID_COMPILE_OPTIONS["dbg_compile_flags"] + extra_dbg_compile_flags,
        include_directories = [],  # Set "manually" with -isystem above and -L flag.
        link_flags = ANDROID_COMPILE_OPTIONS["link_flags"] +
                     gcc_toolchain_flag +
                     target_flag +
                     extra_link_flags +
                     [
                         "-Lexternal/{ws_name}/sources/cxx-stl/llvm-libc++/libs/{abi_version}".format(
                             ws_name = WORKSPACE_NAME,
                             abi_version = settings["abi_version"],
                         ),
                     ],
        opt_compile_flags = ANDROID_COMPILE_OPTIONS["opt_compile_flags"] + extra_opt_compile_flags,
        opt_link_flags = ANDROID_COMPILE_OPTIONS["opt_link_flags"],
        sysroot = "external/{ws_name}/platforms/android-{ndk_version}/{android_arch}".format(
            ndk_version = ndk_version,
            android_arch = settings["android_arch"],
            ws_name = WORKSPACE_NAME,
        ),
        target_cpu = settings["abi_version"],
        target_system_name = settings["target_system_name"],
        tool_paths = dict([(
            k,
            v.format(base_dir = tool_base_path),
        ) for (k, v) in _TOOL_PATHS.items()]),
        toolchain_identifier = settings["abi_version"] + "-android",
        unfiltered_compile_flags = ANDROID_COMPILE_OPTIONS["unfiltered_compile_flags"] + [
            "-isystem",
            "external/{ws_name}/sysroot/usr/include/{system_name}".format(
                ws_name = WORKSPACE_NAME,
                system_name = settings["target_system_name"],
            ),
        ],
    )
