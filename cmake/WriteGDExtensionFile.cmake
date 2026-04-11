include_guard(GLOBAL)

function(write_gdextension_file EXTENSION_NAME OUTPUT_DIR)
    file(MAKE_DIRECTORY "${OUTPUT_DIR}")

    set(ENTRY_SYMBOL "extension_init")
    set(file_path "${OUTPUT_DIR}/${EXTENSION_NAME}.gdextension")
    set(file_content [=[ [configuration]

entry_symbol = "@ENTRY_SYMBOL@"
compatibility_minimum = "4.5"
reloadable = false

[libraries]
; Relative paths ensure that our GDExtension can be placed anywhere in the project directory.
macos.single.debug = "./macos/lib@EXTENSION_NAME@.macos.template_debug.dylib"
macos.double.debug = "./macos/lib@EXTENSION_NAME@.macos.template_debug.double.dylib"
macos.single.release = "./macos/lib@EXTENSION_NAME@.macos.template_release.dylib"
macos.double.release = "./macos/lib@EXTENSION_NAME@.macos.template_release.double.dylib"

ios.arm64.single.debug = "./ios/lib@EXTENSION_NAME@.ios.template_debug.arm64.dylib"
ios.arm64.double.debug = "./ios/lib@EXTENSION_NAME@.ios.template_debug.arm64.double.dylib"
ios.arm64.single.release = "./ios/lib@EXTENSION_NAME@.ios.template_release.arm64.dylib"
ios.arm64.double.release = "./ios/lib@EXTENSION_NAME@.ios.template_release.arm64.double.dylib"

windows.x86_32.single.debug = "./windows/@EXTENSION_NAME@.windows.template_debug.x86_32.dll"
windows.x86_32.double.debug = "./windows/@EXTENSION_NAME@.windows.template_debug.x86_32.double.dll"
windows.x86_32.single.release = "./windows/@EXTENSION_NAME@.windows.template_release.x86_32.dll"
windows.x86_32.double.release = "./windows/@EXTENSION_NAME@.windows.template_release.x86_32.double.dll"

windows.x86_64.single.debug = "./windows/@EXTENSION_NAME@.windows.template_debug.x86_64.dll"
windows.x86_64.double.debug = "./windows/@EXTENSION_NAME@.windows.template_debug.x86_64.double.dll"
windows.x86_64.single.release = "./windows/@EXTENSION_NAME@.windows.template_release.x86_64.dll"
windows.x86_64.double.release = "./windows/@EXTENSION_NAME@.windows.template_release.x86_64.double.dll"

linux.x86_64.single.debug = "./linux/lib@EXTENSION_NAME@.linux.template_debug.x86_64.so"
linux.x86_64.double.debug = "./linux/lib@EXTENSION_NAME@.linux.template_debug.x86_64.double.so"
linux.x86_64.single.release = "./linux/lib@EXTENSION_NAME@.linux.template_release.x86_64.so"
linux.x86_64.double.release = "./linux/lib@EXTENSION_NAME@.linux.template_release.x86_64.double.so"

linux.arm64.single.debug = "./linux/lib@EXTENSION_NAME@.linux.template_debug.arm64.so"
linux.arm64.double.debug = "./linux/lib@EXTENSION_NAME@.linux.template_debug.arm64.double.so"
linux.arm64.single.release = "./linux/lib@EXTENSION_NAME@.linux.template_release.arm64.so"
linux.arm64.double.release = "./linux/lib@EXTENSION_NAME@.linux.template_release.arm64.double.so"

linux.rv64.single.debug = "./linux/lib@EXTENSION_NAME@.linux.template_debug.rv64.so"
linux.rv64.double.debug = "./linux/lib@EXTENSION_NAME@.linux.template_debug.rv64.double.so"
linux.rv64.single.release = "./linux/lib@EXTENSION_NAME@.linux.template_release.rv64.so"
linux.rv64.double.release = "./linux/lib@EXTENSION_NAME@.linux.template_release.rv64.double.so"

android.x86_64.single.debug = "./android/lib@EXTENSION_NAME@.android.template_debug.x86_64.so"
android.x86_64.double.debug = "./android/lib@EXTENSION_NAME@.android.template_debug.x86_64.double.so"
android.x86_64.single.release = "./android/lib@EXTENSION_NAME@.android.template_release.x86_64.so"
android.x86_64.double.release = "./android/lib@EXTENSION_NAME@.android.template_release.x86_64.double.so"

android.arm64.single.debug = "./android/lib@EXTENSION_NAME@.android.template_debug.arm64.so"
android.arm64.double.debug = "./android/lib@EXTENSION_NAME@.android.template_debug.arm64.double.so"
android.arm64.single.release = "./android/lib@EXTENSION_NAME@.android.template_release.arm64.so"
android.arm64.double.release = "./android/lib@EXTENSION_NAME@.android.template_release.arm64.double.so"

web.wasm32.single.debug = "./web/lib@EXTENSION_NAME@.web.template_debug.wasm32.nothreads.wasm"
web.wasm32.double.debug = "./web/lib@EXTENSION_NAME@.web.template_debug.wasm32.double.nothreads.wasm"
web.wasm32.single.release = "./web/lib@EXTENSION_NAME@.web.template_release.wasm32.nothreads.wasm"
web.wasm32.double.release = "./web/lib@EXTENSION_NAME@.web.template_release.wasm32.double.nothreads.wasm"
]=])

    string(CONFIGURE "${file_content}" file_content @ONLY)
    file(WRITE "${file_path}" "${file_content}")
endfunction()
