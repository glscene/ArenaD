// MRQZZZ 2003
// Simple fire/smoke effect class
// (surely needs many improvements..)

unit UFireFxBase;

interface

Uses
  Windows, Classes, SysUtils, JPeg,
   
  GLS.Scene, GLS.VectorFileObjects, GLS.Objects, GLS.Sound, GLS.Texture,
  GLS.VectorGeometry, GLS.VectorTypes, GLS.Material;

Type
  TFireFxSprite = class(TGLSprite)
    { TFireFxDummyCubeBase }
  public
    FxtkStarted: integer;
    Fxspeed: TVector3f;
    FxMatRepeats: integer;
    FxtkMatRepeated: integer;
  end;

  // Base Fire/Smoke/Particle effect emitter class
Type
  TFireFxDummyCubeBase = class(TGLDummyCube)
  private
    FFxSpritesCount: integer;
    FFxMatLib: TGLMaterialLibrary;
    FFxEnabled: boolean;
    mustDisable: boolean;
    procedure SetFxSpritesCount(const Value: integer);
    procedure SetFxMatLib(const Value: TGLMaterialLibrary);
    procedure destroyAllSprites;
    procedure SetFxEnabled(const Value: boolean);
  public
    FxMatIndexStart: integer;
    // start index of Material  in the Material library
    FxMatIndexEnd: integer; // End index of Material  in the Material library
    FxMatIndexIncCoeff: single;
    // animation increment (from FxMatIndexStart to FxMatIndexEnd). FxMatIndexIncCoeff * (GetTickCount-StartTk) := Deltaindex
    FxMatRepeatCount: integer;
    // how many times we must restart from FxMatIndexStart

    FxSpritesParentObject: TGLBaseSceneObject; // Parent of emitted sprites
    FxSpritesList: TList;

    FXStartSize: TVector3f;
    FXDeltaSize: TVector3f;

    FXStartRotation: single;
    FXDeltaRotation: single;

    FXStartSpeed: TVector3f;
    FXDeltaSpeed: TVector3f;

    FXAccel: TVector3f;

    FxtkStarted: integer; // TickCount when started

    FXLifeLength: integer; // in milliseconds

    FxTkEmissiondelay: integer;
    // in milliseconds : delay between each sprite emission
    FxTkUpdatedelay: integer;
    // in milliseconds : delay between each sprite update (animation,position)

    FXTKLastEmission: integer; // TickCount when emitted last sprite
    FXTKLastUpdate: integer; // TickCount when done last update to sprites

    FxCurrenTGLSpriteIndex: integer;

    constructor Create(ParentObject, SpritesParentObject: TGLBaseSceneObject;
      AOwner: TComponent); overload;
    destructor destroy; override;
    procedure FxAdvance; virtual;
    property FxSpritesCount: integer read FFxSpritesCount
      write SetFxSpritesCount;
    property FxMatLib: TGLMaterialLibrary read FFxMatLib write SetFxMatLib;
    property FxEnabled: boolean read FFxEnabled write SetFxEnabled;

  end;

var
  IsClient: boolean = false;
  YHeadOffset: single;

implementation

constructor TFireFxDummyCubeBase.Create(ParentObject, SpritesParentObject
  : TGLBaseSceneObject; AOwner: TComponent);
begin
  inherited Create(AOwner);
  ParentObject.AddChild(self);
  FxSpritesParentObject := SpritesParentObject;
  FxSpritesList := TList.Create;
  FFxSpritesCount := 0;
  FxTkEmissiondelay := 60;
  FxTkUpdatedelay := 20;
  FXLifeLength := 1000;
  MakeVector(FXAccel, 0, 0, 0);
  MakeVector(FXStartSpeed, 0, 0, 0);
  MakeVector(FXStartSize, 1, 1, 0);
  MakeVector(FXDeltaSize, 1, 1, 1);
  FxMatIndexIncCoeff := 0.01;
  FxMatRepeatCount := 1;
  FXStartRotation := -1;
  FXDeltaRotation := 0.1;
  FxCurrenTGLSpriteIndex := 0;
  FxEnabled := false;
end;

destructor TFireFxDummyCubeBase.destroy;
begin
  destroyAllSprites;
  inherited;
end;

procedure TFireFxDummyCubeBase.destroyAllSprites;
var
  t: integer;
  sp: TFireFxSprite;
begin
  for t := FxSpritesList.Count - 1 downto 0 do
  begin
    sp := TFireFxSprite(FxSpritesList[t]);
    sp.Parent.Remove(sp, false);
    sp.Free;
    FxSpritesList.Delete(t);
  end;
  inherited;
end;

