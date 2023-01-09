unit uSpaceBodies;

(*-----------------------------------------------------------------------------
  Purpose: Custom "Space" GLScene Objects
  - Multiple planets, Moons,... with their individual properties
  - One Space object per orbit, unlimited orbit per Planet & for Sun
  History:
   "Main Idea From Blaise Bernier", J.Delauney, I.L.Herring, P.Vassiliev
  ----------------------------------------------------------------------------- *)

interface

uses
  System.SysUtils,
  System.Classes,
  GLS.Objects,
  GLS.GeomObjects,
  GLS.VectorFileObjects;

type
  TGLPlanetarySystemData = record
    NSun: byte;
    NPlanet: byte;
    NMoon: byte;
    NAsteroid: Byte;
    NComete: Byte;
  end;

  TGLStarData = record
    StarName: array [0 .. 9] of Char; // Also Equal to material
    distance: single;
    diameter: single;
    AngleAxis: single;
    Mass: single;
    DocIndex: byte;
  end;

  TOrbitData = record
    Period: single;
    Velocity: single;
    Eccentricity: single;
    AxisAngle: single;
  end;

  TPlanetData = record
    PlanetName: array [0 .. 15] of Char;
    distance: single;
    diameter: single;
    Mass: single;
    RotationPeriod: single;
    AngleEquatorOrbit: single;
    NbMoon: byte;
    AtmosphericConstituents: array [0 .. 19] of Char;
    DocIndex: byte;
  end;

  TMoonData = record
    MoonName: array [0 .. 9] of Char;
    distance: single;
    diameter: single;
    RotationPeriod: single;
    AngleEquatorOrbit: single;
    Mass: single;
    DocIndex: byte;
  end;

  TRingData = record
    RingName: array [0 .. 9] of Char;
    distance: single;
    diameter: single;
    RotationPeriod: single;
    AngleEquatorOrbit: single;
    Mass: single;
    DocIndex: byte;
  end;

  // ----------------------------------------------------

  TGLSun = class(TGLSphere)
  private
    FExtraData: TGLStarData;
  public
    property ExtraData: TGLStarData read FExtraData write FExtraData;
  end;

  TGLOrbit = class(TGLLines)
  private
    FExtraData: TOrbitData;
  public
    property ExtraData: TOrbitData read FExtraData write FExtraData;
  end;

  TGLPlanet = class(TGLFreeForm)
  private
    FExtraData: TPlanetData;
  public
    property ExtraData: TPlanetData read FExtraData write FExtraData;
  end;

  TGLPlanetRing = class(TGLDisk)
  Private
    FExtraData: TRingData;
  public
    property ExtraData: TRingData read FExtraData write FExtraData;
  end;

  TGLMoon = class(TGLFreeForm)
  private
    FExtraData: TMoonData;
  public
    property ExtraData: TMoonData read FExtraData write FExtraData;
  end;

(*
  TGLAsteroid = Class(TGLFreeForm)
  private
    FExtraData: TAsteroidData;
  public
    procedure BuildAsteroid;
    property ExtraData: TAsteroidData read FExtraData write FExtraData;
  end;
*)
  //
  // TGLSpaceShip=Class(TGLFreeForm)
  // Private
  // FExtraData : TSpaceShipData;
  // public
  // property ExtraData : TAsteroidData read FExtraData write FExtraData;
  // end;
  //
  // TGLSatelit=Class(TGLFreeForm)
  // Private
  // FExtraData : TSatelitData;
  // public
  // property ExtraData : TSatelitData read FExtraData write FExtraData;
  // end;

implementation

{ -----------------------------------------------------------------------------
  Procedure   : All Comment Below it's for creating Asteroids
  it provided From : Alexandre Hirzel ?
  Date        : 17/july/2003
  Arguments   : None
  Result      : None
  Description :
  ----------------------------------------------------------------------------- }

