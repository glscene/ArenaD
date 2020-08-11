//---------------------------------------------------------------------------

#ifndef Unit1H
#define Unit1H
//---------------------------------------------------------------------------
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Forms.hpp>
#include "GLAnimatedSprite.hpp"
#include "GLAsyncTimer.hpp"
#include "GLBaseClasses.hpp"
#include "GLBitmapFont.hpp"
#include "GLCadencer.hpp"
#include "GLCoordinates.hpp"
#include "GLCrossPlatform.hpp"
#include "GLFireFX.hpp"
#include "GLHUDObjects.hpp"
#include "GLMaterial.hpp"
#include "GLObjects.hpp"
#include "GLS.ParticleFX.hpp"
#include "GLPerlinPFX.hpp"
#include "GLScene.hpp"
#include "GLSpaceText.hpp"
#include "GLWin32Viewer.hpp"
#include "GLWindowsFont.hpp"
//---------------------------------------------------------------------------
class TForm4 : public TForm
{
__published:	// IDE-managed Components
	TGLSceneViewer *vp;
	TGLScene *GLScene1;
	TGLSpaceText *txt_gl;
	TGLSpaceText *txt_scene;
	TGLDummyCube *GLDummyCube1;
	TGLDummyCube *GLDummyCube5;
	TGLLines *GLLines1;
	TGLDummyCube *dc_fire;
	TGLDummyCube *dc_poly;
	TGLDummyCube *dc_perlin;
	TGLDummyCube *dc_plight;
	TGLDummyCube *dc_asprite;
	TGLAnimatedSprite *asprite;
	TGLParticleFXRenderer *GLParticleFXRenderer1;
	TGLHUDText *txt_fire;
	TGLHUDText *txt_plight;
	TGLHUDText *txt_perlin;
	TGLHUDText *txt_poly;
	TGLHUDText *txt_asprite;
	TGLCamera *GLCamera1;
	TGLLightSource *GLLightSource1;
	TGLCadencer *GLCadencer1;
	TGLPointLightPFXManager *GLPointLightPFXManager1;
	TGLPerlinPFXManager *GLPerlinPFXManager1;
	TGLPolygonPFXManager *GLPolygonPFXManager1;
	TGLFireFXManager *GLFireFXManager1;
	TGLAsyncTimer *AsyncTimer1;
	TGLMaterialLibrary *matlib;
	TGLWindowsBitmapFont *GLWindowsBitmapFont1;
	void __fastcall FormMouseWheel(TObject *Sender, TShiftState Shift, int WheelDelta,
          TPoint &MousePos, bool &Handled);
private:	// User declarations
public:		// User declarations
	__fastcall TForm4(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm4 *Form4;
//---------------------------------------------------------------------------
#endif
