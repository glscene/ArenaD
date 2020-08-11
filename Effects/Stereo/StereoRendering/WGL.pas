unit WGL;
{ Converted from wingdi.h (Microsoft PlatformSDK)}
interface

uses
  Windows;

// OpenGL wgl prototypes
type
  PROC = pointer;

  _POINTFLOAT = packed record
    x, y: single;
  end;
  POINTFLOAT = _POINTFLOAT;
  TPointFloat = _POINTFLOAT;
  PPointFloat = ^_POINTFLOAT;

  _GLYPHMETRICSFLOAT = packed record
     gmfBlackBoxX,
     gmfBlackBoxY: single;
     gmfptGlyphOrigin: TPointFloat;
     gmfCellIncX,
     gmfCellIncY: single;
  end;
  GLYPHMETRICSFLOAT = _GLYPHMETRICSFLOAT;
  TGlyphMetricsFloat = _GLYPHMETRICSFLOAT;
  PGlyphMetricsFloat = ^_GLYPHMETRICSFLOAT;

function wglCopyContext (p1: HGLRC; p2: HGLRC; p3: UINT): BOOL; stdcall;
function wglCreateContext (p1: HDC): HGLRC; stdcall;
function wglCreateLayerContext (p1: HDC; p2: integer): HGLRC; stdcall;
function wglDeleteContext (p1: HGLRC): BOOL; stdcall;
function wglGetCurrentContext (): HGLRC; stdcall;
function wglGetCurrentDC (): HDC; stdcall;
function wglGetProcAddress (p1: LPCSTR): PROC; stdcall;
function wglMakeCurrent (p1: HDC; p2: HGLRC): BOOL; stdcall;
function wglShareLists (p1: HGLRC; p2: HGLRC): BOOL; stdcall;
function wglUseFontBitmaps (p1: HDC; p2, p3, p4: DWORD): BOOL; stdcall;
function wglUseFontBitmapsA (p1: HDC; p2, p3, p4: DWORD): BOOL; stdcall;
function wglUseFontBitmapsW (p1: HDC; p2, p3, p4: DWORD): BOOL; stdcall;

const
  WGL_FONT_LINES      = 0;
  WGL_FONT_POLYGONS   = 1;

function wglUseFontOutlines(p1: HDC; p2, p3, p4: DWORD; p5, p6: single; p7: integer; p8: PGLYPHMETRICSFLOAT): BOOL; stdcall;
function wglUseFontOutlinesA(p1: HDC; p2, p3, p4: DWORD; p5, p6: single; p7: integer; p8: PGLYPHMETRICSFLOAT): BOOL; stdcall;
function wglUseFontOutlinesW(p1: HDC; p2, p3, p4: DWORD; p5, p6: single; p7: integer; p8: PGLYPHMETRICSFLOAT): BOOL; stdcall;

type
  tagLAYERPLANEDESCRIPTOR = packed record
    nSize: WORD;
    nVersion: WORD;
    dwFlags: DWORD;
    iPixelType: BYTE;
    cColorBits: BYTE;
    cRedBits: BYTE;
    cRedShift: BYTE;
    cGreenBits: BYTE;
    cGreenShift: BYTE;
    cBlueBits: BYTE;
    cBlueShift: BYTE;
    cAlphaBits: BYTE;
    cAlphaShift: BYTE;
    cAccumBits: BYTE;
    cAccumRedBits: BYTE;
    cAccumGreenBits: BYTE;
    cAccumBlueBits: BYTE;
    cAccumAlphaBits: BYTE;
    cDepthBits: BYTE;
    cStencilBits: BYTE;
    cAuxBuffers: BYTE;
    iLayerPlane: BYTE;
    bReserved: BYTE;
    crTransparent: COLORREF;
  end;
  LAYERPLANEDESCRIPTOR = tagLAYERPLANEDESCRIPTOR;
  TLayerPlaneDescriptor = tagLAYERPLANEDESCRIPTOR;
  PLayerPlaneDescriptor = ^tagLAYERPLANEDESCRIPTOR;

