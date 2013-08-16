#CommentFlag ;

/*
	Title: Gist-class
		Class to handle gists (https://gist.github.com/)

	Author: 
        hoppfrosch
    
	Credits: 
		- Perl Module WWW::GitHub::Gist(https://metacpan.org/module/WWW::GitHub::Gist)
		- ComObject HTTPRequest(http://www.autohotkey.com/community/viewtopic.php?p=377651#p377651 & http://msdn.microsoft.com/en-us/library/aa384106.aspx)
	    - Base64 Encoding by Laszlo (http://www.autohotkey.com/community/viewtopic.php?p=68613#p68613)
		
	Requires:
		- lib_json by LordKrandel (http://www.autohotkey.com/community/viewtopic.php?f=13&t=66070)
		
	License: 
        WTFPL (http://sam.zoy.org/wtfpl/)
		
	Changelog:
	    0.1.1 (20121015) - hoppfrosch ([+] Memberfunction getJSON())
		0.1.0 (20121015) - hoppfrosch ([+] Initial)
*/
class Gist {
	static _api_url := "https://api.github.com"
	static _version := "0.1.1"
	_debug := 1  ; _DBG_
	static user := ""
	static password := ""
	static id := 0
	static WebRequest := ""
	gist := ""
	
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
	get() {
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([id:" this.id "])]" ; _DBG_
		
		url := "/gists/" this.id
		retVal := this.__get_json_obj(url)
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
	getJSON() {
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([id:" this.id "])]" ; _DBG_
		
		url := "/gists/" this.id
		retVal := this.__get_json(url)
		this.gist := retVal
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([id:" this.id "])]" ; _DBG_
		return retVal
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
    20110928 (Original) - hoppfrosch
===============================================================================
*/  
    __basic_auth_header() {
		
		if (!(this.user) && !(this.password)) {
			if (this._debug) ; _DBG_
				OutputDebug % "![" A_ThisFunc "(user=" this.user ", password=" this.password ")] - ERROR: required parameter is missing" ; _DBG_
			return
		}
		
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "(user=" this.user ", password=" this.password ")]" ; _DBG_
		
		str := this.user ":" this.password
		token := "Basic " Base64Encode(str)
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "() -> ret:" token ")]" ; _DBG_
		
		OutputDebug % ">[" A_ThisFunc "(user=" this.user ", password=" this.password ")  -> ret:" token "]" ; _DBG_
		return token
	}

/*
===============================================================================
Function: __get_json_obj
    HTTPget on Github-URL, returning result as Object

Parameters:
    url - URL to get - it's a relative URL to "https://api.github.com" (required)
    
Returns:
    json object, (empty object in case of error)
    
Author(s):
    20110928 (Original) - hoppfrosch
===============================================================================
*/ 
	__get_json_obj(url) {
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "(url=" url ")]" ; _DBG_
		data := this.__get_json(url)
		j := JSON_from(data)
		
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(url=" url ")]" ; _DBG_
		return j
	}

/*
===============================================================================
Function: __get_json
    HTTPget on Github-URL, returning result as JSON-String

Parameters:
    url - URL to get - it's a relative URL to "https://api.github.com" (required)
    
Returns:
    String ("{"message":"Not Found"}" in case of Error)
    
Author(s):
    20110928 (Original) - hoppfrosch
===============================================================================
*/ 
	__get_json(url) {
		if (this._debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "(url=" url ")]" ; _DBG_
		req_url  := this._api_url url
		this.WebRequest.Open("GET", req_url)
		this.WebRequest.Send()
		data := this.WebRequest.ResponseText
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(url=" req_url ")] -> ret: " data ; _DBG_
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
    id - Gist-ID (*Obligatory* - https://gist.github.com/).
	user - Username for https://gist.github.com/
	password - Password for https://gist.github.com/
	    
Author(s):
    20120621 (Original) - hoppfrosch
===============================================================================
*/     
	__New(id = 3742243, user = "AHKUser", password = "AHKUser2012", debug = 1) {
		this._debug := debug  ; _DBG_
		
		if (this._debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(id=" id ", user= " user ", password=" password ")]" ; _DBG_
		this.id := id
		this.user := user
		this.password := password
		
		this.WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		if (this._debug) && (!this.WebRequest) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(id=" req_url ", user=" user ", password=" password ")] -> ERROR: Creating WinHttp.WinHttpRequest COM objecz" ; _DBG_
	}
}
; end of class

/* 
**********************************************************************************
Start of Base64 Encoding/Decoding

Base64 Encoding/Decoding  (see: http://en.wikipedia.org/wiki/Base64)

Original - Laszlo - http://www.autohotkey.com/community/viewtopic.php?p=68613#p68613
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
