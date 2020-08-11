{ The fire special effect basic sample.   

   If you look at the code you won't see anything fancy. The FireFX is a dynamic
   special effect (driven by a cadencer). Making use of it means two things :   
   - dropping a FirexFXManager, this one controls fire particle systems aspects   
   - adding a FireFX effect to the object you want to see burning (here, a sphere)   
   You may have multiple objects sharing the same FireFXManager, this means they
   will all look the same, but also that the particle system calculations are
   made only once.   

   This effect looks cool but is fill-rate hungry, but un-textured fillrate
   hungry, ie. video card memory bandwith is not an issue. Anyway, you can
   always make it look nice with smaller and/or less particles.
}
unit Unit1;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.Math,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
   
  GLS.Scene,
  GLS.VectorTypes,
  GLS.FireFX,
  GLS.Cadencer,
  GLS.Objects,
  GLS.Behaviours,
  GLS.VectorGeometry,
  GLS.SceneViewer, GLS.GeomObjects,
  GLS.Coordinates,  GLS.BaseClasses;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCadencer1: TGLCadencer;
    GLFireFXManager1: TGLFireFXManager;
    GLCamera1: TGLCamera;
    Sphere1: TGLSphere;
    GLLightSource2: TGLLightSource;
    Timer1: TTimer;
    Panel1: TPanel;
    TrackBar1: TTrackBar;
    Timer2: TTimer;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    TrackBar4: TTrackBar;
    TrackBar6: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    TrackBar7: TTrackBar;
    Label7: TLabel;
    TrackBar8: TTrackBar;
    Label5: TLabel;
    TrackBar5: TTrackBar;
    Label8: TLabel;
    TrackBar9: TTrackBar;
    Button1: TButton;
    Button2: TButton;
    procedure GLSceneViewer1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure TrackBar4Change(Sender: TObject);
    procedure TrackBar5Change(Sender: TObject);
    procedure TrackBar6Change(Sender: TObject);
    procedure TrackBar7Change(Sender: TObject);
    procedure TrackBar8Change(Sender: TObject);
    procedure TrackBar9Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
        
  public
        
    mx, my : Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   mx:=x; my:=y;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
   if Shift<>[] then
      GLCamera1.MoveAroundTarget(my-y, mx-x);
   mx:=x; my:=y;
   GLCadencer1.Progress;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
   Caption:=Format('Fire Demo '+ '%.1f FPS', [GLSceneViewer1.FramesPerSecond]);
   GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
	GLCamera1.AdjustDistanceToTarget(Power(1.1, WheelDelta/120));
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
    GLFireFXManager1.FireDensity:= TrackBar1.Position*0.1;
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin
    GLFireFXManager1.FireBurst:= TrackBar2.Position;
end;

procedure TForm1.TrackBar3Change(Sender: TObject);
begin
    GLFireFXManager1.FireCrown:= TrackBar3.Position*0.1;
end;

procedure TForm1.TrackBar4Change(Sender: TObject);
begin
    GLFireFXManager1.FireEvaporation:= TrackBar4.Position*0.1;
end;

procedure TForm1.TrackBar5Change(Sender: TObject);
begin
  GLFireFXManager1.FireRadius:= TrackBar5.Position*0.3;
end;

procedure TForm1.TrackBar6Change(Sender: TObject);
begin
  GLFireFXManager1.ParticleSize:= TrackBar6.Position*0.1;
end;

procedure TForm1.TrackBar7Change(Sender: TObject);
begin
  GLFireFXManager1.ParticleLife:= TrackBar7.Position+1;
end;

procedure TForm1.TrackBar8Change(Sender: TObject);
begin
  GLFireFXManager1.ParticleInterval:= TrackBar8.Position*0.004;
end;

procedure TForm1.TrackBar9Change(Sender: TObject);
begin
    GLFireFXManager1.FireDir.Z:=-TrackBar9.Position*0.1;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  GLFireFXManager1.IsotropicExplosion(1,15,1);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  GLFireFXManager1.RingExplosion(1,15,1 ,XVector, ZVector);
end;

end.
