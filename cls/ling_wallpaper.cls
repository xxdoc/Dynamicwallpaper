VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ling_wallpaper"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private Const myname As String = "�ӑB�ڼ��ģ�K"
'   �ڼ����w�O���ģ�K [�@�����̛]������ҕ�l�M��������ֻ��һ���ڼ�ģ�K]
'�뷨������2019/7/28
'By: �L�� |С��
' Blog: https://www.cnblogs.com/lingqingxue/
'   Blog: http://inkhin.com/
'       E-mail: 1919988942@qq.com
'__________________________________________
'
'   ԭ���� �O�ø��Ӵ��w�̈́�����픴��w
'   ͨ�^һ��C#�Ŀ���g����,��Ȼ,������ͨ�^���ò��ŽM��,ʹ���ɠ��ӑB�ڼ�
'   ���w�������c�h���ҕ����ҵ�BLog��ָ����[�x�x֧��]
'__________________________________________
'Public Enum SendMessageTimeoutFlags
'SMTO_ABORTIFHUNG = 2
'SMTO_BLOCK = 1
'SMTO_ERRORONEXIT = &H20
'SMTO_NORMAL = 0
'SMTO_NOTIMEOUTIFNOTHUNG = 8
'End Enum

'Private Const def_MessageA = &H52C '0x52c
'Private Const def_MessageB = &H3E8 '0x3e8
Private Const UNITS = 4294967296#
Private Const MAX_LONG = -2147483648#

Private mlTimer As Long 'Watetime��s var
Private Desktop As Long, hwnd As Long
Private WithEvents l_Timer As ling_Timer
Attribute l_Timer.VB_VarHelpID = -1
Private l_Image As B_Image

Private Sub Class_Initialize()
Set l_Image = New B_Image
    '�yԇ�r���ô��a�����r�����õ���  С���޸��� 19/7/30 12��00
    'Set l_Timer = New ling_Timer
    'l_Timer.Enabled = False
    'l_Timer.numInterval = 1
End Sub
Private Sub Class_Terminate()
Set l_Image = Nothing
    'Set l_Timer = Nothing
End Sub
Public Sub �O������(ByRef b_hwnd As Long)
'�O�Å���
hwnd = b_hwnd 'Set hwnd
'�O�ô��w��ʽ
            Call Frm_MAX(hwnd)
'�O�ô��w
            Desktop = BackDesktop
'�������O���鸸����
            Call win32api.SetParent(hwnd, Desktop)
'ģ�Mˢ������
            Call win32api.ShowWindow(hwnd, win32api.SW_HIDE)
            Call win32api.ShowWindow(hwnd, win32api.SW_SHOW)
