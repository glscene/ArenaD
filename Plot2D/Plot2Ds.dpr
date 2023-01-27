program Plot2Ds;

uses
  Forms,
  fGridOptions in 'Source\fGridOptions.pas',
  fCoordOptions in 'Source\fCoordOptions.pas',
  fDerivativeOptions in 'Source\fDerivativeOptions.pas',
  fGridColors in 'Source\fGridColors.pas',
  fPlotColors in 'Source\fPlotColors.pas',
  fAddPlotColors in 'Source\fAddPlotColors.pas',
  uParser in 'Source\uParser.pas',
  uGlobal in 'Source\uGlobal.pas',
  fMain in 'Source\fMain.pas',
  fFunctions in 'Source\fFunctions.pas',
  fAbout in 'Source\fAbout.pas',
  fEvaluate in 'Source\fEvaluate.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TViewForm, ViewForm);
  Application.CreateForm(TFunctionsForm, FunctionsForm);
  Application.CreateForm(TGridOptionsForm, GridOptionsForm);
  Application.CreateForm(TEvaluateForm, EvaluateForm);
  Application.CreateForm(TCoordsForm, CoordsForm);
  Application.CreateForm(TDerivativesForm, DerivativesForm);
  Application.CreateForm(TGridColorsForm, GridColorsForm);
  Application.CreateForm(TPlotColorsForm, PlotColorsForm);
  Application.CreateForm(TAddPlotColorsForm, AddPlotColorsForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
