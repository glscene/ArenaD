unit GLu;
{ Converted from glu.h (Microsoft PlatformSDK) }
interface
(*
** Copyright 1991-1993, Silicon Graphics, Inc.
** All Rights Reserved.
**
** This is UNPUBLISHED PROPRIETARY SOURCE CODE of Silicon Graphics, Inc.;
** the contents of this file may not be disclosed to third parties, copied or
** duplicated in any form, in whole or in part, without the prior written
** permission of Silicon Graphics, Inc.
**
** RESTRICTED RIGHTS LEGEND:
** Use, duplication or disclosure by the Government is subject to restrictions
** as set forth in subdivision (c)(1)(ii) of the Rights in Technical Data
** and Computer Software clause at DFARS 252.227-7013, and/or in similar or
** successor clauses in the FAR, DOD or NASA FAR Supplement. Unpublished -
** rights reserved under the Copyright Laws of the United States.
*)
uses
  gl;
(*
** Return the error string associated with a particular error code.
** This will return 0 for an invalid error code.
**
** The generic function prototype that can be compiled for ANSI or Unicode
** is defined as follows:
**
** LPCTSTR APIENTRY gluErrorStringWIN (GLenum errCode);
*)
type
  TArray3d    = array[0..2] of GLdouble;  PArray3d    = ^TArray3d;
  TArray4i    = array[0..3] of GLint;     PArray4i    = ^TArray4i;
  TArray4f    = array[0..3] of GLfloat;   PArray4f    = ^TArray4f;
  TArray4v    = array[0..3] of GLvoid;    PArray4v    = ^TArray4v;
  TArray16d   = array[0..15] of GLdouble; PArray16d   = ^TArray16d;
  TArray16f   = array[0..15] of GLfloat;  PArray16f   = ^TArray16f;

function gluErrorString (errCode: GLenum): PChar; stdcall;
function gluErrorUnicodeStringEXT (errCode: GLenum): PWideChar; stdcall;
function gluGetString (name: GLenum): PChar; stdcall;

procedure gluOrtho2D (left, right, bottom, top: GLdouble); stdcall;
procedure gluPerspective (fovy, aspect: GLdouble; zNear, zFar: GLdouble); stdcall;
procedure gluPickMatrix (x, y: GLdouble; width, height: GLdouble; viewport: TArray4i); stdcall;
procedure gluLookAt (eyex, eyey, eyez: GLdouble; centerx, centery, centerz: GLdouble; upx, upy, upz: GLdouble); stdcall;
function gluProject (objx, objy, objz: GLdouble; const modelMatrix: TArray16d; const projMatrix: TArray16d; const TArray4i; winx, winy, winz: PGLdouble): GLint; stdcall;
function gluUnProject (winx, winy, winz: GLdouble; const modelMatrix: TArray16d; const projMatrix: TArray16d; const viewport: TArray4i; objx, objy, objz: PGLdouble): GLint; stdcall;
function gluScaleImage (format: GLenum; widthin, heightin: GLint; typein: GLenum; const datain: GLvoid; widthout, heightout: GLint; typeout: GLenum; dataout: GLvoid): GLint; stdcall;
function gluBuild1DMipmaps (target: GLenum; components: GLint; width: GLint; format: GLenum; _type: GLenum; const data: pointer): GLint; stdcall;
function gluBuild2DMipmaps (target: GLenum; components: GLint; width, height: GLint; format: GLenum; _type: GLenum; const data: GLvoid): GLint; stdcall;

type
  GLUnurbs = record end;
  PGLUnurbs = ^GLUnurbs;
  GLUquadric  = record end;
  PGLUquadric = ^GLUquadric;
  GLUtesselator = record end;
  PGLUtesselator = ^GLUtesselator;

