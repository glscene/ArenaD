//Called to display data from  MeshShowFrm
unit FMeshData;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TMeshDataFrm = class(TForm)
    rdMeshData: TRichEdit;
  private
     
  public
     
  end;

procedure ShowMeshData(const aList : TStringList);

implementation

{$R *.dfm}

procedure ShowMeshData(const aList : TStringList);
var
  lfrm : TMeshDataFrm;
begin
  if aList = nil then
    Exit;
    
  lfrm := TMeshDataFrm.Create(nil);
  try
    lfrm.rdMeshData.Lines.Assign(aList);
    lfrm.ShowModal;
  finally
    FreeAndNil(lfrm);
  end;
end;

end.