const
  // LAYERPLANEDESCRIPTOR flags
  LPD_DOUBLEBUFFER        = $00000001;
  LPD_STEREO              = $00000002;
  LPD_SUPPORT_GDI         = $00000010;
  LPD_SUPPORT_OPENGL      = $00000020;
  LPD_SHARE_DEPTH         = $00000040;
  LPD_SHARE_STENCIL       = $00000080;
  LPD_SHARE_ACCUM         = $00000100;
  LPD_SWAP_EXCHANGE       = $00000200;
  LPD_SWAP_COPY           = $00000400;
  LPD_TRANSPARENT         = $00001000;

  LPD_TYPE_RGBA        = 0;
  LPD_TYPE_COLORINDEX  = 1;

  // wglSwapLayerBuffers flags
  WGL_SWAP_MAIN_PLANE     = $00000001;
  WGL_SWAP_OVERLAY1       = $00000002;
  WGL_SWAP_OVERLAY2       = $00000004;
  WGL_SWAP_OVERLAY3       = $00000008;
  WGL_SWAP_OVERLAY4       = $00000010;
  WGL_SWAP_OVERLAY5       = $00000020;
  WGL_SWAP_OVERLAY6       = $00000040;
  WGL_SWAP_OVERLAY7       = $00000080;
  WGL_SWAP_OVERLAY8       = $00000100;
  WGL_SWAP_OVERLAY9       = $00000200;
  WGL_SWAP_OVERLAY10      = $00000400;
  WGL_SWAP_OVERLAY11      = $00000800;
  WGL_SWAP_OVERLAY12      = $00001000;
  WGL_SWAP_OVERLAY13      = $00002000;
  WGL_SWAP_OVERLAY14      = $00004000;
  WGL_SWAP_OVERLAY15      = $00008000;
  WGL_SWAP_UNDERLAY1      = $00010000;
  WGL_SWAP_UNDERLAY2      = $00020000;
  WGL_SWAP_UNDERLAY3      = $00040000;
  WGL_SWAP_UNDERLAY4      = $00080000;
  WGL_SWAP_UNDERLAY5      = $00100000;
  WGL_SWAP_UNDERLAY6      = $00200000;
  WGL_SWAP_UNDERLAY7      = $00400000;
  WGL_SWAP_UNDERLAY8      = $00800000;
  WGL_SWAP_UNDERLAY9      = $01000000;
  WGL_SWAP_UNDERLAY10     = $02000000;
  WGL_SWAP_UNDERLAY11     = $04000000;
  WGL_SWAP_UNDERLAY12     = $08000000;
  WGL_SWAP_UNDERLAY13     = $10000000;
  WGL_SWAP_UNDERLAY14     = $20000000;
  WGL_SWAP_UNDERLAY15     = $40000000;

function wglDescribeLayerPlane (p1: HDC; p2, p3: integer; p4: UINT; var p5: TLayerPlaneDescriptor): BOOL; stdcall;
function wglSetLayerPaletteEntries (p1: HDC; p2, p3, p4: integer; var COLORREF): integer; stdcall;
function wglGetLayerPaletteEntries (p1: HDC; p2, p3, p4: integer; var COLORREF): integer; stdcall;
function wglRealizeLayerPalette(p1: HDC; p2: integer; p3: BOOL): BOOL; stdcall;
function wglSwapLayerBuffers(p1: HDC; p2: UINT): BOOL; stdcall;

type
  _WGLSWAP = packed record
    hdc: HDC;
    uiFlags: UINT;
  end;
  WGLSWAP = _WGLSWAP;
  TWGLSwap = _WGLSWAP;
  PWGLSwap = ^_WGLSWAP;

const
  WGL_SWAPMULTIPLE_MAX = 16;

function wglSwapMultipleBuffers (p1: UINT; var WGLSWAP): DWORD; stdcall;

implementation

const OPENGL_LIBRARY = 'opengl32.dll';

function wglCopyContext; stdcall; external OPENGL_LIBRARY;
function wglCreateContext; stdcall; external OPENGL_LIBRARY;
function wglCreateLayerContext; stdcall; external OPENGL_LIBRARY;
function wglDeleteContext; stdcall; external OPENGL_LIBRARY;
function wglGetCurrentContext; stdcall; external OPENGL_LIBRARY;
function wglGetCurrentDC; stdcall; external OPENGL_LIBRARY;
function wglGetProcAddress; stdcall; external OPENGL_LIBRARY;
function wglMakeCurrent; stdcall; external OPENGL_LIBRARY;
function wglShareLists; stdcall; external OPENGL_LIBRARY;
function wglUseFontBitmaps; stdcall; external OPENGL_LIBRARY name 'wglUseFontBitmapsA';
function wglUseFontBitmapsA; stdcall; external OPENGL_LIBRARY;
function wglUseFontBitmapsW; stdcall; external OPENGL_LIBRARY;
function wglUseFontOutlines; stdcall; external OPENGL_LIBRARY name 'wglUseFontOutlinesA';
function wglUseFontOutlinesA; stdcall; external OPENGL_LIBRARY;
function wglUseFontOutlinesW; stdcall; external OPENGL_LIBRARY;
function wglDescribeLayerPlane; stdcall; external OPENGL_LIBRARY;
function wglSetLayerPaletteEntries; stdcall; external OPENGL_LIBRARY;
function wglGetLayerPaletteEntries; stdcall; external OPENGL_LIBRARY;
function wglRealizeLayerPalette; stdcall; external OPENGL_LIBRARY;
function wglSwapLayerBuffers; stdcall; external OPENGL_LIBRARY;
function wglSwapMultipleBuffers; stdcall; external OPENGL_LIBRARY;

end.
