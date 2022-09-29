object Form5: TForm5
  Left = 571
  Top = 181
  Width = 640
  Height = 643
  Caption = #1053#1072#1079#1085#1072#1095#1080#1090#1100' '#1076#1072#1090#1095#1080#1082' '#1090#1077#1075#1091
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    632
    612)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 64
    Width = 608
    Height = 230
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1099#1081' '#1076#1072#1090#1095#1080#1082
    TabOrder = 0
    OnMouseUp = GroupBox1MouseUp
    DesignSize = (
      608
      230)
    object Label1: TLabel
      Left = 355
      Top = 6
      Width = 86
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088
    end
    object Label2: TLabel
      Left = 515
      Top = 7
      Width = 64
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1043#1086#1076' '#1074#1099#1087#1091#1089#1082#1072
    end
    object ListView1: TListView
      Left = 9
      Top = 48
      Width = 590
      Height = 174
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <
        item
          AutoSize = True
          Caption = #1058#1080#1087
        end
        item
          Caption = #1045#1076'. '#1080#1079#1084'.'
          Width = 150
        end>
      ReadOnly = True
      RowSelect = True
      TabOrder = 2
      ViewStyle = vsReport
      OnMouseUp = GroupBox1MouseUp
    end
    object Edit1: TEdit
      Left = 9
      Top = 23
      Width = 192
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = '%'
      OnMouseUp = GroupBox1MouseUp
    end
    object Button1: TButton
      Left = 207
      Top = 23
      Width = 82
      Height = 20
      Anchors = [akTop, akRight]
      Caption = #1053#1072#1081#1090#1080
      TabOrder = 1
      OnClick = Button1Click
      OnMouseUp = GroupBox1MouseUp
    end
    object Edit2: TEdit
      Left = 496
      Top = 23
      Width = 101
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 3
      OnMouseUp = GroupBox1MouseUp
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 0
      Width = 145
      Height = 17
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1099#1081' '#1076#1072#1090#1095#1080#1082
      TabOrder = 4
      OnMouseUp = GroupBox1MouseUp
    end
    object Edit3: TEdit
      Left = 305
      Top = 23
      Width = 184
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 5
      OnMouseUp = GroupBox1MouseUp
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 304
    Width = 609
    Height = 259
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1055#1088#1080#1074#1103#1079#1072#1090#1100' '#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1080#1081' '#1076#1072#1090#1095#1080#1082
    TabOrder = 1
    OnMouseUp = GroupBox2MouseUp
    DesignSize = (
      609
      259)
    object Label3: TLabel
      Left = 8
      Top = 16
      Width = 103
      Height = 13
      Caption = #1053#1072#1081#1090#1080' '#1087#1086' '#8470' '#1076#1072#1090#1095#1080#1082#1072
    end
    object Label4: TLabel
      Left = 312
      Top = 16
      Width = 90
      Height = 13
      Caption = #1053#1072#1081#1090#1080' '#1087#1086' '#1086#1073#1098#1077#1082#1090#1091
    end
    object ListView2: TListView
      Left = 9
      Top = 56
      Width = 590
      Height = 198
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <
        item
          Caption = #8470' '#1076#1072#1090#1095#1080#1082#1072
          Width = 100
        end
        item
          AutoSize = True
          Caption = #1058#1080#1087
        end
        item
          Caption = #1045#1076'. '#1080#1079#1084'.'
          Width = 55
        end
        item
          Caption = #1054#1073#1098#1077#1082#1090
          Width = 150
        end
        item
          Caption = #1057#1074#1103#1079#1072#1085#1085#1099#1081' '#1090#1077#1075
          Width = 90
        end>
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnMouseUp = GroupBox2MouseUp
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 0
      Width = 193
      Height = 17
      Caption = #1055#1088#1080#1074#1103#1079#1072#1090#1100' '#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1080#1081' '#1076#1072#1090#1095#1080#1082
      TabOrder = 1
      OnMouseUp = GroupBox2MouseUp
    end
    object Edit4: TEdit
      Left = 9
      Top = 31
      Width = 192
      Height = 21
      TabOrder = 2
      Text = '%'
      OnMouseUp = GroupBox2MouseUp
    end
    object Button2: TButton
      Left = 207
      Top = 31
      Width = 82
      Height = 20
      Anchors = [akTop]
      Caption = #1053#1072#1081#1090#1080
      TabOrder = 3
      OnClick = Button2Click
      OnMouseUp = GroupBox2MouseUp
    end
    object Edit5: TEdit
      Left = 313
      Top = 31
      Width = 192
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
      Text = '%'
      OnMouseUp = GroupBox2MouseUp
    end
    object Button5: TButton
      Left = 511
      Top = 31
      Width = 82
      Height = 20
      Anchors = [akTop, akRight]
      Caption = #1053#1072#1081#1090#1080
      TabOrder = 5
      OnClick = Button5Click
      OnMouseUp = GroupBox2MouseUp
    end
  end
  object Button3: TButton
    Left = 8
    Top = 565
    Width = 609
    Height = 18
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1090#1095#1080#1082#1080
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 7
    Top = 584
    Width = 610
    Height = 18
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = Button4Click
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 0
    Width = 609
    Height = 57
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    DesignSize = (
      609
      57)
    object Label5: TLabel
      Left = 163
      Top = 16
      Width = 86
      Height = 13
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088
    end
    object Label6: TLabel
      Left = 483
      Top = 15
      Width = 64
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1043#1086#1076' '#1074#1099#1087#1091#1089#1082#1072
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 0
      Width = 185
      Height = 17
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1090#1077#1082#1091#1097#1080#1081' '#1076#1072#1090#1095#1080#1082
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 0
      OnMouseUp = GroupBox3MouseUp
    end
    object Edit6: TEdit
      Left = 9
      Top = 31
      Width = 408
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      OnMouseUp = GroupBox3MouseUp
    end
    object Edit7: TEdit
      Left = 424
      Top = 31
      Width = 177
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 2
      OnMouseUp = GroupBox3MouseUp
    end
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 104
    Top = 96
  end
end
