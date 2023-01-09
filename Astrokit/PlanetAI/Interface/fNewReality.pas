{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: fNewReality.pas,v 1.5 2003/06/28 21:47:54 aidave Exp $
}
unit fNewReality;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,Forms, Dialogs,
  StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,Vcl.ComCtrls,cAIReality;

type
  TfmNewReality = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    edCreator: TEdit;
    Panel3: TPanel;
    Panel4: TPanel;
    edWidth: TEdit;
    Panel5: TPanel;
    Panel6: TPanel;
    edEnvironment: TEdit;
    Panel7: TPanel;
    Panel8: TPanel;
    edHeight: TEdit;
    UpDownWidth: TUpDown;
    UpDownHeight: TUpDown;
    Panel11: TPanel;
    Panel12: TPanel;
    edTension: TEdit;
    UpDownTension: TUpDown;
    Panel19: TPanel;
    btnBarren: TBitBtn;
    btnDirty: TBitBtn;
    btnGrass: TBitBtn;
    btnWatery: TBitBtn;
    Panel20: TPanel;
    Panel22: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel23: TPanel;
    Panel21: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    edWater: TEdit;
    UpDownWater: TUpDown;
    Panel9: TPanel;
    Panel10: TPanel;
    edLandHeight: TEdit;
    UpDownLandHeight: TUpDown;
    Panel17: TPanel;
    Panel18: TPanel;
    edHumidity: TEdit;
    UpDownHumidity: TUpDown;
    Panel15: TPanel;
    Panel16: TPanel;
    edTemp: TEdit;
    UpDownTemp: TUpDown;
    Panel24: TPanel;
    cbContinents: TCheckBox;
    cbIslands: TCheckBox;
    cbHalo: TCheckBox;
    cbSun: TCheckBox;
    Label1: TLabel;
    edContinents: TEdit;
    edIslands: TEdit;
    cbFrozenPoles: TCheckBox;
    Panel25: TPanel;
    Label2: TLabel;
    cbFuzzy: TCheckBox;
    UpDownContinents: TUpDown;
    UpDownIslands: TUpDown;
    Panel26: TPanel;
    Panel27: TPanel;
    edPlanetRadius: TEdit;
    UpDownRadius: TUpDown;
    procedure UpDownWidthClick(Sender: TObject; Button: TUDBtnType);
    procedure UpDownHeightClick(Sender: TObject; Button: TUDBtnType);
    procedure btnBarrenClick(Sender: TObject);
    procedure btnDirtyClick(Sender: TObject);
    procedure btnGrassClick(Sender: TObject);
    procedure btnWateryClick(Sender: TObject);
    procedure UpDownTensionClick(Sender: TObject; Button: TUDBtnType);
    procedure UpDownWaterClick(Sender: TObject; Button: TUDBtnType);
    procedure UpDownLandHeightClick(Sender: TObject; Button: TUDBtnType);
    procedure UpDownHumidityClick(Sender: TObject; Button: TUDBtnType);
    procedure UpDownTempClick(Sender: TObject; Button: TUDBtnType);
    procedure UpDownContinentsClick(Sender: TObject; Button: TUDBtnType);
    procedure UpDownIslandsClick(Sender: TObject; Button: TUDBtnType);
    procedure UpDownRadiusClick(Sender: TObject; Button: TUDBtnType);
  private
     
  public
     
    procedure ExtractValues(aReality: AIReality);
  end;

var
  fmNewReality: TfmNewReality;

implementation

uses cAIThings;

{$R *.DFM}

procedure TfmNewReality.UpDownWidthClick(Sender: TObject; Button: TUDBtnType);
begin
  edWidth.Text := IntToStr(UpDownWidth.Position);
end;

procedure TfmNewReality.UpDownHeightClick(Sender: TObject;
  Button: TUDBtnType);
begin
  edHeight.Text := IntToStr(UpDownHeight.Position);
end;

procedure TfmNewReality.UpDownRadiusClick(Sender: TObject;
  Button: TUDBtnType);
begin
  edPlanetRadius.Text := IntToStr(UpDownRadius.Position);
end;

