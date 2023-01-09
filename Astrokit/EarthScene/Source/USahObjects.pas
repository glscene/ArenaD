unit USahObjects;

(*
  Alexandre Hirzel Collection of OpenGL objects
*)

interface

uses
  Winapi.OpenGL,
  System.Math,

  GLS.VectorTypes,
  GLS.VectorGeometry,
  GLS.VectorFileObjects,
  GLS.Scene,
  GLS.Coordinates;

type
  TGLVec = array [0 .. 3] of GLFloat;
  TGLSpeedMatrix = array [0 .. 15] of GLFloat;

  // Transformation matrix, by columns
  TMovingCamera = class(tObject)
  private
  protected
  public
    ux, uy, uz: single; // U: Horizontal vector (Left to right)   (World system)
    vx, vy, vz: single; // V: Vertical vector (bottom-up screen)  (World system)
    nx, ny, nz: single; // N: Normal vector (into the screen)     (World system)
    x, y, z: single; // Coordinates (World system)
    ru, rv, rn: single; // Angular speed; [deg./sec] (Camera system)
    Speed: single; // Speed (along S) [1/sec]
    sx, sy, sz: single; // Speed vector (multiplied by Speed) (World system)
    SpeedMatrix: TGLSpeedMatrix;
    SceneObject: TGLBaseSceneObject;
    procedure Accelerate(const au, av, an: single); // Change the speed vector
    procedure Apply; // Rotate and translate the glWorld accordingly
    procedure ApplyFrontView; // Look in the direction of movement
    constructor Create;
    destructor Destroy; override;
    procedure GoThatWay; // Set the velocity vector toward the direction of view
    procedure Move(const du, dv, dn: single);
    // Translation in the camera system
    procedure Pitch(const Angle: single); // U rotation
    procedure ResetAttitude;
    procedure Roll(const Angle: single); // N rotation
    procedure ComputeSpeed;
    procedure Translate(const dx, dy, dz: single);
    // Translation in the world system
    procedure UpdateAll(const Time: double);
    // Compute new coordinates and angles
    procedure UpdateAttitude(const Time: double); // Compute new angles
    procedure UpdatePosition(const Time: double); // Compute new coordinates
    procedure Yaw(const Angle: single); // V rotation
  end; // record

  TRealMovingCamera = class(TMovingCamera)
    { Implement vibration and gyroscopic effects }
  protected
    Vibx, Viby, Vibz: single;
  public
    InU, InV, InN: single; // Mass inertia along the three axes
    procedure Apply;
    procedure GyroPitch(const Moment: single); // U rotation
    procedure GyroRoll(const Moment: single); // N rotation
    procedure Vibrate(const Vibration: single);
    procedure GyroYaw(const Moment: single); // V rotation
  end; // class

(*
  Cube for sphere radius 1 (size 2 with vertices between -1 and 1) centred on the origine.
  If a texture is applied it will be tiled Tile times along each direction
*)
procedure BuildCube(const Tile: double = 1);
// Stars randomly placed on a sphere of radius 1
procedure BuildStarField(const nbStars: integer);
procedure BuildCross(const Radius: single);
// Polyhedron and Subdivide algorithms from OpenGL Red Book
procedure BuildSphere(var Mesh: TGLMeshObject; const Depth: integer = 0);
(*
  Fractal process to build a random potatoid. Depth correspond to the depth
  of the recursive process. Use ActualDepth to generate a same potatoid at
  various level of details
*)
function BuildPotatoid(var Mesh: TGLMeshObject; const Deviance: single = 0.2;
  const Depth: integer = 1; ActualDepth: integer = -1): boolean;

// ==================================================================
implementation
// ==================================================================

