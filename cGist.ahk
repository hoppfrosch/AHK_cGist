#CommentFlag ;

/*
	Title: Gist-class
		Class to handle gists (https://gist.github.com/)

	Author: 
	hoppfrosch

	Credits: 
		- Perl Module WWW::GitHub::Gist(https://metacpan.org/module/WWW::GitHub::Gist)
		- ComObject HTTPRequest(http://www.autohotkey.com/board/topic/56987-com-object-reference-autohotkey-l/#entry358508 & http://msdn.microsoft.com/en-us/library/aa384106.aspx)
		- Base64 Encoding by Laszlo (http://www.autohotkey.com/board/topic/5545-base64-coderdecoder/page-2#entry64250)
		- Gist() by Geekdude (https://gist.github.com/4421950)
		
	Requires:
		- lib_json by LordKrandel (http://www.autohotkey.com/board/topic/61328-lib-json-ahk-l-json-object/)
		
	License: 
	WTFPL (http://sam.zoy.org/wtfpl/)
		
	Changelog:
		0.2.0 (20130102) - hoppfrosch (Create new gist & delete existing gist
		0.1.2 (20130102) - hoppfrosch ([+] Functions AKK2StandardControlCharacter(), Standard2AHKControlCharacter())
		0.1.1 (20121015) - hoppfrosch ([+] Memberfunction getJSON())
		0.1.0 (20121015) - hoppfrosch ([+] Initial)
*/
class Gist {
	static _api_url := "https://api.github.com"
	static _gist_url := "https://gist.github.com"
	static _version := "0.2.0"
	_debug := 1  ; _DBG_
	static user := ""
	static password := ""
	static id := 0
	static WebRequest := ""
	gist := ""

/*
===============================================================================
Function:   delete
    Deletes an Gist with given ID - if ID is missing the internally stored ID is used

Params:
    id - id of gist to delete (optional - default: internally stored id)
	
Author(s):
    20130102 (Original) - hoppfrosch
===============================================================================
*/
	delete(id=0) {
		if (id = 0) {
			if (this.id) {
				id := this.id
			}
			else {
				return
			}
		}
		this.id := id
		
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([id:" this.id "])]" ; _DBG_
		
		url := "/gists/" id
		retVal := this.__HTTPdelete(url)
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([id:" this.id "]) -> " retVal "]" ; _DBG_
		return retVal
	}
	
/*
===============================================================================
Function:   files
    Returns an array with filenames stored in gist

Returns:
    Array with filenames. The several files can be accessed via gist.files[fn] with fn as name of the file to access...
	
Author(s):
    20120928 (Original) - hoppfrosch
===============================================================================
*/
	files() {	
		if (!this.gist)	
			gist := this.get()
		else 
			gist := this.gist
			
		Arr := {}
		Cnt := 0
		str := ""
		for file, val in gist.files {
			if (Cnt > 0) 
				str := str ", "
			Arr.Insert(file)
			Cnt := Cnt + 1
			str := str file
		}
		
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([id:" this.id "])] -> Gist contains " Cnt " files (" str ")" ; _DBG_
		return Arr
	}

/*
===============================================================================
Function:   get
    Returns an Object with current GIST

Returns:
    GIST-Object
	
Author(s):
    20120928 (Original) - hoppfrosch
===============================================================================
*/
	get(id=0) {
		if (id = 0) {
			if (this.id) {
				id := this.id
			}
		}
		this.id := id
		
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([id:" this.id "])]" ; _DBG_
		
		url := "/gists/" id
		retVal := this.__HTTPget_obj(url)
		this.gist := retVal
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([id:" this.id "])]" ; _DBG_
		return retVal
	}
	
/*
===============================================================================
Function:   getJSON
    Returns the JSON string with current GIST

Returns:
    String (JSON)
	
Author(s):
    20121015 (Original) - hoppfrosch
===============================================================================
*/
	getJSON(id=0) {
		if (id = 0) {
			if (this.id) {
				id := this.id
			}
		}
		this.id := id
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([id:" this.id "])]" ; _DBG_
		
		url := "/gists/" this.id
		retVal := this.__HTTPget(url)
		this.gist := retVal
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([id:" this.id "])]" ; _DBG_
		return retVal
	}

/*
===============================================================================
Function:   put
    Creates a new gist

Parameters:
    Contents - Contents of the new gist (required)
	Title - title (filename) of the new gist (optional - default: "Autohotkey")
	Public - Flag to indicate wheter new gist should be public (optional - default: 1 (true))
	
Returns:
    GIST-Object
	
Author(s):
    20120928 (Original) - hoppfrosch
===============================================================================
*/
	put(Contents, Title="AutoHotkey", Public="1")
	{
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([id:" this.id "])]" ; _DBG_
		
		Public := Public ? "true" : "false"
		Contents := AHK2StandardControlCharacter(Contents)
    
		JSON = {"public":"%Public%","files":{"%Title%":{"content":"%Contents%"}}}
    
		data:= this.__HTTPpost(JSON, "/gists")
    
		If (RegExMatch(data, """html_url""\:""(.*?)""", Out)) {
			this.id := this.__extractIDFromURL(Out1)
			if (this._debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "([id:" this.id "])]" ; _DBG_
			return this.get()
		}
		
		return
	}

	/*
===============================================================================
Function: url
    Returns the URL of the gist 

Returns:
    String (URL)
	
Author(s):
    20130102 (Original) - hoppfrosch
===============================================================================
*/
	url() {
		return this._gist_url "/" this.id
	}
	
