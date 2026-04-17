from SCons.Script import Environment

from .file import write_gdextension_manifest


def add_gdextension_library(
    extension_name: str,
    godotcpp_src_dir: str,
    extension_src_dir: str,
    install_dir_prefix: str,
    env: Environment,
) -> list:
    lib_env = env.Clone()
    lib_env.AppendUnique(
        CPPPATH=[
            f"{godotcpp_src_dir}",
            f"{godotcpp_src_dir}/include",
            f"{extension_src_dir}/..",
        ]
    )
    lib_sources = env.Glob(f"{extension_src_dir}/*.cpp")

    if lib_env["target"] in ["editor", "template_debug"]:
        doc_source = lib_env.GodotCPPDocData(
            target=f"{extension_src_dir}/{extension_name}.doc.cpp",
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
