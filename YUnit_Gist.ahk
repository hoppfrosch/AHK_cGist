;#NoEnv
;#Warn
#CommentFlag ;

#Include %A_ScriptDir%\Yunit\Yunit.ahk
#Include %A_ScriptDir%\Yunit\Window.ahk
#Include %A_ScriptDir%\Yunit\StdOut.ahk
#include %A_ScriptDir%\cGist.ahk

; #Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force

ReferenceVersion := "0.6.0"
debug := 1


Yunit.Use(YunitStdOut, YunitWindow).Test(MiscTestSuite,BasicTestSuite,BearerTestSuite)
;Yunit.Use(YunitStdOut, YunitWindow).Test(BearerTestSuite)
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
  		OutputDebug % "************** Start of BasicTestSuite ******************************************************* "
		Global debug
		this.obj := new Gist() ; Create a new GIST-object
		this.obj.authmethod := "basic"
		this.obj.username := this.user
		this.obj.password :=this.pw
    }
 
	Get()
	{
		this.obj.get("6268535")
		
		MyFiles := this.obj.files()
		fn := MyFiles[1]
		MsgBox % "First FILENAME:" fn
				
		;MsgBox % this.obj.getJSON()
	}
	
	End()
    {
        this.remove("obj")
		this.obj := 
		OutputDebug % "************** End of BasicTestSuite ******************************************************* "
    }
}

; ###################################################################
class BearerTestSuite
{
	; Basic-Data
	accesstoken := "0bb269e042baa2c203944f2c8255017d809bc134"

    Begin()
    {
    	OutputDebug % "************** Start of BearerTestSuite ******************************************************* "
		Global debug
		this.obj := new Gist() ; Create a new GIST-object

		this.obj.authmethod := "bearer"
		this.obj.accesstoken := this.accesstoken			
    }
	
	Get()
	{
		this.obj.get("6268535")
		
		MyFiles := this.obj.files()
		fn := MyFiles[1]
		MsgBox % "First FILENAME:" fn
		Yunit.assert(fn == "Apple")
				
		;MsgBox % this.obj.getJSON()
	}
	
	End()
    {
        this.remove("obj")
		this.obj := 
		OutputDebug % "************** End of BearerTestSuite ******************************************************* "
    }
}

; ###################################################################
class MiscTestSuite
{
	; Basic-Data
	accesstoken := "0bb269e042baa2c203944f2c8255017d809bc134"

    Begin()
    {
    	OutputDebug % "************** Start of MiscTestSuite ******************************************************* "
		Global debug
		this.obj := new Gist() ; Create a new GIST-object

		this.obj.authmethod := "bearer"
		this.obj.accesstoken := this.accesstoken		
		
    }
 
	
	Version()
    {
		Global ReferenceVersion
		version := this.obj.version
		Yunit.assert(this.obj.version == ReferenceVersion)
    }
		
	End()
    {
        this.remove("obj")
		this.obj := 
		OutputDebug % "************** End of MiscTestSuite ******************************************************* "
    }
}

