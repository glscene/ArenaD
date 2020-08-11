unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Graphics, Controls, Forms, ExtCtrls,JPEG, StdCtrls, Dialogs,
   
  GLS.Texture, GLS.Scene, GLS.Objects, GLS.SceneViewer, GLS.Cadencer,
  UFireFxBase, GLS.VectorGeometry, GLS.GeomObjects,
  GLS.Material, GLS.Coordinates,  GLS.BaseClasses, GLS.ExplosionFx,
  GLS.FireFX;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    GLLightSource1: TGLLightSource;
    GLMatLibrary: TGLMaterialLibrary;
    GLCadencer1: TGLCadencer;
    Timer1: TTimer;
    Sprites: TGLDummyCube;
    GLSphere1: TGLSphere;
    Button1: TButton;
    GLDummyCube1: TGLDummyCube;
    GLCylinder1: TGLCylinder;
    GLFireFXManager1: TGLFireFXManager;
    procedure FormCreate(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
     
  public
     
    LastTk : integer;
    Fx : TFireFxDummyCubeBase;
  end;

var
  Form1: TForm1;

implementation


{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  t: integer;
  LM : TGLLibMaterial;
  st: string;
  stPath : string;
  sp : TGLSprite;
begin
  LastTk := 0;
  stPath := '.\';
  for t := 1 to 10 do begin
    st := 'boom'+inttostr(t)+'.jpg';
    LM := GLMatLibrary.AddTextureMaterial(st,stPath + st,true);
    LM.Material.BlendingMode := bmAdditive;
    LM.Material.Texture.Disabled := false;
    LM.Material.Texture.ImageAlpha := tiaAlphaFromIntensity;
    LM.Material.Texture.TextureMode := tmReplace;
  end;

  GLCadencer1.Enabled := true;

  Fx := TFireFxDummyCubeBase.Create(GLSphere1,Sprites,Self);
  Fx.FxMatLib := GLMatLibrary;
  Fx.FxMatIndexStart := 0;
  Fx.FxMatIndexEnd := 9;
  Fx.FxSpritesCount := 10;
  Makevector(Fx.FXStartSize,0.5,0.5,0);
  Makevector(Fx.FXDeltaSize,0.001,0.001,0);
  Makevector(Fx.FXAccel,0,1,0);
  Fx.FxTkEmissiondelay := 80;
  Fx.FxTkUpdatedelay   := 10;
  Fx.FxMatIndexIncCoeff := 0.01;
  Fx.FXDeltaRotation :=0.2;
  Fx.FxMatRepeatCount := 1;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Fx.Free;
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
var
  sp : TGLSprite;
  t: integer;
begin
  GLSCene1.BeginUpdate;
  Fx.FxAdvance;
  GLDummyCube1.Turn(deltaTime*100);
  GLSCene1.EndUpdate;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Form1.Caption:='FPS='+FloatToStr(GLSceneViewer1.FramesPerSecond);
  GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Fx.FxEnabled := not Fx.FxEnabled;
  GLLightSource1.Shining := Fx.FxEnabled;
end;

end.