'l_Timer.Enabled = True
End Sub
'��Ϣ����������WorkerW �������� ����Ҫö�ٲ�������SHELLDLL_DefView������� WorkerW ���� ���ص���
Private Function BackDesktop() As Long
Dim Desktop_h As Long
Desktop_h = win32api.FindWindowA("Progman", "Program Manager") 'ȡ������Ķ�������
Dim result As Long
result = 0&
Dim state As Long
state = 0
state = win32api.SendMessageTimeoutA(Desktop_h, &H52C, 0&, 0&, 0, &H328, VarPtr(result))
If state <> 1 Then MsgBox "�����ڼ����w�r�l��������"
'VarPtr(Workerw) = 0&
Workerw = 0&
' Win32.User32.ShowWindow(workerw, Win32.User32.SW_HIDE);
Call EnumWindows(AddressOf EnumWindowsProcA, 0&)
BackDesktop = Desktop_h
End Function
Public Sub Frm_MAX(hwnd As Long)
'�O�ßo߅���ʽ
Dim style As Long
style = win32api.GetWindowLongA(hwnd, GWL_STYLE)
style = style And Not win32api.WS_CAPTION
style = style And Not win32api.WS_SYSMENU
style = style And Not win32api.WS_MAXIMIZEBOX
style = style And Not win32api.WS_MINIMIZEBOX
style = style And Not win32api.WS_SIZEBOX
win32api.SetWindowLongA hwnd, win32api.GWL_STYLE, style
Dim swpFlag As Long
swpFlag = win32api.SWP_NOMOVE Or win32api.SWP_NOSIZE Or win32api.SWP_NOZORDER Or win32api.SWP_NOREDRAW Or win32api.SWP_NOOWNERZORDER Or win32api.SWP_NOCOPYBITS Or win32api.SWP_NOACTIVATE Or win32api.SWP_FRAMECHANGED Or win32api.WM_NCCALCSIZE
win32api.SetWindowPos hwnd, 0, 0, 0, 0, 0, swpFlag
'�O�ô��w�ߴ�
win32api.MoveWindow hwnd, 0, 0, Screen.Width, Screen.Height, ByVal 1
End Sub
'ling_2019/7/30��ע: Taskbar_visible�������΄ՙ��[�� /// ������ƺ��]��ʲ����̎
Public Sub Taskbar_Visble()
Dim hwnd As Long
hwnd = win32api.FindWindowA("Shell_TrayWnd", "")
If win32api.IsWindowVisible(hwnd) <> 0 Then
win32api.ShowWindow hwnd, 0
Else
win32api.ShowWindow hwnd, 1
End If
End Sub
Public Sub ��̬��ֽ����(ByRef Aplayer As Player, hwnd As Long, ByVal file As String)
Aplayer.SetConfig 2, App.path & "\Bin\codecs" '�d���a��
Aplayer.Open file '���d�O��ҕ�l
Adaptive_Aspect_ratio Aplayer, hwnd '���m���M�v��
End Sub
Public Sub �ڼ��O��(ByVal hdc As Long, ByVal hwnd As Long, file)
'���d�DƬ
'GDI+����ͼƬ
Dim wh As RECT
Call l_Image.Init(hdc)
Call win32api.GetWindowRect(hwnd, wh)
Call l_Image.add(file, 0, 0, wh.Right - wh.Left, wh.Bottom - wh.Top, True)
Call l_Image.Drawshow
End Sub
Public Sub Adaptive_Aspect_ratio(ByRef Aplayer As Player, hwnd As Long)
Dim Rect_play As RECT
WateTime 300
'�@ȡ�͑�^��С:
Call win32api.GetWindowRect(hwnd, Rect_play)
Dim cxClient As Long
cxClient = Rect_play.Right - Rect_play.Left
Dim cyClient As Long
cyClient = Rect_play.Bottom - Rect_play.Top
'�O�ÙM�v��
Aplayer.SetConfig 204, Me.Get_Aspect_ratio((cxClient), cyClient)
End Sub
'�Ɍ��ߴ�СӋ��M�v��
Public Function Get_Aspect_ratio(ByVal w As Integer, ByVal h As Integer) As String '���ؙM�v��
Dim tmp_A As Integer, tmp_B As Integer, R As Integer
tmp_A = w
tmp_B = h
R = tmp_B Mod tmp_A
Do While R <> 0
tmp_B = tmp_A
tmp_A = R
R = tmp_B Mod tmp_A
Loop
Get_Aspect_ratio = CStr(w / tmp_A) & ";" & CStr(h / tmp_A)
End Function




'����������������������������������������������������������������������������������������������������������������������������������������������������������������
Public Sub WateTime(MilliSecond As Long) '���Ǵ��İ�������ˣ�ʮ�ֱ�Ǹ��
    'ʱ����ʱ��������λ���룬�˺����������ʹ��壬������ɴ������
    On Error GoTo ErrHandler
    Dim ft As FILETIME
    Dim lBusy As Long
    Dim lRet As Long
    Dim dblDelay As Double
    Dim dblDelayLow As Double
    
    mlTimer = CreateWaitableTimerA(0, True, App.EXEName & "Timer" & format$(Now(), "NNSS"))
    If Err.LastDllError <> ERROR_ALREADY_EXISTS Then
        ft.dwLowDateTime = -1
        ft.dwHighDateTime = -1
        lRet = SetWaitableTimer(mlTimer, ft, 0, 0, 0, 0)
    End If
    dblDelay = CDbl(MilliSecond) * 10000#
    ft.dwHighDateTime = -CLng(dblDelay / UNITS) - 1
    dblDelayLow = -UNITS * (dblDelay / UNITS - Fix(CStr(dblDelay / UNITS)))
    If dblDelayLow < MAX_LONG Then dblDelayLow = UNITS + dblDelayLow
    ft.dwLowDateTime = CLng(dblDelayLow)
    lRet = SetWaitableTimer(mlTimer, ft, 0, 0, 0, False)
    Do
        lBusy = MsgWaitForMultipleObjects(1, mlTimer, False, INFINITE, QS_ALLINPUT&)
        DoEvents
    Loop Until lBusy = WAIT_OBJECT_0
    CloseHandle mlTimer
    mlTimer = 0
    Exit Sub
    
ErrHandler:                                                 'clsWaitableTimer
    Err.Raise Err.Number, Err.Source, "�ӳ�ʱ��" & Err.Description
End Sub





