unit fSatellite;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes, Vcl.Graphics, Vcl.Controls,Forms, Dialogs,
  StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,cAISatellites;

type
  TfmSatellite = class(TForm)
    panDescription: TPanel;
    panRate: TPanel;
    edRate: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    edMovement: TEdit;
    Panel3: TPanel;
    Panel4: TPanel;
    edRadius: TEdit;
    Panel5: TPanel;
    rgDirection: TRadioGroup;
    Panel6: TPanel;
    Panel7: TPanel;
    panButtonBar: TPanel;
    panOKButton: TPanel;
    btnOK: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel8: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    edX: TEdit;
    edY: TEdit;
    edZ: TEdit;
    edSize: TEdit;
    edDistance: TEdit;
    procedure rgDirectionClick(Sender: TObject);
    procedure edRateChange(Sender: TObject);
    procedure edRadiusChange(Sender: TObject);
    procedure edMovementChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
     
    fSatellite: AISatellite;
    procedure SetSatellite(aSatellite: AISatellite);
  public
     
    property Satellite: AISatellite read fSatellite write SetSatellite;

    procedure Refresh;
  end;

var
  fmSatellite: TfmSatellite;

implementation

uses
  cAIThings;

{$R *.DFM}

procedure TfmSatellite.SetSatellite(aSatellite: AISatellite);
begin
  fSatellite := aSatellite;

  Caption := Satellite.Name;

  if Satellite.Kind = cSun then
    panRate.Caption := 'Heat'
  else
    panRate.Caption := 'Cold';

  Refresh;
end;

procedure TfmSatellite.Refresh;
begin
//  edRate.Text := IntToStr(Satellite.Rate);
//  edRadius.Text := IntToStr(Satellite.Radius);
//  edMovement.Text := IntToStr(Satellite.Movement);

//  rgDirection.ItemIndex := Satellite.Direction;
end;

procedure TfmSatellite.rgDirectionClick(Sender: TObject);
begin
//  Satellite.Direction := rgDirection.ItemIndex;
end;

procedure TfmSatellite.edRateChange(Sender: TObject);
begin
//  Satellite.Rate := StrToInt(edRate.Text);
end;

procedure TfmSatellite.edRadiusChange(Sender: TObject);
begin
//  Satellite.Radius := StrToInt(edRadius.Text);
end;

procedure TfmSatellite.edMovementChange(Sender: TObject);
begin
//  Satellite.Movement := StrToInt(edMovement.Text);
end;

procedure TfmSatellite.btnOKClick(Sender: TObject);
begin
  Close;
end;

end.
