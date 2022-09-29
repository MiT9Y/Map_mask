object Form6: TForm6
  Left = 628
  Top = 278
  Width = 800
  Height = 600
  Caption = #1040#1088#1093#1080#1074#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1086#1073#1098#1077#1082#1090#1091':'
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
    792
    569)
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 0
    Top = 0
    Width = 784
    Height = 559
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 15
    DefaultColWidth = 120
    DefaultRowHeight = 30
    FixedCols = 0
    RowCount = 50
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
    TabOrder = 0
    OnDrawCell = StringGrid1DrawCell
    OnKeyDown = StringGrid1KeyDown
    OnMouseUp = StringGrid1MouseUp
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 168
    Top = 136
  end
  object PopupMenu1: TPopupMenu
    Left = 144
    Top = 192
    object N1: TMenuItem
      Caption = #1042#1099#1073#1086#1088' '#1074#1080#1076#1080#1084#1086#1089#1090#1080
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object R1: TMenuItem
      AutoCheck = True
      Caption = 'T_R'
      Checked = True
    end
    object K1: TMenuItem
      AutoCheck = True
      Caption = 'T_K'
      Checked = True
    end
  end
end
