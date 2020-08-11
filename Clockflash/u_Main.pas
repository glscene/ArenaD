unit u_Main;

interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Graphics,
  Vcl.Buttons,
  Vcl.StdCtrls,

  u_Flash;

type
  TForm1 = class(TForm)
    sb: TStatusBar;
    Timer1: TTimer;
    Panel2: TPanel;
    Image1: TImage;
    Image5: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Image2: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Image3: TImage;
    Label5: TLabel;
    pb_1: TImage;
    pb_2: TImage;
    pb_4: TImage;
    pb_3: TImage;
    pb_5: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Label3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  public
    flash: c_FLash;
    vr, vl: single;
    procedure onFSCommand(a_Sender: TObject; const c, a: WideString);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//
procedure TForm1.FormCreate;
begin

  flash := c_FLash.Create(self);
  flash.Align := alClient;
  flash.onFSCommand := onFSCommand;
  flash.loadFromFile('clockflash.swf', 'scale=noScale&salign=TL');

  // play mp3:
  // path, local or net /ex: my.mp3, http://mysite.com/my.mp3
  // start pos, in seconds /ex: 0, 3, 15.5
  // volume, 0 to 1(100%), 2 = 200% ...
  flash.func('p2f_playMP3', ['http://glasm.ru/audio/koan.mp3', 0, 1]);
  vr := 0;
  vl := 0;

  flash.func('p2f_newText', ['Clock Flash']);

  Panel2.DoubleBuffered := true;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  flash.Invalidate;
end;

procedure TForm1.onFSCommand;
var
  t: TStringList;
  i, j, m, n: Integer;
  f: single;

begin
  t := TStringList.Create;
  t.Delimiter := '¦';
  t.DelimitedText := a;

  if c = 'f2p_SomeInfo' then
  begin

    if t.Count = 4 then
      sb.SimpleText := 'stage size: ' + t[0] + ' x ' + t[1] +
        ' [800x600] / mouse pos: ' + t[2] + ' x ' + t[3];
  end
  else if c = 'f2p_MP3Info' then
  begin

    if trystrtoint(t[2], m) and trystrtoint(t[3], n) and (m > 0) then
    begin

      f := n / m;
      pb_1.Width := round(167 * f);

      if trystrtoint(t[0], i) and trystrtoint(t[1], j) then
      begin
        f := j / i * f;
        pb_2.Width := round(167 * f);
        Label5.Caption := format('%.2f%%', [f * 100]);
      end;

    end;

    if trystrtoint(t[4], i) then
    begin
      pb_3.Width := round(i * 8.35);
      Label3.Caption := inttostr(i * 10) + '%';
    end;

    if trystrtoint(t[5], i) then
      if i > vl then
        vl := i;

    if trystrtoint(t[6], i) then
      if i > vr then
        vr := i;

  end
  else if c = 'f2p_mp3Complete' then
  begin
    flash.func('p2f_playMP3', ['http://hourtv.ru/koan_odysseus.mp3', 0, 1]);
  end;
  t.Free;
end;

procedure TForm1.Timer1Timer;
begin
  flash.func('p2f_getSomeInfo', []);
  flash.func('p2f_getMP3Info', []);

  vl := vl * 0.9;
  pb_4.Width := round(1.67 * vl / 8) * 8;
  vr := vr * 0.9;
  pb_5.Width := round(1.67 * vr / 8) * 8;

end;

procedure TForm1.Label3MouseDown;
begin
  flash.func('p2f_setVolume', [X / 83]);
end;

procedure TForm1.Label5MouseDown;
begin
  flash.func('p2f_setPos', [X / 167]);
end;

end.