// -----------
// ADVANCE
// -----------
procedure TFireFxDummyCubeBase.FxAdvance;
var
  tk, dTk: integer;
  sp: TFireFxSprite;
  P: TVector4F;
  t: integer;
  MatIdx: integer;
begin
  tk := GetTickCount;

  // EMIT NEW SPRITE ?
  if (tk - FXTKLastEmission >= FxTkEmissiondelay) and (not mustDisable) then
  begin
    inc(FxCurrenTGLSpriteIndex);
    if FxCurrenTGLSpriteIndex > FxSpritesList.Count - 1 then
      FxCurrenTGLSpriteIndex := 0;
    sp := TFireFxSprite(FxSpritesList[FxCurrenTGLSpriteIndex]);
    sp.BeginUpdate;
    P := self.AbsolutePosition;
    sp.Position.SetPoint(P.X, P.Y, P.Z);
    sp.FxtkStarted := tk;
    sp.FxtkMatRepeated := tk;
    sp.Fxspeed := FXStartSpeed;
    sp.FxMatRepeats := 1;
    sp.Width := FXStartSize.X;
    sp.Height := FXStartSize.Y;
    sp.Visible := true;
    if FXStartRotation = -1 then
      sp.Rotation := random * 360
    else
      sp.Rotation := FXStartRotation;

    // sp.EndUpdate;
    FXTKLastEmission := tk;
  end;

  // Positions/Animations updates
  dTk := tk - FXTKLastUpdate;
  if dTk >= FxTkUpdatedelay then
  begin
    for t := 0 to FxSpritesList.Count - 1 do
    begin
      sp := TFireFxSprite(FxSpritesList[t]);
      if sp.Visible then
      begin
        // sp.BeginUpdate;

        // UPDATE SPEED
        VectorAdd(FXAccel, sp.Fxspeed, sp.Fxspeed);
        VectorScale(sp.Fxspeed, dTk * 0.001 * random, sp.Fxspeed);

        // UPDATE POS
        P := sp.Position.AsVector;
        sp.Position.SetPoint(P.X + sp.Fxspeed.X, P.Y + sp.Fxspeed.Y,
          P.Z + sp.Fxspeed.Z);

        // Update size
        sp.Width := sp.Width + (FXDeltaSize.X * dTk);
        sp.Height := sp.Height + (FXDeltaSize.Y * dTk);

        // Update Rotation
        sp.Rotation := sp.Rotation + (FXDeltaRotation * dTk * (random));

        // UPDATE MATERIAL
        MatIdx := FxMatIndexStart +
          Round(FxMatIndexIncCoeff * (tk - sp.FxtkMatRepeated));
        if MatIdx > FxMatIndexEnd then
        begin
          inc(sp.FxMatRepeats);
          if sp.FxMatRepeats > FxMatRepeatCount then
          begin
            sp.Visible := false; // Sprite dies
          end
          else
            MatIdx := FxMatIndexStart;

          MatIdx := FxMatIndexEnd;
          sp.FxtkMatRepeated := tk;
        end;
        sp.Material.LibMaterialName := sp.Material.MaterialLibrary.Name[MatIdx];
        // sp.EndUpdate;
      end;
    end;
    FXTKLastUpdate := tk;
  end;
end;

procedure TFireFxDummyCubeBase.SetFxEnabled(const Value: boolean);
var
  t: integer;
  sp: TFireFxSprite;
  P: TVector4F;
begin
  if (not Value) then
  begin
    mustDisable := true;
    { for t := FxSpritesList.Count-1 downto 0 do
      begin
      sp := TFireFxSprite(FxSpritesList[t]);
      sp.Visible := false;
      end; }
  end
  else if (not FFxEnabled) and Value then
  begin
    mustDisable := false;
    FXTKLastUpdate := GetTickCount;
  end;
  FFxEnabled := Value;
end;

procedure TFireFxDummyCubeBase.SetFxMatLib(const Value: TGLMaterialLibrary);
var
  t: integer;
  sp: TFireFxSprite;
begin
  FFxMatLib := Value;
  for t := FxSpritesList.Count - 1 downto 0 do
  begin
    sp := TFireFxSprite(FxSpritesList[t]);
    sp.Material.MaterialLibrary := FFxMatLib;
  end;
end;

procedure TFireFxDummyCubeBase.SetFxSpritesCount(const Value: integer);
var
  t: integer;
  sp: TFireFxSprite;
begin
  destroyAllSprites;
  FFxSpritesCount := Value;

  for t := 0 to FFxSpritesCount - 1 do
  begin
    sp := TFireFxSprite(FxSpritesParentObject.AddNewChild(TFireFxSprite));
    FxSpritesList.Add(sp);
    sp.MirrorU := true;
    sp.Visible := false;
  end;

  SetFxMatLib(FFxMatLib);
end;

end.
