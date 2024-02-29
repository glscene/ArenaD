unit UABUtils;

(* Misc. utility functions *)

interface

uses
  System.Classes,
  GLS.VectorGeometry,
  GLS.VectorTypes,
  GLS.Canvas,
  GLS.Texture,
  GLS.Material,
  GLS.RenderContextInfo;

function StringToVector3(const str: String): TAffineVector;
function Vector3ToString(const v: TGLVector): String; overload;
function Vector3ToString(const v: TAffineVector): String; overload;

function FindInPaths(const fileName, paths: String): String;

procedure RenderCornersQuad(Canvas: TGLCanvas; w: Integer);
procedure RenderLosange(Canvas: TGLCanvas; s: Integer);
procedure RenderSpriteQuad(var rci: TGLRenderContextInfo; px, py, size: Single;
  libMat: TGLLibMaterial);

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
implementation

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

uses
  System.SysUtils,
  Winapi.OpenGL;

// StringToVector3
//
function StringToVector3(const str: String): TAffineVector;
var
  p1, p2: Integer;
begin
  if str = '' then
  begin
    Result := NullVector;
  end
  else
  begin
    p1 := Pos(',', str);
    p2 := LastDelimiter(',', str);
    Result.X := StrToFloat(Copy(str, 1, p1 - 1));
    Result.Y := StrToFloat(Copy(str, p1 + 1, p2 - p1 - 1));
    Result.Z := StrToFloat(Copy(str, p2 + 1, MaxInt));
  end;
end;

// Vector3ToString
//
function Vector3ToString(const v: TGLVector): String;
begin
  Result := Vector3ToString(AffineVectorMake(v));
end;

// Vector3ToString
//
function Vector3ToString(const v: TAffineVector): String;
begin
  Result := Format('%f,%f,%f', [v.X, v.Y, v.Z]);
end;

// FindInPaths
//
function FindInPaths(const fileName, paths: String): String;
var
  p: Integer;
  buf: String;
  sl: TStringList;
begin
  if FileExists(fileName) then
  begin
    Result := fileName;
    Exit;
  end;
  buf := paths;
  sl := TStringList.Create;
  try
    p := Pos(';', buf);
    while p > 0 do
    begin
      sl.Add(Copy(buf, 1, p - 1));
      buf := Copy(buf, p + 1, MaxInt);
      p := Pos(';', buf);
    end;
    sl.Add(buf);
    for p := 0 to sl.Count - 1 do
    begin
      buf := sl[p];
      if Copy(buf, 1, Length(buf)) <> '\' then
        buf := buf + '\';
      buf := buf + fileName;
      if FileExists(buf) then
      begin
        Result := buf;
        Exit;
      end;
    end;
  finally
    sl.Free;
  end;
  Result := '';
end;

// RenderCornersQuad
//
procedure RenderCornersQuad(Canvas: TGLCanvas; w: Integer);
var
  w2: Integer;
begin
  w2 := w div 2;
  with Canvas do
  begin
    MoveToRel(-w, w2);
    LineToRel(0, w2);
    LineToRel(w2, 0);
    MoveToRel(w, 0);
    LineToRel(w2, 0);
    LineToRel(0, -w2);
    MoveToRel(0, -w);
    LineToRel(0, -w2);
    LineToRel(-w2, 0);
    MoveToRel(-w, 0);
    LineToRel(-w2, 0);
    LineToRel(0, w2);
  end;
end;

// RenderLosange
//
procedure RenderLosange(Canvas: TGLCanvas; s: Integer);
begin
  with Canvas do
  begin
    MoveToRel(0, s);
    LineToRel(s, -s);
    LineToRel(-s, -s);
    LineToRel(-s, s);
    LineToRel(s, s);
  end;
end;

// RenderSpriteQuad
//
procedure RenderSpriteQuad(var rci: TGLRenderContextInfo; px, py, size: Single;
  libMat: TGLLibMaterial);
begin
  size := size * 0.5;
  libMat.Apply(rci);
  glBegin(GL_QUADS);
  glTexCoord2f(0, 0);
  glVertex2f(px - size, py + size);
  glTexCoord2f(1, 0);
  glVertex2f(px + size, py + size);
  glTexCoord2f(1, 1);
  glVertex2f(px + size, py - size);
  glTexCoord2f(0, 1);
  glVertex2f(px - size, py - size);
  glEnd;
  libMat.UnApply(rci);
end;

end.
