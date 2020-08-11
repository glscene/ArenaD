unit UMainForm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Winapi.OpenGL,
  Winapi.OpenGLext,
  System.SysUtils,
  System.Classes,
  System.Math,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Imaging.jpeg,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,

  GLS.Scene,
  GLS.VectorTypes,
  GLS.SkyDome,
  GLS.Mirror,
  GLS.Objects,
  GLS.ShadowPlane,
  GLS.SceneViewer,
  GLS.Cadencer,
  GLS.Texture,
  GLS.ParticleFX,
  GLS.VectorGeometry,
  GLS.Behaviours,
  GLS.Keyboard,
  GLS.SpaceText,
  GLS.Color,
  GLS.Gui,
  GLS.Material,
  GLS.BitmapFont,
  GLS.Windows,
  GLS.HUDObjects,
  GLS.RenderContextInfo,
  GLS.PersistentClasses,
  GLS.Coordinates,
  
  GLS.BaseClasses;

type
  TGameStatus = (gsLevelPreview, gsWarmup, gsPlaying, gsLevelWon, gsLevelLost);

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    Cadencer: TGLCadencer;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera: TGLCamera;
    CubeMapCamera: TGLCamera;
    DCBoard: TGLDummyCube;
    GLMaterialLibrary: TGLMaterialLibrary;
    DCTable: TGLDummyCube;
    Mirror: TGLMirror;
    SPTable: TGLShadowplane;
    GLDirectOpenGL1: TGLDirectOpenGL;
    SelCube: TGLCube;
    Timer1: TTimer;
    DCInterface: TGLDummyCube;
    GLSpaceText1: TGLSpaceText;
    GLMemoryViewer1: TGLMemoryViewer;
    GLPlane1: TGLPlane;
    Panel1: TPanel;
    Button2: TButton;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure GLDirectOpenGL1Render(var rci: TGLRenderContextInfo);
    procedure CadencerProgress(Sender: TObject; CONST deltaTime, newTime: Double);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure GenerateCubeMap;
  public
    pickstartx, pickstarty, speedrot: integer;
    gameStatus: TGameStatus;
    MirrorObj, cubeMapWarnDone: Boolean;
    procedure glDraw(var rci: TGLRenderContextInfo);
    procedure SetObjectMaterial(SceneObject: TGLBaseSceneObject; matindex: integer);
    procedure SetBehavioursDamping(rc, rl, rq, sr, sp, st, tc, tl, tq, sx, sy, sz, mass: single);
    procedure InitDamion;
    procedure InitDamion3D;
    function ModifieDamion(aff: boolean): boolean;
    procedure selectdamion;
  end;

const
  Prof = 150;
  pas_prof = 30;
type
  StructDamion = record
    etat: integer;
    col: integer;
    zeta: integer;
  end;

type
  glcoord = record
    x, y, z: Single;
  end;
const
  TEXTURE_SPEED = 1 / 75;

var
  Form1: TForm1;
  Damion: array[0..4, 0..4] of StructDamion;
  cursx, cursy: integer;
  Tunnels: array[0..32, 0..32] of glcoord;
  Angle: Single;
  Speed: Single;

//----------------------------------
implementation
//----------------------------------

{$R *.DFM}

type
  TOutLineShader = class(TGLShader)
  private
    BackgroundColor, LineColor: TColorVector;
    OutlineSmooth, lighting: boolean;
    OutlineWidth, oldlinewidth: single;
    PassCount: Integer;
  public
    procedure DoApply(var rci: TGLRenderContextInfo; Sender: TObject); override;
    function DoUnApply(var rci: TGLRenderContextInfo): Boolean; override;
  end;

var
  shader1: TOutlineShader;

procedure TOutLineShader.DoApply(var rci: TGLRenderContextInfo; Sender: TObject);
begin
  PassCount := 1;
  glPushAttrib(GL_ENABLE_BIT);
  glDisable(GL_LIGHTING);

  if outlineSmooth then
    begin
      glEnable(GL_BLEND);
      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
      glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
      glEnable(GL_LINE_SMOOTH);
    end
  else
    glDisable(GL_LINE_SMOOTH);

  glGetFloatv(GL_LINE_WIDTH, @oldlinewidth);
  glLineWidth(OutLineWidth);
  glPolygonMode(GL_BACK, GL_LINE);
  //SetGLPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
  glCullFace(GL_FRONT);
  glDepthFunc(GL_LEQUAL);
  glColor3fv(@lineColor);
