;#NoEnv
#Warn

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include cGist.ahk

; #Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force

ReferenceVersion := "0.2.0"
debug := 1


Yunit.Use(YunitStdOut, YunitWindow).Test(BasicTestSuite)
;Yunit.Use(YunitStdOut, YunitWindow).Test(MiscTestSuite, NotRealWindowTestSuite, HideShowTestSuite, ExistTestSuite, RollupTestSuite, MoveResizeTestSuite, TileTestSuite)
Return

; ###################################################################
class BasicTestSuite
{
	; Basic-Data
	user := "AHKUser"
	pw := "AHKUser2012"

    Begin()
    {
		Global debug
		this.obj := new Gist(this.user, this.pw) ; Create a new GIST-object by given ID
    }
 
	
	Version()
    {
		Global ReferenceVersion
		Yunit.assert(this.obj.version() == ReferenceVersion)
    }
	
	End()
    {
        this.remove("obj")
		this.obj := 
    }
}