procedure TfmNewReality.btnBarrenClick(Sender: TObject);
begin
  edWater.Text := '0'; UpDownWater.Position := 0;
  edLandHeight.Text := '5'; UpDownLandHeight.Position := 5;
  edHumidity.Text := '0'; UpDownHumidity.Position := 0;
  edTemp.Text := '0'; UpDownTemp.Position := 0;
end;

procedure TfmNewReality.btnDirtyClick(Sender: TObject);
begin
  edWater.Text := '2'; UpDownWater.Position := 2;
  edLandHeight.Text := '10'; UpDownLandHeight.Position := 10;
  edHumidity.Text := '8'; UpDownHumidity.Position := 8;
  edTemp.Text := '5'; UpDownTemp.Position := 5;
end;

procedure TfmNewReality.btnGrassClick(Sender: TObject);
begin
  edWater.Text := '20'; UpDownWater.Position := 20;
  edLandHeight.Text := '25'; UpDownLandHeight.Position := 25;
  edHumidity.Text := '5'; UpDownHumidity.Position := 5;
  edTemp.Text := '2'; UpDownTemp.Position := 2;
end;

procedure TfmNewReality.btnWateryClick(Sender: TObject);
begin
  edWater.Text := '25'; UpDownWater.Position := 25;
  edLandHeight.Text := '5'; UpDownLandHeight.Position := 5;
  edHumidity.Text := '5'; UpDownHumidity.Position := 5;
  edTemp.Text := '2'; UpDownTemp.Position := 2;
end;

procedure TfmNewReality.UpDownTensionClick(Sender: TObject;
  Button: TUDBtnType);
begin
  edTension.Text := IntToStr(UpDownTension.Position);
end;

procedure TfmNewReality.UpDownWaterClick(Sender: TObject;
  Button: TUDBtnType);
begin
  edWater.Text := IntToStr(UpDownWater.Position);
end;

procedure TfmNewReality.UpDownLandHeightClick(Sender: TObject;
  Button: TUDBtnType);
begin
  edLandHeight.Text := IntToStr(UpDownLandHeight.Position);
end;

procedure TfmNewReality.UpDownHumidityClick(Sender: TObject;
  Button: TUDBtnType);
begin
  edHumidity.Text := IntToStr(UpDownHumidity.Position);
end;

procedure TfmNewReality.UpDownTempClick(Sender: TObject;
  Button: TUDBtnType);
begin
  edTemp.Text := IntToStr(UpDownTemp.Position);
end;

procedure TfmNewReality.UpDownContinentsClick(Sender: TObject;
  Button: TUDBtnType);
begin
  edContinents.Text := IntToStr(UpDownContinents.Position);
end;

procedure TfmNewReality.UpDownIslandsClick(Sender: TObject;
  Button: TUDBtnType);
begin
  edIslands.Text := IntToStr(UpDownIslands.Position);
end;

procedure TfmNewReality.ExtractValues(aReality: AIReality);
begin
  aReality.Creator := edCreator.Text;
  aReality.Environment.Name := edEnvironment.Text;
  aReality.Environment.Space.DefaultHeight := UpDownLandHeight.Position;
  aReality.Environment.Space.DefaultWater := UpDownWater.Position;
  aReality.Environment.Space.DefaultTemperature := UpDownTemp.Position;
  aReality.Environment.Space.DefaultHumidity := UpDownHumidity.Position;
  aReality.Environment.Space.Radius := UpDownRadius.Position;
  aReality.Build(UpDownWidth.Position, UpDownHeight.Position);
  if cbContinents.Checked then
    aReality.Environment.Space.GenerateContinents(UpDownContinents.Position);
  if cbIslands.Checked then
    aReality.Environment.Space.GenerateIslands(UpDownIslands.Position);
  if cbHalo.Checked then
    aReality.Environment.Space.GenerateHalo;
  if cbSun.Checked then
    aReality.Environment.Things.NewThing(cSun);
  if cbFrozenPoles.Checked then
    aReality.Environment.Space.FreezePoles;
  if cbFuzzy.Checked then
    aReality.Environment.Space.FuzzyHeight(16);
end;

end.
