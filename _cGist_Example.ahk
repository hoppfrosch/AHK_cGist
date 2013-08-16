#CommentFlag ;

; Basic-Data
gistID := "3742243"
user := "AHKUser"
pw := "AHKUser2012"

; ########## Retrieving GIST that already exists on github ##################################
; Create a new GIST-object by given ID
gistObj := new Gist(gistID, user, pw)

; Get the GistObject by ID
gist := gistObj.get()

; Get the names of the files within the GIST
MyFiles := gistObj.files()
fn := MyFiles[1]
MsgBox % "FILENAME:" fn

; Get the contents of the file as plain string
contents := Standard2AHKControlCharacter(gist.files[fn].content)
MsgBox % contents

; Get the GIST as JSON-String
gistJSON := gistObj.getJSON()
MsgBox % gistJSON

#include cGist.ahk