/*
===============================================================================
Function:   version
    Current version of the class (Versioning scheme according to http://semver.org)

Returns:
    current version number of the class

Author(s):
    20120621 (Original) - hoppfrosch
===============================================================================
*/
	version() {
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "() -> (" this._version ")]" ; _DBG_
		return this._version
	}

; ##############################################################################
; #################### INTERNAL FUNCTIONS ######################################
; ##############################################################################
/*
===============================================================================
Function: __basic_auth_header
    Creates authorization token for github (**INTERNAL**)
    
Returns:
    authorization token (string)
    
Author(s):
	20120928 (Original) - hoppfrosch
	20130102 Support anonymous authorization
===============================================================================
*/  
    __basic_auth_header() {
		
		if (!(this.user) && !(this.password)) {
			token :=  ; Don't auth (anonymous)
			return token
		}
		
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "(user=" this.user ", password=" this.password ")]" ; _DBG_
		
		str := this.user ":" this.password
		token := "Basic " Base64Encode(str)
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "(user=" this.user ", password=" this.password ")  -> ret:" token "]" ; _DBG_
		return token
	}


/*
===============================================================================
Function: __extractIDFromURL
    Extracts ID from a given gist-url(**INTERNAL**)
    
Parameters:
    url - gist-URL (required)
	
Returns:
    gist-ID
    
Author(s):
	20130102 (Original) - hoppfrosch
===============================================================================
*/  
	__extractIDFromURL(url) {
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "(url=" url ")]" ; _DBG_
		
		FoundPos := RegExMatch(url, this._gist_url "/(\d+)", match)
		
		if (FoundPos) {
			if (this._debug) ; _DBG_
				OutputDebug % ">[" A_ThisFunc "(url=" url ")  -> ret:" match1 "]" ; _DBG_
			return match1
		}
		
		return
	}

/*
===============================================================================
Function: __HTTPdelete
    HTTPdelete on Github-URL

Parameters:
    url - URL to deletet - it's a relative URL to "https://api.github.com" (required)
    
Returns:
    String ("{"message":"Not Found"}" in case of Error)
    
Author(s):
    20130102 (Original) - hoppfrosch
===============================================================================
*/ 
	__HTTPdelete(url) {
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "(url=" url ")]" ; _DBG_
		req_url  := this._api_url url
		Basic := this.__basic_auth_header() 
		this.WebRequest.Open("DELETE", req_url)
		if (Basic)
			this.WebRequest.SetRequestHeader("authorization", Basic)
		this.WebRequest.Send()
		data := this.WebRequest.ResponseText
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(url=" req_url ")] -> ret: " data ; _DBG_
		return data
	}

/*
===============================================================================
Function: __HTTPget_obj
    HTTPget on Github-URL, returning result as Object

Parameters:
    url - URL to get - it's a relative URL to "https://api.github.com" (required)
    
Returns:
    json object, (empty object in case of error)
    
Author(s):
    20120928 (Original) - hoppfrosch
===============================================================================
*/ 
	__HTTPget_obj(url) {
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "(url=" url ")]" ; _DBG_
		data := this.__HTTPget(url)
		j := JSON_from(data)
		
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(url=" url ")]" ; _DBG_
		return j
	}

/*
===============================================================================
Function: __HTTPget
    HTTPget on Github-URL, returning result as JSON-String

Parameters:
    url - URL to get - it's a relative URL to "https://api.github.com" (required)
    
Returns:
    String ("{"message":"Not Found"}" in case of Error)
    
Author(s):
    20120928 (Original) - hoppfrosch
===============================================================================
*/ 
	__HTTPget(url) {
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "(url=" url ")]" ; _DBG_
		req_url  := this._api_url url
		Basic := this.__basic_auth_header() 
		this.WebRequest.Open("GET", req_url)
		if (Basic)
			this.WebRequest.SetRequestHeader("authorization", Basic)
		this.WebRequest.Send()
		data := this.WebRequest.ResponseText
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(url=" req_url ")] -> ret: " data ; _DBG_
		return data
	}

/*
===============================================================================
Function: __HTTPpost
    HTTPpost JSON-string to on Github-URL, returning result as JSON-String

Parameters:
	Contents - Contents to post
    url - URL to get - it's a relative URL to "https://api.github.com" (required)
    
Returns:
    String ("{"message":"Not Found"}" in case of Error)
    
Author(s):
    20130201 (Original) - hoppfrosch
===============================================================================
*/ 
	__HTTPpost(Contents, url = "/gists") {
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "(JSON=" JSON ", url=" url ")]" ; _DBG_
		req_url  := this._api_url url
		this.WebRequest.Open("POST", req_url)
		Basic := this.__basic_auth_header() 
		if (Basic)
			this.WebRequest.SetRequestHeader("authorization", Basic)
		this.WebRequest.Send(Contents)
		data := this.WebRequest.ResponseText
		If !RegExMatch(this.WebRequest.ResponseText, """html_url""\:""(.*?)""", Out)
			throw this.WebRequest.ResponseText
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(JSON=" JSON ", url=" req_url ")] -> ret: " data ; _DBG_
		return data
	}
	
	
	__debug(value="") { ; _DBG_
		if % (value="") ; _DBG_
			return this._debug ; _DBG_
		value := value<1?0:1 ; _DBG_
		this._debug := value ; _DBG_
		return this.debug ; _DBG_
	} ; _DBG_

