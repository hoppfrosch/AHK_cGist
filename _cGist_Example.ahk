#CommentFlag ;

gistID := "3742243"
user := "AHKUser"
pw := "AHKUser2012"

gistObj := new Gist(gistID, user, pw)
gist := gistObj.get()
MyFiles := gistObj.files()
fn := MyFiles[1]
MsgBox % "FILENAME:" fn

contents := gist.files[fn].content
MsgBox % contents

#include cGist.ahk