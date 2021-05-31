
def _jt_rule_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.write(
        output = out,
        content = "Hello\n",
    )
    return [DefaultInfo(files = depset([out]))]

jt_rule = rule(
    implementation = _jt_rule_impl,
    attrs = {
        "deps": attr.label_list(),
    },
)


def _emit_size_impl(ctx):
    # The input file is given to us from the BUILD file via an attribute.
    in_file = ctx.file.file
    deps = ctx.files.deps

    # The output file is declared with a name based on the target's name.
    out_file = ctx.actions.declare_file("%s.size" % ctx.attr.name)

    ctx.actions.run_shell(
        # Input files visible to the action.
        inputs = [in_file] + deps,
        # Output files that must be created by the action.
        outputs = [out_file],
        # The progress message uses `short_path` (the workspace-relative path)
        # since that's most meaningful to the user. It omits details from the
        # full path that would help distinguish whether the file is a source
        # file or generated, and (if generated) what configuration it is built
        # for.
        progress_message = "Getting size of %s" % in_file.short_path,
        # The command to run. Alternatively we could use '$1', '$2', etc., and
        # pass the values for their expansion to `run_shell`'s `arguments`
        # param (see convert_to_uppercase below). This would be more robust
        # against escaping issues. Note that actions require the full `path`,
        # not the ambiguous truncated `short_path`.
        command = "ls -l bar.txt > '%s'" %
                  (out_file.path),
    )

    # Tell Bazel that the files to build for this target includes
    # `out_file`.
    return [DefaultInfo(files = depset([out_file]))]

emit_size = rule(
    implementation = _emit_size_impl,
    attrs = {
        "file": attr.label(
            mandatory = True,
            allow_single_file = True,
            doc = "The file whose size is computed",
        ),
        "deps": attr.label_list(),
    },
    doc = """
Given an input file, creates an output file with the extension `.size`
containing the file's size in bytes.
""",
)