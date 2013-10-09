/*
	Title: JSON
		 JSON Utilities for AutoHotkey

	Details:
		 Internally the ActiveX Control "Windows Script Control " (http://www.microsoft.com/de-de/download/details.aspx?id=1949) is used by those functions

	Author: 
	Compilation by hoppfrosch; Original work by Wicked and tmplinshi

	Credits: 
		- Wicked (http://www.autohotkey.com/board/topic/95262-obj-json-obj/#entry600438)
		- tmplinshi (http://www.autohotkey.com/board/topic/94687-jsonformatter-json-pretty-print-using-javascript/#entry596715)
;
		
	License: 
	???
*/

/*
===============================================================================
Function:   jsonAHK
    returns an AHK object from a JSON string

Params:
    s - String representing a JSON object
	
Author(s):
    20130713 (Original) - Wicked (http://www.autohotkey.com/board/topic/95262-obj-json-obj/#entry600438)
===============================================================================
*/
jsonAHK(s){
	static o:=comobjcreate("scriptcontrol")
	o.language:="jscript"
	return o.eval("(" s ")")
}

/*
===============================================================================
Function:   jsonBuild
   returns a JSON string from an AHK object.

Params:
    j - AHK object
	
Author(s):
    20130713 (Original) - Wicked (http://www.autohotkey.com/board/topic/95262-obj-json-obj/#entry600438)
===============================================================================
*/
; To format arrays as objects, see http://www.autohotkey.com/board/topic/95303-differentiating-between-array-and-object/, switch the commented lines.
jsonBuild(j) { 
	for x,y in j
		s.=((a:=(j.setcapacity(0)=(j.maxindex()-j.minindex()+1)))?"":x ":")(isobject(y)?jsonBuild(y):y/y||y==0?y:"'" y "'") ","	
		;s.=x ":" (isobject(y)?jsonBuild(y):y/y||y==0?y:"'" y "'") ","
	return (a?"[" rtrim(s,",") "]":"{" rtrim(s,",") "}")
	;return ("{" rtrim(s,",") "}")
}

/*
===============================================================================
Function:   jsonGet
   returns an value from a JSON string

Params:
    s - String representing a JSON object
    k - key whose value to get from HSON string
	
Author(s):
    20130713 (Original) - Wicked (http://www.autohotkey.com/board/topic/95262-obj-json-obj/#entry600438)
===============================================================================
*/
jsonGet(s,k){
	static o:=comobjcreate("scriptcontrol")
	o.language:="jscript"
	return o.eval("(" s ")." k)
}


/*
===============================================================================
Function:   jsonFormatter
   returns a prettyPrinted string from a JSON string

Params:
    json - String representing a JSON object
	
Author(s):
    20130722 (Original) - tmplinshi (http://www.autohotkey.com/board/topic/94687-jsonformatter-json-pretty-print-using-javascript/#entry596715)
===============================================================================
*/
jsonFormatter(json)
{
	global js_JsonUti
	if !js_JsonUti
		__LoadJsonUti()

	ComObjError(false)
	oSC := ComObjCreate("ScriptControl")
	oSC.Language := "JScript"
	oSC.ExecuteStatement(js_JsonUti)
	format_str := oSC.Eval("JsonUti.convertToString(" json ")")
	Return, format_str
}

; Internal Helper function for jsonFormatter() - Embedded JavaScript to do the main formatting task
; By  tmplinshi (http://www.autohotkey.com/board/topic/94687-jsonformatter-json-pretty-print-using-javascript/#entry596715)
__LoadJsonUti()
{
	global js_JsonUti

	; http://blog.csdn.net/lijpwsw/article/details/6881487
	js_JsonUti =
	(LTrim
		var JsonUti = {
		    n: "\n",
		    t: "\t",
		    convertToString: function(obj) {
		        return JsonUti.__writeObj(obj, 1);
		    },
		    __writeObj: function(obj
		    , level 
		    , isInArray) { 
		        if (obj == null) {
		            return "null";
		        }
		        if (obj.constructor == Number || obj.constructor == Date || obj.constructor == String || obj.constructor == Boolean) {
		            var v = obj.toString();
		            var tab = isInArray ? JsonUti.__repeatStr(JsonUti.t, level - 1) : "";
		            if (obj.constructor == String || obj.constructor == Date) {
		                return tab + ("\"" + v + "\"");
		            }
		            else if (obj.constructor == Boolean) {
		                return tab + v.toLowerCase();
		            }
		            else {
		                return tab + (v);
		            }
		        }
		        var currentObjStrings = [];
		        for (var name in obj) {
		            var temp = [];
		            var paddingTab = JsonUti.__repeatStr(JsonUti.t, level);
		            temp.push(paddingTab);
		            temp.push(name + " : ");
		            var val = obj[name];
		            if (val == null) {
		                temp.push("null");
		            }
		            else {
		                var c = val.constructor;
		                if (c == Array) {
		                    temp.push(JsonUti.n + paddingTab + "[" + JsonUti.n);
		                    var levelUp = level + 2;
		                    var tempArrValue = [];
		                    for (var i = 0; i < val.length; i++) {
		                        tempArrValue.push(JsonUti.__writeObj(val[i], levelUp, true));
		                    }
		                    temp.push(tempArrValue.join("," + JsonUti.n));
		                    temp.push(JsonUti.n + paddingTab + "]");
		                }
		                else if (c == Function) {
		                    temp.push("[Function]");
		                }
		                else {
		                    temp.push(JsonUti.__writeObj(val, level + 1));
		                }
		            }
		            currentObjStrings.push(temp.join(""));
		        }
		        return (level > 1 && !isInArray ? JsonUti.n: "")
		        + JsonUti.__repeatStr(JsonUti.t, level - 1) + "{" + JsonUti.n
		        + currentObjStrings.join("," + JsonUti.n)
		        + JsonUti.n + JsonUti.__repeatStr(JsonUti.t, level - 1) + "}";
		    },
		    __isArray: function(obj) {
		        if (obj) {
		            return obj.constructor == Array;
		        }
		        return false;
		    },
		    __repeatStr: function(str, times) {
		        var newStr = [];
		        if (times > 0) {
		            for (var i = 0; i < times; i++) {
		                newStr.push(str);
		            }
		        }
		        return newStr.join("");
		    }
		};
	)
}