(* backwards compatibility: *)
  GLUnurbsObj = GLUnurbs;
  PGLUnurbsObj = ^GLUnurbsObj;
  GLUquadricObj = GLUquadric;
  PGLUquadricObj = ^GLUquadricObj;
  GLUtesselatorObj = GLUtesselator;
  PGLUtesselatorObj = ^GLUtesselatorObj;
  GLUtriangulatorObj = GLUtesselator;
  PGLUtriangulatorObj = ^GLUtriangulatorObj;

(****           Callback function prototypes    ****)

(* gluQuadricCallback *)
  GLUquadricErrorProc = procedure (p1: GLenum); stdcall;
  PGLUquadricErrorProc = ^GLUquadricErrorProc;

(* gluTessCallback *)
  GLUtessBeginProc = procedure (p1: GLenum); stdcall;
  PGLUtessBeginProc = ^GLUtessBeginProc;
  GLUtessEdgeFlagProc = procedure (p1: GLboolean); stdcall;
  PGLUtessEdgeFlagProc = ^GLUtessEdgeFlagProc;
  GLUtessVertexProc = procedure (); stdcall;
  PGLUtessVertexProc = ^GLUtessVertexProc;
  GLUtessEndProc = procedure(); stdcall;
  PGLUtessEndProc = ^GLUtessEndProc;
  GLUtessErrorProc = procedure (p1: GLenum); stdcall;
  PGLUtessErrorProc = ^GLUtessErrorProc;
  GLUtessCombineProc = procedure (p1: TArray3d; p2: TArray4v; p3: TArray4f; p4: PGLvoid); stdcall;
  PGLUtessCombineProc = ^GLUtessCombineProc;
  GLUtessBeginDataProc = procedure (p1: GLenum; p2: PGLvoid); stdcall;
  PGLUtessBeginDataProc = ^GLUtessBeginDataProc;
  GLUtessEdgeFlagDataProc = procedure (p1: GLboolean; p2: PGLvoid); stdcall;
  PGLUtessEdgeFlagDataProc = ^GLUtessEdgeFlagDataProc;
  GLUtessVertexDataProc = procedure (p1, p2: PGLvoid); stdcall;
  PGLUtessVertexDataProc = ^GLUtessVertexDataProc;
  GLUtessEndDataProc = procedure (p1: GLvoid); stdcall;
  PGLUtessEndDataProc = ^GLUtessEndDataProc;
  GLUtessErrorDataProc = procedure (p1: GLenum; p2: GLvoid); stdcall;
  PGLUtessErrorDataProc = ^GLUtessErrorDataProc;
  GLUtessCombineDataProc = procedure (p1: TArray3d; p2: TArray4v; p3: TArray4f; p4: PGLvoid; p5: GLvoid); stdcall;
  PGLUtessCombineDataProc = ^GLUtessCombineDataProc;

(* gluNurbsCallback *)
  GLUnurbsErrorProc = procedure (p1: GLenum); stdcall;
  PGLUnurbsErrorProc = ^GLUnurbsErrorProc;

