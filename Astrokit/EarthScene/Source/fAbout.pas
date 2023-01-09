unit fAbout;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Winapi.ShellApi,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Imaging.Jpeg,
  Vcl.Imaging.PngImage,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Buttons;

type
  TAboutFrm = class(TForm)
    Panel1: TPanel;
    GLSImage: TImage;
    OGLImage: TImage;
    DelphiButton: TSpeedButton;
    procedure OGLImageClick(Sender: TObject);
    procedure GLSImageClick(Sender: TObject);
    procedure DelphiButtonClick(Sender: TObject);
  private
  public
  end;

var
  AboutFrm: TAboutFrm;

implementation


{$R *.DFM}

procedure TAboutFrm.GLSImageClick(Sender: TObject);
begin
  ShellExecute(0, 'open',
    'http://www.glscene.org/', '', '', SW_SHOW);
end;

procedure TAboutFrm.OGLImageClick(Sender: TObject);
begin
  ShellExecute(0, 'open',
    'http://www.opengl.org/', '', '', SW_SHOW);
end;

procedure TAboutFrm.DelphiButtonClick(Sender: TObject);
begin
  ShellExecute(0, 'open',
    'https://github.com/glscene', '', '', SW_SHOW);
end;


end.
