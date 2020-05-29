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
  GLCadencer,
  GLTexture,
  GLWin32Viewer,
  GLScene,
  GLObjects,
  GLMaterial,
  GLFileTGA,
  GLCoordinates,
  GLTeapot,
  GLCrossPlatform,
  GLBaseClasses;

type
  TForm1 = class(TForm)
    GLScene: TGLScene;
    GLSceneViewer: TGLSceneViewer;
    GLMaterialLibrary: TGLMaterialLibrary;
    GLCadencer: TGLCadencer;
    gloCamera: TGLCamera;
    gloFog: TGLDummyCube;
    gloFogZ2: TGLPlane;
    gloFogY3: TGLPlane;
    gloFogZ1: TGLPlane;
    gloFogY1: TGLPlane;
    gloFogX3: TGLPlane;
    gloFogY2: TGLPlane;
    gloFogZ3: TGLPlane;
    gloFogX2: TGLPlane;
    gloFogX1: TGLPlane;
    gloLight: TGLLightSource;
    gloTeapot: TGLTeapot;
    procedure FormCreate(Sender: TObject);
    procedure GLCadencerProgress(Sender: TObject; const deltaTime,
      newTime: Double);
  private
     
  public
     
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
   i        : integer;
   NewMat   : TGLLibMaterial;
begin
   randomize;

   with GLMaterialLibrary.Materials do
   begin
      for i:=1 to 5 do
      begin
         NewMat := Add;
         NewMat.Name := 'cloud' + inttostr(i);
         NewMat.Material.Texture.Image.LoadFromFile('textures\cloud' + inttostr(i) + '.tga');
         NewMat.Material.MaterialOptions := [moNoLighting];
         NewMat.Material.Texture.Enabled := True;
         NewMat.Material.Texture.TextureMode := tmReplace;
         NewMat.Material.BlendingMode := bmTransparency;
      end;
   end;

   with gloFog do
   begin
      for i:=0 to 8 do
      begin
         TGLPlane(Children[i]).Material.MaterialLibrary := GLMaterialLibrary;
         TGLPlane(Children[i]).Material.LibMaterialName := 'cloud' + inttostr(random(4)+1);
      end;
   end;

end;

procedure TForm1.GLCadencerProgress(Sender: TObject; const deltaTime,
  newTime: Double);
begin
   gloFog.Turn(10*deltaTime);
   gloTeaPot.Position.Y := Sin(newTime) * 5;
end;

end.
