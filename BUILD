load(":jt_rule.bzl", "emit_size")

print("BUILD file")

filegroup(
    name = "my_file",
    srcs = ["bar.txt"],
)
# jt_rule(
#     name = "bin1",
#     deps = [":my_file"],
# )
# jt_rule(
#     name = "bin2",
#     deps = [":my_file"],
# )

emit_size(
    name = "foo",
    file = "foo.txt",
    deps = [":my_file"],
)
java_library(
    name = "Greeting",
    srcs = [":Greeting.java"],
)
java_library(
    name = "HelloWorld",
    srcs = [":HelloWorld.java"],
    deps = [":Greeting"]
)
java_binary(
    name = "App",
    runtime_deps = [":HelloWorld"],
    resource_jars = [":j2ee-1.4.jar"],
#    main_class = "HelloWorld",
    create_executable = False,
)