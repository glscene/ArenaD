unit Unit1;

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

  GLS.Cadencer,
  GLS.Scene,
  GLS.Objects,
  GLS.SceneViewer,
  GLS.AsyncTimer,
  GLS.VectorFileObjects,
  GLS.Texture,
  GLS.Graph,
  GLS.File3DS,
  GLS.VectorGeometry,
  GLS.VectorTypes,
  GLS.Graphics,
  GLS.Material,
  GLS.Coordinates,
  
  GLS.BaseClasses,
  GLS.VectorLists,

  Uplasma;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    GLCadencer1: TGLCadencer;
    AsyncTimer1: TGLAsyncTimer;
    GLDummyCube1: TGLDummyCube;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLActor1: TGLActor;
    Lights: TGLDummyCube;
    GLLightSource1: TGLLightSource;
    procedure GLCadencer1Progress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
  private
    is_mouse_pressed: boolean;
    procedure UpdatePlasmaImage(B: TBitmap);
    procedure init_plasma_world;
    procedure step_plasma_world;
  public
    B: TBitmap;
    f: TForceField;
  end;

var
  Form1: TForm1;

implementation


{$R *.dfm}

procedure TForm1.AsyncTimer1Timer(Sender: TObject);
begin
  Caption := Inttostr(Round(GLSceneViewer1.FramesPerSecond)) + ' FPS';
  GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  GLActor1.LoadFromFile('plane.3DS');
  B := TBitmap.Create;
  B.LoadFromFile('bitmap.bmp');
  B.PixelFormat := pf32bit;
  f := TForceField.Create;
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject;
  const deltaTime, newTime: Double);
var
  t: Integer;
  VL: TAffineVectorList;
  dV: TVector3f;
begin
  step_plasma_world;
  UpdatePlasmaImage(B);
  GLMaterialLibrary1.Materials[0].Material.Texture.Image.Assign(B);
  GLSceneViewer1.Invalidate;
end;

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  is_mouse_pressed := true;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if is_mouse_pressed then
  begin
    if (X < N * 4) and (Y < N * 4) then
    begin
      f.dens_prev[X div 4, Y div 4] := 20;
    end;
  end;
end;

procedure TForm1.GLSceneViewer1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  is_mouse_pressed := false;
end;

procedure TForm1.UpdatePlasmaImage(B: TBitmap);
var
  X, Y, C: Integer;
  Line: PPixel32Array;
  v: Integer;
begin
  // Update the texture.
  for Y := 0 to N do
  begin
    Line := B.ScanLine[Y];
    for X := 0 to N do
    begin
      // Here the color of the bitmap might be set better than this:
      Line[X].r := abs(Round(f.u[X, Y] * 100));
      Line[X].g := abs(Round(f.dens[X, Y] * 100));
      Line[X].B := abs(Round(f.v[X, Y] * 100));
    end;
  end;

end;

procedure TForm1.step_plasma_world;
var
  X, Y: Integer;
  l: Integer;
  diff, visc, dt: real;
begin
  diff := 0.0001;
  visc := 0.0001;
  dt := 0.1;

  // eventually update dens_prev, u_prev, v_prev here:
  init_plasma_world;

  f.vel_step(N, f.u, f.v, f.u_prev, f.v_prev, visc, dt);
  f.dens_step(N, f.dens, f.dens_prev, f.u, f.v, diff, dt, is_mouse_pressed);
end;

procedure TForm1.init_plasma_world;
var
  X, Y: Integer;
  tk: real;
begin
  tk := 0.2 * (GettickCount / 360 * 3.14159);

  // ADD A FORCE EMITTER HERE
  for X := 10 to 20 do
  begin
    for Y := 10 to 20 do
    begin
      f.u_prev[X, Y] := sin(tk) * 8; // random*150;//1
      f.v_prev[X, Y] := cos(tk) * 8; // random*150;//1
    end;
  end;

  // ADD A FORCE EMITTER HERE
  for X := 80 to 90 do
  begin
    for Y := 80 to 90 do
    begin
      f.u_prev[X, Y] := -random * 5; // 1
      f.v_prev[X, Y] := -random * 5; // 1
    end;
  end;

  // ADD A FORCE EMITTER HERE
  for X := 30 to 40 do
  begin
    for Y := 40 to 50 do
    begin
      f.u_prev[X, Y] := sin(tk * 1.23) * 8; // random*150;//1
      f.v_prev[X, Y] := cos(tk * 2.32) * 8; // random*150;//1
    end;
  end;

end;

end.
