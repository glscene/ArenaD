unit fViewStatus;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,Forms,
  Dialogs, Vcl.StdCtrls,ComCtrls, Vcl.ExtCtrls,Buttons;

type
  TfmConstruction = class(TForm)
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
  fmConstruction: TfmConstruction;

implementation

{$R *.dfm}

end.
