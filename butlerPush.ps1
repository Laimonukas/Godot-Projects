#butler push Pong/Exported/Exported.zip Laimonukas/pn:html
#butler push Shaders/Exported/ Laimonukas/shaders:html
#butler push CrashCourse/Exported/Exported.zip Laimonukas/godot-crashcourse:html
#butler push JetPack/Exported/ Laimonukas/jetpack-game:html
butler push JetRaid/Exported/ Laimonukas/jetraid:html

#butler status Laimonukas/godot-crashcourse
#butler status Laimonukas/pn
#butler status Laimonukas/shaders
#butler status Laimonukas/jetpack-game
butler status Laimonukas/jetraid

Read-Host -Prompt "Press Enter to exit"