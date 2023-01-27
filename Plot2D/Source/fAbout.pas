unit fAbout;

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
  Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TAboutForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    PanelCentre: TPanel;
    MemoContributors: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  AboutForm: TAboutForm;

//==========================================================================
implementation
//==========================================================================

{$R *.dfm}

procedure TAboutForm.Button1Click(Sender: TObject);
begin
  MemoContributors.Visible := not MemoContributors.Visible;
end;

end.
