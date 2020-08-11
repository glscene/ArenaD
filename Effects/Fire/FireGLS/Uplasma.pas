unit Uplasma;

{
  Main loop in program should be:
  while ( simulating ) do
  begin
  get_from_UI ( dens_prev, u_prev, v_prev );         <<--- program should update dens_prev, u_prev, v_prev (= density array, u and v velocities)
  vel_step ( N, u, v, u_prev, v_prev, visc, dt );    <<--- step call
  dens_step ( N, dens, dens_prev, u, v, diff, dt );  <<--- step call
  draw_dens ( N, dens );                             <<--- render graphics
  end;

}

interface

uses
  System.SysUtils,
  Vcl.Dialogs;

const
  N = 100;

type

  TField = array [0 .. N + 1, 0 .. N + 1] of real;
  PField = ^TField;

  TForceField = class
  public
    dens, dens_prev, u, v, u_prev, v_prev: PField;
    constructor create;
    procedure dens_step(N: integer; var x: PField; var x0: PField;
      var u: PField; var v: PField; diff: real; dt: real;
      do_addSource: boolean);
    procedure vel_step(N: integer; var u: PField; var v: PField; var u0: PField;
      var v0: PField; visc: real; dt: real);
  private
    fdens, fdens_prev, fu, fv, fu_prev, fv_prev: TField;
    procedure SWAP(var px, py: PField);
    procedure add_source(N: integer; var x: PField; var s: PField; dt: real);
    procedure diffuse(N: integer; b: integer; var x: PField; var x0: PField;
      diff: real; dt: real);
    procedure advect(N: integer; b: integer; var d: PField; var d0: PField;
      var u: PField; var v: PField; dt: real);
    procedure project(N: integer; var u: PField; var v: PField; var p: PField;
      var dv: PField);
    procedure set_bnd(N: integer; b: integer; var x: PField);
  end;

  // ============================================================
implementation

// ============================================================

{ ForceField }

constructor TForceField.create;
begin
  // set pointers to array addresses
  dens := @fdens;
  dens_prev := @fdens_prev;
  u := @fu;
  v := @fv;
  u_prev := @fu_prev;
  v_prev := @fv_prev;
end;

procedure TForceField.add_source(N: integer; var x: PField; var s: PField;
  dt: real);
var
  i, j: integer;
begin
  for i := 0 to N + 1 do
  begin
    for j := 0 to N + 1 do
    begin
      x[i, j] := x[i, j] + (dt * s[i, j]);
    end;
  end;
end;

procedure TForceField.diffuse(N: integer; b: integer; var x: PField;
  var x0: PField; diff: real; dt: real);
var
  i, j, k: integer;
  a, aa: real;
begin
  a := dt * diff * N * N;
  aa := 1 / (1 + (4 * a));

  for k := 0 to 20 do
  begin
    for i := 1 to N + 1 do
    begin
      for j := 1 to N + 1 do
      begin
        x[i, j] := (x0[i, j] + a * (x[i - 1, j] + x[i + 1, j] + x[i, j - 1] +
          x[i, j + 1])) * aa;
      end;
    end;
    set_bnd(N, b, x);
  end;
end;

procedure TForceField.advect(N: integer; b: integer; var d: PField;
  var d0: PField; var u: PField; var v: PField; dt: real);
var
  i, j, i0, j0, i1, j1: integer;
  x, y, s0, t0, s1, t1, dt0: real;
begin
  dt0 := dt * N;
  for i := 1 to N + 1 do
  begin
    for j := 1 to N + 1 do
    begin
      x := i - (dt0 * u[i, j]);
      y := j - (dt0 * v[i, j]);
      if (x < 0.5) then
        x := 0.5;
      if (x > N + 0.5) then
        x := N + 0.5;
      i0 := round(x);
      i1 := i0 + 1;
      if (y < 0.5) then
        y := 0.5;
      if (y > N + 0.5) then
        y := N + 0.5;
      j0 := round(y);
      j1 := j0 + 1;
      s1 := x - i0;
      s0 := 1 - s1;
      t1 := y - j0;
      t0 := 1 - t1;

      d[i, j] := s0 * (t0 * d0[i0, j0] + t1 * d0[i0, j1]) + s1 *
        (t0 * d0[i1, j0] + t1 * d0[i1, j1]);
    end;
  end;
end;

procedure TForceField.dens_step(N: integer; var x: PField; var x0: PField;
  var u: PField; var v: PField; diff: real; dt: real; do_addSource: boolean);
