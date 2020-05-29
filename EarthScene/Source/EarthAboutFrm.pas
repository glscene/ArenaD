unit EarthAboutFrm;

interface

uses
  Winapi.Windows, Winapi.Messages,
  Winapi.ShellApi,{WWW Links}
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Imaging.Jpeg, Vcl.Imaging.PngImage,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls;

type
  TAboutForm = class(TForm)
    Panel1: TPanel;
    GLSImage: TImage;
    OGLImage: TImage;
    DelphiButton: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OGLImageClick(Sender: TObject);
    procedure GLSImageClick(Sender: TObject);
    procedure CloseBitBtnClick(Sender: TObject);
    procedure DelphiButtonDblClick(Sender: TObject);
  private
     
  public
     
  end;

var
  AboutForm: TAboutForm;

implementation

uses
  uGlobals;

{$R *.DFM}

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  left := AboutFormX;
  top := AboutFormY;
end;

procedure TAboutForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  AboutFormX := AboutForm.left;
  AboutFormY := AboutForm.top;
end;

procedure TAboutForm.CloseBitBtnClick(Sender: TObject);
begin
 // Close;
end;

procedure TAboutForm.OGLImageClick(Sender: TObject);
begin
  ShellExecute(0, 'open',
    'http://www.opengl.org/', '', '', SW_SHOW);
end;

procedure TAboutForm.DelphiButtonDblClick(Sender: TObject);
begin
  ShellExecute(0, 'open',
    'http://www.embarcadero.com/delphi/', '', '', SW_SHOW);
end;

procedure TAboutForm.GLSImageClick(Sender: TObject);
begin
  ShellExecute(0, 'open',
    'http://www.glscene.org/', '', '', SW_SHOW);
end;

end.
