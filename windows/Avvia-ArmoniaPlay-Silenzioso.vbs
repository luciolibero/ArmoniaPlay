' ArmoniaPlay — Lucio Ardito (Avvio silenzioso senza finestra terminale)
Set fso = CreateObject("Scripting.FileSystemObject")
Set sh = CreateObject("WScript.Shell")
dir = fso.GetParentFolderName(WScript.ScriptFullName)
bat = dir & "\Avvia-ArmoniaPlay.bat"

args = ""
If WScript.Arguments.Count > 0 Then
  For i = 0 To WScript.Arguments.Count - 1
    args = args & " """ & WScript.Arguments(i) & """"
  Next
End If

sh.Run """" & bat & """" & args, 0, False