function gluNewQuadric (): GLUquadric; stdcall;
procedure gluDeleteQuadric (state: PGLUquadric); stdcall;
procedure gluQuadricNormals (quadObject: PGLUquadric; normals: GLenum); stdcall;
procedure gluQuadricTexture (quadObject: PGLUquadric; textureCoords: GLboolean); stdcall;
procedure gluQuadricOrientation (quadObject: PGLUquadric; orientation: GLenum); stdcall;
procedure gluQuadricDrawStyle (quadObject: PGLUquadric; drawStyle: GLenum); stdcall;
procedure gluCylinder (qobj: PGLUquadric; baseRadius, topRadius: GLdouble; height: GLdouble; slices: GLint; stacks: GLint); stdcall;
procedure gluDisk (qobj: PGLUquadric; innerRadius, outerRadius: GLdouble; slices: GLint; loops: GLint); stdcall;
procedure gluPartialDisk (qobj: PGLUquadric; innerRadius, outerRadius: GLdouble; slices: GLint; loops: GLint; startAngle, sweepAngle: GLdouble); stdcall;
procedure gluSphere (qobj: PGLUquadric; radius: GLdouble; slices: GLint; stacks: GLint); stdcall;
procedure gluQuadricCallback (qobj: PGLUquadric; which: GLenum; fn: GLUquadricErrorProc); stdcall;
function gluNewTess (): GLUtesselator; stdcall;
procedure gluDeleteTess (tess: PGLUtesselator); stdcall;
procedure gluTessBeginPolygon (tess: PGLUtesselator; polygon_data: GLvoid); stdcall;
procedure gluTessBeginContour (tess: PGLUtesselator); stdcall;
procedure gluTessVertex (tess: PGLUtesselator; coords: TArray3d; data: PGLvoid); stdcall;
procedure gluTessEndContour (tess: PGLUtesselator); stdcall;
procedure gluTessEndPolygon(tess: PGLUtesselator); stdcall;
procedure gluTessProperty (tess: PGLUtesselator; which: GLenum; value: GLdouble); stdcall;
procedure gluTessNormal (tess: PGLUtesselator; x, y, z: GLdouble); stdcall;
procedure gluTessCallback (tess: PGLUtesselator; which: GLenum; fn: GLUtessBeginProc); stdcall;
procedure gluGetTessProperty (tess: PGLUtesselator; which: GLenum; value: PGLdouble); stdcall;
function gluNewNurbsRenderer (): GLUnurbs; stdcall;
procedure gluDeleteNurbsRenderer (nobj: PGLUnurbs); stdcall;
procedure gluBeginSurface (nobj: PGLUnurbs); stdcall;
procedure gluBeginCurve (nobj: PGLUnurbs); stdcall;
procedure gluEndCurve (nobj: PGLUnurbs); stdcall;
procedure gluEndSurface (nobj: PGLUnurbs); stdcall;
procedure gluBeginTrim (nobj: PGLUnurbs); stdcall;
procedure gluEndTrim (nobj: PGLUnurbs); stdcall;
procedure gluPwlCurve (nobj: PGLUnurbs; count: GLint; _array: PGLfloat; stride: GLint; _type: GLenum); stdcall;
procedure gluNurbsCurve (nobj: PGLUnurbs; nknots: GLint; knot: PGLfloat; stride: GLint; ctlarray: PGLfloat; order: GLint; _type: GLenum); stdcall;
procedure gluNurbsSurface(nobj: PGLUnurbs; sknot_count: GLint; sknot: PGLfloat; tknot_count: GLint; tknot: PGLfloat; s_stride, t_stride: GLint; ctlarray: PGLfloat; sorder: GLint; torder: GLint; _type: GLenum); stdcall;
procedure gluLoadSamplingMatrices (nobj: PGLUnurbs; const modelMatrix: TArray16f; const projMatrix: TArray16f; const viewport: TArray4i); stdcall;
procedure gluNurbsProperty (nobj: PGLUnurbs; _property: GLenum; value: GLfloat); stdcall;
procedure gluGetNurbsProperty (nobj: PGLUnurbs; _property: GLenum; value: PGLfloat); stdcall;
procedure gluNurbsCallback (nobj: PGLUnurbs; which: GLenum; fn: GLUnurbsErrorProc); stdcall;

(****           Generic constants               ****)

const
(* Version *)
  GLU_VERSION_1_1                 = 1;
  GLU_VERSION_1_2                 = 1;

(* Errors: (return value 0 = no error) *)
  GLU_INVALID_ENUM        = 100900;
  GLU_INVALID_VALUE       = 100901;
  GLU_OUT_OF_MEMORY       = 100902;
  GLU_INCOMPATIBLE_GL_VERSION     = 100903;

(* StringName *)
  GLU_VERSION             = 100800;
  GLU_EXTENSIONS          = 100801;

(* Boolean *)
  GLU_TRUE                = GL_TRUE;
  GLU_FALSE               = GL_FALSE;

(****           Quadric constants               ****)

(* QuadricNormal *)
  GLU_SMOOTH              = 100000;
  GLU_FLAT                = 100001;
  GLU_NONE                = 100002;

