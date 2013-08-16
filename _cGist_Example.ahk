#CommentFlag ;

; Basic-Data
user := "AHKUser"
pw := "AHKUser2012"

; Create a new GIST-object by given ID
gistObj := new Gist(user, pw)


; ########## Creating a new GIST ###########################################################
; Create Public gist linked to given account, with the title "Apple" - the newly created gist-ID is stored internally
gist := gistObj.put("Test 3", "Apple", 1)
MsgBox % "ID:" gistObj.id "`nURL:" gistObj.url()
gistID := gistObj.id

gist := 

; ########## Retrieving GIST that already exists on github ################################
; Get the GistObject by ID - the ID is stored internally
gist := gistObj.get(gistID)
MsgBox % "ID:" gistObj.id "`nURL:" gistObj.url()

; ########## Working with contents of the gist ############################################
; Get the names of the files within the GIST
MyFiles := gistObj.files()
fn := MyFiles[1]
MsgBox % "FILENAME:" fn

; Get the contents of the file as plain string
contents := Standard2AHKControlCharacter(gist.files[fn].content)
MsgBox % contents

; Get the GIST as JSON-String - the internally stored ID is used
gistJSON := gistObj.getJSON()
MsgBox % gistJSON

; ########## Delete a gist ################################################################
gistObj.delete()


#include cGist.ahk