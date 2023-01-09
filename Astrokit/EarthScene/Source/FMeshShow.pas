{  CapeRaven mesh demo.
   Changing mesh vertex data, normals and striping redundent data.
   Custom cube class declared for vertex point identification.
   On moving these vertex modifiers, the apointed vertex follows.
}

unit FMeshShow;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Winapi.OpenGL,
  System.Contnrs,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Menus,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Buttons,

  GLS.Scene,
  GLS.VectorFileObjects,
  GLS.SceneViewer,
  GLS.File3DS,
  GLS.Objects,
  GLS.Texture,
  GLS.State,{ HoloGizmo, }
  GLS.Material,
  GLS.GeomObjects,
  GLS.Graph,
  GLS.Cadencer,
  GLS.VectorTypes,
  GLS.VectorGeometry,
  GLS.Coordinates,
  GLS.Color,
  GLS.PersistentClasses,
  GLS.VectorLists,
  GLS.MeshUtils,
  
  GLS.BaseClasses;

type
  TMovingAxis = (maAxisX, maAxisY, maAxisZ, maAxisXY, maAxisXZ, maAxisYZ);

  TModifierCube = class(TGLCube)
  public
    FVectorIndex : Integer;
    FMeshObjIndex : Integer;
    constructor Create(AOwner: TComponent); override;
  end;

  TMeshShowFrm = class(TForm)
    Scn: TGLSceneViewer;
    GLScene1: TGLScene;
    GLCamera1: TGLCamera;
    GLFreeForm1: TGLFreeForm;
    GLLightSource1: TGLLightSource;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    Edit1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    GLDummyCube1: TGLDummyCube;
    StatusBar: TStatusBar;
    ControlPanel: TPanel;
    ViewControlPanel: TMenuItem;
    dcModifiers: TGLDummyCube;
    Splitter1: TSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox2: TGroupBox;
    rbXY: TRadioButton;
    rbZY: TRadioButton;
    tbPos: TTrackBar;
    Label6: TLabel;
    GroupBox1: TGroupBox;
    Bevel1: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    chbShowAxis: TCheckBox;
    chbViewPoints: TCheckBox;
    cbPolygonMode: TComboBox;
    Label2: TLabel;
    TabSheet3: TTabSheet;
    TrackBar1: TTrackBar;
    GroupBox3: TGroupBox;
    btnVertex: TBitBtn;
    btnNormals: TBitBtn;
    btnTextcoords: TBitBtn;
    btnGroups: TBitBtn;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
