unit LiquidsFm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Imaging.Jpeg,
  GLS.VectorFileObjects,
  GLS.Scene,
  GLS.Selection,
  GLS.Objects,
  GLS.Cadencer,
  GLS.SceneViewer,
  GLS.Extrusion,
  GLS.Nodes,
  GLS.VectorGeometry,
  GLS.BaseClasses,
  GLS.Coordinates,

  GLS.GeomObjects,
  GLS.VectorTypes,
  GLS.Keyboard,
  GLS.Material,
  GLS.Texture,
  GLS.MultiPolygon,
  GLS.File3DS;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    camera_cube: TGLDummyCube;
    GLCadencer1: TGLCadencer;
    GLLightSource1: TGLLightSource;
    GLCube1: TGLCube;
    GLCube2: TGLCube;
    block: TGLCube;
    GLCylinder1: TGLCylinder;
    GLMaterialLibrary1: TGLMaterialLibrary;
    PaintBox1: TPaintBox;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
  private
  end;

  TFlowKind = (fkInactive, fkFall, fkSpill);

  { DEFINE SCHEMEMODE }

var
  Form1: TForm1;

  MAX_FLOW_LENGTH: single;
  gravity: TGLVector;

  flows: array of {$IFDEF SCHEMEMODE} TGLLines {$ELSE} TGLPolygonBase {$ENDIF};
  fldata: array of record kind: TFlowKind;
  time, l, r: single;
  vel: TGLVector;
  obstacle: Integer;
end;

var
  flows_count: Integer;
  flobstacles: TGLPickList;
  ff: TGLFreeForm;
  mx, my: Integer;

procedure AddNewFlow(pos: TGLVector; radius: single; k: TFlowKind;
  root: TGLBaseSceneObject);

implementation

{$R *.DFM}

procedure AddNewFlow(pos: TGLVector; radius: single; k: TFlowKind;
  root: TGLBaseSceneObject);
begin
  flows_count := flows_count + 1;
  SetLength(flows, flows_count);
  SetLength(fldata, flows_count);
  fldata[flows_count - 1].kind := k;
  fldata[flows_count - 1].r := radius;

{$IFNDEF SCHEMEMODE}
  if k = fkFall then
    flows[flows_count - 1] := TGLPipe.CreateAsChild(root)
  else
    flows[flows_count - 1] := TGLPolygon.CreateAsChild(root);
  with flows[flows_count - 1] do
  begin
    if k = fkFall then
    begin
      TGLPipe(flows[flows_count - 1]).radius := radius;
      TGLPipe(flows[flows_count - 1]).Slices := 8;
      TGLPipe(flows[flows_count - 1]).Parts :=
        [ppOutside, ppStartDisk, ppStopDisk];
      Material.LibMaterialName := 'fall';
    end
    else
    begin
      TGLPolygon(flows[flows_count - 1]).Parts := [ppTop, ppBottom];
      SplineMode := lsmCubicSpline;
      Material.LibMaterialName := 'spill';
    end;
    Material.MaterialLibrary := Form1.GLMaterialLibrary1;
    AddNode(AffineVectorMake(pos));
  end;
{$ELSE}
  flows[flows_count - 1] := TGLLines.CreateAsChild(root);
  flows[flows_count - 1].SplineMode := lsmLines;
  flows[flows_count - 1].AddNode(AffineVectorMake(pos));
{$ENDIF}
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  with GLMaterialLibrary1 do
  begin
    AddTextureMaterial('fall', 'fall.jpg');
    Materials[0].Material.BlendingMode := bmTransparency;
    Materials[0].Material.FrontProperties.Diffuse.Alpha := 0.3;
    Materials[0].Material.Texture.MappingMode := tmmSphere;
    Materials[0].Material.MaterialOptions := [moNoLighting];
    AddTextureMaterial('spill', 'spill.jpg');
    Materials[1].Material.BlendingMode := bmTransparency;
    Materials[1].Material.FrontProperties.Diffuse.Alpha := 0.4;
    Materials[1].Material.Texture.MappingMode := tmmCubeMapReflection;
    Materials[1].Material.Texture.ImageBrightness := 2;
  end;

  // Making the necessary objects as obstacles for the liquid
  ff := TGLFreeForm.CreateAsChild(GLScene1.Objects);
  ff.Position.SetPoint(0, 10, -15);
  ff.Direction.SetVector(0, 1, 0);
  ff.Up.SetVector(0, 0, 1);
  ff.LoadFromFile('tube.3ds');
  ff.BuildOctree;

  flobstacles := TGLPickList.Create(psDefault);
  flobstacles.AddHit(block, nil, 0, 0);
  flobstacles.AddHit(GLCube1, nil, 0, 0);
  flobstacles.AddHit(ff, nil, 0, 0);

  // Gravitation
  SetVector(gravity, 0, -150, 0);
  // Flow length
  MAX_FLOW_LENGTH := 6000;

  // Parameters: position, radius, type, parent
  AddNewFlow(VectorMake(0, 50, -20), 4, fkFall, GLScene1.Objects);
  fldata[0].vel := VectorMake(0, 0, 30);

  (*
    The correct accounting for gravity occurs only with a more or less
    constant deltaTime, therefore reset the time accumulated for OnCreate,
    otherwise there will be a rapture at the beginning of the flow
  *)
  GLCadencer1.Reset;
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject;
  const deltaTime, newTime: Double);
