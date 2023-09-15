object Form1: TForm1
  Left = 832
  Top = 239
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Serveur'
  ClientHeight = 263
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 197
    Height = 113
    Caption = 'Options'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 25
      Height = 13
      Caption = 'Port :'
    end
    object Edit1: TEdit
      Left = 56
      Top = 20
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '2000'
    end
    object Button1: TButton
      Left = 16
      Top = 72
      Width = 75
      Height = 25
      Caption = 'Connection'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 104
      Top = 72
      Width = 75
      Height = 25
      Caption = 'Disconnection'
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 128
    Width = 201
    Height = 121
    Caption = 'Receiver'
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 24
      Width = 27
      Height = 13
      Caption = 'Text :'
    end
    object Label3: TLabel
      Left = 72
      Top = 56
      Width = 3
      Height = 13
    end
    object SpeedButton1: TSpeedButton
      Left = 3
      Top = 56
      Width = 97
      Height = 25
      Caption = 'Attach file'
      OnClick = SpeedButton1Click
    end
    object Label4: TLabel
      Left = 11
      Top = 96
      Width = 82
      Height = 13
      Caption = 'TradingView.msix'
    end
    object Edit2: TEdit
      Left = 72
      Top = 22
      Width = 113
      Height = 21
      TabOrder = 0
    end
    object Button3: TButton
      Left = 99
      Top = 56
      Width = 97
      Height = 25
      Caption = 'Send message'
      TabOrder = 1
      OnClick = Button3Click
    end
  end
  object GroupBox3: TGroupBox
    Left = 216
    Top = 8
    Width = 217
    Height = 225
    Caption = 'Report'
    TabOrder = 2
    object Memo1: TMemo
      Left = 16
      Top = 24
      Width = 185
      Height = 177
      TabOrder = 0
    end
  end
  object ServerSocket1: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnListen = ServerSocket1Listen
    OnAccept = ServerSocket1Accept
    OnClientConnect = ServerSocket1ClientConnect
    OnClientDisconnect = ServerSocket1ClientDisconnect
    OnClientRead = ServerSocket1ClientRead
    OnClientError = ServerSocket1ClientError
    Left = 184
    Top = 24
  end
  object OpenDialog1: TOpenDialog
    Left = 24
    Top = 128
  end
end
