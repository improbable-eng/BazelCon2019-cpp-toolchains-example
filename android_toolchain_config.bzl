load(":unix_toolchain_config.bzl", "unix_cc_toolchain_config", "CLANG_OPTIONS")

WORKSPACE_NAME = "androidsdk_ndk-bundle"
ANDROID_COMPILE_OPTIONS = dict(CLANG_OPTIONS)
# Override groups of flags which differ for Android.
ANDROID_COMPILE_OPTIONS.update({
    "compile_flags": CLANG_OPTIONS["compile_flags"] + [
        "-funwind-tables",
        "-fstack-protector-strong",
        "-fpic",
    ],
    "cxx_flags": [
        "-stdlib=libc++",
    ],
})

_TOOL_PATHS = {
    "ar": "{arch_base_dir}-ar",
    "cpp": "{arch_base_dir}-cpp",
    "gcc": "toolchains/llvm/prebuilt/linux-x86_64/bin/clang",
    "gcov": "{arch_base_dir}-gcov",
    "ld": "{arch_base_dir}-ld",
    "nm": "/usr/bin/nm",
    "objdump": "{arch_base_dir}-objdump",
    "strip": "{arch_base_dir}-strip",
}
NDK_VERSION = "24"

ARCH_SPECIFIC_SETTINGS = {
    "arm64": {
        # <ndk root>/toolchains/llvm/prebuilt/linux-x86_64/bin/<target_system_name>-<tools...>
        "target_system_name": "aarch64-linux-android",
        # value of -target.
        "target_flag": "aarch64-none-linux-android",
    },
    "armeabi": {
        "target_system_name": "arm-linux-androideabi",
        "target_flag": "armv7-none-linux-androideabi",
    },
    "x86_64": {
        "target_system_name": "x86_64-linux-android",
        "target_flag": "x86_64-none-linux-android",
    },
}

def android_cc_toolchain_config(name, arch, ndk_version, extra_compile_flags = [], extra_dbg_compile_flags = [], extra_opt_compile_flags = [], extra_link_flags = [], **kwargs):
    settings = ARCH_SPECIFIC_SETTINGS[arch]

    target_flag = [
        "-target",
        settings["target_flag"] + ndk_version,
    ]

    # All NDK toolchain binaries have the format <target_system_name>-<tool_name>. This variable
    # contains the entire path up to and including the file name prefix, s.t. you just have to
    # append `-<tool_name>`.
    tool_base_path = "toolchains/llvm/prebuilt/linux-x86_64/bin/{target_system_name}".format(
        target_system_name = settings["target_system_name"],
    )

    unix_cc_toolchain_config(
        name = name,
        abi_version = settings["target_system_name"],
        compile_flags = ANDROID_COMPILE_OPTIONS["compile_flags"] +
                        target_flag +
                        extra_compile_flags,
        cxx_flags = ANDROID_COMPILE_OPTIONS["cxx_flags"],
        dbg_compile_flags = ANDROID_COMPILE_OPTIONS["dbg_compile_flags"] + extra_dbg_compile_flags,
        include_directories = [],  # Set "manually" with -isystem.
        link_flags = ANDROID_COMPILE_OPTIONS["link_flags"] +
                     target_flag +
                     extra_link_flags,
        opt_compile_flags = ANDROID_COMPILE_OPTIONS["opt_compile_flags"] + extra_opt_compile_flags,
        opt_link_flags = ANDROID_COMPILE_OPTIONS["opt_link_flags"],
        target_cpu = settings["target_system_name"],
        target_system_name = settings["target_system_name"],
        tool_paths = dict([(
            k,
            v.format(arch_base_dir = tool_base_path),
        ) for (k, v) in _TOOL_PATHS.items()]),
        toolchain_identifier = settings["target_system_name"],
        unfiltered_compile_flags = ANDROID_COMPILE_OPTIONS["unfiltered_compile_flags"],
    )