(* QuadricDrawStyle *)
  GLU_POINT               = 100010;
  GLU_LINE                = 100011;
  GLU_FILL                = 100012;
  GLU_SILHOUETTE          = 100013;

(* QuadricOrientation *)
  GLU_OUTSIDE             = 100020;
  GLU_INSIDE              = 100021;

(* Callback types: *)
(*      GLU_ERROR               100103 *)


(****           Tesselation constants           ****)

  GLU_TESS_MAX_COORD              = 1.0e150;

(* TessProperty *)
  GLU_TESS_WINDING_RULE           = 100140;
  GLU_TESS_BOUNDARY_ONLY          = 100141;
  GLU_TESS_TOLERANCE              = 100142;

(* TessWinding *)
  GLU_TESS_WINDING_ODD            = 100130;
  GLU_TESS_WINDING_NONZERO        = 100131;
  GLU_TESS_WINDING_POSITIVE       = 100132;
  GLU_TESS_WINDING_NEGATIVE       = 100133;
  GLU_TESS_WINDING_ABS_GEQ_TWO    = 100134;

(* TessCallback *)
  GLU_TESS_BEGIN          = 100100;  // void (CALLBACK*)(GLenum type)
  GLU_TESS_VERTEX         = 100101;  // void (CALLBACK*)(void *data)
  GLU_TESS_END            = 100102;  // void (CALLBACK*)(void)
  GLU_TESS_ERROR          = 100103;  // void (CALLBACK*)(GLenum errno)
  GLU_TESS_EDGE_FLAG      = 100104;  // void (CALLBACK*)(GLboolean boundaryEdge)
  GLU_TESS_COMBINE        = 100105;  // void (CALLBACK*)(GLdouble coords[3], void *data[4], GLfloat weight[4], void **dataOut)
  GLU_TESS_BEGIN_DATA     = 100106;  // void (CALLBACK*)(GLenum type, void *polygon_data)
  GLU_TESS_VERTEX_DATA    = 100107;  // void (CALLBACK*)(void *data, void *polygon_data)
  GLU_TESS_END_DATA       = 100108;  // void (CALLBACK*)(void      *polygon_data)
  GLU_TESS_ERROR_DATA     = 100109;  // void (CALLBACK*)(GLenum errno, void *polygon_data)
  GLU_TESS_EDGE_FLAG_DATA = 100110;  // void (CALLBACK*)(GLboolean boundaryEdge, void *polygon_data)
  GLU_TESS_COMBINE_DATA   = 100111;  // void (CALLBACK*)(GLdouble  coords[3], void *data[4], GLfloat weight[4], void **dataOut, void *polygon_data) 

(* TessError *)
  GLU_TESS_ERROR1     = 100151;
  GLU_TESS_ERROR2     = 100152;
  GLU_TESS_ERROR3     = 100153;
  GLU_TESS_ERROR4     = 100154;
  GLU_TESS_ERROR5     = 100155;
  GLU_TESS_ERROR6     = 100156;
  GLU_TESS_ERROR7     = 100157;
  GLU_TESS_ERROR8     = 100158;

  GLU_TESS_MISSING_BEGIN_POLYGON  = GLU_TESS_ERROR1;
  GLU_TESS_MISSING_BEGIN_CONTOUR  = GLU_TESS_ERROR2;
  GLU_TESS_MISSING_END_POLYGON    = GLU_TESS_ERROR3;
  GLU_TESS_MISSING_END_CONTOUR    = GLU_TESS_ERROR4;
  GLU_TESS_COORD_TOO_LARGE        = GLU_TESS_ERROR5;
  GLU_TESS_NEED_COMBINE_CALLBACK  = GLU_TESS_ERROR6;

(****           NURBS constants                 ****)

