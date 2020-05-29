unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Jpeg,
   
  GLCadencer, GLTexture, GLScene, GLVectorFileObjects,
  GLWin32Viewer, GLMaterial, GLCoordinates, GLCrossPlatform,
  GLBaseClasses, GLFileSMD;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    GLActor1: TGLActor;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLCadencer1: TGLCadencer;
    GLLightSource1: TGLLightSource;
    procedure FormCreate(Sender: TObject);
    procedure GLSceneViewer1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
  private
     
  public
     
  end;

var
  Form1: TForm1;
  mx,my:integer;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  GLActor1.LoadFromFile('model.smd');
  GLActor1.AddDataFromFile('run.smd');
  GLActor1.SwitchToAnimation(1);
end;

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
mx:=x;my:=y;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
if ssleft in shift then begin
  GLCamera1.MoveAroundTarget(my-y,mx-x);
  mx:=x;my:=y;
end;
end;

end.
