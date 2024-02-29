unit FEnterKey;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.Types,
  System.SysUtils,
  System.Classes,
  VCL.Graphics,
  VCL.Controls,
  VCL.Forms,
  VCL.Dialogs,
  VCL.ExtCtrls,
  VCL.StdCtrls,
  GLS.Keyboard;

type
  TEnterKey = class(TForm)
    Label1: TLabel;
    Shape1: TShape;
    LAFunction: TLabel;
    Timer: TTimer;
    procedure TimerTimer(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
    FVKey : Integer;
  public
    { Public declarations }
    function Execute(const func : String) : TVirtualKeyCode;
  end;

var
  EnterKey: TEnterKey;

implementation

{$R *.dfm}

// ------------------
// ------------------ TEnterKey ------------------
// ------------------

// Execute
//
function TEnterKey.Execute(const func : String) : TVirtualKeyCode;
begin
   LAFunction.Caption:=func;
   KeyboardNotifyWheelMoved(0);
   while KeyPressed<>-1 do begin Application.ProcessMessages; Sleep(10); end;
   Timer.Enabled:=True;
   ShowModal;
   Result:=FVKey;
end;

procedure TEnterKey.TimerTimer(Sender: TObject);
begin
   FVKey:=KeyPressed;
   if FVKey<>-1 then begin
      Timer.Enabled:=False;
      ModalResult:=mrOk;
   end;
end;

procedure TEnterKey.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
   KeyboardNotifyWheelMoved(WheelDelta);
end;

end.

