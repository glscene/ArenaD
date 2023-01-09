{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: fKeyboard.pas,v 1.2 2003/06/28 21:47:54 aidave Exp $
}
unit fKeyboard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,Forms,
  Dialogs, Vcl.StdCtrls,ComCtrls, Vcl.Buttons, ExtCtrls;

type
  TfmKeyboard = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    btnRun: TBitBtn;
    Panel2: TPanel;
    redIntro: TRichEdit;
  private
     
  public
     
  end;

var
  fmKeyboard: TfmKeyboard;

implementation

{$R *.dfm}

end.
