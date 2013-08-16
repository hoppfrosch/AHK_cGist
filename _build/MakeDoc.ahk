; Mit dem Skript wird die Dokumentation im Ordner _doc erzeugt

#include _inc\BuildTools.ahk
#NoEnv

srcBaseDir := A_ScriptDir "\.."
dstBaseDir := A_ScriptDir "\..\_doc"

makeCopy(srcBaseDir "\cGist.ahk", dstBaseDir)
;makeCopy(srcBaseDir "\_inc\cJeeBooConfig.ahk", dstBaseDir "\_inc") 

; Erzeuge die Doku nur fuer die eigenen Dateien
MakeDoc(dstBaseDir)
;MakeDoc(dstBaseDir "\inc")

;FileDelete, %dstBaseDir%\JeeBoo_ConfigEditor.ahk
;FileDelete, %dstBaseDir%\_inc\cJeeBooConfig.ahk
