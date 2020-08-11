//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Unit1.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "GLAnimatedSprite"
#pragma link "GLAsyncTimer"
#pragma link "GLBaseClasses"
#pragma link "GLBitmapFont"
#pragma link "GLCadencer"
#pragma link "GLCoordinates"
#pragma link "GLCrossPlatform"
#pragma link "GLFireFX"
#pragma link "GLHUDObjects"
#pragma link "GLMaterial"
#pragma link "GLObjects"
#pragma link "GLS.ParticleFX"
#pragma link "GLPerlinPFX"
#pragma link "GLScene"
#pragma link "GLSpaceText"
#pragma link "GLWin32Viewer"
#pragma link "GLWindowsFont"
#pragma resource "*.dfm"
TForm4 *Form4;
bool _shift; // индикатор нажатия любой кнопки "мыша"
int _mx,_my;      // предыдущие координаты "мыша"
float _zoom;       //
//---------------------------------------------------------------------------
__fastcall TForm4::TForm4(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm4::FormMouseWheel(TObject *Sender, TShiftState Shift, int WheelDelta,
          TPoint &MousePos, bool &Handled)
{
 _zoom = WheelDelta/120; // запоминаем положение колёсика "мыша"
}
//---------------------------------------------------------------------------
