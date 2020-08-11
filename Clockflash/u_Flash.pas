
// glasm.ru


unit u_Flash;

interface

uses

  ActiveX, 
  System.Classes, 
  System.SysUtils, 
  Vcl.Controls, 
  ShockwaveFlashObjects_TLB, 
  zlib;


type

  c_Flash = class(TShockwaveFlash)
  private

    f_OleObj: IOleObject;

    f_loaded: Boolean;
    f_fw,f_fh,f_fc: cardinal;
    f_fr,f_fps: single;

    procedure _parsePrm(a_PrmList:string);

  protected

    procedure InitControlInterface(const Obj:IUnknown); override;

  public

    constructor Create(a_Owner:TComponent); reintroduce;

    procedure setSize(a_Width,a_Height:integer);
    procedure Invalidate; override;
    function func(a_FFunc:String; a_Args:array of const):String;

    // a_Params: http://kb2.adobe.com/cps/127/tn_12701.html

    procedure loadFromStream(a_Stream:TStream;
      a_Params:string = ''; a_FlashVars:string = '');
    procedure loadFromFile(a_FileName:string;
      a_Params:string = ''; a_FlashVars:string = '');
    procedure loadFromRes(a_ResName:string; a_ResType:string = 'SWF';
      a_Params:string = ''; a_FlashVars:string = '');

    property frameWidth: cardinal read f_fw;
    property frameHeight: cardinal read f_fh;
    property frameRate: single read f_fr;
    property frameCount: cardinal read f_fc;
    property isLoaded: Boolean read f_loaded;

    end;


implementation


// / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / /  c _ F l a s h


//                                                                  constructor
//
constructor c_Flash.Create;
begin

  inherited Create(a_Owner);
  parent := TWinControl(a_Owner);

  f_loaded := false;

end;


//                                                         InitControlInterface
//
procedure c_Flash.InitControlInterface;
begin

  f_OleObj := Obj as IOleObject;

end;


//                                                                params parser
//
procedure c_Flash._parsePrm;
var
    i,c: integer;
    t: TStringList;
    s1,s2: string;
    b: boolean;

begin

  t := TStringList.Create;
  t.Delimiter := '&';
  t.DelimitedText := a_PrmList;

  for i := 0 to t.Count - 1 do begin

    c := pos('=', t[i]);
    if c = 0 then
      continue;

    s1 := lowercase(copy(t[i], 1, c-1));
    s2 := lowercase(copy(t[i], c + 1, length(t[i])-c));

    if (s1 = 'w') or (s1 = 'width') then begin
      if trystrtoint(s2, c) then
        Width := c;
      end
    else if (s1 = 'h') or (s1 = 'height') then begin
      if trystrtoint(s2, c) then
        Height := c;
      end
    else if (s1 = 's') or (s1 = 'scale') then Scale := s2
    else if (s1 = 'a') or (s1 = 'salign') then SAlign := s2
    else if (s1 = 'q') or (s1 = 'Quality') then Quality2 := s2
    else if (s1 = 'm') or (s1 = 'wmode') then WMode := s2
    else if (s1 = 'menu') then begin
      if trystrtobool(s2, b) then
        Menu := b;
      end;

    end;

end;


//                                                                         func
//
function c_Flash.func;
var
    i: integer;
    s: string;
    fs: TFormatSettings;

  procedure addNum(t:string);
  begin
    s := s + '<number>' + t + '</number>';
    end;

  procedure addStr(t:string);
  begin
    s := s + '<string>' + t + '</string>';
    end;

begin

  s := '<invoke name="' + a_FFunc + '">';
  fs.DecimalSeparator := '.';

  if length(a_Args) > 0 then begin

    s := s + '<arguments>';

    for i := 0 to high(a_Args) do
      with a_Args[i] do
        case vType of
          vtInteger: addNum(inttostr(VInteger));
          vtBoolean: if VBoolean then addStr('true') else addStr('false');
          vtExtended: addNum(FormatFloat('0.####', VExtended^, fs));
          vtPointer: addNum(inttostr(integer(VPointer)));
          vtWideString: addStr(String(VWideString));
          vtAnsiString: addStr(String(VAnsiString));
          vtWideChar: addStr(VWideChar);
          vtChar: addStr(String(VChar));
          vtInt64: addNum(inttostr(VInt64^));
          vtString: addStr(String(VString));
        {$if CompilerVersion>18.5}
          17: addStr(String(VUnicodeString));
        {$ifend}
        end;

    s := s + '</arguments>';

    end;

  s := s + '</invoke>';

  try
    result := CallFunction(s);
  except
  end;

end;


//                                                                      setSize
//
procedure c_Flash.setSize;
begin

  width := a_Width;
  height := a_Height;

  Invalidate;

