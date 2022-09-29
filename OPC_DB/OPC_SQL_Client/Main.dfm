object Form1: TForm1
  Left = 230
  Top = 126
  Width = 563
  Height = 393
  Caption = #1069#1082#1089#1087#1086#1088#1090' '#1080#1079' OPC '#1074' SQL'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    555
    364)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 2
    Top = 3
    Width = 543
    Height = 326
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Button1: TButton
    Left = 392
    Top = 335
    Width = 153
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = #1054#1087#1088#1086#1089#1080#1090#1100' OPC '#1057#1077#1088#1074#1077#1088
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 4
    Top = 335
    Width = 157
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = #1055#1077#1088#1077#1087#1086#1076#1082#1083#1102#1095#1080#1090#1089#1103' '#1082' OPC'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 168
    Top = 335
    Width = 217
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1042#1099#1073#1088#1072#1090#1100' '#1085#1086#1074#1099#1081' OPC'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 464
    Top = 16
  end
  object ADOQuery1: TADOQuery
    ParamCheck = False
    Parameters = <>
    Left = 144
    Top = 8
  end
  object ADOQuery2: TADOQuery
    ParamCheck = False
    Parameters = <>
    SQL.Strings = (
      'EXEC EditTagValue')
    Left = 176
    Top = 8
  end
  object Timer2: TTimer
    Enabled = False
    OnTimer = Timer2Timer
    Left = 432
    Top = 16
  end
end