// BuildCube
//
procedure BuildCube(const Tile: double = 1);
begin
  // Front Face
  glBegin(GL_QUADS);
  glNormal3f(0.0, 0.0, 1.0);
  glTexCoord2f(0.0, 0.0);
  glVertex3f(-1, -1, 1);
  glTexCoord2f(Tile, 0.0);
  glVertex3f(1, -1, 1);
  glTexCoord2f(Tile, Tile);
  glVertex3f(1, 1, 1);
  glTexCoord2f(0.0, Tile);
  glVertex3f(-1, 1, 1);
  glEnd();
  // Back Face
  glBegin(GL_QUADS);
  glNormal3f(0.0, 0.0, -1.0);
  glTexCoord2f(Tile, 0.0);
  glVertex3f(-1, -1, -1);
  glTexCoord2f(Tile, Tile);
  glVertex3f(-1, 1, -1);
  glTexCoord2f(0.0, Tile);
  glVertex3f(1, 1, -1);
  glTexCoord2f(0.0, 0.0);
  glVertex3f(1, -1, -1);
  glEnd();
  // Top Face
  glBegin(GL_QUADS);
  glNormal3f(0.0, 1.0, 0.0);
  glTexCoord2f(0.0, Tile);
  glVertex3f(-1, 1, -1);
  glTexCoord2f(0.0, 0.0);
  glVertex3f(-1, 1, 1);
  glTexCoord2f(Tile, 0.0);
  glVertex3f(1, 1, 1);
  glTexCoord2f(Tile, Tile);
  glVertex3f(1, 1, -1);
  glEnd();
  // Bottom Face
  glBegin(GL_QUADS);
  glNormal3f(0.0, -1.0, 0.0);
  glTexCoord2f(Tile, Tile);
  glVertex3f(-1, -1, -1);
  glTexCoord2f(0.0, Tile);
  glVertex3f(1, -1, -1);
  glTexCoord2f(0.0, 0.0);
  glVertex3f(1, -1, 1);
  glTexCoord2f(Tile, 0.0);
  glVertex3f(-1, -1, 1);
  glEnd();
  // Right face
  glBegin(GL_QUADS);
  glNormal3f(1.0, 0.0, 0.0);
  glTexCoord2f(Tile, 0.0);
  glVertex3f(1, -1, -1);
  glTexCoord2f(Tile, Tile);
  glVertex3f(1, 1, -1);
  glTexCoord2f(0.0, Tile);
  glVertex3f(1, 1, 1);
  glTexCoord2f(0.0, 0.0);
  glVertex3f(1, -1, 1);
  glEnd();
  // Left Face
  glBegin(GL_QUADS);
  glNormal3f(-1.0, 0.0, 0.0);
  glTexCoord2f(0.0, 0.0);
  glVertex3f(-1, -1, -1);
  glTexCoord2f(Tile, 0.0);
  glVertex3f(-1, -1, 1);
  glTexCoord2f(Tile, Tile);
  glVertex3f(-1, 1, 1);
  glTexCoord2f(0.0, Tile);
  glVertex3f(-1, 1, -1);
  glEnd();
end;

// ----------------------------------------------
// Stars randomly placed on a sphere of radius 1
procedure BuildStarField(const nbStars: integer);
var
  i: integer;
  a, b: double;
  c, s: double;
  cb, sb: double;
  Mag: single;
begin
  glPointSize(1);
  glBegin(GL_POINTS);
  glColor3d(1, 1, 1);
  for i := 1 to Round(0.75 * nbStars) do
  begin
    a := random * 2 * pi;
    b := random * pi - pi / 2;
    SinCosine(a, s, c);
    SinCosine(b, sb, cb);
    Mag := random * 0.5 + 0.3;
    glColor3d(Mag, Mag, Mag);
    glVertex3f(c * cb, s * cb, sb);
  end; // for i
  glEnd();
  glPointSize(2);
  glBegin(GL_POINTS);
  glColor3d(1, 1, 1);
  for i := 1 to Round(0.25 * nbStars) do
  begin
    a := random * 2 * pi;
    b := random * pi - pi / 2;
    SinCosine(a, s, c);
    SinCosine(b, sb, cb);
    Mag := random * 0.5 + 0.3;
    glColor3d(Mag, Mag, Mag);
    glVertex3f(c * cb, s * cb, sb);
  end; // for i
  glEnd();
end;

// =========================================
//
procedure BuildCross(const Radius: single);
begin
  glBegin(GL_LINES);
    glVertex3f(-Radius, 0, 0);
    glVertex3f(+Radius, 0, 0);
  glEnd;
  glBegin(GL_LINES);
    glVertex3f(0, -Radius, 0);
    glVertex3f(0, +Radius, 0);
  glEnd;
end;

procedure Normalize(var v: array of single);
var
  d: double;