procedure ShowHint(Sender: TObject);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure ScnMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ScnMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure TrackBar1Change(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Contents1Click(Sender: TObject);
    procedure OnHelp1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ScnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbPolygonModeChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chbViewPointsClick(Sender: TObject);
    procedure chbShowAxisClick(Sender: TObject);
    procedure tbPosChange(Sender: TObject);
    procedure ScnBeforeRender(Sender: TObject);
    procedure btnVertexClick(Sender: TObject);
    procedure btnNormalsClick(Sender: TObject);
    procedure btnTextcoordsClick(Sender: TObject);
    procedure btnGroupsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ViewControlPanelClick(Sender: TObject);
  private
     
    FOldX, FOldY      : Integer;
    FModifierList     : TObjectList;
    FSelectedModifier : TModifierCube;
    FMoveZ            : Boolean;
    FOldMouseWorldPos : TGLVector;
    function GetPolygonMode: TGLPolygonMode;
    procedure SetPolygonMode(const Value: TGLPolygonMode);
   { function MouseWorldPos(x, y: Integer): TGLVector;}

    {Create cubes used to modify vertex points}
    procedure SetVertexModifiers;
    {Populate statusbar with object information}
    procedure ShowModifierStatus(const aObj : TModifierCube);
    {Change the mesh vector property for the selected modifier.}
    procedure ChangeMeshVector(const aObj : TModifierCube; const aPos : TVector4f);
    {Identify mouse position in X, Y and Z axis}
    function MouseWorldPos(x, y : Integer) : TGLVector;
    {Strip redundent data, recalculate normals and faces}
    procedure StripAndRecalc;
    {Set Freeform's polygon mode: line, fill or points}
    property PolygonMode : TGLPolygonMode read GetPolygonMode write SetPolygonMode;

  public

    MovingAxis: TMovingAxis;
    Pick : TGLCustomSceneObject;
    SelectedObject: TGLCustomSceneObject;
    OldCursorPick: TGLCustomSceneObject;
   { GizmoX,
    GizmoY,
    GizmoZ: TGLGizmoArrow;
    GizmoCornerXY,
    GizmoCornerXZ,
    GizmoCornerYZ: TGLGizmoCorner; }
    mx, my : Integer;
    lastMouseWorldPos: TGLVector;
    procedure UpdateGizmo;
  end;

var
  MeshShowFrm: TMeshShowFrm;

//===============================================
implementation
//===============================================

uses
  FMeshData, uGlobals;

{$R *.dfm}

const
  {Default combobox index for startup}
  CLinePolyMode  = 1;
  {Scale dimention}
  CModifierDim   = 0.04;

var
  {Modifier colors}
  CModColorNormal : TGLColorVector;
  CModColorSelect : TGLColorVector;

constructor TModifierCube.Create(AOwner: TComponent);
begin
  inherited;
  {Set the modifiers initial size and color}
  CubeWidth  := CModifierDim;
  CubeHeight := CModifierDim;
  CubeDepth  := CModifierDim;
  Material.FrontProperties.Diffuse.Color := CModColorNormal;
end;

procedure GenerateIcosahedron(Vertices : TGLAffineVectorList; Indices : TGLIntegerList);
var
  phi, a, b : Single;
begin
  if not (Assigned(Vertices) or Assigned(Indices)) then exit;

  phi:=(1+sqrt(5))/2;
  a:=0.5;
  b:=1/(2*phi);

  Vertices.Clear;
  with Vertices do begin
    Add( 0,-b,-a);
    Add( 0,-b, a);
    Add( 0, b,-a);
    Add( 0, b, a);
    Add(-a, 0,-b);
    Add(-a, 0, b);
    Add( a, 0,-b);
    Add( a, 0, b);
    Add(-b,-a, 0);
    Add(-b, a, 0);
    Add( b,-a, 0);
    Add( b, a, 0);
  end;

  Indices.Clear;
  Indices.AddIntegers(
    [ 2,11, 9,
      3, 9,11,
      3, 1, 5,
      3, 7, 1,
      2, 0, 6,
      2, 4, 0,
      1,10, 8,
      0, 8,10,
      9, 5, 4,
      8, 4, 5,
     11, 6, 7,
     10, 7, 6,
      3, 5, 9,
      3,11, 7,
      2, 9, 4,
      2, 6,11,
      0, 4, 8,
      0,10, 6,
      1, 8, 5,
      1, 7,10 ] );
end;

procedure BuildGeosphere(GLBaseMesh : TGLBaseMesh; Iterations : Integer);
var
  i : Integer;
  mesh : TGLMeshObject;
  facegroup : TFGVertexIndexList;
begin
  mesh:=TGLMeshObject.CreateOwned(GLBaseMesh.MeshObjects);
  mesh.Mode:=momFaceGroups;
  facegroup:=TFGVertexIndexList.CreateOwned(mesh.FaceGroups);
  GenerateIcosahedron(mesh.Vertices, facegroup.VertexIndices);
  mesh.BuildNormals(facegroup.VertexIndices, momTriangles);
  for i:=0 to Iterations-1 do
    SubdivideTriangles(1, mesh.Vertices, facegroup.VertexIndices, mesh.Normals);
end;

{
function THoloForm.MouseWorldPos(x, y: Integer): TGLVector;
var
  v : TGLVector;
begin
  y := GLSceneViewer.Height - y;

  if Assigned(FSelectedModifier) then
  begin
    SetVector(v, x, y, 0);
    if FMoveZ then
      GLSceneViewer.Buffer.ScreenVectorIntersectWithPlaneXZ(v, FSelectedModifier.Position.Y, Result)
    else
      GLSceneViewer.Buffer.ScreenVectorIntersectWithPlaneXY(v, FSelectedModifier.Position.Z, Result);
  end
  else
    SetVector(Result, NullVector);
end;}

function TMeshShowFrm.MouseWorldPos(x, y : Integer) : TGLVector;
var
   v : TGLVector;
begin
   y:=Scn.Height-y;
  if Assigned(FSelectedModifier) then
  begin
    SetVector(v, x, y, 0);
    if FMoveZ then
      Scn.Buffer.ScreenVectorIntersectWithPlaneXZ(v, FSelectedModifier.Position.Y, Result)
    else
      Scn.Buffer.ScreenVectorIntersectWithPlaneXY(v, FSelectedModifier.Position.Z, Result);
  end
  else
   if Assigned(SelectedObject) then
   begin
     SetVector(v, x, y, 0);
     case MovingAxis of
       maAxisX : begin
                   Scn.Buffer.ScreenVectorIntersectWithPlaneXZ(v, SelectedObject.Position.Y, Result);
                 end;
       maAxisY : begin
                   Scn.Buffer.ScreenVectorIntersectWithPlaneYZ(v, SelectedObject.Position.X, Result);
                 end;
       maAxisZ : begin
                   Scn.Buffer.ScreenVectorIntersectWithPlaneYZ(v, SelectedObject.Position.X, Result);
                 end;
       maAxisXY: begin
                   Scn.Buffer.ScreenVectorIntersectWithPlaneXY(v, SelectedObject.Position.Z, Result);
                 end;
       maAxisXZ: begin
                   Scn.Buffer.ScreenVectorIntersectWithPlaneXZ(v, SelectedObject.Position.Y, Result);
                 end;
       maAxisYZ: begin
                   Scn.Buffer.ScreenVectorIntersectWithPlaneYZ(v, SelectedObject.Position.X, Result);
                 end;
     end;
   end
   else SetVector(Result, NullVector);
end;


procedure TMeshShowFrm.FormShow(Sender: TObject);
begin
  Application.OnHint := ShowHint;
end;
procedure TMeshShowFrm.FormCreate(Sender: TObject);
begin
  top:=HoloFormY;
  left:=HoloFormX;
{  GizmoX := TGLGizmoArrow.Create(GLScene1);
  GizmoX.GizmoType := gtAxisX;
  GizmoX.Name := 'GizmoX';
  GizmoX.Height := 0.5;
  GLDummyCube1.AddChild(GizmoX);

  GizmoY := TGLGizmoArrow.Create(GLScene1);
  GizmoY.GizmoType := gtAxisY;
  GizmoY.Name := 'GizmoY';
  GizmoY.Height := 0.5;
  GLDummyCube1.AddChild(GizmoY);

  GizmoZ := TGLGizmoArrow.Create(GLScene1);
  GizmoZ.GizmoType := gtAxisZ;
  GizmoZ.Name := 'GizmoZ';
  GizmoZ.Height := 0.5;
  GLDummyCube1.AddChild(GizmoZ);

  GizmoCornerXY := TGLGizmoCorner.Create(GLScene1);
  GizmoCornerXY.GizmoType := gtPlaneXY;
  GizmoCornerXY.Name := 'GizmoXY';
  GizmoCornerXY.Height := 0.2;
  GizmoCornerXY.Distance := 0.5;
  GLDummyCube1.AddChild(GizmoCornerXY);

  GizmoCornerXZ := TGLGizmoCorner.Create(GLScene1);
  GizmoCornerXZ.GizmoType := gtPlaneXZ;
  GizmoCornerXZ.Name := 'GizmoXZ';
  GizmoCornerXZ.Height := 0.2;
  GizmoCornerXZ.Distance := 0.5;
  GLDummyCube1.AddChild(GizmoCornerXZ);

  GizmoCornerYZ := TGLGizmoCorner.Create(GLScene1);
  GizmoCornerYZ.GizmoType := gtPlaneYZ;
  GizmoCornerYZ.Name := 'GizmoYZ';
  GizmoCornerYZ.Height := 0.2;
  GizmoCornerYZ.Distance := 0.5;
  GLDummyCube1.AddChild(GizmoCornerYZ);}

  {Do initial setup}
  FModifierList := TObjectList.Create;
  CModColorNormal := clrCoral;
  CModColorSelect := clrSkyBlue;


  BuildGeosphere(GLFreeForm1, 3);
    StripAndRecalc;
    SetVertexModifiers;

  GLFreeForm1.StructureChanged;
    cbPolygonMode.ItemIndex := CLinePolyMode;
end;

function TMeshShowFrm.GetPolygonMode: TGLPolygonMode;
begin
  Result := GLFreeForm1.Material.PolygonMode;
end;

procedure TMeshShowFrm.SetPolygonMode(const Value: TGLPolygonMode);
begin
  GLFreeForm1.Material.PolygonMode := Value;
end;

procedure TMeshShowFrm.cbPolygonModeChange(Sender: TObject);
begin
  {GLFreeForm1.Material.FrontProperties.}
  PolygonMode := TGLPolygonMode(cbPolygonMode.ItemIndex);
{  if CheckBox1.Checked then
    GLFreeForm1.Material.PolygonMode:=pmFill
  else
    GLFreeForm1.Material.PolygonMode:=pmLines;}
end;


procedure TMeshShowFrm.ShowHint(Sender: TObject);
begin
{  HintPanel.Caption := GetLongHint(Application.Hint);}
  StatusBar.Panels[0].Text := Application.Hint;
end;

procedure TMeshShowFrm.Exit1Click(Sender: TObject);
begin
 Close;
end;

procedure TMeshShowFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  HoloFormY:= MeshShowFrm.top;
  HoloFormX:= MeshShowFrm.left;
end;
procedure TMeshShowFrm.FormDestroy(Sender: TObject);
begin
  FModifierList.Clear;
  FreeAndNil(FModifierList);
end;


procedure TMeshShowFrm.ScnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lObj : TGLBaseSceneObject;
begin
  mx:=x;   my:=y;
  FOldX := X; FOldY := Y;
  {If selecting a different modifier, change the last one's color back to default}
  if Assigned(FSelectedModifier) then
     FSelectedModifier.Material.FrontProperties.Diffuse.Color := CModColorNormal;

  {Get selected objects}
  if (ssCtrl in Shift) then
  begin
  {Check if selected object is a modifier.
   If so, change modifiers color as to indicated selected modifier.}
  lObj := scn.Buffer.GetPickedObject(X, Y);
  if (lObj is TModifierCube) then
  begin
    FSelectedModifier := TModifierCube(lObj);
    FSelectedModifier.Material.FrontProperties.Diffuse.Color := CModColorSelect;
    FSelectedModifier.NotifyChange(FSelectedModifier);
    ShowModifierStatus(TModifierCube(lObj));

    FMoveZ := rbZY.Checked;
    FOldMouseWorldPos := MouseWorldPos(X, Y);
  end;

  end;
  if Shift=[ssLeft] then
  begin
  	pick:=(Scn.Buffer.GetPickedObject(x, y) as TGLCustomSceneObject);
    if Assigned(Pick) then
    begin
      if Pick.Name = 'GizmoX' then
      begin
        MovingAxis := maAxisX;
      end
      else if Pick.Name = 'GizmoY' then
      begin
        MovingAxis := maAxisY;
      end
      else if Pick.Name = 'GizmoZ' then
      begin
        MovingAxis := maAxisZ;
      end
      else if Pick.Name = 'GizmoXY' then
      begin
        MovingAxis := maAxisXY;
      end
      else if Pick.Name = 'GizmoXZ' then
      begin
        MovingAxis := maAxisXZ;
      end
      else if Pick.Name = 'GizmoYZ' then
      begin
        MovingAxis := maAxisYZ;
      end
      else if Pick.Tag = 0 then
      begin
        SelectedObject := Pick;
        GLDummyCube1.Visible := True;
        UpdateGizmo;
      end;

      lastMouseWorldPos := MouseWorldPos(x, y);
    end
    else
    begin
      GLDummyCube1.Visible := False;
      SelectedObject := nil;
      UpdateGizmo;
    end;
  end;
end;

procedure TMeshShowFrm.ScnMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
   {vec1,
   vec2,
   newPos : TGLVector;
   CursorPick: TGLCustomSceneObject;}

  lCurrentPos : TGLVector;
  lOldV       : TVector3f;
  lDiff       : TVector4f;
begin
  {If ctrl is not in use, move around freeform}
  if (ssLeft in Shift) and (not (ssCtrl in Shift)) then
  begin
    GLCamera1.MoveAroundTarget(FOldY - Y, FOldX - X);
    FOldX := X; FOldY := Y;
    Exit;
  end;

  {Move modifier and change relevant vertex data}
  if (ssLeft in Shift) then
  begin
    FMoveZ := rbZY.Checked;

    lCurrentPos := MouseWorldPos(X, Y);
    if Assigned(FSelectedModifier) and (VectorNorm(FOldMouseWorldPos) <> 0) then
    begin
      MakeVector(lOldV, FSelectedModifier.Position.X, FSelectedModifier.Position.Y, FSelectedModifier.Position.Z);
      lDiff := VectorSubtract(lCurrentPos, FOldMouseWorldPos);
      FSelectedModifier.Position.Translate(lDiff);
      ChangeMeshVector(FSelectedModifier, lDiff);
    end;
    FOldMouseWorldPos := lCurrentPos;
  end;
{  if ssLeft in Shift then
    GLCamera1.MoveAroundTarget(my-y, mx-x);
  mx:=x;    my:=y;}
  if Shift=[ssRight] then
  begin
    GLCamera1.MoveAroundTarget(my-y, mx-x);
    mx:=x; my:=y;
    {UpdateGizmo;}
  end;

  {if (Shift=[ssLeft]) and (SelectedObject <> nil) then
  begin
    newPos:=MouseWorldPos(x, y);
    if (VectorNorm(lastMouseWorldPos)<>0) then
    begin
       vec1 := newPos;
       vec2 := lastMouseWorldPos;

       case MovingAxis of
         maAxisX : begin
                     vec1[1] := 0;
                     vec1[2] := 0;
                     vec1[3] := 0;
                     vec2[1] := 0;
                     vec2[2] := 0;
                     vec2[3] := 0;
                   end;
         maAxisY : begin
                     vec1[0] := 0;
                     vec1[2] := 0;
                     vec1[3] := 0;
                     vec2[0] := 0;
                     vec2[2] := 0;
                     vec2[3] := 0;
                   end;
         maAxisZ : begin
                     vec1[0] := 0;
                     vec1[1] := 0;
                     vec1[3] := 0;
                     vec2[0] := 0;
                     vec2[1] := 0;
                     vec2[3] := 0;
                   end;
       end;

       SelectedObject.Position.Translate(VectorSubtract(vec1, vec2));
    end;
    lastMouseWorldPos:=newPos;
    UpdateGizmo;
  end
  else if Shift = [] then
  begin
  	CursorPick := (Scn.Buffer.GetPickedObject(x, y) as TGLCustomSceneObject);
    if OldCursorPick <> CursorPick then
    begin
      if (CursorPick <> nil) and (Pos('Gizmo', CursorPick.Name) = 1) then
      begin
        Scn.Cursor := crSizeAll;

        if CursorPick is TGLGizmoArrow then
          (CursorPick as TGLGizmoArrow).Selected := True;

        if CursorPick is TGLGizmoCorner then
        begin
          (CursorPick as TGLGizmoCorner).Selected := True;
          if CursorPick.Name = 'GizmoXY' then
          begin
            GizmoX.Selected := True;
            GizmoY.Selected := True;
          end
          else if CursorPick.Name = 'GizmoXZ' then
          begin
            GizmoX.Selected := True;
            GizmoZ.Selected := True;
          end
          else if CursorPick.Name = 'GizmoYZ' then
          begin
            GizmoY.Selected := True;
            GizmoZ.Selected := True;
          end;
        end;
      end
      else
      begin
        Scn.Cursor := crDefault;
      end;

      if (OldCursorPick is TGLGizmoArrow) then
        (OldCursorPick as TGLGizmoArrow).Selected := False;

      if (OldCursorPick is TGLGizmoCorner) then
      begin
        (OldCursorPick as TGLGizmoCorner).Selected := False;
        if OldCursorPick.Name = 'GizmoXY' then
        begin
          GizmoX.Selected := False;
          GizmoY.Selected := False;
        end
        else if OldCursorPick.Name = 'GizmoXZ' then
        begin
          GizmoX.Selected := False;
          GizmoZ.Selected := False;
        end
        else if OldCursorPick.Name = 'GizmoYZ' then
        begin
          GizmoY.Selected := False;
          GizmoZ.Selected := False;
        end;
      end;
      OldCursorPick := CursorPick;
    end;
  end;}

end;

procedure TMeshShowFrm.TrackBar1Change(Sender: TObject);
begin
  GLFreeForm1.MeshObjects.Clear;
  BuildGeosphere(GLFreeForm1, TrackBar1.Position);
  GLFreeForm1.StructureChanged;
end;




procedure TMeshShowFrm.Open1Click(Sender: TObject);
var
  F: TextFile;
  S: string;
begin
  if OpenDialog1.Execute then          { Display Open dialog box }
  begin
    AssignFile(F, OpenDialog1.FileName);   { File selected in dialog box }
    Reset(F);
    Readln(F, S);                          { Read the first line out of the file }
    //Edit1.Text := S;                       { Put string in a TEdit control }
    CloseFile(F);
  end;
end;

procedure TMeshShowFrm.Save1Click(Sender: TObject);
var F: TextFile;
  {I: integer;
  FirstLine: string;}
begin
  if SaveDialog1.Execute then
      begin
  AssignFile(F, SaveDialog1.filename);
  Rewrite(F);
 { Writeln(F, 'Just created file with this text in it...'); }
  CloseFile(F);
      end;
end;

procedure TMeshShowFrm.ViewControlPanelClick(Sender: TObject);
begin
  ViewControlPanel.Checked:=(not ViewControlPanel.Checked);
  If ViewControlPanel.Checked then
  begin
    Scn.Align:=alNone;
    ControlPanel.Visible:=True;
    ControlPanel.Align:=alLeft;
    Scn.Align:=alClient;
  end else
  begin
    Scn.Align:=alNone;
    ControlPanel.Visible:=False;
    ControlPanel.Align:=alNone;
    Scn.Align:=alClient;
  end;
end;

procedure TMeshShowFrm.Contents1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTENTS, 0);
end;

procedure TMeshShowFrm.OnHelp1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_HELPONHELP, 0);
end;

procedure TMeshShowFrm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  GLCamera1.AdjustDistanceToTarget(PowerSingle(1.1, WheelDelta / 120));
  UpdateGizmo;
end;

procedure TMeshShowFrm.UpdateGizmo;
var
   absDir: TGLVector;
begin
  if SelectedObject = nil then
  begin
    StatusBar.Panels[1].Text := 'X:';
    StatusBar.Panels[2].Text := 'Y:';
    StatusBar.Panels[3].Text := 'Z:';
    Exit;
  end;
  absDir := VectorSubtract(SelectedObject.absolutePosition, GLCamera1.AbsolutePosition);
  NormalizeVector(absDir);

  ScaleVector(absDir, 4);

  absDir := VectorAdd(GLCamera1.AbsolutePosition, absDir);

  GLDummyCube1.Position.AsVector := absDir;

  StatusBar.Panels[0].Text := SelectedObject.Name;
  StatusBar.Panels[1].Text := Format('X: %.2f', [SelectedObject.Position.X]);
  StatusBar.Panels[2].Text := Format('Y: %.2f', [SelectedObject.Position.Y]);
  StatusBar.Panels[3].Text := Format('Z: %.2f', [SelectedObject.Position.Z]);
end;

procedure TMeshShowFrm.ScnMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pick := nil;
//  SelectedObject := nil;
  if Assigned(FSelectedModifier) then
  begin
    FSelectedModifier.Material.FrontProperties.Diffuse.Color := CModColorNormal;
    FSelectedModifier := nil;
    {Recalculate structure and redraw freeform}
    StripAndRecalc;
    {Reset vertex modifiers and their data.}
    SetVertexModifiers;
  end;
end;

procedure TMeshShowFrm.SetVertexModifiers;
  procedure ScaleVector(var V1, V2 : TVector3F);
  begin
    V1.X := V1.X * V2.X;
    V1.Y := V1.Y * V2.Y;
    V1.Z := V1.Z * V2.Z;
  end;
var
  i, j : Integer;
  lVector, lScale : TVector3F;
  lModifier : TModifierCube;
begin
  FModifierList.Clear;
  GLScene1.BeginUpdate;
  try
    with GLFreeForm1.MeshObjects do
    begin
      for i := 0 to Count - 1 do
        for j := 0 to Items[i].Vertices.Count - 1 do
        begin
          lVector := Items[i].Vertices.Items[j];
          lModifier := TModifierCube.Create(nil);
          lModifier.FVectorIndex := j;
          lModifier.FMeshObjIndex := i;

          FModifierList.Add(lModifier);
          GLScene1.Objects.AddChild(lModifier);

          lScale := GLFreeForm1.Scale.AsAffineVector;
          ScaleVector(lVector, lScale);
          lModifier.Position.Translate(lVector);
        end;
    end;
  finally
    GLScene1.EndUpdate;
  end;
end;

procedure TMeshShowFrm.ShowModifierStatus(const aObj: TModifierCube);
begin
  if aObj = nil then
    StatusBar.Panels[0].Text := ''
  else
    StatusBar.Panels[0].Text := Format('Modifier vector index [%d]', [aObj.FVectorIndex]);
end;

procedure TMeshShowFrm.ChangeMeshVector(const aObj : TModifierCube; const aPos : TVector4f);
var
  lVIndex,
  lMIndex  : Integer;
  v        : TVector3f;
begin
  if aObj = nil then
    Exit;

  lVIndex := aObj.FVectorIndex;
  lMIndex := aObj.FMeshObjIndex;

  {Get new vertex position, keep freeform scale in mind and redraw freeform.}
  MakeVector(v, aPos.X/CModifierDim, aPos.Y/CModifierDim, aPos.Z/CModifierDim);
  GLFreeForm1.MeshObjects.Items[lMIndex].Vertices.TranslateItem(lVIndex, v);
  GLFreeForm1.StructureChanged;
end;




procedure TMeshShowFrm.StripAndRecalc;
var
  lTrigList,
  lNormals    : TGLAffineVectorList;
  lIndices    : TGLIntegerList;
  lObj        : TGLMeshObject;
  lStrips     : TGLPersistentObjectList;

  lFaceGroup  : TFGVertexIndexList;
  i           : Integer;
begin
  // Extract raw triangle data to work with.
  lTrigList := GLFreeForm1.MeshObjects.ExtractTriangles;

  // Builds a vector-count optimized indices list.
  lIndices := BuildVectorCountOptimizedIndices(lTrigList);
  // Alter reference/indice pair and removes unused reference values.
  RemapAndCleanupReferences(lTrigList, lIndices);
   // Calculate normals.
  lNormals := BuildNormals(lTrigList, lIndices);

  // Strip where posible.
  lStrips := StripifyMesh(lIndices, lTrigList.Count, True);

  // Clear current mesh object data.
  GLFreeForm1.MeshObjects.Clear;

  // Setup new mesh object.
  lObj := TGLMeshObject.CreateOwned(GLFreeForm1.MeshObjects);
  lObj.Vertices := lTrigList;
  lObj.Mode := momFaceGroups;
  lObj.Normals := lNormals;

  for i:=0 to lStrips.Count-1 do
  begin
    lFaceGroup := TFGVertexIndexList.CreateOwned(lObj.FaceGroups);
    lFaceGroup.VertexIndices := (lStrips[i] as TGLIntegerList);
    if i > 0 then
      lFaceGroup.Mode := fgmmTriangleStrip
    else
      lFaceGroup.Mode := fgmmTriangles;
    lFaceGroup.MaterialName:=IntToStr(i and 15);
  end;
  // Redraw freeform
  GLFreeForm1.StructureChanged;

  lTrigList.Free;
  lNormals.Free;
  lIndices.Free;
end;



procedure TMeshShowFrm.chbViewPointsClick(Sender: TObject);
var
  i : Integer;
begin
  GLScene1.BeginUpdate;
  try
    for i := 0 to FModifierList.Count - 1 do
      TModifierCube(FModifierList.Items[i]).Visible := chbViewPoints.Checked;
  finally
    GLScene1.EndUpdate;
  end;
end;

procedure TMeshShowFrm.chbShowAxisClick(Sender: TObject);
begin
  dcModifiers.ShowAxes := TCheckBox(Sender).Checked;
end;

procedure TMeshShowFrm.tbPosChange(Sender: TObject);
begin
  GLCamera1.Position.Z := tbPos.Position;
end;

procedure TMeshShowFrm.ScnBeforeRender(Sender: TObject);
begin
  glEnable(GL_NORMALIZE);
end;

procedure TMeshShowFrm.btnVertexClick(Sender: TObject);
var
  i, j    : Integer;
  lList   : TStringList;
  lVector : TVector3f;
begin
  lList := TStringList.Create;
  try
    with GLFreeForm1.MeshObjects do
      for i := 0 to Count - 1 do
      begin
        lList.Add('For mesh object ' + IntToStr(i));
        for j := 0 to Items[i].Vertices.Count - 1 do
        begin
          lVector := Items[i].Vertices.Items[j];
          lList.Add(Format('%f %f %f', [lVector.X, lVector.Y, lVector.Z]));
        end;
      end;
    ShowMeshData(lList);
  finally
    FreeAndNil(lList);
  end;
end;

procedure TMeshShowFrm.btnNormalsClick(Sender: TObject);
var
  i, j    : Integer;
  lList   : TStringList;
  lVector : TVector3f;
begin
  lList := TStringList.Create;
  try
    with GLFreeForm1.MeshObjects do
      for i := 0 to Count - 1 do
      begin
        lList.Add('For mesh object ' + IntToStr(i));
        for j := 0 to Items[i].Normals.Count - 1 do
        begin
          lVector := Items[i].Normals.Items[j];
          lList.Add(Format('%f %f %f', [lVector.X, lVector.Y, lVector.Z]));
        end;
      end;
    ShowMeshData(lList);
  finally
    FreeAndNil(lList);
  end;
end;

procedure TMeshShowFrm.btnTextcoordsClick(Sender: TObject);
var
  i, j    : Integer;
  lList   : TStringList;
  lVector : TVector3f;
begin
  lList := TStringList.Create;
  try
    with GLFreeForm1.MeshObjects do
      for i := 0 to Count - 1 do
      begin
        lList.Add('For mesh object ' + IntToStr(i));
        for j := 0 to Items[i].TexCoords.Count - 1 do
        begin
          lVector := Items[i].TexCoords.Items[j];
          lList.Add(Format('%f %f %f', [lVector.X, lVector.Y, lVector.Z]));
        end;
      end;
    ShowMeshData(lList);
  finally
    FreeAndNil(lList);
  end;
end;

procedure TMeshShowFrm.btnGroupsClick(Sender: TObject);
var
  i    : Integer;
  lList   : TStringList;
begin
  lList := TStringList.Create;
  try
    with GLFreeForm1.MeshObjects do
      for i := 0 to Count - 1 do
      begin
        lList.Add('For mesh object ' + IntToStr(i));
        lList.Add(IntToStr(Items[i].TriangleCount));
      end;
    ShowMeshData(lList);
  finally
    FreeAndNil(lList);
  end;
end;



end.
