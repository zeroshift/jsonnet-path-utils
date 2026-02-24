package(default_visibility = ["//visibility:public"])

load("@rules_jsonnet//jsonnet:jsonnet.bzl", "jsonnet_library")

jsonnet_library(
    name = "main",
    srcs = ["main.libsonnet"],
    deps = ["//vendor/github.com/jsonnet-libs/docsonnet/doc-util:main"],
    imports = ["../vendor/github.com/jsonnet-libs/docsonnet"],
)