begin
  d := sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
  v[0] := v[0] / d;
  v[1] := v[1] / d;
  v[2] := v[2] / d;
end;

procedure NormCrossProd(const v1, v2: array of single;
  var Result: array of single);
begin
  Result[0] := v1[1] * v2[2] - v1[2] * v2[1];
  Result[1] := v1[2] * v2[0] - v1[0] * v2[2];
  Result[2] := v1[0] * v2[1] - v1[1] * v2[0];
  Normalize(Result);
end;

procedure CartToPol(v: array of single; var Theta, Phi: single);
var
  CosPhi: single;
begin
  Normalize(v);
  Phi := ArcSin(v[1]);
  if Abs(v[1]) < 1 then
  begin
    CosPhi := sqrt(1 - sqr(v[1]));
    Theta := ArcCosine(v[0] / CosPhi);
    if v[2] < 0 then
      Theta := -Theta;
  end
  else
    Theta := 0;
end;

procedure SpheroidAddTriangle(var Mesh: TGLMeshObject;
  const v1, v2, v3: array of single);
var
  j: integer;
  d1, d2, norm: array [0 .. 2] of single;
  Theta, Phi: array [0 .. 2] of single;
begin
  for j := 0 to 2 do
  begin
    d1[j] := v1[j] - v2[j];
    d2[j] := v2[j] - v3[j];
  end; // for j
  NormCrossProd(d1, d2, norm);

  CartToPol(v1, Theta[0], Phi[0]);
  CartToPol(v2, Theta[1], Phi[1]);
  CartToPol(v3, Theta[2], Phi[2]);
  if (Abs(SignStrict(Theta[0]) + SignStrict(Theta[1]) + SignStrict(Theta[2])) <
    3) and (Abs(Theta[0] * Theta[1] * Theta[2]) > 8) then
  begin
    if Theta[0] < 0 then
      Theta[0] := Theta[0] + 2 * pi;
    if Theta[1] < 0 then
      Theta[1] := Theta[1] + 2 * pi;
    if Theta[2] < 0 then
      Theta[2] := Theta[2] + 2 * pi;
  end; // if

  Mesh.Vertices.add(v1[0], v1[1], v1[2]);
  // Mesh.Normals.add ((v1[0]+norm[0])/2,(v1[1]+norm[1])/2,(v1[2]+norm[2])/2);
  Mesh.Normals.add(norm[0], norm[1], norm[2]);
  Mesh.TexCoords.add(Theta[0] / pi / 2 + 0.5, Phi[0] / pi + 0.5);

  Mesh.Vertices.add(v2[0], v2[1], v2[2]);
  // Mesh.Normals.add ((v2[0]+norm[0])/2,(v2[1]+norm[1])/2,(v2[2]+norm[2])/2);
  Mesh.Normals.add(norm[0], norm[1], norm[2]);
  Mesh.TexCoords.add(Theta[1] / pi / 2 + 0.5, Phi[1] / pi + 0.5);

  Mesh.Vertices.add(v3[0], v3[1], v3[2]);
  // Mesh.Normals.add ((v3[0]+norm[0])/2,(v3[1]+norm[1])/2,(v3[2]+norm[2])/2);
  Mesh.Normals.add(norm[0], norm[1], norm[2]);
  Mesh.TexCoords.add(Theta[2] / pi / 2 + 0.5, Phi[2] / pi + 0.5);
end;

// ----------------------------------------------------------------
procedure BuildSphere(var Mesh: TGLMeshObject; const Depth: integer = 0);
// Polyhedron and Subdivide algorithms from OpenGL Red Book 

  procedure Subdivide(const v1, v2, v3: array of single; const Depth: integer);
  var
    v12, v23, v31: array [0 .. 2] of single;
    i: integer;
  begin
    if Depth = 0 then
      SpheroidAddTriangle(Mesh, v1, v2, v3)
    else
    begin
      for i := 0 to 2 do
      begin
        v12[i] := v1[i] + v2[i];
        v23[i] := v2[i] + v3[i];
        v31[i] := v3[i] + v1[i];
      end; // for
      Normalize(v12);
      Normalize(v23);
      Normalize(v31);
      Subdivide(v1, v12, v31, Depth - 1);
      Subdivide(v2, v23, v12, Depth - 1);
      Subdivide(v3, v31, v23, Depth - 1);
      Subdivide(v12, v23, v31, Depth - 1);
    end; // else
  end;

