object optionsForm: ToptionsForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Tools'
  ClientHeight = 302
  ClientWidth = 144
  Color = clBtnFace
  Constraints.MaxHeight = 340
  Constraints.MaxWidth = 160
  Constraints.MinHeight = 340
  Constraints.MinWidth = 160
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object timeLabel: TLabel
    Left = 16
    Top = 8
    Width = 107
    Height = 13
    Caption = 'Interval in milliseconds'
  end
  object gridsizeLabel: TLabel
    Left = 16
    Top = 67
    Width = 89
    Height = 13
    Caption = 'Size of grid square'
  end
  object labelRownum: TLabel
    Left = 16
    Top = 130
    Width = 79
    Height = 13
    Caption = 'Number of Rows'
  end
  object labelColnum: TLabel
    Left = 16
    Top = 186
    Width = 93
    Height = 13
    Caption = 'Number of Columns'
  end
  object timeEdit: TEdit
    Left = 16
    Top = 27
    Width = 121
    Height = 21
    Hint = 
      'The time, in milliseconds, between which the computer displays t' +
      'he current form of life on the grid.'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnKeyPress = timeEditKeyPress
  end
  object buttonSaveOptions: TButton
    Left = 61
    Top = 269
    Width = 75
    Height = 25
    Caption = 'Save Options'
    TabOrder = 1
    OnClick = buttonSaveOptionsClick
  end
  object gridsizeEdit: TEdit
    Left = 16
    Top = 86
    Width = 121
    Height = 21
    Hint = 
      'Decide the size of the grid squares. Increasing this may fix ren' +
      'dering bugs on high resolution systems.'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnKeyPress = gridsizeEditKeyPress
  end
  object checkboxDebug: TCheckBox
    Left = 16
    Top = 240
    Width = 121
    Height = 17
    Hint = 'Show the debug screen to the right of the grid.'
    Caption = 'Show Debug Menu'
    DoubleBuffered = False
    ParentDoubleBuffered = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object editRownum: TEdit
    Left = 15
    Top = 149
    Width = 121
    Height = 21
    MaxLength = 3
    NumbersOnly = True
    TabOrder = 4
    TextHint = 'Maximum 127'
    OnKeyPress = editRownumKeyPress
  end
  object editColnum: TEdit
    Left = 15
    Top = 205
    Width = 121
    Height = 21
    MaxLength = 3
    TabOrder = 5
    TextHint = 'Maximum 127'
    OnKeyPress = editColnumKeyPress
  end
end
