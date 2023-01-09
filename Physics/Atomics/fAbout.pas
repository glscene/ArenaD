unit fAbout;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, ShellAPI,{mail}
  Vcl.Graphics, Vcl.Forms,Vcl.Controls,StdCtrls,
  Buttons, Vcl.ExtCtrls,Vcl.ComCtrls,PngImage;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    RichEdit1: TRichEdit;
    GlsceneImage: TImage;
    OpenglImage: TImage;
    Panel2: TPanel;
    PrintBtn: TSpeedButton;
    OKButton: TButton;
    procedure OKButtonClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure GlsceneImageClick(Sender: TObject);
    procedure OpenglImageClick(Sender: TObject);
    procedure CBLabelClick(Sender: TObject);
  private
     
  public
     
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.DFM}

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TAboutBox.PrintBtnClick(Sender: TObject);
begin
  RichEdit1.Print('Atomics Help');
end;

procedure TAboutBox.CBLabelClick(Sender: TObject);
begin
  ShellExecute(0, 'open',
    'http://www.opengl.org/', '', '', SW_SHOW);
end;

procedure TAboutBox.GlsceneImageClick(Sender: TObject);
begin
  ShellExecute(0, 'open',
    'http://www.glscene.org/', '', '', SW_SHOW);
end;

procedure TAboutBox.OpenglImageClick(Sender: TObject);
begin
  ShellExecute(0, 'open',
    'https://github.com/GLScene/GLScene', '', '', SW_SHOW);
end;

end.

