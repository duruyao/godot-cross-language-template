from SCons.Script import Environment

from .file import write_gdextension_manifest


def add_gdextension_library(
    env: Environment,
    extension_name: str,
    godotcpp_src_dir: str,
    extension_src_dir: str,
    install_dir_prefix: str,
    extra_sources: list[str] | None = None,
    extra_header_dirs: list[str] | None = None,
    extra_compile_definitions: list[str] | None = None,
    extra_compile_flags: list[str] | None = None,
) -> list:
    lib_env = env.Clone()
    lib_env.AppendUnique(
        CPPPATH=[
            f"{extension_src_dir}/..",
        ]
    )
    lib_env.AppendUnique(CPPPATH=extra_header_dirs or [])
    lib_env.AppendUnique(CPPDEFINES=extra_compile_definitions or [])
    lib_env.AppendUnique(CCFLAGS=extra_compile_flags or [])
    lib_sources = []
    for extension in ["c", "cc", "cpp", "cxx"]:
        lib_sources.extend(env.Glob(f"{extension_src_dir}/*.{extension}"))
    for source in extra_sources or []:
        lib_sources.append(lib_env.File(source))

    if lib_env["target"] in ["editor", "template_debug"]:
        doc_source = lib_env.GodotCPPDocData(
            target=f"{extension_src_dir}/gen/{extension_name}.doc.cpp",
            source=env.Glob(f"{extension_src_dir}/*.xml"),
        )
        lib_sources.append(doc_source)

    lib_filename = "{}{}{}{}".format(
        lib_env.subst("$SHLIBPREFIX"),
        extension_name,
        lib_env["suffix"].replace(".dev", "").replace(".universal", ""),
        lib_env.subst("$SHLIBSUFFIX"),
    )

    lib = lib_env.SharedLibrary(
        target=f"{install_dir_prefix}/bin/{lib_env['platform']}/{lib_filename}",
        source=lib_sources,
    )

    manifest = lib_env.Command(
        target=f"{install_dir_prefix}/bin/{extension_name}.gdextension",
        source=lib,
        action=lambda target, source, env: write_gdextension_manifest(
            extension_name, str(target[0])
        ),
    )

    return [lib, manifest]
