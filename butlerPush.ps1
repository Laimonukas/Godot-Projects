#butler push Pong/Exported/Exported.zip Laimonukas/pn:html
#butler push Shaders/Exported/Exported.zip Laimonukas/shaders:html
#butler push CrashCourse/Exported/Exported.zip Laimonukas/godot-crashcourse:html
butler push JetPack/Exported/ Laimonukas/jetpack-game:html

butler status Laimonukas/godot-crashcourse
butler status Laimonukas/pn
butler status Laimonukas/shaders
butler status Laimonukas/jetpack-game

Read-Host -Prompt "Press Enter to exit"