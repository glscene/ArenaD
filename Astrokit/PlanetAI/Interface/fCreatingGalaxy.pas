unit fCreatingGalaxy;

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
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons;

type
  TfmCreatingGalaxy = class(TForm)
    Panel1: TPanel;
    redStatus: TRichEdit;
    Panel2: TPanel;
    pbTextures: TProgressBar;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
  private
     
  public
     
  end;

var
  fmCreatingGalaxy: TfmCreatingGalaxy;

implementation

{$R *.dfm}

end.
