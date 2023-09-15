unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ScktComp, Buttons;

type
  TForm1 = class(TForm)
    ClientSocket1: TClientSocket;
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox2: TGroupBox;
    Edit4: TEdit;
    Label4: TLabel;
    Button3: TButton;
    GroupBox3: TGroupBox;
    Memo1: TMemo;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ClientSocket1Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Connecting(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Disconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
  private
    { Déclarations privées }
    fIleStream    : TFileStream;
  public
    { Déclarations publiques }
  end;

  THeader = record
    lengthMessage : Integer;
    lengthNameFile : byte;
    sizeFile : Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ClientSocket1.Port:=StrToInt(Edit1.Text); //Define the port >= 1024 (ex: 2000)
  ClientSocket1.Host := Edit2.Text; //Set host address (ip address)
  ClientSocket1.Open; //Open the socket connection
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ClientSocket1.Close; //Close the socket connection
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
  lheader.lengthMessage:=Length(Edit4.Text);
  if Label3.Caption<>'' then
  begin
    lFile:=TFileStream.Create(Label3.Caption, fmOpenRead);
    lheader.sizeFile:=lFile.Size;
    lname:=ExtractFileName(Label3.Caption);
    lsize:=SizeOf(lheader)+Length(lname)+Length(Edit4.Text);
    lptr:=GetMemory(lsize);
    try
      lheader.lengthNameFile:=Length(lname);
      CopyMemory(lptr, @lheader, SizeOf(lheader));
      CopyMemory(Pointer(Integer(Pointer(lptr))+SizeOf(lheader)), @Edit4.Text[1], lheader.lengthMessage);
      CopyMemory(Pointer(Integer(Pointer(lptr))+SizeOf(lheader)+lheader.lengthMessage), @lname[1], Length(lname));
      ClientSocket1.Socket.SendBuf(lptr^, lsize);
    finally
      FreeMemory(lptr);
    end;
    ClientSocket1.Socket.SendStream(lfile);
  end
  else
  begin
    ClientSocket1.Socket.SendBuf(lheader, SizeOf(lheader));
    ClientSocket1.Socket.SendText(Edit4.Text); //Transmit the text of Edit4 by the ClienSocket
  end;
  Label3.Caption:='';
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClientSocket1.Close; //Close the socket connection if we quit the program
end;

procedure TForm1.ClientSocket1Connect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Memo1.Lines.Add('Connected to '+Socket.RemoteHost); //Message that specifies that we are connected to the Server
end;

procedure TForm1.ClientSocket1Connecting(Sender: TObject; Socket: TCustomWinSocket);
begin
  Memo1.Lines.Add('Server was found'); //Message that specifies that the server has been found
end;

procedure TForm1.ClientSocket1Disconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Memo1.Lines.Add('Disconnected'); //Message that specifies that we are disconnected from the Server
end;

procedure TForm1.ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
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
  Label3.Caption:=OpenDialog1.FileName;
end;
end;

procedure TForm1.ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
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
      Edit4.Text:=lmessage; //Put in Edit2.Text, the text we received from the sockets
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

end.
