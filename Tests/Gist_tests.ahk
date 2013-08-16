#NoEnv

class Category_Gist {

    class Category_Basic  {
        
        Test_version() {
            OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>" 
            l := new Gist()
            Tests.TestEqual(l.version(),"0.1.1")
            OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
        }    
        
        Test_get() {
            OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
            gistID := "3742243"
            user := "AHKUser"
            pw := "AHKUser2012"
            l := new Gist(gistID, user, pw)
            j := l.get()
            Tests.TestEqual(j.git_push_url, "git@gist.github.com:" gistID ".git")
            ; ObjTree(j)
            OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
        }
     }
     
     class Category_Internal  {        
            
        Test___get_json()  {
            OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
            gistID := "3742243"
            user := "AHKUser"
            pw := "AHKUser2012"
            l := new Gist(gistID, user, pw)
            data := l.__get_json("/gists/" gistID)
            Tests.TestNotEqual(data, "{""message"":""Not Found""}")
            OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
        }
    
        Test___get_json_obj()  {
            OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
            gistID := "3742243"
            user := "AHKUser"
            pw := "AHKUser2012"
            l := new Gist(gistID, user, pw)
            j := l.__get_json_obj("/gists/" gistID)
            Tests.TestEqual(j.git_push_url, "git@gist.github.com:" gistID ".git")
            ;Array_List(j)
            OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
        }
        
        Test___basic_auth_header()  {
            OutputDebug % "<<<<<<<<<<<<<<<<<<<[" A_ThisFunc "]>>>>>>>>>>>>>>>>>>>>>>>>>>"
            l := new Gist()
            Tests.TestEqual(l.__basic_auth_header(),"Basic QUhLVXNlcjpBSEtVc2VyMjAxMg==")
            OutputDebug % ">>>>>>>>>>>>>>>>>>>[" A_ThisFunc "]<<<<<<<<<<<<<<<<<<<<<<<<<<"
        }
    }
}

TestEqual(Result="?",Value="?",Info="")
{
    If !Equal(Result,Value)
        throw Info "Data is not equal (" Result " != " Value ")"
}

TestNotEqual(Result="?",Value="?",Info="")
{
    If Equal(Result,Value)
        throw Info "Data is equal (" Result " == " Value ")"
}