(* NurbsProperty *)
  GLU_AUTO_LOAD_MATRIX    = 100200;
  GLU_CULLING             = 100201;
  GLU_SAMPLING_TOLERANCE  = 100203;
  GLU_DISPLAY_MODE        = 100204;
  GLU_PARAMETRIC_TOLERANCE        = 100202;
  GLU_SAMPLING_METHOD             = 100205;
  GLU_U_STEP                      = 100206;
  GLU_V_STEP                      = 100207;

(* NurbsSampling *)
  GLU_PATH_LENGTH                 = 100215;
  GLU_PARAMETRIC_ERROR            = 100216;
  GLU_DOMAIN_DISTANCE             = 100217;


(* NurbsTrim *)
  GLU_MAP1_TRIM_2         = 100210;
  GLU_MAP1_TRIM_3         = 100211;

(* NurbsDisplay *)
(*      GLU_FILL                100012 *)
  GLU_OUTLINE_POLYGON     = 100240;
  GLU_OUTLINE_PATCH       = 100241;

(* NurbsCallback *)
(*      GLU_ERROR               100103 *)

(* NurbsErrors *)
  GLU_NURBS_ERROR1        = 100251;
  GLU_NURBS_ERROR2        = 100252;
  GLU_NURBS_ERROR3        = 100253;
  GLU_NURBS_ERROR4        = 100254;
  GLU_NURBS_ERROR5        = 100255;
  GLU_NURBS_ERROR6        = 100256;
  GLU_NURBS_ERROR7        = 100257;
  GLU_NURBS_ERROR8        = 100258;
  GLU_NURBS_ERROR9        = 100259;
  GLU_NURBS_ERROR10       = 100260;
  GLU_NURBS_ERROR11       = 100261;
  GLU_NURBS_ERROR12       = 100262;
  GLU_NURBS_ERROR13       = 100263;
  GLU_NURBS_ERROR14       = 100264;
  GLU_NURBS_ERROR15       = 100265;
  GLU_NURBS_ERROR16       = 100266;
  GLU_NURBS_ERROR17       = 100267;
  GLU_NURBS_ERROR18       = 100268;
  GLU_NURBS_ERROR19       = 100269;
  GLU_NURBS_ERROR20       = 100270;
  GLU_NURBS_ERROR21       = 100271;
  GLU_NURBS_ERROR22       = 100272;
  GLU_NURBS_ERROR23       = 100273;
  GLU_NURBS_ERROR24       = 100274;
  GLU_NURBS_ERROR25       = 100275;
  GLU_NURBS_ERROR26       = 100276;
  GLU_NURBS_ERROR27       = 100277;
  GLU_NURBS_ERROR28       = 100278;
  GLU_NURBS_ERROR29       = 100279;
  GLU_NURBS_ERROR30       = 100280;
  GLU_NURBS_ERROR31       = 100281;
  GLU_NURBS_ERROR32       = 100282;
  GLU_NURBS_ERROR33       = 100283;
  GLU_NURBS_ERROR34       = 100284;
  GLU_NURBS_ERROR35       = 100285;
  GLU_NURBS_ERROR36       = 100286;
  GLU_NURBS_ERROR37       = 100287;

(****           Backwards compatibility for old tesselator           ****)

procedure gluBeginPolygon(tess: PGLUtesselator); stdcall;
procedure gluNextContour(tess: PGLUtesselator; _type: GLenum); stdcall;
procedure gluEndPolygon(tess: PGLUtesselator); stdcall;

const
(* Contours types -- obsolete! *)
  GLU_CW          = 100120;
  GLU_CCW         = 100121;
  GLU_INTERIOR    = 100122;
  GLU_EXTERIOR    = 100123;
  GLU_UNKNOWN     = 100124;

(*Names without "TESS_" prefix *)
  GLU_BEGIN       = GLU_TESS_BEGIN;
  GLU_VERTEX      = GLU_TESS_VERTEX;
  GLU_END         = GLU_TESS_END;
  GLU_ERROR       = GLU_TESS_ERROR;
  GLU_EDGE_FLAG   = GLU_TESS_EDGE_FLAG;

implementation

