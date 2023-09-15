unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ScktComp, StdCtrls, Buttons;

type

  THeader = record
    lengthMessage : Integer;
    lengthNameFile : byte;
    sizeFile : Integer;
  end;

  PHeader = ^THeader;

  TForm1 = class(TForm)
    ServerSocket1: TServerSocket;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    GroupBox2: TGroupBox;
    Edit2: TEdit;
    Label2: TLabel;
    GroupBox3: TGroupBox;
    Memo1: TMemo;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    Button3: TButton;
    Label4: TLabel;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ServerSocket1Accept(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocket1ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocket1ClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocket1Listen(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocket1ClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Déclarations privées }
    fIleStream    : TFileStream;
    fSocket: TCustomWinSocket;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
ServerSocket1.Port:=StrtoInt(Edit1.Text); //Define the port used >=1024 (ex:2000)
ServerSocket1.Open; //Open the socket connection
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
ServerSocket1.Close; //Close the socket connection
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
ServerSocket1.Close; //Close the socket connection if we quit the program
end;

procedure TForm1.ServerSocket1Accept(Sender: TObject; Socket: TCustomWinSocket);
begin
Memo1.Lines.Add('Connected to '+Socket.RemoteAddress); //Message indicating the IP address of the remote system linked to the socket connection
end;

procedure TForm1.ServerSocket1ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
fSocket:=Socket;
Memo1.Lines.Add('Connection accepted by server socket'); //Message that specifies that the connection was successful
end;

procedure TForm1.ServerSocket1ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
fSocket:=nil;
Memo1.Lines.Add('Disconnected');//Message that specifies that you are disconnected from the client
FreeAndNil(fIleStream);
end;

procedure TForm1.ServerSocket1ClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  lbuf: string;
  lpos: integer;
  lheader: THeader;
  lfile  : TFileStream;
  lmessage: string;
  lnamefile: string;
begin
  lbuf:=Socket.ReceiveText;
  if fIleStream=nil then
    fIleStream:=TFileStream.Create('temp.dat', fmCreate);
  fIleStream.Write(lbuf[1], length(lbuf));
  Label3.Caption:=IntToStr(fIleStream.size);
  if fIleStream.Size>9 then
  begin
    fIleStream.Position:=0;
    fIleStream.ReadBuffer(lheader, SizeOf(lheader));
    if lheader.lengthMessage+lheader.lengthNameFile+lheader.sizeFile+12=fIleStream.Size then
    begin
      SetLength(lmessage, lheader.lengthMessage);
      fIleStream.Read(lmessage[1], lheader.lengthMessage);
      Edit2.Text:=lmessage; //Put in Edit2.Text, the text we received from the sockets
      if lheader.sizeFile>0 then
      begin                 
        SetLength(lnamefile, lheader.lengthNameFile);
        fIleStream.Read(lnamefile[1], lheader.lengthNameFile);
        lfile:=TFileStream.Create(lnamefile, fmCreate);
        try
          lfile.CopyFrom(fIleStream, fIleStream.Size-fIleStream.Position);
        finally
          FreeAndNil(lfile);
        end;  
      end;
      Memo1.Lines.Add('The file received from the sockets');
      FreeAndNil(fIleStream);
    end
    else
      fIleStream.Position:=fIleStream.Size;
  end;
end;

procedure TForm1.ServerSocket1Listen(Sender: TObject; Socket: TCustomWinSocket);
begin
Memo1.Lines.Add('Listening...'); //Message that specifies that the socket server is listening
end;

procedure TForm1.ServerSocket1ClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
   var ErrorCode: Integer);
begin
//Put an error message corresponding to the type of error in Memo1
if ErrorEvent=eeGeneral then
Memo1.Lines.Add('Unexpected error');

if ErrorEvent=eeSend then
Memo1.Lines.Add('Error writing socket connection');

if ErrorEvent=eeReceive then
Memo1.Lines.Add('Error reading socket connection');

if ErrorEvent=eeConnect then
Memo1.Lines.Add('An already accepted connection request could not be completed');

if ErrorEvent=eeDisconnect then
Memo1.Lines.Add('Error closing a connection');

if ErrorEvent=eeAccept then
Memo1.Lines.Add('Error accepting client connection request');

end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
if OpenDialog1.Execute then
begin
  Label4.Caption:=OpenDialog1.FileName;
end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  lFile    : TFileStream;
  lheader  : THeader;
  lptr      : Pointer;
  lname     : string;
  lsize     : Byte;
begin
  ZeroMemory(@lheader, SizeOf(lheader));
  lheader.lengthMessage:=Length(Edit2.Text);
  if Label4.Caption<>'' then
  begin
    lFile:=TFileStream.Create(Label4.Caption, fmOpenRead);
    lheader.sizeFile:=lFile.Size;
    lname:=ExtractFileName(Label4.Caption);
    lsize:=SizeOf(lheader)+Length(lname)+Length(Edit2.Text);
    lptr:=GetMemory(lsize);
    try
      lheader.lengthNameFile:=Length(lname);
      CopyMemory(lptr, @lheader, SizeOf(lheader));
      CopyMemory(Pointer(Integer(Pointer(lptr))+SizeOf(lheader)), @Edit2.Text[1], lheader.lengthMessage);
      CopyMemory(Pointer(Integer(Pointer(lptr))+SizeOf(lheader)+lheader.lengthMessage), @lname[1], Length(lname));
      fSocket.SendBuf(lptr^, lsize);
    finally
      FreeMemory(lptr);
    end;
    fSocket.SendStream(lfile);
  end
  else
  begin
    fSocket.SendBuf(lheader, SizeOf(lheader));
    fSocket.SendText(Edit2.Text); //Transmit the text of Edit4 by the ClienSocket
  end;
  Label4.Caption:='';
end;

end.