end;

function TOutLineShader.DoUnApply(var rci: TGLRenderContextInfo): Boolean;
begin
  case PassCount of
    1:
      begin
        PassCount := 2;
        if lighting then
          glEnable(GL_LIGHTING)
        else
          glColor3fv(@backGroundColor);
        glDepthFunc(GL_LESS);
        glCullFace(GL_BACK);
        //glEnable(GL_BLEND);
//         glBlendFunc(GL_SRC_ALPHA,GL_SRC_ALPHA);
        //glPolygonMode(GL_Back, GL_Fill);
       // SetGLPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

        Result := True;
      end;
    2:
      begin
        glPopAttrib;
        glLineWidth(oldLineWidth);
        Result := False;
      end;
  else
    Assert(False);
    Result := False;
  end;
end;

procedure Tform1.glDraw(var rci: TGLRenderContextInfo);
var
  I, J: Integer;
  C, J1, J2: Single;
begin
  // GLTunnel FX From Jans Horn www.sulaco.co.za

  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT); // Clear The Screen And The Depth Buffer
  glLoadIdentity(); // Reset The View
  glTranslatef(0.0, 0.0, -30.0);

  Angle := Angle + speed;

  // setup tunnel coordinates
  for I := 0 to 24 do
    begin
      for J := 0 to 30 do
        begin
          Tunnels[I, J].x := (24 - J / 12) * cos(2 * pi / 12 * I) + 2 * sin((Angle + 2 * j) / 24) + cos((Angle + 2 * j)
            / 10) - 2 * sin(Angle / 24) - cos(Angle / 10);
          Tunnels[I, J].y := (24 - J / 12) * sin(2 * pi / 12 * I) + 2 * cos((Angle + 2 * j) / 29) + sin((Angle + 2 * j)
            / 14) - 2 * cos(Angle / 29) - sin(Angle / 14);
          Tunnels[I, J].z := -(J - 10);
        end;
    end;

  // draw tunnel
  for J := 0 to 30 do
    begin
      J1 := J / 32 + Angle * TEXTURE_SPEED; // precalculate texture v coords for speed
      J2 := (J + 1) / 32 + Angle * TEXTURE_SPEED;

      // near the end of the tunnel, fade the effect away
      if J > 24 then
        C := 1.0 - (J - 24) / 10
      else
        C := 1.0;
      glColor3f(C, C, C);
      GLMaterialLibrary.ApplyMaterial('mat001', rci);
      glbegin(GL_QUADS);
      for I := 0 to 11 do
        begin
          glTexCoord2f((I - 3) / 12, J1); glVertex3f(Tunnels[I, J].X, Tunnels[I, J].Y, Tunnels[I, J].Z);
          glTexCoord2f((I - 2) / 12, J1); glVertex3f(Tunnels[I + 1, J].X, Tunnels[I + 1, J].Y, Tunnels[I + 1, J].Z);
          glTexCoord2f((I - 2) / 12, J2); glVertex3f(Tunnels[I + 1, J + 1].X, Tunnels[I + 1, J + 1].Y, Tunnels[I + 1, J
            + 1].Z);
          glTexCoord2f((I - 3) / 12, J2); glVertex3f(Tunnels[I, J + 1].X, Tunnels[I, J + 1].Y, Tunnels[I, J + 1].Z);
        end;
      glEnd();
      GLMaterialLibrary.UnApplyMaterial(rci);
    end;
end;

procedure TForm1.SetObjectMaterial(SceneObject: TGLBaseSceneObject; matindex: integer);
var
  obj : TGLCustomSceneObject;
begin
  if assigned(sceneobject) and (matindex >= 0) then
    begin
      obj := TGLCustomSceneObject(sceneobject);
      Obj.Material.MaterialLibrary := GLMaterialLibrary;
      obj.Material.Assign(GLMaterialLibrary.Materials[matindex].Material);
    end;
end;