const GLU_LIBRARY  = 'glu32.dll';

function gluErrorString; stdcall; external GLU_LIBRARY;
function gluErrorUnicodeStringEXT; stdcall; external GLU_LIBRARY;
function gluGetString; stdcall; external GLU_LIBRARY;
procedure gluOrtho2D; stdcall; external GLU_LIBRARY;
procedure gluPerspective; stdcall; external GLU_LIBRARY;
procedure gluPickMatrix; stdcall; external GLU_LIBRARY;
procedure gluLookAt; stdcall; external GLU_LIBRARY;
function gluProject; stdcall; external GLU_LIBRARY;
function gluUnProject; stdcall; external GLU_LIBRARY;
function gluScaleImage; stdcall; external GLU_LIBRARY;
function gluBuild1DMipmaps; stdcall; external GLU_LIBRARY;
function gluBuild2DMipmaps; stdcall; external GLU_LIBRARY;
function gluNewQuadric; stdcall; external GLU_LIBRARY;
procedure gluDeleteQuadric; stdcall; external GLU_LIBRARY;
procedure gluQuadricNormals; stdcall; external GLU_LIBRARY;
procedure gluQuadricTexture; stdcall; external GLU_LIBRARY;
procedure gluQuadricOrientation; stdcall; external GLU_LIBRARY;
procedure gluQuadricDrawStyle; stdcall; external GLU_LIBRARY;
procedure gluCylinder; stdcall; external GLU_LIBRARY;
procedure gluDisk; stdcall; external GLU_LIBRARY;
procedure gluPartialDisk; stdcall; external GLU_LIBRARY;
procedure gluSphere; stdcall; external GLU_LIBRARY;
procedure gluQuadricCallback; stdcall; external GLU_LIBRARY;
function gluNewTess; stdcall; external GLU_LIBRARY;
procedure gluDeleteTess; stdcall; external GLU_LIBRARY;
procedure gluTessBeginPolygon; stdcall; external GLU_LIBRARY;
procedure gluTessBeginContour; stdcall; external GLU_LIBRARY;
procedure gluTessVertex; stdcall; external GLU_LIBRARY;
procedure gluTessEndContour; stdcall; external GLU_LIBRARY;
procedure gluTessEndPolygon; stdcall; external GLU_LIBRARY;
procedure gluTessProperty; stdcall; external GLU_LIBRARY;
procedure gluTessNormal; stdcall; external GLU_LIBRARY;
procedure gluTessCallback; stdcall; external GLU_LIBRARY;
procedure gluGetTessProperty; stdcall; external GLU_LIBRARY;
function gluNewNurbsRenderer; stdcall; external GLU_LIBRARY;
procedure gluDeleteNurbsRenderer; stdcall; external GLU_LIBRARY;
procedure gluBeginSurface; stdcall; external GLU_LIBRARY;
procedure gluBeginCurve; stdcall; external GLU_LIBRARY;
procedure gluEndCurve; stdcall; external GLU_LIBRARY;
procedure gluEndSurface; stdcall; external GLU_LIBRARY;
procedure gluBeginTrim; stdcall; external GLU_LIBRARY;
procedure gluEndTrim; stdcall; external GLU_LIBRARY;
procedure gluPwlCurve; stdcall; external GLU_LIBRARY;
procedure gluNurbsCurve; stdcall; external GLU_LIBRARY;
procedure gluNurbsSurface; stdcall; external GLU_LIBRARY;
procedure gluLoadSamplingMatrices; stdcall; external GLU_LIBRARY;
procedure gluNurbsProperty; stdcall; external GLU_LIBRARY;
procedure gluGetNurbsProperty; stdcall; external GLU_LIBRARY;
procedure gluNurbsCallback; stdcall; external GLU_LIBRARY;
procedure gluBeginPolygon; stdcall; external GLU_LIBRARY;
procedure gluNextContour; stdcall; external GLU_LIBRARY;
procedure gluEndPolygon; stdcall; external GLU_LIBRARY;

end.
