unit u_Graph;

interface

uses
   Winapi.Windows,
   System.Classes,
   System.SysUtils,
   Vcl.Graphics,

   GLS.Scene,
   GLS.AsyncTimer,
   GLS.Canvas,
   GLS.RenderContextInfo;


type
  c_FPSGraph = class(TGLImmaterialSceneObject)
  private
    f_fps,f_fpsMax: single;
    f_pos,f_brd: integer;
    f_arr:array of single;
    f_ATimer:TGLAsyncTimer;
    procedure _setInterval(v:integer);
    procedure _onTime(Sender:TObject);
  public
    constructor CreateAsChild(aParentOwner: TGLBaseSceneObject);
    procedure DoRender(var ARci: TGLRenderContextInfo;
      ARenderSelf, ARenderChildren: Boolean); override;
    property border:integer read f_brd write f_brd;
    property interval:integer write _setInterval;
    property fps:single read f_fps;
  end;

//=====================================================================
implementation
//=====================================================================

constructor c_FPSGraph.CreateAsChild;
begin
  Create(aParentOwner);
  aParentOwner.AddChild(Self);
  f_Pos := 0;
  f_fpsMax := 1;
  f_brd := 50;
	setlength(f_Arr, 8192);
  f_ATimer := TGLAsyncTimer.Create(self);
  f_ATimer.OnTimer := _onTime;
  f_ATimer.Enabled := true;
  _setInterval(100);
end;

//------------------------------------------------------------------

procedure c_FPSGraph._setInterval;
begin
  f_Atimer.Interval := v;
end;

//------------------------------------------------------------------

procedure c_FPSGraph._onTime;
var
    i: integer;
    f: single;
begin
  if Scene.CurrentBuffer = nil then exit;
  f := Scene.CurrentBuffer.FramesPerSecond;
  Scene.CurrentBuffer.ResetPerformanceMonitor;
  for i := 0 to 4 do
    f := f + f_Arr[(f_Pos - i) and $1fff];
  f_fps := f / 5;
  if f_fps * 0.9 > f_fpsMax then
    f_fpsMax := f_fps;
  f_Arr[f_Pos and $1fff] := f_fps;
  inc(f_pos);
end;

//------------------------------------------------------------------

procedure c_FPSGraph.DoRender;
var
    glc: TGLCanvas;
    i,dw: integer;
    a: single;

begin
  with Scene.CurrentBuffer do
    glc := TGLCanvas.Create(Width, Height);

  with glc do begin
    InvertYAxis;
    a := (CanvasSizeY - f_brd * 3) / f_fpsMax;
    dw := CanvasSizeX - f_brd * 2;
    PenColor := $ffffff;
    PenAlpha := 0.5;
    for i := 0 to round(f_fpsMax / 100) do
      Line(f_brd, f_brd + i * 100 * a, f_brd + dw, f_brd + i * 100 * a);
    for i := 0 to dw - 2 do
    begin
      if (f_pos + i - dw) mod 100 = 0 then
      begin
        PenColor := $ffffff;
        PenAlpha := 0.5;
        Line(f_brd + i, f_brd, f_brd + i, CanvasSizeY - f_brd);
      end;
      PenColor := $0080ff;
      PenAlpha := 0.75;
      Line(f_brd + i, f_brd + f_arr[(f_pos + i - dw) and $1fff] * a,
        f_brd + i + 1, f_brd + f_arr[(f_pos + i + 1 - dw) and $1fff] * a);
    end;
   Free;
  end;
end;


end.
