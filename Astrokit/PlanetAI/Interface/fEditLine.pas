unit fEditLine;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons;

type
  TfmEditLine = class(TForm)
    edLine: TEdit;
    BitBtn1: TBitBtn;
    labName: TLabel;
    BitBtn2: TBitBtn;
  private
     
  public
     
  end;

var
  fmEditLine: TfmEditLine;

implementation

{$R *.DFM}

end.
