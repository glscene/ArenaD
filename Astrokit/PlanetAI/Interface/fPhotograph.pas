{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: fPhotograph.pas,v 1.3 2003/08/08 07:08:47 aidave Exp $
}
unit fPhotograph;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,Forms,
  Dialogs, Vcl.StdCtrls,Vcl.Buttons, ExtCtrls;

type
  TfmPhotograph = class(TForm)
    Panel2: TPanel;
    Label1: TLabel;
    edPhotograph: TEdit;
    Label2: TLabel;
    edThumbnail: TEdit;
    SaveDialog: TSaveDialog;
    cbCreateThumbnail: TCheckBox;
    Label3: TLabel;
    edPhotoHeight: TEdit;
    Label4: TLabel;
    edPhotoWidth: TEdit;
    Label5: TLabel;
    edThumbHeight: TEdit;
    Label6: TLabel;
    edThumbWidth: TEdit;
    btnPhotograph: TBitBtn;
    btnThumbnail: TBitBtn;
    Label7: TLabel;
    edName: TEdit;
    Panel1: TPanel;
    Panel4: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnPhotographClick(Sender: TObject);
    procedure btnThumbnailClick(Sender: TObject);
    procedure edNameChange(Sender: TObject);
  private
     
    fName: string;
    fPhotodir: string;
  public
     
    property Name: string read fName write fName;
    property Photodir: string read fPhotodir write fPhotodir;
  end;

var
  fmPhotograph: TfmPhotograph;

implementation

{$R *.dfm}

procedure TfmPhotograph.FormShow(Sender: TObject);
var
  i: integer;
begin
  i := 1;

  Name := 'snapshot1';

  if DirectoryExists('photos') then
    photodir := 'photos\'
  else
    photodir := '';

  edPhotograph.Text := photodir + Name;
  while FileExists(edPhotograph.Text) do
  begin
    i := i + 1;
    Name := 'snapshot' + IntToStr(i);
    edPhotograph.Text := photodir + Name + '.bmp';
  end;

  edName.Text := Name;
  edThumbnail.Text := photodir + Name + '-thumb.bmp';
end;

procedure TfmPhotograph.btnPhotographClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    edPhotograph.Text := SaveDialog.FileName;
//  imgPhoto.Picture.SaveToFile(edPhotograph.Text);
end;

procedure TfmPhotograph.btnThumbnailClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    edThumbnail.Text := SaveDialog.FileName;
end;

procedure TfmPhotograph.edNameChange(Sender: TObject);
begin
  Name := edName.Text;
  edPhotograph.Text := photodir + Name + '.bmp';
  edThumbnail.Text := photodir + Name + '-thumb.bmp';
end;

end.
