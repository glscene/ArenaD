program SpaceGLScene;

{ ! GLSceneSpace! based on Eric Grange's Earth Demo
  Purpose: Shows GLScene users and developers around the world!

  Initial Idea: Alexandre Hirzel,
  Developed by Ivan Lee Herring,
  Modified by  Aaron Hochwimmer and Pavel Vassiliev

  17/11/14 - updated to support RAD Studio by PW
  01/04/04 - modified by Ivan Lee Herring
  04/07/03 - added high quality textures -  Jerome Delauney

  Others credits:
  TDOT3BumpShader --> Stuart Gooding
  ...though not here and changed to GLTexCombineShader
  Phillip, ___, and many others...

  {: "GLScene Space" Demo.<p>
  See accompanying Readme.txt for user instructions.<p>
  The atmospheric effect is rendered in GLDirectOpenGL1Render, which essentially
  renders a disk, with color of the vertices computed via ray-tracing. Note that
  the tesselation of the disk has been hand-optimized so as to reduce CPU use
  while retaining quality. On anything >1 GHz, the rendering is fill-rate
  limited on a GeForce 4 Ti 4200.<p>
  Stars support is built into the TGLSkyDome, but constellations are rendered
  via a TGLLines, which is filled in the LoadConstellationLines method.<p>
  Eric Grange<br> http://glscene.org }


uses
  Forms,
  USolarSystem in 'USolarSystem.pas',
  FEarthLocations in 'FEarthLocations.pas' {EarthLocationsFrm},
  uGlobals in 'uGlobals.pas',
  USMDStuff in 'USMDStuff.pas',
  FGLSLoadSmdMdl in 'FGLSLoadSmdMdl.pas' {GlsLoadSmdMdlFrm},
  FGlsSmdQc in 'FGlsSmdQc.pas' {GlsSmdQcFrm},
  FGLSViewer in 'FGLSViewer.pas' {GLSViewerFrm},
  FMeshShow in 'FMeshShow.pas' {MeshShowFrm},
  FMeshData in 'FMeshData.pas' {MeshDataFrm},
  USahObjects in 'USahObjects.pas',
  FABCreator in 'FABCreator.pas' {ABCreatorFrm},
  FSpaceGLScene in 'FSpaceGLScene.pas' {SpaceGLSceneFrm},
  USpaceEntities in 'USpaceEntities.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'GLScene Space';
  Application.CreateForm(TSpaceGLSceneFrm, SpaceGLSceneFrm);
  Application.CreateForm(TEarthLocationsFrm, EarthLocationsFrm);
  Application.CreateForm(TGlsLoadSmdMdlFrm, GlsLoadSmdMdlFrm);
  Application.CreateForm(TGlsSmdQcFrm, GlsSmdQcFrm);
  Application.CreateForm(TGLSViewerFrm, GLSViewerFrm);
  Application.CreateForm(TABCreatorFrm, ABCreatorFrm);
  Application.CreateForm(TMeshShowFrm, MeshShowFrm);
  Application.Run;
end.