//-- GAME CODE -----------------------------------------------------------------

procedure CaseBleu;
begin
  if (cursy > 0) then
    damion[cursx, cursy - 1].etat := 1 - Damion[cursx, cursy - 1].etat
  else
    damion[cursx, 4].etat := 1 - Damion[cursx, 4].etat;
end;

procedure CaseVerte;
begin
  if (cursx < 4) then
    damion[cursx + 1, cursy].etat := 1 - Damion[cursx + 1, cursy].etat
  else
    damion[0, cursy].etat := 1 - Damion[0, cursy].etat;
end;

procedure CaseRouge;
begin
  if (cursy < 4) then
    damion[cursx, cursy + 1].etat := 1 - Damion[cursx, cursy + 1].etat
  else
    damion[cursx, 0].etat := 1 - Damion[cursx, 0].etat;
end;

procedure CaseJaune;
begin
  if (cursx > 0) then
    damion[cursx - 1, cursy].etat := 1 - Damion[cursx - 1, cursy].etat
  else
    damion[4, cursy].etat := 1 - Damion[4, cursy].etat;
end;

function TForm1.ModifieDamion(aff: boolean): boolean;
var
  i, j, z, c: integer;
begin
  damion[cursx, cursy].etat := 1 - damion[cursx, cursy].etat;
  case damion[cursx, cursy].col OF
    0: caseBleu;
    1: caseVerte;
    2: caseRouge;
    3: caseJaune;
    4:
      begin
        casebleu;
        caseverte;
        caserouge;
        casejaune;
      end;
  end;
  z := 0;
  WHILE (z < prof) do
    begin
      for j := 0 to 4 do
        begin
          for i := 0 to 4 do
            begin
              if ((damion[i, j].etat = 1) and (damion[i, j].zeta <> prof)) then
                damion[i, j].zeta := damion[i, j].zeta + pas_prof;
              if ((damion[i, j].etat = 0) and (damion[i, j].zeta = prof)) then
                damion[i, j].zeta := damion[i, j].zeta - pas_prof;
            end;
        end;
      z := z + pas_prof;
    end;

  if aff then
    begin
      c := -1;
      for j := 0 to 4 do
        begin
          for i := 0 to 4 do
            begin
              inc(c);
              dcboard.Children[1 + c].Position.y := ((damion[i, j].zeta) / 50);
            end;
        end;
    end;
  result := true;
  for j := 0 to 4 do
    begin
      for i := 0 to 4 do
        begin
          if (damion[i, j].etat = 0) then
            begin
              result := false;
              break;
            end;
          continue;
        end;
      if result = false then break;
    end;

end;

procedure TForm1.InitDamion;
var
  k, cx, cy, i, j: integer;
begin

  for j := 0 to 4 do
    begin
      for i := 0 to 4 do
        begin
          Damion[i, j].etat := 0;
          Damion[i, j].zeta := 0;
          k := random(5);
          damion[i, j].col := k;
        end;
    end;
  cx := random(5);
  cy := random(5);
  for j := 0 to 4 do
    begin
      cursy := j;
      for i := 0 to 4 do
        begin
          cursx := i;
          if ((cursx <> cx) OR (cursy <> cy)) then modifieDamion(true);
        end;
    end;
  cursx := cx;
  cursy := cy;
end;

procedure TForm1.SelectDamion;
var
  tempmaterial: tglmaterial;