label
  1;
var
  i, j, k, c: Integer;
  p, pn, intp, intn: TGLVector;

  (*
    Some procedures that can be easily removed:
    AbsNodePos, PointInPolygon, UnitePolygons
  *)
{$INCLUDE routines.inc}
begin
  for i := 0 to flows_count - 1 do
    if fldata[i].kind <> fkInactive then
      fldata[i].time := fldata[i].time + deltaTime;

  for i := 0 to flows_count - 1 do
  begin
    // Inactive areas are ignored
    if fldata[i].kind = fkInactive then
      Continue;


    // ЕСЛИ УЧАСТОК ЖИДКОСТИ -- ПАДАЮЩАЯ СТРУЯ
    // ---------------------------------------

    if fldata[i].kind = fkFall then
    begin
      // Находим позицию нового узла из позиции последнего
      j := flows[i].Nodes.Count - 1;
      p := flows[i].Nodes[j].AsVector;
      pn := p;
      AddVector(pn, VectorScale(fldata[i].vel, deltaTime));
      AddVector(fldata[i].vel, VectorScale(gravity, deltaTime));

      // Если очередной узел будет лежать на одной
      // прямой с двумя предыдущими, то создавать его
      // нет смысла -- на вид струи он не повлияет --
      // можем просто передвинуть последний узел
      with flows[i] do
        if j > 2 then
          if TriangleArea(AffineVectorMake(pn), Nodes[j].AsAffineVector,
            Nodes[j - 1].AsAffineVector) < 0.01 then
            Nodes[j].AsVector := pn
          else
            Nodes.AddNode(pn)
        else
          Nodes.AddNode(pn);

      fldata[i].l := fldata[i].l + VectorLength(VectorSubtract(pn, p));

      // Слишком длинные потоки отключаем
      with flows[i].Nodes.First do
        if (Abs(pn.X - X) > MAX_FLOW_LENGTH) or
          (Abs(pn.Y - Y) > MAX_FLOW_LENGTH) or (Abs(pn.Z - Z) > MAX_FLOW_LENGTH)
        then
          fldata[i].kind := fkInactive;

      // Если падающая струя столкнулась с преградой,
      // то создаем растекающийся участок c 10 углами.
      // Для RayCast НЕОБХОДИМО, чтобы четвертый
      // элемент вектора raystart был 1. Если преграда
      // это TGL(File3DS)FreeForm, то используем GLOctree
      p.W := 1;
      for k := 0 to flobstacles.Count - 1 do
        if ((flobstacles[k] is TGLFreeForm) and TGLFreeForm(flobstacles[k])
          .OctreeRayCastIntersect(p, VectorNormalize(VectorSubtract(pn, p)),
          @intp, @intn)) or TGLFreeForm(flobstacles[k])
          .RayCastIntersect(p, VectorNormalize(VectorSubtract(pn, p)), @intp,
          @intn) then
          if VectorNorm(VectorSubtract(p, pn)) >=
            VectorNorm(VectorSubtract(p, intp)) then
          begin
            // Текущий поток останавливаем
            flows[i].Nodes.Last.AsVector := intp;
            fldata[i].kind := fkInactive;

            // Если в этом месте уже есть жидкость,
            // то новый поток создавать не надо
            for c := 0 to flows_count - 1 do
              if PointInPolygon2(flows[c], intp) then
                if Abs(flows[c].Nodes[0].Y - intp.Y) < 0.3 then
                  Break;
            if c < flows_count then
              Break;

            AddNewFlow(pn, fldata[i].r, fkSpill, GLScene1.Objects);
            flows[flows_count - 1].Nodes.Clear;
            // direction (j) stored in 4-th element
            for j := 0 to 9 do
              flows[flows_count - 1].AddNode
                (VectorMake(intp.X + Random / 10 + fldata[i].r *
                Cos(j * Pi * 2 / 10), intp.Y + 0.1, intp.Z + Random / 10 +
                fldata[i].r * Sin(j * Pi * 2 / 10), j * Pi * 2 / 10));
            // Запоминаем "облитый" объект
            fldata[flows_count - 1].obstacle := k;
          end;
    end;

    // ЕСЛИ УЧАСТОК ЖИДКОСТИ РАСТЕКАЮЩИЙСЯ
    // -----------------------------------
    if fldata[i].kind = fkSpill then
    begin
      // Наиболее сложный момент: если 2 участка
      // пересекаются, то объединяем их.
      for j := i + 1 to flows_count - 1 do
        if (fldata[j].kind = fkSpill) and
          (fldata[i].obstacle = fldata[j].obstacle) then
        begin
          for k := 0 to flows[j].Nodes.Count - 1 do
            if PointInPolygon2(flows[i], AbsNodePos(flows[j], k)) then
              Break;

          if k = flows[j].Nodes.Count then
            Continue;
          UnitePolygons(flows[i], flows[j]);
          flows[j].Visible := false;
          fldata[j].kind := fkInactive;
        end;

      // Удаляем нереалистично острые углы
      // (неактивные углы с W<0 не трогаем)
      j := 1;
      while j < flows[i].Nodes.Count - 1 do
        with flows[i] do
          if (Nodes[j].W >= 0) and (Nodes[j - 1].W >= 0) and
            (Nodes[j + 1].W >= 0) then
            if VectorAngleCosine(VectorSubtract(Nodes[j - 1].AsAffineVector,
              Nodes[j].AsAffineVector),
              VectorSubtract(Nodes[j + 1].AsAffineVector,
              Nodes[j].AsAffineVector)) > 0 then
              Nodes.Delete(j)
            else
              j := j + 1
          else
            j := j + 1;
      with flows[i] do
        if Nodes.Count > 2 then
          if (Nodes[0].W >= 0) and (Nodes[Nodes.Count - 1].W >= 0) and
            (Nodes[Nodes.Count - 2].W >= 0) then
            if VectorAngleCosine
              (VectorSubtract(Nodes[Nodes.Count - 2].AsAffineVector,
              Nodes[Nodes.Count - 1].AsAffineVector),
              VectorSubtract(Nodes[0].AsAffineVector,
              Nodes[Nodes.Count - 1].AsAffineVector)) > 0 then
              Nodes.Delete(Nodes.Count - 1);

      // Удаляем точки внутри участка
      while j < flows[i].Nodes.Count - 1 do
        if PointInPolygon2(flows[i], flows[i].Nodes[i].AsVector) then
          flows[i].Nodes.Delete(i)
        else
          j := j + 1;

      // Распространяем жидкость
      for j := 0 to flows[i].Nodes.Count - 1 do
      begin
        if flows[i].Nodes[j].W < 0 then
          Continue;

        pn := flows[i].Nodes[j].AsVector;
        p := VectorMake(deltaTime * Cos(pn.W), 0, deltaTime * Sin(pn.W));
        AddVector(pn, VectorScale(p, 3));
        flows[i].Nodes[j].AsVector := pn;

        // Если вдруг под углом участка не оказалось
        // твердой опоры, то создаем стекающую струю
        pn.W := 1;
        k := fldata[i].obstacle;
        if (((flobstacles[k] is TGLFreeForm) and TGLFreeForm(flobstacles[k])
          .OctreeRayCastIntersect(pn, gravity, @intp, @intn)) or
          TGLFreeForm(flobstacles[k]).RayCastIntersect(pn, gravity, @intp,
          @intn)) = false then
        begin
          // Этот угол больше не учитываем
          flows[i].Nodes[j].W := -1;

          // Сначала добавляем 2 узла дальше от
          // точки стекания (pn), чтобы сделать
          // закругление. Т.к. основной поток
          // разделился на 10 частей, то радиус
          // нового потока будет меньше в 2,15=
          // 10^(1/3) раз.
          SubtractVector(pn, VectorScale(p, 4));
          pn.Y := pn.Y - fldata[i].r / 2.15;
          AddNewFlow(pn, fldata[i].r / 2.15, fkFall, GLScene1.Objects);

          AddVector(pn, VectorScale(p, 20));
          pn.Y := pn.Y - 0.1;
          flows[flows_count - 1].AddNode(pn);

          AddVector(pn, VectorScale(p, 5));
          pn.Y := pn.Y - 0.7;
          flows[flows_count - 1].AddNode(pn);
        end;
      end;

      // Если все углы участка неактивны, то
      // деактивируем весь участок
      for j := 0 to flows[i].Nodes.Count - 1 do
        if flows[i].Nodes[j].W >= 0 then
          Break;
      if j = flows[i].Nodes.Count then
        fldata[i].kind := fkInactive;
    end;
  end;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
begin
  GLCadencer1.Enabled := false;
  GLSceneViewer1.Free;
  Timer1.Enabled := false;
  ff.Free;

  flobstacles.Free;
  for i := 0 to flows_count - 1 do
    flows[i].Free;
  SetLength(flows, 0);
  SetLength(fldata, 0);
end;

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mx := X;
  my := Y;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if Shift = [ssLeft] then
    GLCamera1.MoveAroundTarget(my - Y, mx - X);
  if Shift = [ssRight] then
    camera_cube.Lift((my - Y) / 4);
  mx := X;
  my := Y;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Form1.Caption := Format('Liquid Flow -- %.1f FPS',
    [GLSceneViewer1.FramesPerSecond]);
  GLSceneViewer1.ResetPerformanceMonitor;
end;

end.
