program clockflash;

uses
  Forms,
  u_Main in 'u_Main.pas' {Form1},
  u_Flash in 'u_Flash.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