begin
  Selcube.Position.x := dcboard.Children[1 + (cursx) + (cursy * 5)].Position.x;
  Selcube.Position.y := dcboard.Children[1 + (cursx) + (cursy * 5)].Position.y;
  Selcube.Position.z := dcboard.Children[1 + (cursx) + (cursy * 5)].Position.z;
  tempmaterial := tglmaterial.create(self);
  case damion[cursx, cursy].col OF
    0: tempmaterial.FrontProperties.Diffuse.AsWinColor := clBlue;
    1: tempmaterial.FrontProperties.Diffuse.AsWinColor := clGreen;
    2: tempmaterial.FrontProperties.Diffuse.AsWinColor := clRed;
    3: tempmaterial.FrontProperties.Diffuse.AsWinColor := clyellow;
    4: tempmaterial.FrontProperties.Diffuse.AsWinColor := clFuchsia;
  end;
  tempmaterial.FrontProperties.Diffuse.Alpha := 0.4;
  tempmaterial.BackProperties.Diffuse := tempmaterial.FrontProperties.Diffuse;

  with shader1 do
    begin

      case (dcboard.Children[1 + (cursx + 1) * (cursy + 1)] AS TGLCube).tag OF
        0: BackgroundColor := convertwincolor(clBlue, 0.2);
        1: BackgroundColor := convertwincolor(clGreen, 0.2);
        2: BackgroundColor := convertwincolor(clRed, 0.2);
        3: BackgroundColor := convertwincolor(clyellow, 0.2);
        4: BackgroundColor := convertwincolor(clFuchsia, 0.2);
      end;

      Outlinesmooth := true;
      OutLineWidth := 2;
      lighting := True;
      LineColor := clrWhite;
    end;

  glmateriallibrary.Materials[7].Shader := nil;
  glmateriallibrary.Materials[7].Material.Assign(tempmaterial);
  glmateriallibrary.Materials[7].Shader := shader1;
end;

procedure TForm1.InitDamion3D;
var
  i, j, n: integer;
  AObject: TGLBaseSceneObject;
  x, y, z: single;

begin
  n := -1;
  y := 1.5;
  z := 3.0;
  speedrot := 6;
  for j := 0 to 4 do
    begin
      if j > 0 then z := z - 1.5;
      x := -3.0;
      for i := 0 to 4 do
        begin
          inc(n);
          if i > 0 then x := x + 1.5;
          AObject := TGLCube.Create(self);
          AObject.Direction.x := 0;
          AObject.Direction.y := 1;
          AObject.Direction.z := 0;
          AObject.up.x := 0;
          AObject.up.y := 0;
          AObject.up.z := -1;
          AObject.Position.x := x;
          AObject.Position.y := y;
          AObject.Position.z := z;
          AObject.Name := 'Cube' + inttostr(n);
          AObject.Tag := Damion[i, j].col;
          SetObjectMaterial(AObject, 0);
          DCBoard.AddChild(AOBject);
        end;
    end;
  GLSceneviewer1.Camera.TargetObject := DCBoard.Children[13];
  randomize;
  initDamion;
  shader1 := TOutLineShader.Create(Self);

  for j := 0 to 4 do
    begin
      for i := 0 to 4 do
        begin
          case Damion[i, j].col OF
            0: setobjectmaterial(dcboard.Children[1 + i + j * 5], 1);
            1: setobjectmaterial(dcboard.Children[1 + i + j * 5], 2);
            2: setobjectmaterial(dcboard.Children[1 + i + j * 5], 3);
            3: setobjectmaterial(dcboard.Children[1 + i + j * 5], 4);
            4: setobjectmaterial(dcboard.Children[1 + i + j * 5], 5);
          end;
        end;
    end;
  selectdamion;
  //  glscene1.SaveToFile('damion.gls');
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i, j, n: integer;
begin
  randomize;
  initDamion;

  n := -1;
  for j := 0 to 4 do
    begin
      for i := 0 to 4 do
        begin
          inc(n);
          case Damion[i, j].col OF
            0: setobjectmaterial(dcboard.Children[n + 1], 1);
            1: setobjectmaterial(dcboard.Children[n + 1], 2);
            2: setobjectmaterial(dcboard.Children[n + 1], 3);
            3: setobjectmaterial(dcboard.Children[n + 1], 4);
            4: setobjectmaterial(dcboard.Children[n + 1], 5);
          end;
        end;
    end;
  Form1.FocusControl(glsceneviewer1);
  selectdamion;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (ssRight IN Shift) then
    begin
      if GLScene1.CurrentGLCamera.TargetObject <> NIL then
        begin
          // Rotate around Object
          GLScene1.CurrentGLCamera.MoveAroundTarget((y - pickstarty), (x - pickstartx));
        end;
    end;
  PickStartX := x;
  PickStartY := y;
  glsceneviewer1.Invalidate;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  GLSceneViewer1.Camera.AdjustDistanceToTarget(Power(1.005, WheelDelta / 120));
end;

