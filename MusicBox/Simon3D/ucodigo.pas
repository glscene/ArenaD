unit ucodigo;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Winapi.MMSystem,
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Menus,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Graphics,
  Vcl.Controls,
  GLS.Scene,
  GLS.Objects,
  GLS.VectorGeometry,
  GLS.SceneViewer,
  GLS.VectorFileObjects,
  GLS.VectorTypes,
  GLS.Material,
  GLS.State,
  GLS.BitmapFont,
  GLS.WindowsFont,
  GLS.File3DS,
  GLS.HUDObjects,
  GLS.Texture,
  GLS.Coordinates,
  GLS.BaseClasses;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    DummyCube1: TGLDummyCube;
    Red1: TGLFreeForm;
    Green4: TGLFreeForm;
    Yellow3: TGLFreeForm;
    Blue2: TGLFreeForm;
    btnNextStage: TButton;
    Timer1: TTimer;
    Base1: TGLFreeForm;
    GLWindowsBitmapFont1: TGLWindowsBitmapFont;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    Jogo1: TMenuItem;
    Ajuda1: TMenuItem;
    Novo1: TMenuItem;
    Contedo1: TMenuItem;
    N1: TMenuItem;
    Sobre1: TMenuItem;
    GLLightSource1: TGLLightSource;
    GLLightSource2: TGLLightSource;
    N2: TMenuItem;
    Sair1: TMenuItem;
    N3: TMenuItem;
    Recordes1: TMenuItem;
    Exibir1: TMenuItem;
    Perspectiva1: TMenuItem;
    VistaSuperior1: TMenuItem;
    N4: TMenuItem;
    Wireframe1: TMenuItem;
    procedure LoadResourceTexture(ResourceName: String; Texture: TGLTexture);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TocaSom(Sons: String);
    procedure Roda(pedaco: TGLFreeForm);
    procedure btnNextStageClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Novo1Click(Sender: TObject);
    procedure Sobre1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure Recordes1Click(Sender: TObject);
    procedure Contedo1Click(Sender: TObject);
    procedure Perspectiva1Click(Sender: TObject);
    procedure VistaSuperior1Click(Sender: TObject);
    procedure Wireframe1Click(Sender: TObject);
  public
  end;

var
  Form1: TForm1;
  mdx, mdy: Integer;
  cor_antiga, cor_nova: TVector4f;
  cor_a, cor_n: TVector4f;
  notacerta, notaclicada: string;
  jogoiniciado: boolean;
  S1, S2, S3, S4: string;
  Pontos: Integer;
  pickdown: TGLCustomSceneObject;
  pickup: TGLCustomSceneObject;

const
  clrWhite: TGLVector = (X: 1; Y: 1; Z: 1; W: 1);

implementation

uses
  frmSobre,
  frmRecorde;

{$R *.dfm}
{$R SimonRec.RES}

procedure TForm1.LoadResourceTexture(ResourceName: String; Texture: TGLTexture);
var
  B: TBitmap;
  RS: TResourceStream;
begin
  RS := TResourceStream.Create(0, ResourceName, 'BMP');
  try
    B := TBitmap.Create;
    try
      B.LoadFromStream(RS);
      Texture.Image.Assign(B);
    finally
      B.Free;
    end;
  finally
    RS.Free;
  end;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  // if Shift<>[] then
  if Shift = [ssRight] then
    GLCamera1.MoveAroundTarget(mdy - Y, mdx - X);
  mdx := X;
  mdy := Y;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  PedacoR, BaseR: TResourceStream;     // pices for keys
  redt, bluet, yellowt, greent: TGLTexture;
