object Form1: TForm1
  Left = 974
  Top = 317
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Client'
  ClientHeight = 262
  ClientWidth = 467
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
    Width = 222
    Height = 121
    Caption = 'Options'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 25
      Height = 13
      Caption = 'Port :'
    end
    object Label2: TLabel
      Left = 8
      Top = 50
      Width = 28
      Height = 13
      Caption = 'Host :'
    end
    object Button1: TButton
      Left = 32
      Top = 80
      Width = 75
      Height = 25
      Caption = 'Connection'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 120
      Top = 80
      Width = 75
      Height = 25
      Caption = 'Disconnection'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Edit1: TEdit
      Left = 72
      Top = 20
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '2000'
    end
    object Edit2: TEdit
      Left = 72
      Top = 46
      Width = 121
      Height = 21
      TabOrder = 3
      Text = 'localhost'
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 136
    Width = 225
    Height = 121
    Caption = 'Transmiter'
    TabOrder = 1
    object Label4: TLabel
      Left = 8
      Top = 32
      Width = 27
      Height = 13
      Caption = 'Text :'
    end
    object SpeedButton1: TSpeedButton
      Left = 8
      Top = 56
      Width = 97
      Height = 25
      Caption = 'Attach file'
      OnClick = SpeedButton1Click
    end
    object Label3: TLabel
      Left = 16
      Top = 96
      Width = 82
      Height = 13
      Caption = 'TradingView.msix'
    end
    object Edit4: TEdit
      Left = 88
      Top = 28
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '12345678'
    end
    object Button3: TButton
      Left = 112
      Top = 56
      Width = 97
      Height = 25
      Caption = 'Send message'
      TabOrder = 1
      OnClick = Button3Click
    end
  end
  object GroupBox3: TGroupBox
    Left = 240
    Top = 8
    Width = 217
    Height = 249
    Caption = 'Report'
    TabOrder = 2
    object Memo1: TMemo
      Left = 16
      Top = 24
      Width = 185
      Height = 217
      TabOrder = 0
    end
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnecting = ClientSocket1Connecting
    OnConnect = ClientSocket1Connect
    OnDisconnect = ClientSocket1Disconnect
    OnRead = ClientSocket1Read
    OnError = ClientSocket1Error
    Left = 208
    Top = 16
  end
  object OpenDialog1: TOpenDialog
    Left = 24
    Top = 128
  end
end