procedure TForm1.GLDirectOpenGL1Render(var rci: TGLRenderContextInfo);
begin
  //glDisable(GL_CULL_FACE);
  glDraw(rci);
  //glEnable(GL_CULL_FACE);
end;

procedure TForm1.GenerateCubeMap;
//var tmp : tglmaterial;
begin
  // Don't do anything if cube maps aren't supported

  if GL_TEXTURE_CUBE_MAP_ARB <> 0 then
    begin
      if not cubeMapWarnDone then
        ShowMessage('Your graphics board does not support cube maps...');
      cubeMapWarnDone := True;
      Exit;
    end;

  // Here we generate the new cube map, from CubeMapCamera (a child of the
  with GLPlane1 do
    begin
      GLDirectOpenGL1.Visible := false;
      DCInterface.Visible := false;
      SPTable.Visible := false;
      Visible := False;
      glmemoryviewer1.Render;
      GLMemoryViewer1.CopyToTexture(material.Texture, 0, 0, 512, 512, 0, 0);
      Material.Texture.Disabled := False;
      GLDirectOpenGL1.Visible := True;
      Visible := True;
      SPTable.Visible := True;
      DCInterface.Visible := True;
    end;
end;

procedure TForm1.SetBehavioursDamping(rc, rl, rq, sr, sp, st, tc, tl, tq, sx, sy, sz, mass: single);
begin
  GetOrCreateInertia(DCBoard.Behaviours).RotationDamping.SetDamping(rc, rl, rq);
  GetOrCreateInertia(DCBoard).Mass := mass;
  GetOrCreateInertia(DCBoard).Turnspeed := st;
  GetOrCreateInertia(DCBoard).RollSpeed := sr;
  GetOrCreateInertia(DCBoard).PitchSpeed := sp;
  GetOrCreateInertia(DCBoard).TranslationDamping.SetDamping(tc, tl, tq);
  GetOrCreateInertia(DCBoard).TranslationSpeed.SetVector(sx, sy, sz);
  GetOrCreateInertia(DCBoard).DampingEnabled := true;
end;

procedure TForm1.CadencerProgress(Sender: TObject; CONST deltaTime,
  newTime: Double);
var
  mx, my: integer;
begin

  if GameStatus = gsPlaying then
    begin
      button1.Enabled := false;
      if isKeydown(VK_DOWN) then
        if cursy < 4 then inc(cursy);
      if isKeydown(VK_UP) then
        if cursy > 0 then dec(cursy);
      if isKeydown(VK_LEFT) then
        if cursx > 0 then dec(cursx);
      if isKeydown(VK_RIGHT) then
        if cursx < 4 then inc(cursx);

      if iskeydown(vk_space) then modifiedamion(true);

      selectdamion;
    end
  else
    if GameStatus = gsLevelPreview then
    begin
      // if behaviour is created, comment the next line (see setbehaviour... in FormCreate)
      dcboard.TurnAngle := dcboard.TurnAngle + (10 * deltatime);
      //dcboard.TransformationChanged;
      //Mirror.TransformationChanged;
      GLSpacetext1.TurnAngle := GLSpacetext1.TurnAngle + (-15 * deltatime);

      if ISKeyDown(VK_Space) then Gamestatus := gsPlaying;
    end;
  if not (mirrorobj) then GenerateCubeMap;
  glsceneviewer1.Invalidate;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Caption := 'Damion : ' + Format('%.1f FPS', [GLSceneViewer1.FramesPerSecond]) + '  - ' + inttostr(cursx) + ' - ' +
    inttostr(cursy);
  GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Speed := 4;
  Angle := 0;
  cursx := 0;
  cursy := 0;
  GameStatus := gsLevelPreview;
  InitDamion3d;
  Mirrorobj := true;
  //SetBehavioursDamping(0,0,0,0,0,10,0,0,0,0,0,0,1);
  cadencer.Enabled := true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if mirrorobj then
    begin
      glplane1.visible := true;
      mirror.Visible := false;
      mirrorobj := false;
    end
  else
    begin
      glplane1.visible := False;
      mirror.Visible := True;
      mirrorobj := True;
    end;
   GLSceneViewer1.Invalidate;
end;

end.
