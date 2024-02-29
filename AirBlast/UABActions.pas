unit UABActions;

(* AirBlast "scriptable" actions *)

interface

uses
  System.Classes,
  UAirBlastEngine,
  UGameEngine;

procedure PerformABActions(engine: TAirBlastEngine;
  const actionsCommaText: String; envVars: TStrings); overload;
procedure PerformABActions(engine: TAirBlastEngine;
  actions, envVars: TStrings); overload;
procedure PerformABAction(engine: TAirBlastEngine; const cmd: String;
  params: String; envVars: TStrings);

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
implementation

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

uses
  System.SysUtils,
  UABUtils,
  GLS.ApplicationFileIO;

// PerformABActions
//
procedure PerformABActions(engine: TAirBlastEngine;
  const actionsCommaText: String; envVars: TStrings);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  sl.CommaText := actionsCommaText;
  PerformABActions(engine, sl, envVars);
  sl.Free;
end;

// PerformABActions
//
procedure PerformABActions(engine: TAirBlastEngine; actions, envVars: TStrings);
var
  i, p: Integer;
  cmd, params: String;
begin
  for i := 0 to actions.Count - 1 do
  begin
    cmd := actions[i];
    p := Pos(' ', cmd);
    if p > 0 then
    begin
      params := Copy(cmd, p + 1, MaxInt);
      SetLength(cmd, p - 1);
    end
    else
      params := '';
    if cmd = '' then
      continue;
    if cmd[1] = '"' then
    begin
      cmd := Copy(cmd, 2, MaxInt);
      params := '"' + params;
    end;
    PerformABAction(engine, LowerCase(cmd), params, envVars);
  end;
end;

// PerformABAction
//
procedure PerformABAction(engine: TAirBlastEngine; const cmd: String;
  params: String; envVars: TStrings);
var
  p, p2: Integer;
  obj: TGameEngineObject;
  sl: TStringList;
  s: TStream;
  viewerCam: TABViewerCam;
  macroName: String;
begin
  if cmd = '' then
    Exit;
  if params <> '' then
  begin
    // replace macros
    p := Pos('%', params);
    while p > 0 do
    begin
      p2 := p + Pos('%', Copy(params, p + 1, MaxInt));
      if p2 <= p then
        Break;
      macroName := Copy(params, p + 1, p2 - p - 1);
      params := Copy(params, 1, p - 1) + envVars.Values[macroName] +
        Copy(params, p2 + 1, MaxInt);
      p := Pos('%', params);
    end;
  end;

  if cmd = 'enable' then
  begin
    obj := engine.ObjectByName(params);
    if obj <> nil then
      obj.Disabled := False;
  end
  else if cmd = 'disable' then
  begin
    obj := engine.ObjectByName(params);
    if obj <> nil then
      obj.Disabled := True;
  end
  else if cmd = 'toggle' then
  begin
    obj := engine.ObjectByName(params);
    if obj <> nil then
      obj.Disabled := not obj.Disabled;
  end
  else if cmd = 'completed' then
  begin
    envVars.Values['Completed'] := 'Y';
  end
  else if cmd = 'replenish' then
  begin
    obj := engine.ObjectByName(params);
    if obj is TABAirplane then
    begin
      TABAirplane(obj).ReplenishFuel;
      TABAirplane(obj).ReplenishEquipments;
    end
    else if obj is TABSpawnPoint then
    begin
      TABSpawnPoint(obj).Replenish
    end;
  end
  else if cmd = 'deplete' then
  begin
    obj := engine.ObjectByName(params);
    if obj is TABAirplane then
    begin
      TABAirplane(obj).DepleteEquipments;
    end;
  end
  else if cmd = 'repair' then
  begin
    obj := engine.ObjectByName(params);
    if obj is TABAirplane then
      TABAirplane(obj).Repair;
  end
  else if cmd = 'playvoice' then
  begin
    p := Pos(' ', params);
    engine.PlayVoice(Copy(params, 1, p - 1), Copy(params, p + 1, MaxInt));
  end
  else if cmd = 'playsound' then
  begin
    engine.PlaySound('', params);
  end
  else if cmd = 'play2dsound' then
  begin
    engine.Play2DSound(params);
  end
  else if cmd = 'playmusic' then
  begin
    engine.PlayMusic(params, False);
  end
  else if cmd = 'playmusicloop' then
  begin
    engine.PlayMusic(params, True);
  end
  else if cmd = 'camera' then
  begin
    sl := TStringList.Create;
    sl.CommaText := params;
    viewerCam := engine.ViewerCams[StrToInt(sl[0])];
    if sl.Values['Mobile'] <> '' then
      viewerCam.MobileName := sl.Values['Mobile'];
    if sl.Values['Mode'] <> '' then
      viewerCam.SetCamMode(sl.Values['Mode']);
    if sl.Values['ChaseOffset'] <> '' then
      viewerCam.ChaseOffset := StringToVector3(sl.Values['ChaseOffset']);
    if sl.Values['FreePosition'] <> '' then
      viewerCam.FreePosition := StringToVector3(sl.Values['FreePosition']);
    if sl.Values['FreeDirection'] <> '' then
      viewerCam.FreeDirection := StringToVector3(sl.Values['FreeDirection']);
    if sl.Values['VanityOffset'] <> '' then
      viewerCam.VanityOffset := StringToVector3(sl.Values['VanityOffset']);
    if sl.Values['Tension'] <> '' then
      viewerCam.Tension := StrToFloat(sl.Values['Tension']);
    sl.Free;
  end
  else if cmd = 'logmessage' then
  begin
    engine.AddMessage(params, nil, nil);
  end
  else if cmd = 'enableui' then
  begin
    engine.EnableUI(True);
  end
  else if cmd = 'disableui' then
  begin
    engine.EnableUI(False);
  end
  else if cmd = 'delaycountdown' then
  begin
    engine.GameEndCountDown := engine.GameEndCountDown + StrToFloat(params)
  end
  else if cmd = 'load' then
  begin
    s := TFileStream.Create(params, fmOpenRead);
    sl := TStringList.Create;
    try
      sl.LoadFromStream(s);
      PreProcessor(sl);
      engine.AddFromStrings(sl);
    finally
      sl.Free;
      s.Free;
    end;
  end
  else if cmd = 'remove' then
  begin
    obj := engine.ObjectByName(params);
    obj.Free;
  end
  else if cmd = 'gameover' then
  begin
    engine.Completed;
  end
  else
    Assert(False, 'Unknown action command ' + cmd);
end;

end.
