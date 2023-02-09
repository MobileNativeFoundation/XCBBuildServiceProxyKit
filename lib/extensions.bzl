"""Module extension for loading dependencies not yet compatible with bzlmod."""

load(
    ":repositories.bzl",
    "xcbbuildserviceproxy_rules_dependencies",
)

non_module_deps = module_extension(implementation = lambda _: xcbbuildserviceproxy_rules_dependencies(include_bzlmod_ready_dependencies = False))