// RandSeed:=Seed;
// MasterAsteroidF:=TFreeForm(dumMasters.AddNewChild(TFreeForm));
// Temp:=TGLMeshObject.CreateOwned(MasterAsteroidF.MeshObjects);
// BuildPotatoid(Temp,0.5,0,2);
// procedure Normalize(var v:array of single);
// var
// d       :double;
// begin
// d:=sqrt(v[0]*v[0]+v[1]*v[1]+v[2]*v[2]);
// v[0]:=v[0]/d; v[1]:=v[1]/d; v[2]:=v[2]/d;
// end;
//
// procedure NormCrossProd(const v1,v2:array of single;
// var Result:array of single);
// var
// i, j   :GLint;
// length :single;
// begin
// Result[0]:= v1[1]*v2[2] - v1[2]*v2[1];
// Result[1]:= v1[2]*v2[0] - v1[0]*v2[2];
// Result[2]:= v1[0]*v2[1] - v1[1]*v2[0];
// Normalize(Result);
// end;
//
// procedure CartToPol(v:array of single;var Theta,Phi:single);
// var
// CosPhi	:single;
// begin
// Normalize(v);
// Phi:=ArcSin(v[1]);
// if Abs(v[1])<1 then begin
// CosPhi:=sqrt(1-sqr(v[1]));
// Theta:=ArcCos(v[0]/CosPhi);
// if v[2]<0 then Theta:=-Theta;
// end
// else Theta:=0;
// end;
//
// procedure SpheroidAddTriangle(var Mesh:TGLMeshObject; const v1,v2,v3:array of single);
// var
// j			:integer;
// d1,d2,norm 	:array [0..2] of single;
// Theta,Phi	:array [0..2] of single;
// begin
// for j:=0 to 2 do begin
// d1[j]:=v1[j] - v2[j];
// d2[j]:=v2[j] - v3[j];
// end;//for j
// NormCrossProd(d1,d2,norm);
//
// CartToPol(v1,Theta[0],Phi[0]);
// CartToPol(v2,Theta[1],Phi[1]);
// CartToPol(v3,Theta[2],Phi[2]);
// if (abs(sign(Theta[0])+sign(Theta[1])+sign(Theta[2]))<3)and
// (Abs(Theta[0]*Theta[1]*Theta[2])>8) then begin
// if Theta[0]<0 then Theta[0]:=Theta[0]+2*pi;
// if Theta[1]<0 then Theta[1]:=Theta[1]+2*pi;
// if Theta[2]<0 then Theta[2]:=Theta[2]+2*pi;
// end;//if
//
// Mesh.Vertices.add (v1[0],v1[1],v1[2]);
/// /  Mesh.Normals.add ((v1[0]+norm[0])/2,(v1[1]+norm[1])/2,(v1[2]+norm[2])/2);
// Mesh.Normals.Add(norm[0],norm[1],norm[2]);
// Mesh.TexCoords.Add(Theta[0]/pi/2+0.5,Phi[0]/pi+0.5);
//
// Mesh.Vertices.add (v2[0],v2[1],v2[2]);
/// /  Mesh.Normals.add ((v2[0]+norm[0])/2,(v2[1]+norm[1])/2,(v2[2]+norm[2])/2);
// Mesh.Normals.Add(norm[0],norm[1],norm[2]);
// Mesh.TexCoords.Add(Theta[1]/pi/2+0.5,Phi[1]/pi+0.5);
//
// Mesh.Vertices.add (v3[0],v3[1],v3[2]);
/// /  Mesh.Normals.add ((v3[0]+norm[0])/2,(v3[1]+norm[1])/2,(v3[2]+norm[2])/2);
// Mesh.Normals.Add(norm[0],norm[1],norm[2]);
// Mesh.TexCoords.Add(Theta[2]/pi/2+0.5,Phi[2]/pi+0.5);
// end;
//
// procedure BuildSphere(var Mesh:TGLMeshObject; const Depth:integer=0);
// {Polyhedron and Subdivide algorithms from OpenGL Red Book}
//
// procedure Subdivide(const v1,v2,v3:array of single;const Depth:integer);
// var
// v12,v23,v31	:array[0..2] of single;
// i			:integer;
// begin
// if Depth=0 then SpheroidAddTriangle(Mesh, v1,v2,v3)
// else begin
// for i:=0 to 2 do begin
// v12[i]:= v1[i]+v2[i];
// v23[i]:= v2[i]+v3[i];
// v31[i]:= v3[i]+v1[i];
// end;//for
// normalize(v12);
// normalize(v23);
// normalize(v31);
// Subdivide(v1,v12,v31,Depth-1);
// Subdivide(v2,v23,v12,Depth-1);
// Subdivide(v3,v31,v23,Depth-1);
// Subdivide(v12,v23,v31,Depth-1);
// end;//else
// end;
//
// const
// X=0.525731112119133606; // Chosen for a radius-1 icosahedron
// Z=0.850650808352039932; //
// vdata:array[0..11,0..2] of single = (    // 12 vertices
// (-X, 0.0, Z), (X, 0.0, Z), (-X, 0.0,-Z), (X, 0.0, -Z),
// (0.0, Z, X), (0.0, Z, -X), (0.0, -Z, X), (0.0, -Z, -X),
// (Z, X, 0.0), (-Z, X, 0.0), (Z, -X, 0.0), (-Z, -X, 0.0) );
//
// tindices:array[0..19,0..2]of glInt = (    // 20 faces
// (0,4,1),  (0,9,4),  (9,5,4),  (4,5,8), (4,8,1),
// (8,10,1), (8,3,10), (5,3,8),  (5,2,3), (2,7,3),
// (7,10,3), (7,6,10), (7,11,6), (11,0,6),(0,1,6),
// (6,1,10), (9,0,11), (9,11,2), (9,2,5), (7,2,11) );
// var
// i	:integer;
// begin
// for i:=0 to 19 do begin
// Subdivide(vdata[tindices[i,0],0],
// vdata[tindices[i,1],0],
// vdata[tindices[i,2],0],
// Depth);
// end;//for
// end;