/*
===============================================================================
Function: __New
    Constructor

Parameters:
	user - Username for https://gist.github.com/
	password - Password for https://gist.github.com/
	    
Author(s):
    20120621 (Original) - hoppfrosch
	20130102 Removed ID as parameter
===============================================================================
*/     
	__New(user = "AHKUser", password = "AHKUser2012", debug = 1) {
		this._debug := debug  ; _DBG_
		
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(id=" id ", user= " user ", password=" password ")]" ; _DBG_
		this.user := user
		this.password := password
		
		this.WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		if (this._debug) && (!this.WebRequest) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(user=" user ", password=" password ")] -> ERROR: Creating WinHttp.WinHttpRequest COM object" ; _DBG_
	}
}
; end of class

/* 
**********************************************************************************
Start of Base64 Encoding/Decoding

Base64 Encoding/Decoding  (see: http://en.wikipedia.org/wiki/Base64)

Original - Laszlo - http://www.autohotkey.com/board/topic/5545-base64-coderdecoder/page-2#entry64250
*/
Base64Encode(string) {
	out := ""
	Loop Parse, string
	{
		If Mod(A_Index,3) = 1
			buffer := Asc(A_LoopField) << 16
		Else If Mod(A_Index,3) = 2
			buffer += Asc(A_LoopField) << 8
		Else {
			buffer += Asc(A_LoopField)
			out := out . Code(buffer>>18) . Code(buffer>>12) . Code(buffer>>6) . Code(buffer)
		}
	}
	If Mod(StrLen(string),3) = 0
		Return out
	If Mod(StrLen(string),3) = 1
		Return out . Code(buffer>>18) . Code(buffer>>12) "=="
	Return out . Code(buffer>>18) . Code(buffer>>12) . Code(buffer>>6) "="
}

Base64Decode(code) {
	out := ""
	StringReplace code, code, =,,All
	Loop Parse, code 
	{	
		If Mod(A_Index,4) = 1
			buffer := DeCode(A_LoopField) << 18
		Else If Mod(A_Index,4) = 2
			buffer += DeCode(A_LoopField) << 12
		Else If Mod(A_Index,4) = 3
			buffer += DeCode(A_LoopField) << 6
		Else {
			buffer += DeCode(A_LoopField)
			out := out . Chr(buffer>>16) . Chr(255 & buffer>>8) . Chr(255 & buffer)
		}
	}
	If Mod(StrLen(code),4) = 0
		Return out
	If Mod(StrLen(code),4) = 2
		Return out . Chr(buffer>>16)
	Return out . Chr(buffer>>16) . Chr(255 & buffer>>8)
}

Code(i) {   ; <== Chars[i & 63], 0-base index
	Chars = ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/
	StringMid i, Chars, (i&63)+1, 1
	Return i
}

DeCode(c) { ; c = a char in Chars ==> position [0,63]
	Chars = ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/
	Return InStr(Chars,c,1) - 1
}
/* 
End of Base64 Encoding/Decoding
**********************************************************************************
*/

/*
===============================================================================
Function: AHK2StandardControlCharacter
	Replace AHK-style control characters to Standard

Parameters:
    J - String to convert to Standard style
    
Returns:
    String in Standard Style
    
Author(s):
    20130201 (Original) - hoppfrosch
	Original - geekdude - http://www.autohotkey.com/board/topic/88675-gist-ahk-l/
===============================================================================
*/
AHK2StandardControlCharacter(J) {
	StringReplace, J, J, \, \\, All
	StringReplace, J, J, `b, \b, All
	StringReplace, J, J, `f, \f, All
	StringReplace, J, J, `n, \n, All
	StringReplace, J, J, `r, \r, All
	StringReplace, J, J, `t, \t, All
	StringReplace, J, J, `", \`", All
	return J
}

/*
===============================================================================
Function: Standard2AHKControlCharacter
	Replace Standard control characters to AHK-style 

Parameters:
    J - String to convert to AHK-Style
    
Returns:
    String in AHK style
    
Author(s):
    20130201 (Original) - hoppfrosch
===============================================================================
*/
Standard2AHKControlCharacter(J) {
	StringReplace, J, J, \\, \, All
	StringReplace, J, J, \b, `b, All
	StringReplace, J, J, \f, `f, All
	StringReplace, J, J, \n, `n, All
	StringReplace, J, J, \r, `r, All
	StringReplace, J, J, \t, `t, All
	StringReplace, J, J, \`", `", All
	return J
}
