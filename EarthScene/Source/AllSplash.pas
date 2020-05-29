//adapted from:
// Author: Pete Goodwin (pgoodwin@blueyonder.co.uk)
unit AllSplash;

interface

uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TSplashScreen = class(TForm)
    Timer: TTimer;
    Label1: TLabel;
    TitleLabel: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label3: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    Image1: TImage;
    Label8: TLabel;
    Label7: TLabel;
    procedure TimerTimer(Sender: TObject);
    procedure SplashPanelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
procedure SplashSet(Which,When:Integer);
  private
     
  public
     
  end;

var
  SplashScreen: TSplashScreen;

implementation

{$R *.DFM}

procedure TSplashScreen.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := false;
  Close;
end;

procedure TSplashScreen.SplashPanelClick(Sender: TObject);
begin
  Timer.Enabled := false;
  Close;
end;

procedure TSplashScreen.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TSplashScreen.SplashSet(Which,When:Integer);
Begin
Case Which of
0:TitleLabel.Caption:='Image Locatable Holographics';
1:TitleLabel.Caption:='Image';
2:TitleLabel.Caption:='Locatable';
3:TitleLabel.Caption:='Holographics';
4:TitleLabel.Caption:='Imagem';
5:TitleLabel.Caption:='Life';
6:TitleLabel.Caption:='Fractal 3D';
7:TitleLabel.Caption:='Digital Terrain Mapping';
8:TitleLabel.Caption:='Tracer';
9:TitleLabel.Caption:='VOICE';
10:TitleLabel.Caption:='GRIP ICE';
11:TitleLabel.Caption:='SOS MAP';
12:TitleLabel.Caption:='VR GIS';
13:TitleLabel.Caption:='Open GL Viewer';
14:TitleLabel.Caption:='Manipulative Digital Image';
15:TitleLabel.Caption:='VR Importer';
16:TitleLabel.Caption:='Tongs';
17:TitleLabel.Caption:='GLS Boids';
End;
{5000 = 5 seconds splash
The default value is 1000 (one second).}
Timer.Interval:=When;
End;

end.
