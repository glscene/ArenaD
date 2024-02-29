unit UABVoice;

(* Voice playback support *)

interface

uses
  System.Classes,
  Sounds.FMOD,
  FMOD.Types,
  FMOD.Import;

type

  // TVoice
  //
  TVoice = class(TObject)
  private
    { Private Properties }
    FSamples, FTextQueue: TStringList;
    FChannel: Integer;
    FSoundSample: PFSoundSample;
    FSampleData: String;
    FBaseFrequency: Integer;
    FSampleStopPlayAt: Cardinal;
    FVolume: Single;

  protected
    { Protected Properties }

  public
    { Public Properties }
    constructor Create(const fileName: String);
    destructor Destroy; override;

    procedure Progress;
    procedure Speak(const text: String);
    procedure Stop;
    procedure Pause;
    procedure Resume;

    property Samples: TStringList read FSamples;
    property Channel: Integer read FChannel;
    property SoundSample: PFSoundSample read FSoundSample;
    property BaseFrequency: Integer read FBaseFrequency;
    property Volume: Single read FVolume write FVolume;
  end;

  // ------------------------------------------------------------------
  // ------------------------------------------------------------------
  // ------------------------------------------------------------------
implementation

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

uses
  System.SysUtils,
  GLS.ApplicationFileIO;

// ------------------
// ------------------ TVoice ------------------
// ------------------

// Create
//
constructor TVoice.Create(const fileName: String);
var
  s: TStream;
begin
  Volume := 1;
  FTextQueue := TStringList.Create;

  s := TFileStream.Create(fileName + '.voice', fmOpenRead);
  FSamples := TStringList.Create;
  FSamples.LoadFromStream(s);
  FBaseFrequency := StrToIntDef(FSamples.Values['!Frequency'], 16000);
  s.Free;

  s := TFileStream.Create(fileName + '.mp3', fmOpenRead);
  SetLength(FSampleData, s.Size);
  s.Read(FSampleData[1], s.Size);
  s.Free;

  FSoundSample := FSOUND_Sample_Load(FSOUND_FREE, PAnsiChar(@FSampleData[1]),
    { FSOUND_8BITS or } FSOUND_MONO or FSOUND_HW2D or FSOUND_LOOP_OFF or
    FSOUND_LOADMEMORY, 0, Length(FSampleData));
  FChannel := -1;
end;

// Destroy
//
destructor TVoice.Destroy;
begin
  inherited;
  if FChannel <> -1 then
    FSOUND_StopSound(FChannel);
  if Assigned(FSoundSample) then
    FSOUND_Sample_Free(FSoundSample);

  FSamples.Free;
  FTextQueue.Free;
end;

// Progress
//
procedure TVoice.Progress;
var
  txt: String;
  p: Integer;
  start, len: Single;
  voiceSamplePlayed: Boolean;
begin
  if FChannel <> -1 then
    voiceSamplePlayed := (not FSOUND_IsPlaying(FChannel)) or
      (FSOUND_GetCurrentPosition(FChannel) > FSampleStopPlayAt)
  else
    voiceSamplePlayed := True;

  if FTextQueue.Count = 0 then
  begin
    if (FChannel <> -1) and voiceSamplePlayed then
    begin
      FSOUND_StopSound(FChannel);
      FChannel := -1;
    end;
  end
  else
  begin
    if (FChannel <> -1) and (not voiceSamplePlayed) then
      Exit;
    txt := FTextQueue[0];
    FTextQueue.Delete(0);
    txt := FSamples.Values[txt];
    if txt <> '' then
    begin
      p := Pos(',', txt);
      start := StrToFloat(Copy(txt, 1, p - 1));
      len := StrToFloat(Copy(txt, p + 1, MaxInt));
      if FChannel = -1 then
        FChannel := FSOUND_PlaySound(FSOUND_FREE, FSoundSample);
      FSOUND_SetCurrentPosition(FChannel, Round(start * BaseFrequency));
      FSOUND_SetVolume(FChannel, Round(Volume * 255));
      FSampleStopPlayAt := Round((start + len) * BaseFrequency);
    end;
  end;
end;

// Speak
//
procedure TVoice.Speak(const text: String);
begin
  FTextQueue.Add(text);
end;

// Stop
//
procedure TVoice.Stop;
begin
  if FChannel <> -1 then
  begin
    FSOUND_StopSound(FChannel);
    FChannel := -1;
    FTextQueue.Clear;
  end;
end;

// Pause
//
procedure TVoice.Pause;
begin
  if FChannel <> -1 then
    FSOUND_SetPaused(FChannel, True);
end;

// Resume
//
procedure TVoice.Resume;
begin
  if FChannel <> -1 then
    FSOUND_SetPaused(FChannel, False);
end;

end.
