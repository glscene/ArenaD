VERSION 5.00
Begin VB.Form frmMain 
   Caption         =   "Form1"
   ClientHeight    =   3150
   ClientLeft      =   60
   ClientTop       =   390
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3150
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows-Standard
   Visible         =   0   'False
   Begin VB.FileListBox filMain 
      Height          =   2235
      Left            =   240
      Pattern         =   "*.htm*"
      TabIndex        =   0
      Top             =   240
      Width           =   2895
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'*** Dirty little text replacer, takes a single file as input
'*** Written by Dennis Murczak for the ai.planet project
'*** http://www.aiplanet.org

Dim file As String

Private Sub Form_Load()

On Error GoTo ErrorHandler

file = Command$

Open file For Binary As #1

a$ = Space$(LOF(1))
Get #1, , a$
a$ = Replace(a$, ".png", ".jpg")
Seek #1, 1
Put #1, , a$
 
Close

End

Exit Sub

ErrorHandler:
MsgBox "Parameter or disk error! Report to dennis@aiplanet.org.", vbExclamation, "Even 100 lines of codes can bug"
End

End Sub