begin
  if do_addSource then
    add_source(N, x, x0, dt);
  SWAP(x0, x);
  diffuse(N, 0, x, x0, diff, dt);
  SWAP(x0, x);
  advect(N, 0, x, x0, u, v, dt);
end;

procedure TForceField.SWAP(var px, py: PField);
var
  ptmp: PField;
begin
  ptmp := px;
  px := py;
  py := ptmp;
end;

procedure TForceField.vel_step(N: integer; var u: PField; var v: PField;
  var u0: PField; var v0: PField; visc: real; dt: real);
begin
  add_source(N, u, u0, dt);
  add_source(N, v, v0, dt);
  SWAP(u0, u);
  diffuse(N, 1, u, u0, visc, dt);
  SWAP(v0, v);
  diffuse(N, 2, v, v0, visc, dt);
  project(N, u, v, u0, v0);
  SWAP(u0, u);
  SWAP(v0, v);
  advect(N, 1, u, u0, u0, v0, dt);
  advect(N, 2, v, v0, u0, v0, dt);
  project(N, u, v, u0, v0);
end;

procedure TForceField.project(N: integer; var u: PField; var v: PField;
  var p: PField; var dv: PField);
var
  i, j, k: integer;
  h: real;
begin
  h := 1 / N;
  for i := 1 to N + 1 do
  begin
    for j := 1 to N + 1 do
    begin
      dv[i, j] := -0.5 * h * (u[i + 1, j] - u[i - 1, j] + v[i, j + 1] -
        v[i, j - 1]);
      p[i, j] := 0;
    end;
  end;
  set_bnd(N, 0, dv);
  set_bnd(N, 0, p);

  for k := 0 to 20 do
  begin
    for i := 1 to N + 1 do
    begin
      for j := 1 to N + 1 do
      begin
        p[i, j] := (dv[i, j] + p[i - 1, j] + p[i + 1, j] + p[i, j - 1] + p[i,
          j + 1]) * 0.25; // era /4;
      end;
    end;
    set_bnd(N, 0, p);
  end;

  for i := 1 to N + 1 do
  begin
    for j := 1 to N + 1 do
    begin
      u[i, j] := u[i, j] - 0.5 * (p[i + 1, j] - p[i - 1, j]) * N; // era /h
      v[i, j] := v[i, j] - 0.5 * (p[i, j + 1] - p[i, j - 1]) * N; // era /h
    end;
  end;
  set_bnd(N, 1, u);
  set_bnd(N, 2, v);

end;

procedure TForceField.set_bnd(N: integer; b: integer; var x: PField);
var
  i: integer;
begin
  for i := 1 to N do
  begin
    if b = 1 then
    begin
      x[0, i] := -x[1, i];
      x[N + 1, i] := -x[N, i];
    end
    else
    begin
      x[0, i] := x[1, i];
      x[N + 1, i] := x[N, i];
    end;

    if b = 2 then
    begin
      x[i, 0] := -x[i, 1];
      x[i, N + 1] := -x[i, N];
    end
    else
    begin
      x[i, 0] := x[i, 1];
      x[i, N + 1] := x[i, N];
    end;
  end;
  x[0, 0] := 0.5 * (x[1, 0] + x[0, 1]);
  x[0, N + 1] := 0.5 * (x[1, N + 1] + x[0, N]);
  x[N + 1, 0] := 0.5 * (x[N, 0] + x[N + 1, 1]);
  x[N + 1, N + 1] := 0.5 * (x[N, N + 1] + x[N + 1, N]);
end;


// UNUSED:
{ procedure TForceField.normalize(max:real);
  var
  i, j:integer;
  dD,DFx,DFy:real;
  begin
  if DMax-DMin>0.01 then dD := max/(DMax-DMin) else dD:=1;
  if FxMax-FxMin>0.01 then dFx := max/(FXMax-FxMin) else dFx:=1;
  if FyMax-FyMin>0.01 then dFy := max/(FyMax-FyMin) else dFy:=1;
  for i := 0 to N+1 do
  begin
  for j := 0 to N+1 do
  begin
  nD[i,j]:=(D[i,j]-DMin)*dD;
  nFx[i,j]:=(Fx[i,j]-FxMin)*dFx;
  nFy[i,j]:=(Fy[i,j]-FyMin)*dFy;
  end;
  end;
  end;
}

end.
