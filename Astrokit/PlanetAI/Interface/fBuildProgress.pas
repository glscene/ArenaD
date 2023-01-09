unit fBuildProgress;

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
  Vcl.ComCtrls,
  Vcl.StdCtrls;

type
  TfmBuildProgress = class(TForm)
    pbBuildProgress: TProgressBar;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  fmBuildProgress: TfmBuildProgress;

implementation

{$R *.dfm}

procedure TfmBuildProgress.FormCreate(Sender: TObject);
begin
  Top := 1;
  Left := 1;
end;

end.
