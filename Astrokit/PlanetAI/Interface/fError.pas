unit fError;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,

  IdBaseComponent,
  IdComponent,
  IdTCPServer,
  IdSMTPServer,
  IdMessage,
  IdTCPConnection,
  IdTCPClient,
  IdMessageClient,
  IdSMTP,
  Vcl.Buttons;

type
  TfmError = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    memReport: TMemo;
    Panel4: TPanel;
    Button4: TButton;
    btnSaveWorld: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure Button4Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure btnHaltClick(Sender: TObject);
    procedure btnSaveWorldClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
     
    fError: Exception;
  public
     
    property Error: Exception read fError write fError;
  end;

var
  fmError: TfmError;

implementation

{$R *.dfm}

uses ShellAPI, fFirstForm;

procedure TfmError.Button4Click(Sender: TObject);
begin
  Close;
end;

procedure TfmError.Label2Click(Sender: TObject);
begin
  ShellExecute(0,'open','http://sourceforge.net/tracker/?atid=521003&group_id=68377&func=browse','','',SW_SHOW);
end;

procedure TfmError.Label4Click(Sender: TObject);
var
  myEmail: string;
  myFileName: string;
begin
  myFileName := ExtractFilePath(ParamStr(0)) + 'debug.txt';
  memReport.Lines.SaveToFile(myFileName);

  myEmail := 'mailto:aiplanet-bugs@lists.sourceforge.net?subject='
    + memReport.Lines.Strings[0]
    + '&body=Please type a short story of your bug encounter, and paste the error report below.'
    + #13#10 + Error.ClassName + ', ' + Error.Message;

  ShellExecute(0,'open',PChar(myEmail),'','',SW_SHOW);
end;

procedure TfmError.btnHaltClick(Sender: TObject);
begin
  Halt;
end;

procedure TfmError.btnSaveWorldClick(Sender: TObject);
begin
  fmFirstForm.RealityForm.SaveAs1Click(Sender);
end;

procedure TfmError.FormShow(Sender: TObject);
begin
  memReport.SelectAll;
  memReport.SetFocus;
end;

end.
