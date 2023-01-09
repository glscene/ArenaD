{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: fPlanet.pas,v 1.2 2003/06/28 21:47:54 aidave Exp $
}
unit fPlanet;

interface

uses
  Winapi.Windows,
  Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Buttons;

type
  TfmPlanet = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edX: TEdit;
    edY: TEdit;
    edZ: TEdit;
    Label5: TLabel;
    edRadius: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    edHeight: TEdit;
    edWidth: TEdit;
    cbShowBuild: TCheckBox;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
  private

  public

  end;

var
  fmPlanet: TfmPlanet;

implementation

{$R *.dfm}

end.
