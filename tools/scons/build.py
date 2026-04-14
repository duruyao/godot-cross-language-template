from SCons.Script import Environment

from .file import collect_sources, write_gdextension_manifest


def _write_manifest_action(target: any, source: any, env: Environment) -> int:
    extension_name = env["extension_name"]
    file_path = str(target[0])
    return write_gdextension_manifest(extension_name, file_path)


def add_gdextension_library(
    extension_name: str,
    godotcpp_src_dir: str,
    extension_src_dir: str,
    install_dir_prefix: str,
    env: Environment,
) -> list:
    lib_env = env.Clone()
    lib_env.AppendUnique(CPPPATH=[f"{godotcpp_src_dir}/..", f"{extension_src_dir}/.."])
    lib_sources = collect_sources(extension_src_dir, ".cc", ".cpp", ".cxx")

    if lib_env["target"] in ["editor", "template_debug"]:
        doc_source = lib_env.GodotCPPDocData(
            target=f"{extension_src_dir}/{extension_name}.doc.cpp",
            source=collect_sources(extension_src_dir, ".xml"),
        )
        lib_sources.append(doc_source)

    lib_filename = "{}{}{}{}".format(
        lib_env.subst("$SHLIBPREFIX"),
        extension_name,
        lib_env["suffix"].replace(".dev", "").replace(".universal", ""),
        lib_env.subst("$SHLIBSUFFIX"),
    )

    lib = lib_env.SharedLibrary(
        target=f"{extension_src_dir}/{lib_filename}",
        source=lib_sources,
    )

    lib_install = lib_env.Install(
        target=f"{install_dir_prefix}/bin/{lib_env['platform']}",
        source=lib,
    )

    lib_env["extension_name"] = extension_name
    manifest = lib_env.Command(
        target=f"{extension_src_dir}/{extension_name}.gdextension",
        source=lib,
        action=_write_manifest_action,
    )

    manifest_install = lib_env.Install(
        target=f"{install_dir_prefix}/bin",
        source=manifest,
    )

    return [lib, lib_install, manifest, manifest_install]