// function BuildPotatoid(var Mesh:TGLMeshObject; const Deviance:single=0.2;
// const Depth:integer=1; ActualDepth:integer=-1):boolean;
// {Fractal process to build a random potatoid. Depth correspond to the depth
// of the recursive process. Use ActualDepth to generate a same potatoid at
// various level of details}
// const
// Reduction=2;
// type
// pEdge=^tEdge;
// tEdge=record
// c1,c2	:pEdge;
// r		:single;
// end;//record
// var
// i,j		:integer;
// vdata2 	:array[0..11,0..2] of single;
// rr 		:single;
// Edges		:array[0..11,0..11] of pEdge;
// i0,i1,i2	:integer;
// DeltaDepth :integer;

// procedure SubdividePotatoid(const v1,v2,v3:array of single;
// Edges:array of pEdge;
// const Deviance:single; const Depth:integer);
// var
// v12,v23,v31	:array[0..2] of single;
// i			:integer;
// inEdges		:array[0..2] of pEdge;
// begin
// if Depth=DeltaDepth then SpheroidAddTriangle(Mesh,v1,v2,v3);
// if Depth>-DeltaDepth then begin
// for i:=0 to 2 do begin
// v12[i]:=(v1[i]+v2[i])/2;
// v23[i]:=(v2[i]+v3[i])/2;
// v31[i]:=(v3[i]+v1[i])/2;
// end;//for
// for i:=0 to 2 do begin
// v12[i]:=v12[i]*Edges[0]^.r; // Apply the deviance
// v31[i]:=v31[i]*Edges[1]^.r;
// v23[i]:=v23[i]*Edges[2]^.r;
// if Edges[i]^.c1=nil then begin
// New(Edges[i]^.c1);
// Edges[i]^.c1^.r:=exp((random*2-1)*(Deviance/Reduction)); // New division of the Edges
// Edges[i]^.c1^.c1:=nil;
// Edges[i]^.c1^.c2:=nil;
// New(Edges[i]^.c2);
// Edges[i]^.c2^.r:=Edges[i]^.c1^.r; // New division of the Edges
// Edges[i]^.c2^.c1:=nil;
// Edges[i]^.c2^.c2:=nil;
// end;//i
// New(inEdges[i]);
// inEdges[i]^.r:=exp((random*2-1)*(Deviance/Reduction));
// inEdges[i]^.c1:=nil;
// inEdges[i]^.c2:=nil;
// end;//for
//
// SubdividePotatoid(v1,v12,v31,
// [Edges[0]^.c1,Edges[1]^.c1,inEdges[0]],
// Deviance/Reduction,Depth-1);
// SubdividePotatoid(v2,v23,v12,
// [Edges[2]^.c1,Edges[0]^.c2,inEdges[1]],
// Deviance/Reduction,Depth-1);
// SubdividePotatoid(v3,v31,v23,
// [Edges[1]^.c2,Edges[2]^.c2,inEdges[2]],
// Deviance/Reduction,Depth-1);
// SubdividePotatoid(v12,v23,v31,
// [inEdges[1],inEdges[0],inEdges[2]],
// Deviance/Reduction,Depth-1);
// Dispose(inEdges[0]);
// Dispose(inEdges[1]);
// Dispose(inEdges[2]);
// end;//else
// end;
//
// procedure DisposeEdge(Edge:pEdge);
// begin
// if Edge^.c1<>nil then DisposeEdge(Edge^.c1);
// if Edge^.c2<>nil then DisposeEdge(Edge^.c2);
// Dispose(Edge);
// end;
//
// const
// X=0.525731112119133606; // Chosen for a radius-1 icosahedron
// Z=0.850650808352039932; //
// vdata:array[0..11,0..2] of single = (    // 12 vertices
// (-X, 0.0, Z), (X, 0.0, Z), (-X, 0.0,-Z), (X, 0.0, -Z),
// (0.0, Z, X), (0.0, Z, -X), (0.0, -Z, X), (0.0, -Z, -X),
// (Z, X, 0.0), (-Z, X, 0.0), (Z, -X, 0.0), (-Z, -X, 0.0) );
// tindices:array[0..19,0..2]of glInt = (    // 20 faces
// (0,4,1),  (0,9,4),  (9,5,4),  (4,5,8), (4,8,1),
// (8,10,1), (8,3,10), (5,3,8),  (5,2,3), (2,7,3),
// (7,10,3), (7,6,10), (7,11,6), (11,0,6),(0,1,6),
// (6,1,10), (9,0,11), (9,11,2), (9,2,5), (7,2,11) );
// begin
// Result:=False;
// if ActualDepth<Depth then ActualDepth:=Depth;
// DeltaDepth:=ActualDepth-Depth;
// Mesh.Mode:=momTriangles;
// Mesh.Vertices.Clear;
// Mesh.Normals.Clear;
// Mesh.TexCoords.Clear;
// for i:=0 to 11 do begin // randomize vertices
// rr:=exp((random*2-1)*(Deviance));
// for j:=0 to 2 do vdata2[i,j]:=vdata[i,j]*rr;
// end;//for i
// try
// for i:=1 to 11 do begin // randomize Edges
// for j:=0 to i-1 do begin
// New(Edges[i,j]);
// Edges[i,j]^.r:=exp((random*2-1)*(Deviance/Reduction));
// Edges[j,i]:=Edges[i,j];
// Edges[i,j]^.c1:=nil; Edges[i,j]^.c2:=nil;
// end;//for
// end;//for i
//
// for i:=0 to 19 do begin  // Draw triangles
// i0:=tindices[i,0];
// i1:=tindices[i,1];
// i2:=tindices[i,2];
// SubdividePotatoid(Slice(vdata2[i0],3),
// Slice(vdata2[i1],3),
// Slice(vdata2[i2],3),
// [Edges[i0,i1],
// Edges[i0,i2],
// Edges[i1,i2] ],
// Deviance/Reduction, ActualDepth);
// end;//for
// finally
// for i:=1 to 11 do begin // Dispose of pointers
// for j:=0 to i-1 do begin
// DisposeEdge(Edges[i,j]);
// end;//for
// end;//for i
// end;//finally
// Result:=True;
// end;
end.
