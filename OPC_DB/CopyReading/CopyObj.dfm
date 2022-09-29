object Form4: TForm4
  Left = 830
  Top = 210
  Width = 546
  Height = 550
  Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074
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
    538
    519)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 408
    Width = 59
    Height = 13
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1063#1090#1086' '#1084#1077#1085#1103#1090#1100
  end
  object Label2: TLabel
    Left = 8
    Top = 448
    Width = 73
    Height = 13
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1053#1072' '#1095#1090#1086' '#1084#1077#1085#1103#1090#1100
  end
  object Button1: TButton
    Left = 328
    Top = 350
    Width = 195
    Height = 19
    Anchors = [akRight, akBottom]
    Caption = #1055#1086#1089#1084#1086#1090#1088#1077#1090#1100' '#1090#1077#1075#1080
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 352
    Width = 313
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
    Text = '%'
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 392
    Width = 169
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1089' '#1090#1077#1075#1072#1084#1080
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 8
    Top = 424
    Width = 513
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 3
  end
  object Edit3: TEdit
    Left = 8
    Top = 464
    Width = 513
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 4
  end
  object Button2: TButton
    Left = 8
    Top = 490
    Width = 513
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1090#1077#1075#1080
    TabOrder = 5
    OnClick = Button2Click
  end
  object CheckBox2: TCheckBox
    Left = 8
    Top = 376
    Width = 209
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1047#1072#1084#1077#1085#1103#1090#1100' '#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
    TabOrder = 6
  end
  object Edit4: TEdit
    Left = 8
    Top = 4
    Width = 513
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ReadOnly = True
    TabOrder = 7
    Text = #1042#1099#1073#1077#1088#1080#1090#1077' '#1086#1073#1098#1077#1082#1090' '#1074' '#1086#1089#1085#1086#1074#1085#1086#1081' '#1092#1086#1088#1084#1077'...'
  end
  object ListView1: TListView
    Left = 8
    Top = 32
    Width = 513
    Height = 313
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        AutoSize = True
        Caption = #1048#1084#1103
      end
      item
        Caption = #1047#1085#1072#1095#1077#1085#1080#1077
        MaxWidth = 150
        MinWidth = 150
        Width = 150
      end>
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 8
    ViewStyle = vsReport
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 280
    Top = 216
  end
  object ADOQuery2: TADOQuery
    Parameters = <>
    Left = 320
    Top = 216
  end
  object PopupMenu1: TPopupMenu
    Left = 408
    Top = 288
    object N1: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1080#1084#1103' '#1090#1077#1075#1072
      OnClick = N1Click
    end
  end
end
