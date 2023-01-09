unit fMainMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,Forms, Dialogs,
  StdCtrls, Vcl.Buttons, cAIReality;

type
  TfmMainMenu = class(TForm)
    btnNewReality: TBitBtn;
    btnQuit: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    labRealityBla: TLabel;
    labRealityName: TLabel;
    btnActivateReality: TBitBtn;
    procedure btnQuitClick(Sender: TObject);
    procedure btnNewRealityClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnActivateRealityClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
     
    fAIReality: AIReality;
    procedure SetAIReality(aAIReality: AIReality);
  public
     
    property AIReality: AIReality read fAIReality write SetAIReality;
  end;

var
  fmMainMenu: TfmMainMenu;

implementation

uses
  {Forms}     fNewReality, fReality;

{$R *.DFM}

// -----------------------------------------------------------------------------
// --------------------------- FORM LOGIC --------------------------------------
// -----------------------------------------------------------------------------
procedure TfmMainMenu.SetAIReality(aAIReality: AIReality);
begin
  fAIReality := aAIReality;
end;

procedure TfmMainMenu.btnQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMainMenu.btnNewRealityClick(Sender: TObject);
var
  myfmNewReality: TfmNewReality;
begin
  myfmNewReality := TfmNewReality.Create(self);
  myfmNewReality.ShowModal;
  myfmNewReality.Free;
end;

procedure TfmMainMenu.FormDestroy(Sender: TObject);
begin
  fAIReality.Free;
end;

procedure TfmMainMenu.FormShow(Sender: TObject);
begin
//  labRealityName.Caption := AIReality.Name;
end;

procedure TfmMainMenu.btnActivateRealityClick(Sender: TObject);
var
  myfmReality: TfmReality;
begin
  myfmReality := TfmReality.Create(self);
  myfmReality.Reality := fAIReality;
  myfmReality.ShowModal;
  myfmReality.Free;
end;

procedure TfmMainMenu.FormCreate(Sender: TObject);
begin
  fAIReality := AIReality.Create;
end;

end.
