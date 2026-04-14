import sys
from pathlib import Path

from SCons.Script import (
    Default,
    Dir,
    Environment,
    SConscript,
    VariantDir,
)

from tools.scons import add_gdextension_library, print_error

project_root = Dir("#").abspath
customs = [f"{project_root}/custom.py"]
build_dir = f"{project_root}/scons-build"
godotcpp_module_path = "third_party/godot-cpp"

if not Path(f"{project_root}/{godotcpp_module_path}/src").is_dir():
    print_error(f"""godot-cpp bindings source not found.
Run the following command to initialize/update the godot-cpp submodule:

    git submodule update --init --recursive {godotcpp_module_path}""")
    sys.exit(1)

VariantDir(build_dir, project_root, duplicate=False)
env = Environment(tools=["default"], PLATFORM="").Clone()
env = SConscript(
    f"{build_dir}/{godotcpp_module_path}/SConstruct", {"env": env, "customs": customs}
)

targets = []
targets += add_gdextension_library(
    extension_name="foo",
    godotcpp_src_dir=f"{build_dir}/{godotcpp_module_path}",
    extension_src_dir=f"{build_dir}/src/extensions/foo",
    install_dir_prefix=f"{project_root}/project",
    env=env,
)
targets += add_gdextension_library(
    extension_name="bar",
    godotcpp_src_dir=f"{build_dir}/{godotcpp_module_path}",
    extension_src_dir=f"{build_dir}/src/extensions/bar",
    install_dir_prefix=f"{project_root}/project",
    env=env,
)

Default(*targets)
