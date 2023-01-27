program Plot1Ds;

uses
  Forms,
  fMain in 'Source\fMain.pas',
  fFuncts in 'Source\fFuncts.pas',
  fGridOpts in 'Source\fGridOpts.pas',
  fNumeric in 'Source\fNumeric.pas',
  fTextBlocks in 'Source\fTextBlocks.pas',
  fDerivative in 'Source\fDerivative.pas',
  fIntegrateX in 'Source\fIntegrateX.pas',
  fIntegrateY in 'Source\fIntegrateY.pas',
  fBetween in 'Source\fBetween.pas',
  fVolumeX in 'Source\fVolumeX.pas',
  fVolumeY in 'Source\fVolumeY.pas',
  fBitmap in 'Source\fBitmap.pas',
  fPrint in 'Source\fPrint.pas',
  fStyle in 'Source\fStyle.pas',
  fxValue in 'Source\fxValue.pas',
  fx1Value in 'Source\fx1Value.pas',
  fx2Value in 'Source\fx2Value.pas',
  uCanvas in 'Source\uCanvas.pas',
  uGlobal in 'Source\uGlobal.pas',
  uParser in 'Source\uParser.pas',
  fAbout in 'Source\fAbout.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Plot 1D';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFunctionsForm, FunctionsForm);
  Application.CreateForm(TGridOptionsForm, GridOptionsForm);
  Application.CreateForm(TNumericForm, NumericForm);
  Application.CreateForm(TTextBlocksForm, TextBlocksForm);
  Application.CreateForm(TDerivativeForm, DerivativeForm);
  Application.CreateForm(TIntegrateXForm, IntegrateXForm);
  Application.CreateForm(TIntegrateYForm, IntegrateYForm);
  Application.CreateForm(TBetweenForm, BetweenForm);
  Application.CreateForm(TVolumeXForm, VolumeXForm);
  Application.CreateForm(TVolumeYForm, VolumeYForm);
  Application.CreateForm(TfxValueForm, fxValueForm);
  Application.CreateForm(Tfx1ValueForm, fx1ValueForm);
  Application.CreateForm(Tfx2ValueForm, fx2ValueForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