const
  x = 0.525731112119133606; // Chosen for a radius-1 icosahedron
  z = 0.850650808352039932; //
  vdata: array [0 .. 11, 0 .. 2] of single = ( // 12 vertices
    (-x, 0.0, z), (x, 0.0, z), (-x, 0.0, -z), (x, 0.0, -z), (0.0, z, x),
    (0.0, z, -x), (0.0, -z, x), (0.0, -z, -x), (z, x, 0.0), (-z, x, 0.0),
    (z, -x, 0.0), (-z, -x, 0.0));

  tindices: array [0 .. 19, 0 .. 2] of glInt = ( // 20 faces
    (0, 4, 1), (0, 9, 4), (9, 5, 4), (4, 5, 8), (4, 8, 1), (8, 10, 1),
    (8, 3, 10), (5, 3, 8), (5, 2, 3), (2, 7, 3), (7, 10, 3), (7, 6, 10),
    (7, 11, 6), (11, 0, 6), (0, 1, 6), (6, 1, 10), (9, 0, 11), (9, 11, 2),
    (9, 2, 5), (7, 2, 11));
var
  i: integer;
begin
  for i := 0 to 19 do
  begin
    Subdivide(vdata[tindices[i, 0], 0], vdata[tindices[i, 1], 0],
      vdata[tindices[i, 2], 0], Depth);
  end; // for
end;

// BuildPotatoid -----------------------------------------------------------
function BuildPotatoid(var Mesh: TGLMeshObject; const Deviance: single = 0.2;
  const Depth: integer = 1; ActualDepth: integer = -1): boolean;
const
  Reduction = 2;
type
  pEdge = ^tEdge;

  tEdge = record
    c1, c2: pEdge;
    r: single;
  end; // record
var
  i, j: integer;
  vdata2: array [0 .. 11, 0 .. 2] of single;
  rr: single;
  Edges: array [0 .. 11, 0 .. 11] of pEdge;
  i0, i1, i2: integer;
  DeltaDepth: integer;

  procedure SubdividePotatoid(const v1, v2, v3: array of single;
    Edges: array of pEdge; const Deviance: single; const Depth: integer);
  var
    v12, v23, v31: array [0 .. 2] of single;
    i: integer;
    inEdges: array [0 .. 2] of pEdge;
  begin
    if Depth = DeltaDepth then
      SpheroidAddTriangle(Mesh, v1, v2, v3);
    if Depth > -DeltaDepth then
    begin
      for i := 0 to 2 do
      begin
        v12[i] := (v1[i] + v2[i]) / 2;
        v23[i] := (v2[i] + v3[i]) / 2;
        v31[i] := (v3[i] + v1[i]) / 2;
      end; // for
      for i := 0 to 2 do
      begin
        v12[i] := v12[i] * Edges[0]^.r; // Apply the deviance
        v31[i] := v31[i] * Edges[1]^.r;
        v23[i] := v23[i] * Edges[2]^.r;
        if Edges[i]^.c1 = nil then
        begin
          New(Edges[i]^.c1);
          Edges[i]^.c1^.r := exp((random * 2 - 1) * (Deviance / Reduction));
          // New division of the Edges
          Edges[i]^.c1^.c1 := nil;
          Edges[i]^.c1^.c2 := nil;
          New(Edges[i]^.c2);
          Edges[i]^.c2^.r := Edges[i]^.c1^.r; // New division of the Edges
          Edges[i]^.c2^.c1 := nil;
          Edges[i]^.c2^.c2 := nil;
        end; // i
        New(inEdges[i]);
        inEdges[i]^.r := exp((random * 2 - 1) * (Deviance / Reduction));
        inEdges[i]^.c1 := nil;
        inEdges[i]^.c2 := nil;
      end; // for

      SubdividePotatoid(v1, v12, v31, [Edges[0]^.c1, Edges[1]^.c1, inEdges[0]],
        Deviance / Reduction, Depth - 1);
      SubdividePotatoid(v2, v23, v12, [Edges[2]^.c1, Edges[0]^.c2, inEdges[1]],
        Deviance / Reduction, Depth - 1);
      SubdividePotatoid(v3, v31, v23, [Edges[1]^.c2, Edges[2]^.c2, inEdges[2]],
        Deviance / Reduction, Depth - 1);
      SubdividePotatoid(v12, v23, v31, [inEdges[1], inEdges[0], inEdges[2]],
        Deviance / Reduction, Depth - 1);
      Dispose(inEdges[0]);
      Dispose(inEdges[1]);
      Dispose(inEdges[2]);
    end; // else
  end;

  procedure DisposeEdge(Edge: pEdge);
  begin
    if Edge^.c1 <> nil then
      DisposeEdge(Edge^.c1);
    if Edge^.c2 <> nil then
      DisposeEdge(Edge^.c2);
    Dispose(Edge);
  end;