begin
  redt := TGLTexture.Create(self);
  LoadResourceTexture('Red1', redt);
  bluet := TGLTexture.Create(self);
  LoadResourceTexture('Blue2', bluet);
  yellowt := TGLTexture.Create(self);
  LoadResourceTexture('Yellow3', yellowt);
  greent := TGLTexture.Create(self);
  LoadResourceTexture('Green4', greent);
  PedacoR := TResourceStream.Create(hinstance, 'pedaco', '3DS');
  BaseR := TResourceStream.Create(hinstance, 'base', '3DS');
  Red1.LoadFromStream('pedaco.3ds', PedacoR);
  Red1.Material.Texture.Image := redt.Image;
  Blue2.LoadFromStream('pedaco.3ds', PedacoR);
  Blue2.Material.Texture.Image := bluet.Image;
  Yellow3.LoadFromStream('pedaco.3ds', PedacoR);
  Yellow3.Material.Texture.Image := yellowt.Image;
  Green4.LoadFromStream('pedaco.3ds', PedacoR);
  Green4.Material.Texture.Image := greent.Image;
  Base1.LoadFromStream('base.3ds', BaseR);
  jogoiniciado := false;
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';
  Pontos := 0;
end;

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then // test if the clicked mouse button was left
  begin
    pickdown := (GLSceneViewer1.Buffer.GetPickedObject(X, Y)
      as TGLCustomSceneObject);
    if Assigned(pickdown) and (pickdown is TGLFreeForm) then
    begin
      cor_antiga := pickdown.Material.FrontProperties.Emission.Color;
      cor_nova := vectorlerp(cor_antiga, clrWhite, 0.25);
      if pickdown.Name = 'Base1' then
        pickdown.Material.FrontProperties.Emission.Color := cor_antiga
      else
        pickdown.Material.FrontProperties.Emission.Color := cor_nova;
    end;
  end;
end;

procedure TForm1.GLSceneViewer1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pedaco: string;
  tammenor, tammaior: Integer;
  Nome: string;
begin
  if Button = mbLeft then // check if the mouse button is still pressed
  begin
    pickup := (GLSceneViewer1.Buffer.GetPickedObject(X, Y)
      as TGLCustomSceneObject);
    if Assigned(pickup) then
      if (pickup = pickdown) and (pickup is TGLFreeForm) then
      begin
        pickup.Material.FrontProperties.Emission.Color := cor_antiga;
        if pickup.Name = 'Red1' then
        begin
          S1 := S1 + '1';
          // sndPlaySound('red.wav',snd_ASync);
          PlaySound('Red', hinstance, SND_RESOURCE or SND_ASYNC);
        end;
        if pickup.Name = 'Blue2' then
        begin
          S1 := S1 + '2';
          // sndPlaySound('Blue.wav',snd_ASync);
          PlaySound('Blue', hinstance, SND_RESOURCE or SND_ASYNC);
        end;
        if pickup.Name = 'Yellow3' then
        begin
          S1 := S1 + '3';
          // sndPlaySound('Yellow.wav',snd_ASync);
          PlaySound('Yellow', hinstance, SND_RESOURCE or SND_ASYNC);
        end;
        if pickup.Name = 'Green4' then
        begin
          S1 := S1 + '4';
          // sndPlaySound('Green.wav',snd_ASync);
          PlaySound('Green', hinstance, SND_RESOURCE or SND_ASYNC);
        end;
      end;
    if (pickdown is TGLFreeForm) and (pickup <> pickdown) then
    begin
      pickdown.Material.FrontProperties.Emission.Color := cor_antiga;
      if pickdown.Name = 'Red1' then
      begin
        S1 := S1 + '1';
        // sndPlaySound('red.wav',snd_ASync);
        PlaySound('Red', hinstance, SND_RESOURCE or SND_ASYNC);
      end;
      if pickdown.Name = 'Blue2' then
      begin
        S1 := S1 + '2';
        // sndPlaySound('blue.wav',snd_ASync);
        PlaySound('Blue', hinstance, SND_RESOURCE or SND_ASYNC);
      end;
      if pickdown.Name = 'Yellow3' then
      begin
        S1 := S1 + '3';
        // sndPlaySound('yellow.wav',snd_ASync);
        PlaySound('Yellow', hinstance, SND_RESOURCE or SND_ASYNC);
      end;
      if pickdown.Name = 'Green4' then
      begin
        S1 := S1 + '4';
        // sndPlaySound('green.wav',snd_ASync);
        PlaySound('Green', hinstance, SND_RESOURCE or SND_ASYNC);
      end;
    end;
    tammenor := length(S1);
    tammaior := length(S2);
    pedaco := copy(S2, 1, tammenor);
    if (jogoiniciado = true) and (CompareStr(pedaco, S1) <> 0) then
    begin
      // sndPlaySound('error.wav',snd_ASync);
      PlaySound('Error', hinstance, SND_RESOURCE or SND_ASYNC);
      jogoiniciado := false;
      btnNextStage.Visible := false;
      S3 := 'Fim de Jogo';    // show videogame
      // begins the block of records
      Application.CreateForm(TForm2, Form2); // load form into memory
      if Form2.TestaRecorde(inttostr(Pontos)) then
      begin
        Nome := InputBox('Best Scores', 'Type your name', '');
        Form2.AcrescentaRecorde(inttostr(Pontos), Nome);
        Form2.ShowModal; // show form in exclusive mode
        Form2.Free; // free memory
      end;
      // end of the block of memories
    end
    else if (tammenor = tammaior) and (jogoiniciado = true) then
    begin
      S1 := '';
      S3 := 'Stage completed';
      Inc(Pontos);
      S4 := IntToStr(Pontos) + ' Points';
      btnNextStage.Visible := true;
    end
    else
      S3 := '';
  end;
