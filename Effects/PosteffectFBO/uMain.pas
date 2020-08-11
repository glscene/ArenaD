unit uMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Winapi.OpenGL,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,

  GLS.Objects,
  GLS.HUDObjects,
  GLS.Material,
  GLSL.CustomShader,
  GLSL.AsmShader,
  GLS.Scene,
  GLS.FBORenderer,
  GLS.Coordinates,
  GLS.Cadencer,
  
  GLS.BaseClasses,
  GLS.SceneViewer,
  GLS.SimpleNavigation,
  GLS.RenderContextInfo,
  GLS.GeomObjects,
  GLSL.Shader;

type
  TForm1 = class(TForm)
    GLSceneViewer1: TGLSceneViewer;
    GLScene1: TGLScene;
    GLCadencer1: TGLCadencer;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLCamera1: TGLCamera;
    GLFBORenderer1: TGLFBORenderer;
    GLLightSource1: TGLLightSource;
    GLHUDSprite1: TGLHUDSprite;
    GLSimpleNavigation1: TGLSimpleNavigation;
    GLTeapot1: TGLTeapot;
    GLSLShader1: TGLSLShader;
    procedure FormCreate(Sender: TObject);
    procedure GLSLShader1Apply(Shader: TGLCustomGLSLShader);
    procedure FormResize(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  GLSLShader1.Enabled := true;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  // Regenerate blur asm shader, it depend screen size
  GLFBORenderer1.Width   := GLSceneViewer1.Width;
  GLFBORenderer1.Height  := GLSceneViewer1.Height;
  GLHUDSprite1.Width  := GLSceneViewer1.Width;
  GLHUDSprite1.Height := GLSceneViewer1.Height;
  GLHUDSprite1.Position.SetPoint(GLSceneViewer1.Width div 2,
                                 GLSceneViewer1.Height div 2, 0);
  GLCamera1.SceneScale := GLSceneViewer1.Width / GLSceneViewer1.Height;
end;

procedure TForm1.GLSLShader1Apply(Shader: TGLCustomGLSLShader);
begin
  with Shader do begin
    Param['RT'].AsTexture2D[0] := GLMaterialLibrary1.TextureByName('colorTex');
    Param['blur_dist'].AsFloat := 0.006;
  end;
end;

end.
