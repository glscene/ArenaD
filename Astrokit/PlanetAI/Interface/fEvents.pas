{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: fEvents.pas,v 1.2 2003/06/28 21:47:54 aidave Exp $
}
unit fEvents;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,Forms, Dialogs,
  StdCtrls, Vcl.ComCtrls,ExtCtrls;

type
  TfmEvents = class(TForm)
    Panel22: TPanel;
    redEvents: TRichEdit;
    StatusBar1: TStatusBar;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
     
  public
     
    procedure AddEvent(aEvent: string);
  end;

var
  fmEvents: TfmEvents;

implementation

uses fFirstForm;

{$R *.DFM}

procedure TfmEvents.AddEvent(aEvent: string);
begin
  redEvents.Lines.Add(aEvent);
end;

procedure TfmEvents.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := false;
  fmFirstForm.RealityForm.ManagerForm.DropEvents;
end;

end.