end;

Procedure TForm1.TocaSom(Sons: String);
Var
  I, K: Integer;
  J: String;
begin
  S2 := '';
  K := length(Sons);
  for I := 1 to K do
  begin
    J := Sons[I];
    if (J = '1') then
    begin
      S2 := S2 + '1';
      Roda(Red1);
    end;
    if (J = '2') then
    begin
      S2 := S2 + '2';
      Roda(Blue2);
    end;
    if (J = '3') then
    begin
      S2 := S2 + '3';
      Roda(Yellow3);
    end;
    if (J = '4') then
    begin
      S2 := S2 + '4';
      Roda(Green4);
    end;
    sleep(450);
  end;
end;

Procedure TForm1.Roda(pedaco: TGLFreeForm);
begin
  if pedaco.Name = 'Red1' then
  begin
    cor_a := Form1.Red1.Material.FrontProperties.Emission.Color;
    cor_n := VectorLerp(cor_a, clrWhite, 0.25);
    Red1.Material.FrontProperties.Emission.Color := cor_n;
    GLSceneViewer1.Update;
    sleep(50);
    Red1.Material.FrontProperties.Emission.Color := cor_a;
    // sndPlaySound('red.wav',snd_ASync);
    PlaySound('Red', hinstance, SND_RESOURCE or SND_ASYNC);
  end;
  if pedaco.Name = 'Blue2' then
  begin
    cor_a := Form1.Blue2.Material.FrontProperties.Emission.Color;
    cor_n := VectorLerp(cor_a, clrWhite, 0.25);
    Blue2.Material.FrontProperties.Emission.Color := cor_n;
    GLSceneViewer1.Update;
    sleep(50);
    Blue2.Material.FrontProperties.Emission.Color := cor_a;
    // sndPlaySound('blue.wav',snd_ASync);
    PlaySound('Blue', hinstance, SND_RESOURCE or SND_ASYNC);
  end;
  if pedaco.Name = 'Yellow3' then
  begin
    cor_a := Form1.Yellow3.Material.FrontProperties.Emission.Color;
    cor_n := vectorlerp(cor_a, clrWhite, 0.25);
    Yellow3.Material.FrontProperties.Emission.Color := cor_n;
    GLSceneViewer1.Update;
    sleep(50);
    Yellow3.Material.FrontProperties.Emission.Color := cor_a;
    // sndPlaySound('yellow.wav',snd_ASync);
    PlaySound('Yellow', hinstance, SND_RESOURCE or SND_ASYNC);
  end;
  if pedaco.Name = 'Green4' then
  begin
    cor_a := Form1.Green4.Material.FrontProperties.Emission.Color;
    cor_n := VectorLerp(cor_a, clrWhite, 0.25);
    Green4.Material.FrontProperties.Emission.Color := cor_n;
    GLSceneViewer1.Update;
    sleep(50);
    Green4.Material.FrontProperties.Emission.Color := cor_a;
    // sndPlaySound('green.wav',snd_ASync);
    PlaySound('Green', hinstance, SND_RESOURCE or SND_ASYNC);
  end;
