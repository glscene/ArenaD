unit fConstruction;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  cUtilities;

type
  TfmConstruction = class(TForm)
    Panel1: TPanel;
    redStatus: TRichEdit;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
     
  public
     
    StopWatch: TStopWatch;
    DebugFile: TextFile;
    Logfile: boolean;

    procedure AddEvent(aString: string);
    procedure AddUnderlinedEvent(aString: string);
    procedure AppendToLastEvent(aString: string);

    procedure AddEventSuccess(aString: string);
    procedure AddEventFailure(aString: string);

    procedure TimedEventStart(aString: string);
    procedure TimedEventEnd(aString: string);
  end;

var
  fmConstruction: TfmConstruction;

implementation

uses fFirstForm;

{$R *.dfm}

procedure TfmConstruction.FormCreate(Sender: TObject);
begin
  StopWatch := TStopWatch.Create;

  // open a logfile, if possible
  logfile := true;
  if FileExists('construction.log') then
    logfile := DeleteFile('construction.log');

  if logfile then
  begin
    AssignFile(DebugFile, 'construction.log');
    logfile := (IOResult = 0);
    if logfile then
    begin
      Rewrite(DebugFile);
      logfile := (IOResult = 0);
    end;
  end;
end;

procedure TfmConstruction.FormDestroy(Sender: TObject);
begin
  if logfile then
    CloseFile(DebugFile);

  StopWatch.Free;
end;

procedure TfmConstruction.AddEvent(aString: string);
begin
  redStatus.Lines.Add(aString);
  if logfile then writeln(DebugFile, aString);
end;

procedure TfmConstruction.AddUnderlinedEvent(aString: string);
begin
  redStatus.Lines.Add('');
  if logfile then writeln(DebugFile, '');
  AddEvent(aString);
  redStatus.Lines.Add('---------------------------------');
  if logfile then writeln(DebugFile, '---------------------------------');
end;

procedure TfmConstruction.AppendToLastEvent(aString: string);
begin
  redStatus.Lines.Strings[redStatus.Lines.Count - 1] :=
    redStatus.Lines.Strings[redStatus.Lines.Count - 1] + aString;
  if logfile then writeln(DebugFile, aString);
end;

procedure TfmConstruction.AddEventSuccess(aString: string);
begin
  AppendToLastEvent(aString);
end;

procedure TfmConstruction.AddEventFailure(aString: string);
begin
  AppendToLastEvent(aString);
end;

procedure TfmConstruction.TimedEventStart(aString: string);
begin
  StopWatch.Go;
  redStatus.Lines.Add(aString);
end;

procedure TfmConstruction.TimedEventEnd(aString: string);
begin
  StopWatch.Stop;
  AppendToLastEvent(aString + ' ' + IntToStr(Variant(StopWatch.Timer)) + 'ms');
end;

procedure TfmConstruction.BitBtn1Click(Sender: TObject);
begin
  fmFirstForm.RealityForm.ManagerForm.DropConstruction;
end;

procedure TfmConstruction.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := false;
  fmFirstForm.RealityForm.ManagerForm.DropConstruction;
end;

end.
