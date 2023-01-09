program EarthScene;

(*
! GLSceneSpace! based on Eric Grange's Earth Demo
  Purpose: Shows GLScene users and developers around the world!

  Initial Idea: Alexandre Hirzel, developed by Ivan Lee Herring,
  Modified and improved by Aaron Hochwimmer, Pavel Vassiliev and Jerome Delauney

  Others credits:
  TDOT3BumpShader --> Stuart Gooding
  ...though not here and changed to GLTexCombineShader
  Phillip and many others...

  "GLScene Space" Demo.
  See accompanying Readme.txt for user instructions.<p>
  The atmospheric effect is rendered in GLDirectOpenGL1Render, which essentially
  renders a disk, with color of the vertices computed via ray-tracing. Note that
  the tesselation of the disk has been hand-optimized so as to reduce CPU use
  while retaining quality. On anything < 1 GHz, the rendering is fill-rate limited.

  Stars support is built into the TGLSkyDome, but constellations are rendered
  via a TGLLines, which is filled in the LoadConstellationLines method.
*)


uses
  Forms,
  USolarSystem in 'USolarSystem.pas',
  uGlobals in 'uGlobals.pas',
  USahObjects in 'USahObjects.pas',
  uSpaceBodies in 'uSpaceBodies.pas',
  fAbout in 'fAbout.pas',
  USMDStuff in 'USMDStuff.pas',
  fEarthScene in 'fEarthScene.pas',
  FEarthLocations in 'FEarthLocations.pas',
  FLoadSmdModel in 'FLoadSmdModel.pas',
  FABCreator in 'FABCreator.pas',
  FSmdQc in 'FSmdQc.pas',
  FMeshShow in 'FMeshShow.pas',
  FMeshData in 'FMeshData.pas',
  FGLSViewer in 'FGLSViewer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'GLScene Space';
  Application.CreateForm(TSpaceSceneFrm, SpaceSceneFrm);
  Application.CreateForm(TEarthLocationsFrm, EarthLocationsFrm);
  Application.CreateForm(TGlsLoadSmdMdlFrm, GlsLoadSmdMdlFrm);
  Application.CreateForm(TGlsSmdQcFrm, GlsSmdQcFrm);
  Application.CreateForm(TGLSViewerFrm, GLSViewerFrm);
  Application.CreateForm(TABCreatorFrm, ABCreatorFrm);
  Application.CreateForm(TMeshShowFrm, MeshShowFrm);
  Application.CreateForm(TAboutFrm, AboutFrm);
  Application.CreateForm(TSpaceSceneFrm, SpaceSceneFrm);
  Application.CreateForm(TEarthLocationsFrm, EarthLocationsFrm);
  Application.CreateForm(TGlsLoadSmdMdlFrm, GlsLoadSmdMdlFrm);
  Application.CreateForm(TABCreatorFrm, ABCreatorFrm);
  Application.CreateForm(TGlsSmdQcFrm, GlsSmdQcFrm);
  Application.CreateForm(TMeshShowFrm, MeshShowFrm);
  Application.CreateForm(TGLSViewerFrm, GLSViewerFrm);
  Application.Run;
end.
