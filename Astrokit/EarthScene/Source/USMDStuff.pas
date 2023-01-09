// VARIOUS MDL utility functions
// by Mrqzzz

unit USMDStuff;

// LoadQC Examples:
//
// 1) LoadQC('C:\KazeXtreme2\KazeXtreme2.qc',Actor1,True);  <-- Loads the first body found in .QC and animation sequences.
// 2) LoadQC('C:\KazeXtreme2\KazeXtreme2.qc',Actor1,True,'template_urban2');        <-- Loads in Actor1 the body "template_urban2" found in .QC and animation sequences.
// LoadQC('C:\KazeXtreme2\KazeXtreme2.qc',Actor2,True, 'template_urban2_pack');  <-- Loads in Actor2 the body "template_urban2_pack" found in .QC and animation sequences.
// Use "Actor2.Synchronize(Actor1)" when you switch between Actor1's animations

interface

uses
  System.Classes,
  System.SysUtils,
  System.Math,

  GLS.Scene,
  GLS.Coordinates,
  GLS.VectorLists,
  GLS.VectorFileObjects,
  GLS.VectorGeometry,
  GLS.VectorTypes;

// LOADING STUFF
procedure LoadQC(QCFilename: string; Ac: TGLActor; LoadReference: Boolean;
  LoadAnimations: Boolean; BodyName: string = '');

// BONES STUFF
procedure GetIdealBoneRotationLookingAt(Ac: TGLActor; BoneIndex: integer;
  YCenterOffset: single; AbsolutePosition: TVector4f; var aa, bb, cc: single);
procedure RotateBone(Ac: TGLActor; BoneIndex: integer; aa, bb, cc: single;
  SlowerCoeff: single; Maxaa, Minaa, Maxbb, Minbb, Maxcc, Mincc: single);
function GetBoneIndexByName(Ac: TGLActor; BoneName: string): integer;

implementation

function Get_String_From1_From2_To1(st: string;
  From1, From2, To1: string): string;
var
  P1, p2, p3: integer;
  ltot: integer;
begin
  ltot := Length(st);
  Result := '';
  P1 := pos(From1, st);
  if P1 > 0 then
  begin
    P1 := P1 + Length(From1);
    p2 := pos(From2, Copy(st, P1, ltot));
    if p2 > 0 then
    begin
      p2 := p2 + Length(From2) + P1 - 1;
      p3 := pos(To1, Copy(st, p2, ltot));
      if p3 > 0 then
      begin
        Result := Copy(st, p2, p3 - 1);
      end;
    end;
  end;
end;

procedure LoadQC(QCFilename: string; Ac: TGLActor; LoadReference: Boolean;
  LoadAnimations: Boolean; BodyName: string = '');
var
  cwd: string;
  Pth: string;
  Stl: TstringList;
  st: string;
  stAnimName: string;
  t: integer;
