load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "action_config",
    "artifact_name_pattern",
    "env_entry",
    "env_set",
    "feature",
    "feature_set",
    "flag_group",
    "flag_set",
    "make_variable",
    "tool",
    "tool_path",
    "variable_with_value",
    "with_feature_set",
)
load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load("@bazel_tools//tools/cpp:cc_toolchain_config.bzl", "all_compile_actions", "all_link_actions")

CLANG_OPTIONS = {
    "compile_flags": [
        "-Wall",
        "-Wextra",
        "-Werror",
        "-Wpedantic",
        "-fcolor-diagnostics",

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
        # Removal of unused code and data at link time (can this increase binary size in some cases?).
        "-ffunction-sections",
        "-fdata-sections",
    ],
    "unfiltered_compile_flags": [
        # Make compilation deterministic.
        "-no-canonical-prefixes",
        "-Wno-builtin-macro-redefined",
        "-D__DATE__=\"redacted\"",
        "-D__TIMESTAMP__=\"redacted\"",
        "-D__TIME__=\"redacted\"",
    ],
    "cxx_flags": [
        "-std=c++11",
        "-stdlib=libstdc++",
        # Do not export symbols by default.
        "-fvisibility-inlines-hidden",
    ],
    "link_flags": [
        "-latomic",
        # Anticipated future default.
        "-no-canonical-prefixes",
        # Security hardening on by default.
        "-Wl,-z,relro,-z,now",
        "-lstdc++",
        # ALL THE WARNINGS AND ERRORS - even during linking.
        "-Wall",
        "-Wextra",
        "-Werror",
        "-Wpedantic",
    ],
    "opt_link_flags": [
        "-O4",
        "-Wl,--gc-sections",
    ],
}

def _impl(ctx):
    tool_paths = [
        tool_path(
            name = name,
            path = path,
        )
        for name, path in ctx.attr.tool_paths.items()
    ]

    default_compile_flags_feature = feature(
        name = "default_compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_compile_actions,
                flag_groups = ([flag_group(flags = ctx.attr.compile_flags)] if ctx.attr.compile_flags else []),
            ),
            flag_set(
                actions = all_compile_actions,
                flag_groups = ([flag_group(flags = ctx.attr.dbg_compile_flags)] if ctx.attr.dbg_compile_flags else []),
                with_features = [with_feature_set(features = ["dbg"])],
            ),
            flag_set(
                actions = all_compile_actions,
                flag_groups = ([flag_group(flags = ctx.attr.opt_compile_flags)] if ctx.attr.opt_compile_flags else []),
                with_features = [with_feature_set(features = ["opt"])],
            ),
            flag_set(
                actions = [
                    ACTION_NAMES.linkstamp_compile,
                    ACTION_NAMES.cpp_compile,
                    ACTION_NAMES.cpp_header_parsing,
                    ACTION_NAMES.cpp_module_compile,
                    ACTION_NAMES.cpp_module_codegen,
                    ACTION_NAMES.lto_backend,
                    ACTION_NAMES.clif_match,
                ],
                flag_groups = ([flag_group(flags = ctx.attr.cxx_flags)] if ctx.attr.cxx_flags else []),
            ),
        ],
    )

    default_link_flags_feature = feature(
        name = "default_link_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_link_actions,
                flag_groups = ([flag_group(flags = ctx.attr.link_flags)] if ctx.attr.link_flags else []),
            ),
            flag_set(
                actions = all_link_actions,
                flag_groups = ([flag_group(flags = ctx.attr.opt_link_flags)] if ctx.attr.opt_link_flags else []),
                with_features = [with_feature_set(features = ["opt"])],
            ),
            flag_set(
                actions = all_link_actions,
                flag_groups = ([flag_group(flags = ctx.attr.dbg_link_flags)] if ctx.attr.dbg_link_flags else []),
                with_features = [with_feature_set(features = ["dbg"])],
            ),
        ],
    )

    dbg_feature = feature(name = "dbg")

    opt_feature = feature(name = "opt")

    supports_dynamic_linker_feature = feature(name = "supports_dynamic_linker", enabled = True)

    unfiltered_compile_flags_feature = feature(
        name = "unfiltered_compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = [
                    ACTION_NAMES.assemble,
                    ACTION_NAMES.preprocess_assemble,
                    ACTION_NAMES.linkstamp_compile,
                    ACTION_NAMES.c_compile,
                    ACTION_NAMES.cpp_compile,
                    ACTION_NAMES.cpp_header_parsing,
                    ACTION_NAMES.cpp_module_compile,
                    ACTION_NAMES.cpp_module_codegen,
                    ACTION_NAMES.lto_backend,
                    ACTION_NAMES.clif_match,
                ],
                flag_groups = [flag_group(flags = ctx.attr.unfiltered_compile_flags)],
            ),
        ],
    )

    supports_pic_feature = feature(name = "supports_pic", enabled = True)

    features = [
        default_compile_flags_feature,
        default_link_flags_feature,
        dbg_feature,
        opt_feature,
        supports_dynamic_linker_feature,
        supports_pic_feature,
        unfiltered_compile_flags_feature,
    ]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        toolchain_identifier = ctx.attr.toolchain_identifier,
        host_system_name = "x86_64-gcc_libstdcpp-linux",
        target_system_name = ctx.attr.target_system_name,
        target_cpu = ctx.attr.target_cpu,
        target_libc = "local",
        compiler = ctx.attr.compiler,
        abi_version = ctx.attr.abi_version,
        abi_libc_version = "local",
        tool_paths = tool_paths,
        features = features,
        builtin_sysroot = ctx.attr.sysroot,
        cxx_builtin_include_directories = ctx.attr.include_directories,
    )

unix_cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {
        "abi_version": attr.string(mandatory = True),
        "target_cpu": attr.string(mandatory = True),
        "target_system_name": attr.string(mandatory = True),
        "toolchain_identifier": attr.string(mandatory = True),
        "tool_paths": attr.string_dict(mandatory = False),
        # Optional parameters.
        "compiler": attr.string(default = "generic_compiler_version"),
        "compile_flags": attr.string_list(default = []),
        "dbg_compile_flags": attr.string_list(default = []),
        "opt_compile_flags": attr.string_list(default = []),
        "unfiltered_compile_flags": attr.string_list(default = []),
        "link_flags": attr.string_list(default = []),
        "dbg_link_flags": attr.string_list(default = []),
        "opt_link_flags": attr.string_list(default = []),
        "cxx_flags": attr.string_list(default = []),
        "include_directories": attr.string_list(default = []),
        "sysroot": attr.string(default = ""),
    },
    provides = [CcToolchainConfigInfo],
)
