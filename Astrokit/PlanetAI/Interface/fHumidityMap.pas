unit fHumidityMap;

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
  fHeightField;

type
  TfmHumidityMap = class(TfmHeightField)
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
     
  public
     
  end;

var
  fmHumidityMap: TfmHumidityMap;

implementation

uses fFirstForm;

{$R *.dfm}

procedure TfmHumidityMap.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  HeatField.OnGetHeight := HumidityFormula;
end;

procedure TfmHumidityMap.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := false;
  fmFirstForm.RealityForm.ManagerForm.DropHumidityMap;
end;

end.
