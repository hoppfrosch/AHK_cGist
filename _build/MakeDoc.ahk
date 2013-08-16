; Mit dem Skript wird die Dokumentation im Ordner _doc erzeugt

#include _inc\BuildTools.ahk
#NoEnv

srcBaseDir := A_ScriptDir "\.."
dstBaseDir := A_ScriptDir "\..\..\gh_pages"

makeCopy(srcBaseDir "\cGist.ahk", dstBaseDir)
;makeCopy(srcBaseDir "\_inc\cJeeBooConfig.ahk", dstBaseDir "\_inc") 

; Erzeuge die Doku nur fuer die eigenen Dateien
MakeDoc(dstBaseDir)
;MakeDoc(dstBaseDir "\inc")

FileDelete, %dstBaseDir%\cGist.ahk
;FileDelete, %dstBaseDir%\_inc\cJeeBooConfig.ahk

FileMove, %dstBaseDir%\cGist.html, %dstBaseDir%\index.html