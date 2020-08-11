program Simon;



uses
  Forms,
  frmRecorde in 'frmRecorde.pas' {Form2},
  frmSobre in 'frmSobre.pas' {AboutBox},
  ucodigo in 'ucodigo.pas' {Form1};

//{$R *.res}
{$R Simon3D.res}

begin
  Application.Initialize;
  Application.Title := 'Simon 3D';
  Application.HelpFile := '';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