begin
  Pth := ExtractFilePath(QCFilename);
  cwd := GetCurrentDir;
  Stl := TstringList.create;
  Try
    Stl.LoadFromFile(QCFilename);
    SetCurrentDir(Pth);

    // Body---------------------------------
    if LoadReference then
    begin
      if BodyName = '' then
      begin
        st := Trim(Get_String_From1_From2_To1(Stl.Text, '$bodygroup ',
          'studio "', '"'));
        st := StringReplace(st, '/', '\', [rfReplaceAll]);
        st := ExtractFileName(st);
      end
      else
        st := BodyName;
      Ac.LoadFromFile(st + '.smd');
    end;

    if LoadAnimations then
    begin
      // Sequences-----------------------------
      for t := 0 to Stl.Count - 1 do
      begin
        if pos('$sequence ', Stl[t]) = 1 then
        begin
          stAnimName := Trim(Get_String_From1_From2_To1(Stl[t], '$',
            'sequence ', ' "'));
          // Ususlly there are 2 sequences on a line
          st := Trim(Get_String_From1_From2_To1(Stl[t], '$sequence ',
            ' "', '"'));
          if st <> '' then
            Ac.AddDataFromFile(st + '.smd');
          st := Trim(Get_String_From1_From2_To1(Stl[t], '$sequence ',
            '" "', '"'));
          if st <> '' then
            Ac.AddDataFromFile(st + '.smd');
          Ac.Animations[Ac.Animations.Count - 1].Name := stAnimName;
          Ac.Animations[Ac.Animations.Count - 1].MakeSkeletalTranslationStatic;
        end;
      end;
    end;

  finally
    Stl.Free;
    SetCurrentDir(cwd);
  end;
end;

procedure GetIdealBoneRotationLookingAt(Ac: TGLActor; BoneIndex: integer;
  YCenterOffset: single; AbsolutePosition: TVector4f; var aa, bb, cc: single);
var
  AcAp: TVector4f;
  V4: TVector4f;
  V3: Tvector3f;
  VC: Tvector3f;
  cs: single;
  hh: single;
  vl: single;
begin
  AcAp := Ac.AbsolutePosition;

  // ---------------HORIZONLTAL ANGLE-----------------------
  // -------------------------------------------------------
  V4.X := AbsolutePosition.X;
  V4.Y := AcAp.Y;
  V4.Z := AbsolutePosition.Z;
  VectorSubtract(Ac.AbsolutePosition, V4, V3);
  // Get Cosine
  cs := VectorAngleCosine(Ac.Up.AsAffineVector, V3);
  aa := ArcCosine(cs);
  // Get Cross Product
  VectorCrossProduct(V3, Ac.Up.AsAffineVector, VC);
  if VC.Y > 0 then
    aa := -aa;

  // ---------------VERTICAL ANGLES-----------------------
  // -------------------------------------------------------
  V4.X := AbsolutePosition.X;
  V4.Y := AbsolutePosition.Y + YCenterOffset;
  V4.Z := AbsolutePosition.Y;
  VectorSubtract(V4, Ac.AbsolutePosition, V3);
  vl := VectorLength(V3);
  V3.X := (Ac.Up.X * vl);
  V3.Y := V3.Y;
  V3.Z := (Ac.Up.Z * vl);

  // Get Cosine
  cs := VectorAngleCosine(Ac.Up.AsAffineVector, V3);
  hh := ArcCosine(cs);
  SinCosine(aa, bb, cc);
  cc := hh * cc;
  bb := -hh * bb;

  // Correct angles
  if V3.Y > 0 then
    cc := -cc;
  if V3.Y > 0 then
    bb := -bb;

end;

procedure RotateBone(Ac: TGLActor; BoneIndex: integer; aa, bb, cc: single;
  SlowerCoeff: single; Maxaa, Minaa, Maxbb, Minbb, Maxcc, Mincc: single);
var
  BoneRotation: Tvector3f;
  BoneFrame: TGLSkeletonFrame;
  t: integer;
begin
  for t := Ac.Animations.FindName(Ac.CurrentAnimation)
    .StartFrame to Ac.Animations.FindName(Ac.CurrentAnimation).EndFrame do
  begin
    BoneFrame := Ac.Skeleton.Frames[t];
    BoneRotation := BoneFrame.Rotation.Items[BoneIndex];

    if (aa < Minaa) then
      aa := Minaa
    else if (aa > Maxaa) then
      aa := Maxaa;
    BoneRotation.X := BoneRotation.X + ((aa - BoneRotation.X) * SlowerCoeff);

    if (bb < Minbb) then
      bb := Minbb
    else if (bb > Maxbb) then
      bb := Maxbb;
    BoneRotation.Y := BoneRotation.Y + ((bb - BoneRotation.Y) * SlowerCoeff);

    if (cc < Mincc) then
      cc := Mincc
    else if (cc > Maxcc) then
      cc := Maxcc;
    BoneRotation.Z := BoneRotation.Z + ((cc - BoneRotation.Z) * SlowerCoeff);

    BoneFrame.Rotation.Items[BoneIndex] := BoneRotation;
  end;
end;

function GetBoneIndexByName(Ac: TGLActor; BoneName: string): integer;
var
  t: integer;
begin
  Result := -1;
  // WHY CAN'T WE GET THE BONES COUNT ?!?!?
  try
    for t := 0 to 99 { Ac.Skeleton.RootBones.Count-1 } do
    begin
      if Ac.Skeleton.BoneByID(t).Name = BoneName then
      begin
        Result := t;
        Break;
      end;

    end;
  except
  end;
end;

end.