const
  x = 0.525731112119133606; // Chosen for a radius-1 icosahedron
  z = 0.850650808352039932; //
  vdata: array [0 .. 11, 0 .. 2] of single = ( // 12 vertices
    (-x, 0.0, z), (x, 0.0, z), (-x, 0.0, -z), (x, 0.0, -z), (0.0, z, x),
    (0.0, z, -x), (0.0, -z, x), (0.0, -z, -x), (z, x, 0.0), (-z, x, 0.0),
    (z, -x, 0.0), (-z, -x, 0.0));
  tindices: array [0 .. 19, 0 .. 2] of glInt = ( // 20 faces
    (0, 4, 1), (0, 9, 4), (9, 5, 4), (4, 5, 8), (4, 8, 1), (8, 10, 1),
    (8, 3, 10), (5, 3, 8), (5, 2, 3), (2, 7, 3), (7, 10, 3), (7, 6, 10),
    (7, 11, 6), (11, 0, 6), (0, 1, 6), (6, 1, 10), (9, 0, 11), (9, 11, 2),
    (9, 2, 5), (7, 2, 11));
begin
  { Result:=False; }
  if ActualDepth < Depth then
    ActualDepth := Depth;
  DeltaDepth := ActualDepth - Depth;
  Mesh.Mode := momTriangles;
  Mesh.Vertices.Clear;
  Mesh.Normals.Clear;
  Mesh.TexCoords.Clear;
  for i := 0 to 11 do
  begin // randomize vertices
    rr := exp((random * 2 - 1) * (Deviance));
    for j := 0 to 2 do
      vdata2[i, j] := vdata[i, j] * rr;
  end; // for i
  try
    for i := 1 to 11 do
    begin // randomize Edges
      for j := 0 to i - 1 do
      begin
        New(Edges[i, j]);
        Edges[i, j]^.r := exp((random * 2 - 1) * (Deviance / Reduction));
        Edges[j, i] := Edges[i, j];
        Edges[i, j]^.c1 := nil;
        Edges[i, j]^.c2 := nil;
      end; // for
    end; // for i

    for i := 0 to 19 do
    begin // Draw triangles
      i0 := tindices[i, 0];
      i1 := tindices[i, 1];
      i2 := tindices[i, 2];
      SubdividePotatoid(Slice(vdata2[i0], 3), Slice(vdata2[i1], 3),
        Slice(vdata2[i2], 3), [Edges[i0, i1], Edges[i0, i2], Edges[i1, i2]],
        Deviance / Reduction, ActualDepth);
    end; // for
  finally
    for i := 1 to 11 do
    begin // Dispose of pointers
      for j := 0 to i - 1 do
      begin
        DisposeEdge(Edges[i, j]);
      end; // for
    end; // for i
  end; // finally
  Result := True;
end;

(************************************************************************
// CAMERA OBJECT
 ************************************************************************)

// TMovingCamera

procedure TMovingCamera.Accelerate(const au, av, an: single);
begin
  sx := sx + au * ux + av * vx + an * nx;
  sy := sy + au * uy + av * vy + an * ny;
  sz := sz + au * uz + av * vz + an * nz;
end;

procedure TMovingCamera.Apply;
// dx, dy and dz must have been computed beforehand
begin
  with SceneObject do
  begin
    Position.SetVector(x, y, z);
    Direction.SetVector(nx, ny, nz);
    Up.SetVector(vx, vy, vz);
  end; // with
end;

