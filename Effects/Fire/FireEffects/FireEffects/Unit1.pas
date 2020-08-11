////////////////////////////////////////////////////////////////////////
//                                                                    //
//  GLScene Fire Demo v1.0                                            //
//                                        - для начинающих и начавших //
//====================================================================//
//                                                                    //
// демонстрация получения "простого" огня                             //
//--------------------------------------------------------------------//
// • FireFX [TGLFireFXManager]                                        //
// • PointLightPFX [TGLPointLightPFXManager]                          //
// • PolygonPFX [TGLPolygonPFXManager]                                //
// • PerlinPFX [TGLPerlinPFXManager]                                  //
// • AnimatedSprite [TGLAnimatedSprite]                               //
//--------------------------------------------------------------------//
//                                                                    //
//  При ипользовании частиц основная сложность - куча настроек,       //
//  а для начинающих ещё и головная боль с понятием "Effect"          //
//                                                                    //
//  частицы - спрайты, обычно маленькие и много, которые двигаются по //
//  по определенному закону, задающему траекторию для каждой частицы  //
//                                                                    //
// FireFX - компонент, задающий закон распределения подобный пламени  //
//  для его реализации надо создать TGLFireFXManager из "GLScene PFX" //
//  и подключить к нему GLS.Cadencer, который будет "тикать"            //
//  теперь нужно выбрать "горящий" объект и в его параметрах выбираем //
//  Effects->Add->FireFX, далее в Manager выбираем наш...             //
//  ...всё, огонь создан и должен "гореть", остались настройки...     //
//                                                                    //
// PFX - эффекты частиц, т.е. это не огонь, а просто толпа частиц, но //
//  с более широким набором настроек и улучшенной оптимизацией, что   //
//  позволяет создать тот же эффект огня, но более динамичный         //
//  есть несколько реализаций, но я использовал три основные:         //
//  PointLightPFX, PerlinPFX, PolygonPFX                              //
//  первые две одинаковые с той лишь разницей, что во втором исполь-  //
//  зуется генерируемый Perlin-шум как текстура...                    //
//  третий - PolygonPFX - визуально угловатый многогранник            //
//  для их использования нужно сделать следующее:                     //
//  • Scene objects->Add object->Particle Systems->PFX Renderer       //
//  • создаем нужный Manager из вкладки "GLScene PFX"                 //
//  • подключаем к нему "PFX Renderer" и "тикающий" GLCadencer        //
//  • в объекте-"источнике" Effects->Add->PFX Source                  //
//  всё, "источник" создан, теперь надо выставить параметры =)        //
//                                                                    //
// AnimatedSprite - это спрайт, у которого меняются текстурные коор-  //
//  динаты во времени с повторением, создавая анимацию/мультик...     //
//  это огонь, который можно нарисовать или вырезать из видео файла   //
//                                                                    //
//--------------------------------------------------------------------//
//                                                                    //
// быстрее всех, естественно, AnimatedSprite, но требует память под   //
// текстуру огня и есть сложности в реализации анимации "горения"     //
// FireFX удобный, но тормозной и все частицы - единое целое          //
// PFX не очень удобный для тех, кто не любит лишние настройки, но    //
// дает широкие возможности с хорошей оптимизацией                   //
//                                                                    //
//====================================================================//
//                                                                    //
// Успехов в изучении!                                     GLScene.ru //
////////////////////////////////////////////////////////////////////////

unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes, System.Math,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
   
  GLS.Cadencer, GLS.Scene, GLS.Objects, GLS.AsyncTimer,
  GLS.SceneViewer, GLS.GeomObjects, GLS.HUDObjects, GLS.Texture,
  GLS.VectorTypes, GLS.SpaceText, GLS.BitmapFont, GLS.WindowsFont, GLS.VectorGeometry,
  GLS.FireFX, GLS.ParticleFX, GLS.PerlinPFX, GLS.AnimatedSprite, GLS.Material,
  GLS.Coordinates,  GLS.BaseClasses;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    GLCadencer1: TGLCadencer;
    GLCamera1: TGLCamera;
    GLPointLightPFXManager1: TGLPointLightPFXManager;
    GLParticleFXRenderer1: TGLParticleFXRenderer;
    GLPerlinPFXManager1: TGLPerlinPFXManager;
    dc_plight: TGLDummyCube;
    dc_perlin: TGLDummyCube;
    dc_poly: TGLDummyCube;
    GLPolygonPFXManager1: TGLPolygonPFXManager;
    dc_fire: TGLDummyCube;
    GLDummyCube5: TGLDummyCube;
    GLFireFXManager1: TGLFireFXManager;
    AsyncTimer1: TGLAsyncTimer;
    asprite: TGLAnimatedSprite;
    matlib: TGLMaterialLibrary;
    txt_fire: TGLHUDText;
    GLWindowsBitmapFont1: TGLWindowsBitmapFont;
    txt_plight: TGLHUDText;
    txt_perlin: TGLHUDText;
    txt_poly: TGLHUDText;
    txt_asprite: TGLHUDText;
    dc_asprite: TGLDummyCube;
    GLLines1: TGLLines;
    GLDummyCube1: TGLDummyCube;
    GLLightSource1: TGLLightSource;
    txt_gl: TGLSpaceText;
    txt_scene: TGLSpaceText;
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
  public
  end;

var
  Form1:TForm1;
  _shift:boolean=false; // индикатор нажатия любой кнопки "мыша"
  _mx,_my:Integer;      // предыдущие координаты "мыша"
  _zoom:single=0;       //

implementation

{$R *.DFM}

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  _zoom:=WheelDelta/120; // запоминаем положение колёсика "мыша"
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
var v:TVector4f;
begin
  // ярлычок для FireFX
  v:=vp.Buffer.WorldToScreen(dc_fire.AbsolutePosition);
    txt_fire.AbsolutePosition:=VectorMake(v.X,height-v.Y,0);
  // ярлычок для PointLightPFX
  v:=vp.Buffer.WorldToScreen(dc_plight.AbsolutePosition);
    txt_plight.AbsolutePosition:=VectorMake(v.X,height-v.Y,0);
  // ярлычок для PolygonPFX
  v:=vp.Buffer.WorldToScreen(dc_poly.AbsolutePosition);
    txt_poly.AbsolutePosition:=VectorMake(v.X,height-v.Y,0);
  // ярлычок для PerlinPFX
  v:=vp.Buffer.WorldToScreen(dc_perlin.AbsolutePosition);
    txt_perlin.AbsolutePosition:=VectorMake(v.X,height-v.Y,0);
  // ярлычок для AnimatedSprite
  v:=vp.Buffer.WorldToScreen(dc_asprite.AbsolutePosition);
    txt_asprite.AbsolutePosition:=VectorMake(v.X,height-v.Y,0);

  if _shift then begin
    gldummycube1.Pitch(_my-mouse.CursorPos.y); // если нажата кнопка, то
    gldummycube5.Turn(_mx-mouse.CursorPos.x);  // вращение камеры от "мыша"
    end
  else gldummycube5.Turn(deltatime*10); // иначе автоматическая ротация

    _my:=mouse.CursorPos.y; // сохраняем координаты "мыша"
    _mx:=mouse.CursorPos.x; //

  GLCamera1.AdjustDistanceToTarget(Power(1.1, _zoom));

    _zoom:=0; // обнуляем

end;

procedure TForm1.AsyncTimer1Timer(Sender: TObject);
begin
  caption:=vp.FramesPerSecondText(2); // выводим количество кадров в секунду
  vp.ResetPerformanceMonitor;         // и обнуляем счётчик
end;

procedure TForm1.vpMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  _shift:=true; // кнопка нажата
end;

procedure TForm1.vpMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  _shift:=false; // кнопка отжата
end;

end.

