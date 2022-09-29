object Form3: TForm3
  Left = 718
  Top = 140
  Width = 640
  Height = 480
  Caption = #1055#1086#1080#1089#1082' ...'
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    632
    449)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 0
    Width = 616
    Height = 13
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1096#1072#1073#1083#1086#1085#1091
  end
  object Edit1: TEdit
    Left = 8
    Top = 16
    Width = 464
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = '%'
  end
  object Button1: TButton
    Left = 479
    Top = 14
    Width = 137
    Height = 22
    Anchors = [akTop, akRight]
    Caption = #1053#1072#1081#1090#1080
    TabOrder = 1
    OnClick = Button1Click
  end
  object ListView1: TListView
    Left = 8
    Top = 40
    Width = 607
    Height = 398
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
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 2
    ViewStyle = vsReport
    OnChange = ListView1Change
    OnDblClick = ListView1DblClick
  end
  object PopupMenu1: TPopupMenu
    Left = 344
    Top = 232
    object N1: TMenuItem
      Caption = #1042#1099#1073#1088#1072#1090#1100
      OnClick = N1Click
    end
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 80
    Top = 80
  end
end