// Z directed along the speed vector, X and Y are in the ship's horizontal plane
//
procedure TMovingCamera.ApplyFrontView;
var
  { sx1,sy1,sz1, } s: single;
begin
  s := 1 / Speed;
  SpeedMatrix[0] := ux;
  SpeedMatrix[4] := vx;
  SpeedMatrix[8] := sx * s;
  SpeedMatrix[12] := x;
  SpeedMatrix[1] := uy;
  SpeedMatrix[5] := vy;
  SpeedMatrix[9] := sy * s;
  SpeedMatrix[13] := y;
  SpeedMatrix[2] := uz;
  SpeedMatrix[6] := vz;
  SpeedMatrix[10] := sz * s;
  SpeedMatrix[14] := z;
  SpeedMatrix[3] := 0;
  SpeedMatrix[7] := 0;
  SpeedMatrix[11] := 0;
  SpeedMatrix[15] := 1;

  glMultMatrixf(@SpeedMatrix);
end;

procedure TMovingCamera.ComputeSpeed;
begin
  Speed := sqrt(sqr(sx) + sqr(sy) + sqr(sz));
end;

constructor TMovingCamera.Create;
begin
  inherited Create;
  ResetAttitude;
end;

procedure TMovingCamera.GoThatWay;
begin
  sx := nx * Speed;
  sy := ny * Speed;
  sz := nz * Speed;
end;

// Move
//
procedure TMovingCamera.Move(const du, dv, dn: single);
begin
  x := x + (du * ux + dv * vx + dn * nx);
  y := y + (du * uy + dv * vy + dn * ny);
  z := z + (du * uz + dv * vz + dn * nz);
end;

procedure TMovingCamera.Pitch(const Angle: single);
var
  tempx, tempy, tempz: single;
  cosine, sine: double;
begin
  tempx := vx;
  tempy := vy;
  tempz := vz;
  SinCosine(DegToRadian(Angle), sine, cosine);

  vx := tempx * cosine - nx * sine;
  vy := tempy * cosine - ny * sine;
  vz := tempz * cosine - nz * sine;
  nx := tempx * sine + nx * cosine;
  ny := tempy * sine + ny * cosine;
  nz := tempz * sine + nz * cosine;
end;

procedure TMovingCamera.ResetAttitude;
begin
  ux := 1;
  uy := 0;
  uz := 0;
  vx := 0;
  vy := 1;
  vz := 0;
  nx := 0;
  ny := 0;
  nz := -1;
end;

procedure TMovingCamera.Roll(const Angle: single);
var
  tempx, tempy, tempz: single;
  cosine, sine: double;
begin
  tempx := ux;
  tempy := uy;
  tempz := uz;
  SinCosine(DegToRadian(Angle), sine, cosine);

  ux := tempx * cosine - vx * sine;
  uy := tempy * cosine - vy * sine;
  uz := tempz * cosine - vz * sine;
  vx := tempx * sine + vx * cosine;
  vy := tempy * sine + vy * cosine;
  vz := tempz * sine + vz * cosine;
end;

procedure TMovingCamera.Translate(const dx, dy, dz: single);
begin
  x := x + dx;
  y := y + dy;
  z := z + dz;
end;

procedure TMovingCamera.UpdateAll(const Time: double);
begin
  UpdatePosition(Time);
  UpdateAttitude(Time);
end;

procedure TMovingCamera.UpdateAttitude(const Time: double);
begin
  Pitch(ru * Time);
  Yaw(rv * Time);
  Roll(rn * Time);
end;

procedure TMovingCamera.UpdatePosition(const Time: double);
begin
  Translate(sx * Time, sy * Time, sz * Time);
end;

procedure TMovingCamera.Yaw(const Angle: single);
var
  tempx, tempy, tempz: single;
  cosine, sine: double;
begin
  tempx := ux;
  tempy := uy;
  tempz := uz;
  SinCosine(DegToRadian(Angle), sine, cosine);

  ux := tempx * cosine + nx * sine;
  uy := tempy * cosine + ny * sine;
  uz := tempz * cosine + nz * sine;
  nx := -tempx * sine + nx * cosine;
  ny := -tempy * sine + ny * cosine;
  nz := -tempz * sine + nz * cosine;
end;