end;

procedure TForm1.btnNextStageClick(Sender: TObject);
begin

  if jogoiniciado = true then
  begin
    btnNextStage.Visible := false;
    Randomize;
    notacerta := notacerta + inttostr(Random(4) + 1);
    TocaSom(notacerta);
    S1 := '';
    S3 := '';
  end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  // Caption:=Format('%.1f FPS', [GLSceneViewer1.FramesPerSecond]);
  GLSceneViewer1.ResetPerformanceMonitor;
  StatusBar1.Panels[0].Text := S4;
  StatusBar1.Panels[1].Text := S3;
end;

procedure TForm1.Novo1Click(Sender: TObject);
begin
  jogoiniciado := true;
  notacerta := '';
  btnNextStage.Click;
  S4 := '0 Points';
  S3 := '';
  Pontos := 0;
end;

procedure TForm1.Sobre1Click(Sender: TObject);
begin
  Application.CreateForm(TAboutBox, AboutBox);
  AboutBox.ShowModal;
  AboutBox.Free;
end;

procedure TForm1.Sair1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Recordes1Click(Sender: TObject);
begin
  Application.CreateForm(TForm2, Form2);
  Form2.ShowModal;
  Form2.Free;
end;

procedure TForm1.Contedo1Click(Sender: TObject);
begin
  // Application.HelpFile:='Simon3D.hlp';
  // Application.helpcommand(HELP_CONTENTS,0);
end;

procedure TForm1.Perspectiva1Click(Sender: TObject);
begin
  GLCamera1.Position.X := 6;
  GLCamera1.Position.Y := 6;
  GLCamera1.Position.Z := 6;
end;

procedure TForm1.VistaSuperior1Click(Sender: TObject);
begin
  GLCamera1.Position.X := 0;
  GLCamera1.Position.Y := 10;
  GLCamera1.Position.Z := 0;
  GLCamera1.MoveAroundTarget(-45, 0);
  GLSceneViewer1.Update;
end;

procedure TForm1.Wireframe1Click(Sender: TObject);
begin
  if Red1.Material.PolygonMode = pmFill then
  begin
    Red1.Material.PolygonMode := pmLines;
    Wireframe1.Checked := true;
  end
  else
  begin
    Red1.Material.PolygonMode := pmFill;
    Wireframe1.Checked := false;
  end;
  if Blue2.Material.PolygonMode = pmFill then
    Blue2.Material.PolygonMode := pmLines
  else
    Blue2.Material.PolygonMode := pmFill;
  if Yellow3.Material.PolygonMode = pmFill then
    Yellow3.Material.PolygonMode := pmLines
  else
    Yellow3.Material.PolygonMode := pmFill;
  if Green4.Material.PolygonMode = pmFill then
    Green4.Material.PolygonMode := pmLines
  else
    Green4.Material.PolygonMode := pmFill;
  if Base1.Material.PolygonMode = pmFill then
    Base1.Material.PolygonMode := pmLines
  else
    Base1.Material.PolygonMode := pmFill;
end;

end.
