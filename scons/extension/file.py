import os
from pathlib import Path


def collect_sources(dir: str, *suffixes: str) -> list[str]:
    sources = []
    for p in Path(dir).rglob("*"):
        if p.is_file() and p.suffix in suffixes:
            sources.append(str(p))
    return sources


def write_gdextension_manifest(extension_name: str, file_path: str) -> bool:
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
        return False
    except Exception as e:
        print(f"Error occurred while writing {file_path}: {e}")
        return True