// Camera.Apply
//
procedure TRealMovingCamera.Apply;
begin
  with SceneObject do
  begin
    Position.x := x + Vibx;
    Position.y := y + Viby;
    Position.z := z + Vibz;
    Direction.SetVector(nx, ny, nz);
    Up.SetVector(vx, vy, vz);
  end; // with
  Vibx := 0;
  Viby := 0;
  Vibz := 0;
end;

// Input axis: U
//
procedure TRealMovingCamera.GyroPitch(const Moment: single);
var
  dWu, dWv, dWn: single; // Rotation acceleration
  Ini, Ino, Inr: single; // Inertia along input, output and rotor axes
  ri, ro, rr: single; // Rotation speeds on each axis
begin
  Ini := InU;
  ri := DegToRadian(ru);
  // Rotor axis: V, Output axis: N
  Inr := InV;
  rr := DegToRadian(rv);
  Ino := InN;
  ro := DegToRadian(rn);
  dWu := (Moment - (Inr - Ino) * rr * ro) / InU;
  dWn := (-(Ini - Inr) * ri * rr) / InN;
  // Rotor axis: N, Output axis: V
  Inr := InN;
  rr := DegToRadian(rn);
  Ino := InV;
  ro := DegToRadian(rv);
  dWu := dWu + (Moment - (Inr - Ino) * rr * ro) / InU;
  dWv := -(Ini - Inr) * ri * rr / InV;

  ru := ru + RadianToDeg(dWu);
  rv := rv + RadianToDeg(dWv);
  rn := rn + RadianToDeg(dWn);
end;

// Input axis: N
//
procedure TRealMovingCamera.GyroRoll(const Moment: single);
var
  dWu, dWv, dWn: single; // Rotation acceleration
  Ini, Ino, Inr: single; // Inertia along input, output and rotor axes
  ri, ro, rr: single; // Rotation speeds on each axis
begin
  Ini := InN;
  ri := DegToRadian(rn);
  // Rotor axis: V, Output axis: U
  Inr := InV;
  rr := DegToRadian(rv);
  Ino := InU;
  ro := DegToRadian(ru);
  dWn := (Moment - (Inr - Ino) * rr * ro) / InN;
  dWu := (-(Ini - Inr) * ri * rr) / InU;
  // Rotor axis: U, Output axis: V
  Inr := InU;
  rr := DegToRadian(ru);
  Ino := InV;
  ro := DegToRadian(rv);
  dWn := dWn + (Moment - (Inr - Ino) * rr * ro) / InN;
  dWv := -(Ini - Inr) * ri * rr / InV;

  ru := ru + RadianToDeg(dWu);
  rv := rv + RadianToDeg(dWv);
  rn := rn + RadianToDeg(dWn);
end;

// Input axis: V
//
procedure TRealMovingCamera.GyroYaw(const Moment: single);
var
  dWu, dWv, dWn: single; // Rotation acceleration
  Ini, Ino, Inr: single; // Inertia along input, output and rotor axes
  ri, ro, rr: single; // Rotation speeds on each axis
begin
  Ini := InV;
  ri := DegToRadian(rv);
  // Rotor axis: U, Output axis: N
  Inr := InU;
  rr := DegToRadian(ru);
  Ino := InN;
  ro := DegToRadian(rn);
  dWv := (Moment - (Inr - Ino) * rr * ro) / InV;
  dWn := (-(Ini - Inr) * ri * rr) / InN;
  // Rotor axis: N, Output axis: U
  Inr := InN;
  rr := DegToRadian(rn);
  Ino := InU;
  ro := DegToRadian(ru);
  dWv := dWv + (Moment - (Inr - Ino) * rr * ro) / InV;
  dWu := -(Ini - Inr) * ri * rr / InU;

  ru := ru + RadianToDeg(dWu);
  rv := rv + RadianToDeg(dWv);
  rn := rn + RadianToDeg(dWn);
end;

procedure TRealMovingCamera.Vibrate(const Vibration: single);
begin
  Vibx := random * 2 * Vibration - Vibration;
  Viby := random * 2 * Vibration - Vibration;
  Vibz := random * 2 * Vibration - Vibration;
end;

// Destroy
//
destructor TMovingCamera.Destroy;
begin
  inherited Destroy;
end;


end.
