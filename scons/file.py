import os
import re
from pathlib import Path

from .console import print_error


def write_gdextension_manifest(extension_name: str, file_path: str) -> None:
    os.makedirs(os.path.dirname(file_path), exist_ok=True)

    entry_symbol = "extension_init"
    compatibility_minimum = "4.5"
    file_content = f"""[configuration]

entry_symbol = "{entry_symbol}"
compatibility_minimum = "{compatibility_minimum}"
reloadable = false

[libraries]
; Relative paths ensure that our GDExtension can be placed anywhere in the project directory.
macos.single.debug = "./macos/lib{extension_name}.macos.template_debug.dylib"
macos.double.debug = "./macos/lib{extension_name}.macos.template_debug.double.dylib"
macos.single.release = "./macos/lib{extension_name}.macos.template_release.dylib"
macos.double.release = "./macos/lib{extension_name}.macos.template_release.double.dylib"

ios.arm64.single.debug = "./ios/lib{extension_name}.ios.template_debug.arm64.dylib"
ios.arm64.double.debug = "./ios/lib{extension_name}.ios.template_debug.arm64.double.dylib"
ios.arm64.single.release = "./ios/lib{extension_name}.ios.template_release.arm64.dylib"
ios.arm64.double.release = "./ios/lib{extension_name}.ios.template_release.arm64.double.dylib"

windows.x86_32.single.debug = "./windows/{extension_name}.windows.template_debug.x86_32.dll"
windows.x86_32.double.debug = "./windows/{extension_name}.windows.template_debug.x86_32.double.dll"
windows.x86_32.single.release = "./windows/{extension_name}.windows.template_release.x86_32.dll"
windows.x86_32.double.release = "./windows/{extension_name}.windows.template_release.x86_32.double.dll"

windows.x86_64.single.debug = "./windows/{extension_name}.windows.template_debug.x86_64.dll"
windows.x86_64.double.debug = "./windows/{extension_name}.windows.template_debug.x86_64.double.dll"
windows.x86_64.single.release = "./windows/{extension_name}.windows.template_release.x86_64.dll"
windows.x86_64.double.release = "./windows/{extension_name}.windows.template_release.x86_64.double.dll"

linux.x86_64.single.debug = "./linux/lib{extension_name}.linux.template_debug.x86_64.so"
linux.x86_64.double.debug = "./linux/lib{extension_name}.linux.template_debug.x86_64.double.so"
linux.x86_64.single.release = "./linux/lib{extension_name}.linux.template_release.x86_64.so"
linux.x86_64.double.release = "./linux/lib{extension_name}.linux.template_release.x86_64.double.so"

linux.arm64.single.debug = "./linux/lib{extension_name}.linux.template_debug.arm64.so"
linux.arm64.double.debug = "./linux/lib{extension_name}.linux.template_debug.arm64.double.so"
linux.arm64.single.release = "./linux/lib{extension_name}.linux.template_release.arm64.so"
linux.arm64.double.release = "./linux/lib{extension_name}.linux.template_release.arm64.double.so"

linux.rv64.single.debug = "./linux/lib{extension_name}.linux.template_debug.rv64.so"
linux.rv64.double.debug = "./linux/lib{extension_name}.linux.template_debug.rv64.double.so"
linux.rv64.single.release = "./linux/lib{extension_name}.linux.template_release.rv64.so"
linux.rv64.double.release = "./linux/lib{extension_name}.linux.template_release.rv64.double.so"

android.x86_64.single.debug = "./android/lib{extension_name}.android.template_debug.x86_64.so"
android.x86_64.double.debug = "./android/lib{extension_name}.android.template_debug.x86_64.double.so"
android.x86_64.single.release = "./android/lib{extension_name}.android.template_release.x86_64.so"
android.x86_64.double.release = "./android/lib{extension_name}.android.template_release.x86_64.double.so"

android.arm64.single.debug = "./android/lib{extension_name}.android.template_debug.arm64.so"
android.arm64.double.debug = "./android/lib{extension_name}.android.template_debug.arm64.double.so"
android.arm64.single.release = "./android/lib{extension_name}.android.template_release.arm64.so"
android.arm64.double.release = "./android/lib{extension_name}.android.template_release.arm64.double.so"

web.wasm32.single.debug = "./web/lib{extension_name}.web.template_debug.wasm32.nothreads.wasm"
web.wasm32.double.debug = "./web/lib{extension_name}.web.template_debug.wasm32.double.nothreads.wasm"
web.wasm32.single.release = "./web/lib{extension_name}.web.template_release.wasm32.nothreads.wasm"
web.wasm32.double.release = "./web/lib{extension_name}.web.template_release.wasm32.double.nothreads.wasm"
"""

    try:
        with open(file_path, "w", encoding="utf-8") as file:
            file.write(file_content)
    except OSError as e:
        print_error(f"Error occurred while writing {file_path}: {e}")


def write_geos_version(source_dir: str, file_path: str) -> None:
    source_path = Path(source_dir)
    output_path = Path(file_path)
    version_text = (source_path / "Version.txt").read_text(encoding="utf-8")

    version_major = _read_geos_version_value(version_text, "GEOS_VERSION_MAJOR")
    version_minor = _read_geos_version_value(version_text, "GEOS_VERSION_MINOR")
    version_patch = _read_geos_version_value(version_text, "GEOS_VERSION_PATCH")
    version_patch_word = _read_geos_version_value(version_text, "GEOS_PATCH_WORD")
    jts_port = _read_geos_version_value(version_text, "JTS_PORT")
    version = f"{version_major}.{version_minor}.{version_patch}{version_patch_word}"

    file_content = f"""#ifndef GEOS_VERSION_H_INCLUDED
#define GEOS_VERSION_H_INCLUDED
#define GEOS_VERSION_MAJOR {version_major}
#define GEOS_VERSION_MINOR {version_minor}
#define GEOS_VERSION_PATCH {version_patch}{version_patch_word}
#define GEOS_VERSION "{version}"
#define GEOS_JTS_PORT "{jts_port}"
#endif
"""

    try:
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(file_content, encoding="utf-8")
    except OSError as e:
        print_error(f"Error occurred while writing {file_path}: {e}")


def _read_geos_version_value(version_text: str, name: str) -> str:
    match = re.search(rf"^{name}=([0-9A-Za-z.]*)$", version_text, re.MULTILINE)
    if not match:
        raise ValueError(f"GEOS Version.txt is missing '{name}'")
    return match.group(1)


def map_file_paths(
    extensions: list, real_directory: str, mapped_directory: str
) -> list:
    directory_path = Path(real_directory)
    new_directory_path = Path(mapped_directory)
    file_paths = []

    for extension in extensions:
        suffix = extension if extension.startswith(".") else f".{extension}"
        for file_path in directory_path.rglob(f"*{suffix}"):
            if file_path.is_file():
                file_paths.append(
                    str(new_directory_path / file_path.relative_to(directory_path))
                )

    return file_paths
