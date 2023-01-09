unit fMiniForm;

interface

uses
  Winapi.Windows,
  Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls,
  Forms, Vcl.Dialogs, StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Mask, Menus;

// state flags for automatic handling of minimize events
type
  TMiniState = (tmNone, // dont react to the message
    tmWindow, // minimize the window
    tmAll); // minimze all windows of the app

  // the minimize event himself
type
  TMinimizeEvent = procedure(Sender: TObject; var state: TMiniState) of object;

type
  TMiniForm = class(TForm) // derived from TForm
  private
    FOnMinimize: TMinimizeEvent;
    FOnMaximize: TMinimizeEvent;
    FOnRestore: TNotifyEvent;
    procedure WMSIZE(Var Msg: TWMSIZE); Message WM_SIZE;
    procedure WinRestore(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OnMinimize: TMinimizeEvent read FOnMinimize write FOnMinimize;
    property OnMaximize: TMinimizeEvent read FOnMaximize write FOnMaximize;
  end;

//===================================
implementation
//===================================

destructor TMiniForm.Destroy;
begin
  inherited
end;

constructor TMiniForm.Create(AOwner: TComponent);
begin
  FOnMinimize := NIL;
  inherited;
end;

procedure TMiniForm.WMSIZE(VAR Msg: TWMSIZE);
// catch the WM_SIZE message to know what happend
var
  status: TMiniState;
begin
  if Msg.SizeType = integer(wsMinimized) THEN
  BEGIN
    IF Assigned(FOnMinimize) then
    begin
      status := tmWindow; // Default action
      FOnMinimize(self, status);
      case status OF
        tmNone: // Tell windows to restore the window immedately
          PostMessage(Handle, WM_SYSCOMMAND, SC_RESTORE, 0);
        tmWindow:
          ; // All is done by windows and Delphi
        tmAll: // Minimize all windows of the app
          begin
            // Store the OnRestore event
            FOnRestore := Application.OnRestore;
            // Replace it with own handler
            Application.OnRestore := WinRestore;
            // Minimize all
            Application.Minimize;
          end;
      end;
    end;
  end;

  inherited; // Call other hanlder of WMSIZE event
end;

procedure TMiniForm.WinRestore(Sender: TObject);
var
  status: TMiniState;
  // handles restoring of the windows
begin
  // made Window normal
  WindowState := wsNormal;
  // Restore other Windows of the app
  Application.Restore;
  // Restore the old Restore handler
  Application.OnRestore := FOnRestore;
  // Call the restore handler
  IF Assigned(FOnRestore) then
    FOnRestore(Sender);

  IF Assigned(FOnMaximize) then
  begin
    status := tmWindow;
    FOnMaximize(self, status);
  end;
end;

end.
