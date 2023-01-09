{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: fIntro.pas,v 1.2 2003/06/28 21:47:54 aidave Exp $
}
unit fIntro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,Forms, Dialogs,
  ExtCtrls, Vcl.StdCtrls,Vcl.Buttons, ComCtrls;

type
  TfmIntro = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    btnRun: TBitBtn;
    Panel5: TPanel;
    redStats: TRichEdit;
    redIntro: TRichEdit;
    procedure btnRunClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
     
  public
     
    Monitors: integer;
  end;

var
  fmIntro: TfmIntro;

implementation

{$R *.DFM}

procedure TfmIntro.FormShow(Sender: TObject);
begin
  redStats.Clear;
  redStats.Lines.Add('system stats');
  redStats.Lines.Add(' monitors = ' + IntToStr(Monitors));
  if Monitors > 1 then
    redStats.Lines.Add(' multimonitor support enabled')
  else
    redStats.Lines.Add(' multimonitor support disabled');

  btnRun.SetFocus;
end;

procedure TfmIntro.btnRunClick(Sender: TObject);
begin
  Close;
end;

end.
