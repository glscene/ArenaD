unit StereoFrm;

interface

uses
  Winapi.OpenGL,
  Winapi.OpenGLext,
  Winapi.Windows,
  Winapi.Messages,
  System.Classes,
  System.SysUtils,
  System.Math,
  Vcl.Controls,
  Vcl.Menus,
  Vcl.Graphics,
  Vcl.Forms,
  Vcl.Dialogs,

  WGL,
  WGLext,
  GLS.Keyboard,
  GLS.Scene,
  GLS.VectorTypes,
  GLS.PersistentClasses,
  GLS.SceneViewer,
  GLS.Material,
  GLS.Objects,
  GLS.Cadencer,
  GLS.Texture,
  GLS.VectorGeometry,
  GLS.Graphics,
  GLS.HUDObjects,
  GLS.Context,
  GLS.GeomObjects,
  GLSL.TextureShaders,
  GLSL.UserShader,
  GLS.AsyncTimer,
  GLS.Coordinates,
  GLS.BaseClasses,
  GLS.RenderContextInfo;

type
  TAaStereoForm = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLMemoryViewer1: TGLMemoryViewer;
    CameraTarget: TGLDummyCube;
    GLLightSource1: TGLLightSource;
    GLCamera1: TGLCamera;
    GLCadencer1: TGLCadencer;
    GLHUDSprite1: TGLHUDSprite;
    Setup: TGLDirectOpenGL;
    LeftCamera: TGLCamera;
    RightCamera: TGLCamera;
    GLMaterialLibrary1: TGLMaterialLibrary;
    StereoScene: TGLDummyCube;
    Cleanup: TGLDirectOpenGL;
    GLTeapot1: TGLTeapot;
    GLUserShader1: TGLUserShader;
    AsyncTimer1: TGLAsyncTimer;
    PopupMenu1: TPopupMenu;
    Colors1: TMenuItem;
    RedBlueColor: TMenuItem;
    BLueRed1: TMenuItem;
    GreenBlue1: TMenuItem;
    BlueGreen1: TMenuItem;
    StereoView1: TMenuItem;
    NotStereo1: TMenuItem;
    GlyphMenu: TMenuItem;
    Pinout1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Rotate1: TMenuItem;
    VSync1: TMenuItem;
    N2: TMenuItem;
    About1: TMenuItem;
    GLSphere1: TGLSphere;
    Blurred1: TMenuItem;
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime, newTime: Double);
    procedure GLSceneViewer1BeforeRender(Sender: TObject);
    procedure SetupRender(Sender: TObject; var rci: TGLRenderContextInfo);
    procedure CleanupRender(Sender: TObject; var rci: TGLRenderContextInfo);
    procedure GLUserShader1DoApply(Sender: TObject;
      var rci: TGLRenderContextInfo);
    procedure GLUserShader1DoUnApply(Sender: TObject; Pass: Integer;
      var rci: TGLRenderContextInfo; var Continue: Boolean);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure RedBlueColorClick(Sender: TObject);
    procedure NotStereo1Click(Sender: TObject);
    procedure Rotate1Click(Sender: TObject);
    procedure VSync1Click(Sender: TObject);
    procedure GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;  X, Y: Integer);
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure About1Click(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
    procedure GLSceneViewer1DblClick(Sender: TObject);
  private
    StereoCapable, MemCapable, Switcheroo: Boolean;
    StereoMode, mdx, mdy: Integer;
    pseye: Double;
  public
    RenderPass, RenderPassLeft, RenderPassRight: Integer;
  end;

var
  AaStereoForm: TAaStereoForm;

implementation

{$R *.dfm}

procedure TAaStereoForm.FormCreate(Sender: TObject);
var
  flag: BYTEBOOL;
  flagged: PGLBoolean;
begin
  { Dunno how this is supposed to be.. but it does NOT work
    procedure glGetBooleanv(pname: TGLEnum; params: PGLboolean); }
  flag := True; { False; } { It will return Whatever i send it }
  flagged := Addr(flag);
  glGetBooleanv(GL_STEREO, flagged); { Should return Stereo Capability }
//  flag := flagged^;
  if (flagged^=0) then
//  If flag = false then
  begin
    Pinout1.Caption := 'NA';
    StereoCapable := false;
  end
  else
    StereoCapable := True;
  StereoMode := 2;
  (*
    if (not WGL_ARB_pbuffer)<>0 then
    showmessage('no p buffer');
    WGL_ARB_pbuffer:=CheckExtension('WGL_STEREO_ARB ');
  *)
  if (WGL_DOUBLE_BUFFER_ARB = 0) then
    showmessage('no double buffer');
  if (not WGL_STEREO_ARB) = 0 then
    showmessage('no stereo buffer');
  if (WGL_PBUFFER_LOST_ARB = 0) then
  begin
    GlyphMenu.Caption := 'NA';
    MemCapable := false;
    StereoMode := 0;
    NotStereo1.Checked := True;
  end
  else
    MemCapable := True;
  Switcheroo := True;
  RenderPassLeft := 1; { Red }
  RenderPassRight := 3; { Blue }
  pseye := 0.25;
end;

procedure TAaStereoForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TAaStereoForm.About1Click(Sender: TObject);
begin
  showmessage('GLScene Stereo Demo Version 0.1' + #13#10 +
    'GLScene: http://glscene.org/' + #13#10 +
    'Written by Stuart Gooding and Stuart Little II');
end;

procedure TAaStereoForm.FormResize(Sender: TObject);
begin
  // This lines take cares of auto-zooming.
  // magic numbers explanation :  from caterpillar demo
  // 250 is a form width where things looks good when focal length is 50,
  // ie. when form width is 250, uses 38 as focal length,
  // when form is 500, uses 76, etc...
  // GLCameraBase.FocalLength:=Width*38/250;
  GLCamera1.FocalLength := Width * 50 / 512;
  LeftCamera.FocalLength := Width * 50 / 512;
  RightCamera.FocalLength := Width * 50 / 512;
  { Do some ps.eye ? stuff }
end;

procedure TAaStereoForm.FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  { AaStereoForm.Width:=520;
    AaStereoForm.Height:=546; }
  { Make sure the form is Square ?power of 2?
    kinda goofy, move the corner.. it will work }
  If NewHeight > (NewWidth + 26) then
  begin
    NewHeight := (NewWidth + 26);
  end
  else
  begin
    NewWidth := (NewHeight - 26);
  end;
  Resize := True;
  GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TAaStereoForm.GLCadencer1Progress(Sender: TObject;
  const deltaTime, newTime: Double);
begin
  If Rotate1.Checked then
    GLTeapot1.Turn(deltaTime * 25);

  GLHUDSprite1.Visible := false;
  StereoScene.Visible := True;
  case StereoMode of
    0:
      Begin
        RenderPass := 0;
      End;
    1:
      Begin
        If Switcheroo then
        begin
          RenderPass := RenderPassLeft;
          GLSceneViewer1.Camera := LeftCamera;
          Switcheroo := false;
        end
        else
        begin
          RenderPass := RenderPassRight;
          GLSceneViewer1.Camera := RightCamera;
          Switcheroo := True;
        end;
      End;
    2:
      Begin
        with GLMemoryViewer1 do
        begin
          Camera := LeftCamera;
          RenderPass := RenderPassLeft;
          Render;
          CopyToTexture(GLMaterialLibrary1.Materials[0].Material.Texture);

          Camera := RightCamera;
          RenderPass := RenderPassRight;
          Render;
          CopyToTexture(GLMaterialLibrary1.Materials[1].Material.Texture);
        end;
        GLSceneViewer1.Invalidate;
      End;
    3:
      begin { Need to Write to Left and Right Buffers }
        glDrawBuffer(GL_BACK);
        glClear(GL_COLOR_BUFFER_BIT);
        If Switcheroo then
        begin
          RenderPass := RenderPassLeft;
          GLSceneViewer1.Camera := LeftCamera;
          glDrawBuffer(GL_BACK_LEFT);
          Switcheroo := false;
        end
        else
        begin
          RenderPass := RenderPassRight;
          GLSceneViewer1.Camera := RightCamera;
          glDrawBuffer(GL_BACK_RIGHT);
          Switcheroo := True;
        end;
      end;
  End;
end;

procedure TAaStereoForm.GLSceneViewer1BeforeRender(Sender: TObject);
begin
  case StereoMode of
    2:
      begin
        StereoScene.Visible := false;
        with GLHUDSprite1 do
        begin
          Visible := True;
          Width := GLSceneViewer1.Width;
          Height := GLSceneViewer1.Height;
          Position.SetPoint(Width / 2, Height / 2, 0);
        end;
        RenderPass := 0;
      end;
  end;
end;

procedure TAaStereoForm.SetupRender(Sender: TObject;
  var rci: TGLRenderContextInfo);
begin
  case RenderPass of
    1: glColorMask(1, 0, 0, 1);
    2: glColorMask(0, 1, 0, 1);
    3: glColorMask(0, 0, 1, 1);
  else
    glColorMask(1, 1, 1, 1);
  end;
end;

procedure TAaStereoForm.CleanupRender(Sender: TObject;
  var rci: TGLRenderContextInfo);
begin
  glColorMask(1, 1, 1, 1);
end;

procedure TAaStereoForm.GLUserShader1DoApply(Sender: TObject;
  var rci: TGLRenderContextInfo);
begin
  GLMaterialLibrary1.Materials[0].Material.Texture.Apply(rci);
end;

procedure TAaStereoForm.GLUserShader1DoUnApply(Sender: TObject; Pass: Integer;
  var rci: TGLRenderContextInfo; var Continue: Boolean);
begin
  case Pass of
    1:
      begin
        GLMaterialLibrary1.Materials[0].Material.Texture.UnApply(rci);
        glPushAttrib(GL_ENABLE_BIT);
        glEnable(GL_BLEND);
        glBlendFunc(GL_ONE, GL_ONE);
        GLMaterialLibrary1.Materials[1].Material.Texture.Apply(rci);
        Continue := True;
      end;
    2:
      begin
        GLMaterialLibrary1.Materials[1].Material.Texture.UnApply(rci);
        glPopAttrib;
        Continue := false;
      end;

  else
    Assert(false, 'Invalid use of shader!!!');
  end;

end;

procedure TAaStereoForm.AsyncTimer1Timer(Sender: TObject);
begin
  AaStereoForm.Caption := Format('%.2f FPS', [GLSceneViewer1.FramesPerSecond]);
  GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TAaStereoForm.RedBlueColorClick(Sender: TObject);
var
  Item: TMenuItem;
begin
  Item := Sender as TMenuItem;
  Item.Checked := not Item.Checked;
  case TMenuItem(Sender).Tag of
    11:
      begin
        RenderPassLeft := 1; { Red }
        RenderPassRight := 3; { Blue }
      end;
    12:
      begin
        RenderPassLeft := 3;
        RenderPassRight := 1;
      end;
    13:
      begin
        RenderPassLeft := 2; { Green }
        RenderPassRight := 3;
      end;
    14:
      begin
        RenderPassLeft := 3;
        RenderPassRight := 2;
      end;
  end;
end;

procedure TAaStereoForm.NotStereo1Click(Sender: TObject);
var
  Item: TMenuItem;
begin
  Item := Sender as TMenuItem;
  Item.Checked := not Item.Checked;
  GLSceneViewer1.Buffer.ContextOptions := [roDoubleBuffer, roRenderToWindow];
  case TMenuItem(Sender).Tag of
    0: StereoMode := Item.Tag;
    1: StereoMode := Item.Tag;
    2:
      begin
        If (not MemCapable) then
        begin
          StereoMode := 0;
          NotStereo1.Checked := True;
        end
        else
          StereoMode := Item.Tag;
      end;
    3:
      begin
        If not StereoCapable then
        begin
          StereoMode := 0;
          NotStereo1.Checked := True;
        end
        else
        begin
          StereoMode := Item.Tag;
          GLSceneViewer1.Buffer.ContextOptions := [roDoubleBuffer, roRenderToWindow, roStereo];
        end;
      end;
  end;
  GLSceneViewer1.Invalidate;
end;

procedure TAaStereoForm.Rotate1Click(Sender: TObject);
var
  Item: TMenuItem;
begin
  Item := Sender as TMenuItem;
  Item.Checked := not Item.Checked;
end;

procedure TAaStereoForm.VSync1Click(Sender: TObject);
begin
  VSync1.Checked := not VSync1.Checked;
  if VSync1.Checked then
    GLSceneViewer1.VSync := vsmSync
  else
    GLSceneViewer1.VSync := vsmNoSync;
end;

procedure TAaStereoForm.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // store mouse coordinates when a button went down
  mdx := X;
  mdy := Y;
end;

procedure TAaStereoForm.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  dx, dy: Integer;
  v: TVector;
begin
  // calculate delta since last move or last mousedown
  dx := mdx - X;
  dy := mdy - Y;
  mdx := X;
  mdy := Y;
  if ssLeft in Shift then
  begin
    if ssShift in Shift then
    begin
      // left button with shift rotates the teapot
      // (rotation happens around camera's axis)
      GLCamera1.RotateObject(StereoScene, dy, dx);
    end
    else if ssCtrl in Shift then
    begin
      // left button with Ctrl changes camera angle
      // (we're moving around the parent and target dummycube)
      GLCamera1.MoveAroundTarget(dy, dx);
    end
    else
    begin
      // left button moves our target and parent dummycube
      v := GLCamera1.ScreenDeltaToVectorXY(dx, -dy,
        0.12 * GLCamera1.DistanceToTarget / GLCamera1.FocalLength);
      StereoScene.Position.Translate(v);
      // notify camera that its position/target has been changed
      GLCamera1.TransformationChanged;
    end;
  end;
end;

procedure TAaStereoForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if IsKeyDown(VK_ESCAPE) then
    Close;
  case Key of
    'q': Close;
    'Q': Close;
    't':
      begin
        pseye := pseye - 0.05; // move eye distance
        LeftCamera.Position.X := (-1 * pseye);
        RightCamera.Position.X := (pseye);
      end;
    'y':
      begin
        pseye := pseye + 0.05; // move eye distance
        LeftCamera.Position.X := (-1 * pseye);
        RightCamera.Position.X := (pseye);
      end;
    'g':
      begin
        pseye := pseye - 0.01; // move eye distance
        LeftCamera.Position.X := (-1 * pseye);
        RightCamera.Position.X := (pseye);
      end;
    'h':
      begin
        pseye := pseye + 0.01; // move eye distance
        LeftCamera.Position.X := (-1 * pseye);
        RightCamera.Position.X := (pseye);
      end;
    'n': GLCamera1.MoveAroundTarget(-3, 0);
    'm': GLCamera1.MoveAroundTarget(3, 0);
    'j': GLCamera1.MoveAroundTarget(0, -3);
    'k': GLCamera1.MoveAroundTarget(0, 3);
    '-': GLCamera1.AdjustDistanceToTarget(1.1);
    '+': GLCamera1.AdjustDistanceToTarget(1 / 1.1);
    'f':
      begin
        GLCamera1.FocalLength := GLCamera1.FocalLength + 10;
        // Camera focus plane foward */
        LeftCamera.FocalLength := LeftCamera.FocalLength + 10;
        RightCamera.FocalLength := RightCamera.FocalLength + 10;
      end;
    'v':
      begin
        GLCamera1.FocalLength := GLCamera1.FocalLength - 10;
        // Camera focus plane back */
        LeftCamera.FocalLength := LeftCamera.FocalLength - 10;
        RightCamera.FocalLength := RightCamera.FocalLength - 10;
      end;
    'd':
      begin
        GLCamera1.DepthOfView := GLCamera1.DepthOfView + 10;
        // Camera DepthOfView foward */
        LeftCamera.DepthOfView := LeftCamera.DepthOfView + 10;
        RightCamera.DepthOfView := RightCamera.DepthOfView + 10;
      end;
    'c':
      begin
        GLCamera1.DepthOfView := GLCamera1.DepthOfView - 10;
        // Camera DepthOfView back */
        LeftCamera.DepthOfView := LeftCamera.DepthOfView - 10;
        RightCamera.DepthOfView := RightCamera.DepthOfView - 10;
      end;
  end; // end keyboard

  with GLTeapot1 do
    case Key of
      '7': RotateAbsolute(-15, 0, 0);
      '9': RotateAbsolute(+15, 0, 0);
      '4': RotateAbsolute(0, -15, 0);
      '6': RotateAbsolute(0, +15, 0);
      '1': RotateAbsolute(0, 0, -15);
      '3': RotateAbsolute(0, 0, +15);
    end;
  Key := #0;
end;

procedure TAaStereoForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  // Note that 1 wheel-step induces a WheelDelta of 120,
  // this code adjusts the distance to target with a 10% per wheel-step ratio
  GLCamera1.AdjustDistanceToTarget(Power(1.1, WheelDelta / 120));
end;

procedure TAaStereoForm.GLSceneViewer1DblClick(Sender: TObject);
begin
  if (BorderStyle <> bsNone) then
  begin
    BorderStyle := bsNone;
    FormStyle := fsStayOnTop;
    Align := alClient;
  end;
end;

end.
