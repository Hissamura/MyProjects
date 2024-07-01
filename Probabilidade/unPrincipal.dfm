object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 524
  ClientWidth = 861
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 192
    Top = 360
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Memo1: TMemo
    Left = 16
    Top = 8
    Width = 129
    Height = 409
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 208
    Top = 72
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object DBGrid1: TDBGrid
    Left = 352
    Top = 8
    Width = 209
    Height = 473
    DataSource = DataSource1
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Sequencia'
        Width = 78
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'QtdeVezes'
        Width = 88
        Visible = True
      end>
  end
  object Edit1: TEdit
    Left = 200
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 3
    Text = '100'
  end
  object BitBtn2: TBitBtn
    Left = 608
    Top = 72
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    TabOrder = 4
    OnClick = BitBtn2Click
  end
  object Edit2: TEdit
    Left = 600
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 5
    Text = '100'
  end
  object BitBtn3: TBitBtn
    Left = 640
    Top = 216
    Width = 75
    Height = 25
    Caption = 'BitBtn3'
    TabOrder = 6
    OnClick = BitBtn3Click
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet2
    Left = 704
    Top = 424
  end
  object ClientDataSet2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 704
    Top = 368
    object ClientDataSet2Sequencia: TIntegerField
      FieldName = 'Sequencia'
    end
    object ClientDataSet2QtdeVezes: TIntegerField
      FieldName = 'QtdeVezes'
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 200
    OnTimer = Timer1Timer
    Left = 232
    Top = 144
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 200
    OnTimer = Timer2Timer
    Left = 632
    Top = 144
  end
end
