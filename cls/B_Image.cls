VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "B_Image"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private InitImage As Boolean
Dim image() As Long
Dim upx() As Integer '����x
Dim upy() As Integer '����y
Dim imgwidth() As Long 'ԭͼ��
Dim imgheight() As Long 'ԭͼ��
Dim Show() As Boolean '��������
Dim img_count As Integer
Private B_Graphics As Long
Public Function Set_show(ByVal value As Integer, ByVal b As Boolean)
Show(value) = b
End Function
Public Function Init(frm_hdc As Long) As Boolean
'�󶨴���
Call gdiplus.GdipCreateFromHDC(frm_hdc, B_Graphics)
End Function
Public Function Drawshow(Optional value As Integer) 'ˢ����ʾ ������ָ����ʾ��
If InitImage = False Then Exit Function
Dim i As Integer
If IsMissing(value) Then
Call gdiplus.GdipDrawImageRect(B_Graphics, image(value), upx(value), upy(value), imgwidth(value), imgheight(value))
Else
For i = 0 To UBound(image)
If Show(i) = True Then
Call gdiplus.GdipDrawImageRectI(B_Graphics, image(i), upx(i), upy(i), imgwidth(i), imgheight(i))
End If
Next
End If
End Function
' ����Image����
Public Function add(ByVal imgfile As String, ByVal a_upx As Integer, _
ByVal a_upy As Integer, a_imgwidth As Integer, a_imgheight As Integer _
, Optional a_show As Boolean)
    '��·������ͼ�����
    ReDim Preserve image(img_count)  '��������
    Call gdiplus.GdipLoadImageFromFile(StrPtr(imgfile), image(img_count))
    '�����������������Ӳ���ֵ
    ReDim Preserve upx(img_count)
    upx(img_count) = a_upx '����x
    ReDim Preserve upy(img_count)
    upy(img_count) = a_upy '����y
    ReDim Preserve imgwidth(img_count)
    imgwidth(img_count) = a_imgwidth
    'Call GdipGetImageWidth(img(img_count), imgwidth(img_count)) 'ԭͼ��
    ReDim Preserve imgheight(img_count)
    imgheight(img_count) = a_imgheight
    'Call GdipGetImageHeight(img(img_count), imgheight(img_count)) 'ԭͼ��
    ReDim Preserve Show(img_count)
    Show(img_count) = a_show
    img_count = img_count + 1
End Function
Private Sub Class_Initialize()
ReDim image(0) As Long 'png����
ReDim upx(0) As Integer '����x
ReDim upy(0) As Integer '����y
ReDim imgwidth(0) As Long 'ԭͼ��
ReDim imgheight(0) As Long 'ԭͼ��
gdiplus.InitGDIPlus 'ǿ���ظ���ʼ��
InitImage = True
End Sub
Private Sub Class_Terminate()
Dim i As Integer
For i = 0 To UBound(image)
GdipDisposeImage (image(i))
Next
gdiplus.TerminateGDIPlus
End Sub
