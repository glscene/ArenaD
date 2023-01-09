(*
  ai.planet http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: fSplash.pas, v 1.6 2003/07/28 08:02:23 aidave Exp $
*)
unit fSplash;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Imaging.Jpeg,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ComCtrls,

  vSplashScreen;

type
  TfmSplash = class(TForm)
    SplashTimer: TTimer;
    imgBackdrop: TImage;
    labVersion: TLabel;
    labBuild: TLabel;
    Label1: TLabel;
    labButton: TLabel;
    TimerClose: TTimer;
    Label3: TLabel;
    procedure SplashTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure imgBackdropClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClick(Sender: TObject);
    procedure TimerCloseTimer(Sender: TObject);
  private

  public

  end;

var
  fmSplash: TfmSplash;

implementation

uses fAbout;

{$R *.DFM}

procedure TfmSplash.SplashTimerTimer(Sender: TObject);
begin
  labButton.Visible := not labButton.Visible;
end;

procedure TfmSplash.FormCreate(Sender: TObject);
var
  myAboutInfo: TAboutInfo;
begin
  // Width := imgBackdrop.Picture.Bitmap.Width;
  // Height := imgBackdrop.Picture.Bitmap.Height;

  myAboutInfo := TAboutInfo.Create(ParamStr(0));
  // labVersion.Caption := 'Version ' + myAboutInfo.FileVersion;
  labVersion.Caption := 'Version ' + myAboutInfo.FileVersionNoBuild;
  labBuild.Caption := 'v' + myAboutInfo.FileVersion + ' compiled on ' + myAboutInfo.FileBuildDate;
  myAboutInfo.Free;

  // SetWindowRgn(Handle, BitmapToRegion(imgBackdrop.Picture.Bitmap.Handle, clNone, 10), true);
end;

procedure TfmSplash.FormPaint(Sender: TObject);
begin
  // Canvas.Draw(0, 0, imgBackDrop.Picture.Bitmap);
end;

procedure TfmSplash.imgBackdropClick(Sender: TObject);
begin
  Close;
end;

procedure TfmSplash.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Close;
end;

procedure TfmSplash.FormClick(Sender: TObject);
begin
  Close;
end;

procedure TfmSplash.TimerCloseTimer(Sender: TObject);
begin
  Close;
end;

end.
