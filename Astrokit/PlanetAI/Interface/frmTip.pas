unit frmTip;

interface

uses
  buttons,comctrls,Winapi.Windows,Messages,System.SysUtils,System.Classes,Vcl.Graphics,Controls,
  Forms,Dialogs,StdCtrls,ExtCtrls;

type
  TformGETip = class(TForm)
    bClose: TBitBtn;
    bNextTip : TBitBtn;
    bRandomTip: TBitBtn;
    cbxShowTips: TCheckBox;
    Image: TImage;
    lblTitle: TLabel;
    mbTip: TMemo;
    pnlBottom: TPanel;
    pnlTip: TPanel;
    pnlTipDetails: TPanel;
    status: TStatusBar;
    bPreviousTip: TBitBtn;
    procedure bNextTipClick(Sender:TObject);
    procedure bRandomTipClick(Sender:TObject);
    procedure FormClose(Sender:TObject; var Action:TCloseAction);
    procedure FormCreate(Sender:TObject);
    procedure FormShow(Sender:TObject);
    procedure bCloseClick(Sender: TObject);
    procedure bPreviousTipClick(Sender: TObject);
  private
     
    procedure UpdateStatus;
    procedure GetATip;
  public
    numtip:word;
     
    FormTips:TStringList;
    procedure LoadTipFile(aFile: string);
    procedure RandomTip;
  end;

implementation

{$R *.DFM}
// ------ TformGETip.FormClose ---------------------------------------------------
procedure TformGETip.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FormTips.Free;
end;
// ------ TformGETip.FormCreate ------------------------------------------------
procedure TformGETip.FormCreate(Sender: TObject);
begin
  FormTips := TStringList.Create;
end;
// ------ TformGETip.FormShow --------------------------------------------------
procedure TformGETip.FormShow(Sender: TObject);
begin
  if FormTips.Count = 0 then
    FormTips.Add('No tips found!');
  if FormTips.Count = 1 then
    bNextTip.Enabled := False;
{** load the last tip}
  if (NumTip<= (FormTips.Count-1)) then
    UpdateStatus
  else
    GetATip; {** for out of bounds}
end;
// ------ TformGETip.bNextTipClick ---------------------------------------------
procedure TformGETip.bNextTipClick(Sender: TObject);
begin
  if (NumTip>=(FormTips.Count-1)) then
    NumTip := 0
  else
    NumTip := NumTip+1;
  UpdateStatus;
end;
// ------ TformGETip.bPreviousTipClick ---------------------------------------------
procedure TformGETip.bPreviousTipClick(Sender: TObject);
begin
  if (NumTip<=0) then
    NumTip := (FormTips.Count-1)
   else
    NumTip := NumTip-1;
  UpdateStatus;
end;
// ------ TformGETip.bRandomTipClick -------------------------------------------
procedure TformGETip.bRandomTipClick(Sender: TObject);
begin
  GetATip;
end;
// ------ TformGETip.GetATip ---------------------------------------------------
procedure TformGETip.GetATip;
begin
  Randomize;
  NumTip := Random(FormTips.Count);
  UpdateStatus;
end;
// ------ TformGETip.UpdateStatus ----------------------------------------------
procedure TformGETip.UpdateStatus;

begin
  mbTip.Clear;
  mbTip.Text := FormTips.Strings[NumTip];
  status.SimpleText := 'This is tip ' + IntToStr(NumTip+1) + ' of ' +
    IntToStr(FormTips.Count);
  pnlBottom.SetFocus;
end;
// ------ TformGETip.bCloseClick ----------------------------------------------
procedure TformGETip.bCloseClick(Sender: TObject);
begin
  Close;
end;
// ------ TformGETip.LoadTipFile ----------------------------------------------
procedure TformGETip.LoadTipFile(aFile: string);
begin
  if (aFile <> '') then
  begin
    if FileExists(aFile) then
      FormTips.LoadFromFile(aFile);
  end;
end;
// ------ TformGETip.RandomTip ----------------------------------------------
procedure TformGETip.RandomTip;
begin
  NumTip := Random(FormTips.Count);
end;
// =============================================================================
end.
