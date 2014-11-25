object formGameOfLife: TformGameOfLife
  Left = 265
  Top = 47
  Caption = 'Paterson'#39's Game of Life'
  ClientHeight = 899
  ClientWidth = 905
  Color = clBtnFace
  Constraints.MaxHeight = 957
  Constraints.MaxWidth = 1067
  Constraints.MinHeight = 957
  Constraints.MinWidth = 920
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = menuMainMenu
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object labelCycleCount: TLabel
    Left = 920
    Top = 277
    Width = 58
    Height = 13
    Caption = 'Cycle Count'
  end
  object labelLiveDead: TLabel
    Left = 920
    Top = 341
    Width = 108
    Height = 13
    Caption = 'Alive Cells : Dead Cells'
  end
  object strgrGameGrid: TStringGrid
    Left = 0
    Top = 0
    Width = 905
    Height = 899
    Cursor = crHandPoint
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alLeft
    Color = clWhite
    ColCount = 127
    DefaultColWidth = 6
    DefaultRowHeight = 6
    DoubleBuffered = False
    Enabled = False
    RowCount = 127
    Font.Charset = OEM_CHARSET
    Font.Color = clWindowText
    Font.Height = -1
    Font.Name = 'Terminal'
    Font.Style = [fsBold]
    Options = [goVertLine, goHorzLine]
    ParentDoubleBuffered = False
    ParentFont = False
    PopupMenu = popupmenuStrGrid
    TabOrder = 0
    OnClick = strgrGameGridClick
    OnDrawCell = strgrGameGridDrawCell
  end
  object listboxDebugOutput: TListBox
    Left = 922
    Top = 8
    Width = 121
    Height = 257
    ItemHeight = 13
    TabOrder = 1
  end
  object editCyclecountOutput: TEdit
    Left = 920
    Top = 296
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 2
  end
  object editLiveDead: TEdit
    Left = 920
    Top = 360
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 3
  end
  object menuMainMenu: TMainMenu
    Left = 8
    object mainmenuFile: TMenuItem
      Caption = 'File'
      object mainmenuFileNew: TMenuItem
        Caption = 'New'
        OnClick = mainmenuFileNewClick
      end
      object mainmenuFileLoad: TMenuItem
        Caption = 'Open'
        OnClick = mainmenuFileLoadClick
      end
      object mainmenuFileSave: TMenuItem
        Caption = 'Save'
        OnClick = mainmenuFileSaveClick
      end
    end
    object mainmenuGame: TMenuItem
      Caption = 'Game'
      object mainmenuGameClear: TMenuItem
        Caption = 'Clear Grid'
        OnClick = mainmenuGameClearClick
      end
      object mainmenuGameRandomise: TMenuItem
        Caption = 'Randomise Grid'
        OnClick = mainmenuGameRandomiseClick
      end
      object mainmenuGameRotate: TMenuItem
        Caption = 'Rotate Grid'
        object mainmenuGameClock: TMenuItem
          Caption = 'Clockwise'
          OnClick = mainmenuGameClockClick
        end
        object mainmenuGameCounterclock: TMenuItem
          Caption = 'Counterclockwise'
          OnClick = mainmenuGameCounterclockClick
        end
      end
      object mainmenuGamePlacemarker: TMenuItem
        Caption = 'Place Marker'
        OnClick = mainmenuGamePlacemarkerClick
      end
    end
    object mainmenuOptions: TMenuItem
      Caption = 'Tools'
      OnClick = mainmenuOptionsClick
    end
    object mainmenuPauseplay: TMenuItem
      Caption = 'Pause'
      Enabled = False
      OnClick = mainmenuPauseplayClick
    end
  end
  object timerGametick: TTimer
    OnTimer = timerGametickTimer
    Left = 80
  end
  object popupmenuStrGrid: TPopupMenu
    Left = 96
    Top = 80
    object popupmenuAdd: TMenuItem
      Caption = 'Add'
      object popupmenuAddGlider: TMenuItem
        Caption = 'Glider'
        OnClick = popupmenuAddGliderClick
      end
      object popupmenuAddLwss: TMenuItem
        Caption = 'Lightweight Spaceship'
        OnClick = popupmenuAddLwssClick
      end
      object popupmenuAddHwss: TMenuItem
        Caption = 'Heavyweight Spaceship'
        OnClick = popupmenuAddHwssClick
      end
      object popupmenuAddPulsar: TMenuItem
        Caption = 'Pulsar'
        OnClick = popupmenuAddPulsarClick
      end
    end
    object popupmenuMarker: TMenuItem
      Caption = 'Place Marker'
      OnClick = popupmenuMarkerClick
    end
  end
end