end;


//                                                                   Invalidate
//
procedure c_Flash.Invalidate;
begin

{$if CompilerVersion<16} // delphi 7
  CreateWnd;
{$ifend}

  inherited Invalidate;

end;


//                                                               LoadFromStream
//
procedure c_Flash.LoadFromStream;
type
    t_bw = 1..32;

var
    b: byte;
    sgn,p,sz: cardinal;
    ISize: int64;
    comp: boolean;
    n: TStream;
    m1,m2: TMemoryStream;
    z: TDeCompressionStream;
    pStream: IPersistStreamInit;
    sAdapt: TStreamAdapter;
    buf: array[0..24] of byte;
    plst: TStringList;

  function nb(const Buffer; pos:integer; cnt:t_bw):cardinal;
  var
      i: integer;
      c: cardinal;

  begin

    result := 0;
    c := 1 shl(cnt-1);
    for i := pos to pos + cnt - 1 do begin
      if PByteArray(@buf)^[i shr 3] and (128 shr(i and 7)) <> 0 then
      result := result or c;
      c := c shr 1;
      end;

    inc(p, cnt);

    end;

begin

  // flash get info [decompress]

  sgn := 0;
  a_Stream.Read(sgn, 3);
  comp := sgn = $535743;
  if comp then begin
    n := TMemoryStream.Create;
    sgn := $535746;
    n.Write(sgn, 3);
    n.CopyFrom(a_Stream, 1);
    a_Stream.Read(sz, 4);
    n.Write(sz, 4);
    z := TDeCompressionStream.Create(a_Stream);
    try
      n.CopyFrom(z, sz-8);
    finally
      z.free;
    end;
    n.Position := 0;
    end
  else begin
    a_Stream.Position := a_Stream.Position - 3;
    sz := a_Stream.Size - a_Stream.Position;
    n := a_Stream;
    end;

  n.Seek(8, 1);
//  n.Read(f_Len, 4);
  n.Read(buf[0], 25);
  n.Seek(-33, 1);
  p := 0;

  b := t_bw(nb(buf[0], p, 5));
  f_fw := (-nb(buf[0], p, b) + nb(buf[0], p, b)) div 20;
  f_fh := (-nb(buf[0], p, b) + nb(buf[0], p, b)) div 20;

  setSize(f_fw, f_fh);


  // framerate

  b := p and 7;
  p := p shr 3;
  if b > 0 then inc(p);
  f_fr := buf[p + 1] + buf[p] / 256;
  if f_fr > 60 then f_fr := 60;
  f_fc := buf[p + 2] or (buf[p + 3] shl 8);
//  f_dt := 1 / f_fr;
  f_fps := f_fr;


  // params

  plst := TStringList.Create;
  //_prm(plst, a_Params);


  plst.Free;

//  Scale := a_Params.scale;
//  SAlign := a_Params.salign;
//  Quality2 := a_Params.quality;
//  WMode := a_Params.wmode;

  _parsePrm(a_Params);
  //self.MovieData := a_Params;
  FlashVars := a_FlashVars;


  // init streams

  EmbedMovie := false;
  f_OleObj.QueryInterface(IPersistStreamInit, pStream);
  pStream.GetSizeMax(ISize);
  m1 := TMemoryStream.Create;
  m1.SetSize(ISize);
  sAdapt := TStreamAdapter.Create(m1);
  pStream.Save(sAdapt, true);
  sAdapt.Free;
  m1.Position := 1;


  // load

  m2 := TMemoryStream.Create;
  b := $66; m2.Write(b, 1);
  m2.CopyFrom(m1, 3);
  m2.Write(sz, 4);
  m2.CopyFrom(n, sz);
  m2.CopyFrom(m1, m1.Size - m1.Position);
  m2.Position := 0;

  sAdapt := TStreamAdapter.Create(m2);
  pStream.Load(sAdapt);
  sAdapt.Free;
  m2.Free;
  m1.Free;
  pStream := nil;

  if comp then
    n.Free;

  f_loaded := true;

end;


//                                                                 loadFromFile
//
procedure c_Flash.loadFromFile;
var
    f: TFileStream;

begin

  if not fileexists(a_FileName) then exit;

  f := TFileStream.Create(a_FileName, fmOpenRead or fmShareDenyNone);
  LoadFromStream(f, a_Params, a_FlashVars);
  f.Free;

end;


//                                                                  loadFromRes
//
procedure c_Flash.loadFromRes;
var
    p: TResourceStream;

begin

  p := TResourceStream.Create(0, a_ResName, PChar(a_ResType));
  LoadFromStream(p, a_Params, a_FlashVars);
  p.Free;

end;


end.
