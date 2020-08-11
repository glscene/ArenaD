unit uVBOvni;
//
// Vertices,Normals (stat) + Indices (dyn)
//

interface

uses
  Winapi.OpenGL,
  Winapi.OpenGLext,
  System.SysUtils,
  Vcl.Dialogs,

  GLS.Scene,
  GLS.VectorTypes,
  GLS.VectorGeometry,
  GLS.RenderContextInfo,
  GLS.Material,
  GLS.OpenGLTokens,
  GLS.OpenGLAdapter,
  GLS.Context,
  GLS.Utils;

type

  PVertexVN = ^TVertexVN;

  TVertexVN = record
    v, n: TVector3f;
  end;

  PIntIntArr = ^TIntIntArr;
  TIntIntArr = array of array of integer;

  TVBO = class(TGLSceneObject)
  protected
    f_bufG, f_bufI: Cardinal;
    f_glsl: TGLProgramHandle;
    f_init: Boolean;
    f_camLook, f_oldCamLook: integer;
    procedure _initBufs;
  public
    garr: array of TVertexVN;
    iarr: array of array of integer;
    constructor CreateAsChild(AOwner: TGLBaseSceneObject; AShad: string);
    procedure setSize(AGCnt, ADCnt, AICnt: integer);
    procedure init;
    procedure DoRender(var a_Rci: TGLRenderContextInfo;
      a_RenderSelf, a_RenderChildren: Boolean); override;
    property camLook: integer write f_camLook;
  end;

//======================================================================
implementation
//======================================================================

//
// _initBufs
//
procedure TVBO._initBufs;
begin
  gl.GenBuffers(1, @f_bufG);
  gl.BindBuffer(GL_ARRAY_BUFFER, f_bufG);
  gl.BufferData(GL_ARRAY_BUFFER, 24 * length(garr), @garr[0], GL_STATIC_DRAW);
  gl.GenBuffers(1, @f_bufI);
  gl.BindBuffer(GL_ELEMENT_ARRAY_BUFFER, f_bufI);
  gl.BufferData(GL_ELEMENT_ARRAY_BUFFER, 4 * length(iarr[0]), nil,
    GL_DYNAMIC_DRAW);
end;

//
// constructor
//
constructor TVBO.CreateAsChild;
begin
  inherited CreateAsChild(AOwner);
  if not(gl.ARB_vertex_buffer_object and gl.ARB_shader_objects and
    gl.ARB_vertex_shader and gl.ARB_fragment_shader) then
  begin
    ShowMessage('VBO or shader not supported by your hardware');
    Halt;
  end;
  if AShad <> '' then
  begin
    f_glsl := TGLProgramHandle.CreateAndAllocate;
    f_glsl.AddShader(TGLVertexShaderHandle,
      LoadAnsiStringFromFile(AShad + '.vp'));
    f_glsl.AddShader(TGLFragmentShaderHandle,
      LoadAnsiStringFromFile(AShad + '.fp'));
    if not f_glsl.LinkProgram then
      raise Exception.Create(f_glsl.InfoLog);
    if not f_glsl.ValidateProgram then
      raise Exception.Create(f_glsl.InfoLog);
  end;

  f_init := false;
  f_camLook := -1;
  f_oldCamLook := -1;

end;

//
// setSize
//
procedure TVBO.setSize(AGCnt, ADCnt, AICnt: integer);
begin
  SetLength(garr, AGCnt);
  SetLength(iarr, ADCnt, AICnt);
end;

//
// init
//
procedure TVBO.init;
begin
  _initBufs;
  f_init := true;
end;

//
// DoRender
//
procedure TVBO.DoRender;
begin
  if not f_init then
    Exit();
  Material.Apply(a_Rci);
  if f_glsl <> nil then
  begin
    f_glsl.UseProgramObject;
    f_glsl.Uniform1i['BaseTex'] := 0;
    f_glsl.Uniform3f['camDir'] := affineVectorMake(a_Rci.cameraDirection);
  end;
  gl.BindBuffer(GL_ARRAY_BUFFER, f_bufG);
  gl.BindBuffer(GL_ELEMENT_ARRAY_BUFFER, f_bufI);
  gl.EnableClientState(GL_NORMAL_ARRAY);
  gl.EnableClientState(GL_VERTEX_ARRAY);
  gl.NormalPointer(GL_FLOAT, 24, PGLUINT(12));
  gl.VertexPointer(3, GL_FLOAT, 24, PGLUINT(0));
  if f_camLook <> f_oldCamLook then
  begin
    gl.BufferSubData(GL_ELEMENT_ARRAY_BUFFER, 0, length(iarr[0]) * 4,
      @iarr[f_camLook][0]);
    f_oldCamLook := f_camLook;
  end;
  gl.DrawElements(GL_QUADS, length(iarr[0]), GL_UNSIGNED_INT, nil);
  gl.DisableClientState(GL_VERTEX_ARRAY);
  gl.DisableClientState(GL_NORMAL_ARRAY);
  if f_glsl <> nil then
    f_glsl.EndUseProgramObject;
  Material.UnApply(a_Rci);
end;

end.
