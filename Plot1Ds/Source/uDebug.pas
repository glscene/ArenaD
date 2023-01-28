unit uDebug;

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
  Vcl.StdCtrls;

type
  TDebugForm = class(TForm)
    DebugMemo: TMemo;
  private
  public
  end;

var
  DebugForm: TDebugForm;

//=========================================================
implementation
//=========================================================

{$R *.dfm}

end.
