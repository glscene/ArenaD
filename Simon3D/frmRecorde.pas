unit frmRecorde;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cls1: TLabel;
    cls2: TLabel;
    cls3: TLabel;
    cls4: TLabel;
    cls5: TLabel;
    nm1: TLabel;
    nm2: TLabel;
    nm3: TLabel;
    nm4: TLabel;
    nm5: TLabel;
    pt1: TLabel;
    pt2: TLabel;
    pt3: TLabel;
    pt4: TLabel;
    pt5: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure SalvarRecorde;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    Function TestaRecorde(Numero: String): Boolean;
    Procedure AcrescentaRecorde(ptrecorde: string; nmrecorde: string);
    Procedure CarregarRecorde;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
     
  public
     
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}
procedure TForm2.SalvarRecorde;
Var
 Iniciar : Tinifile;
 dir: string;
begin
 getdir(0, dir);
 if Length(dir) = 3 then //para evitar o bug no c:\
 Iniciar := Tinifile.Create(dir+'Recordes.ini')
 else
 Iniciar := Tinifile.Create(dir+'\Recordes.ini');
 With Iniciar do
  begin
  WriteString('Primeiro', 'Nome', nm1.Caption);
  WriteString('Primeiro', 'Pontos', pt1.Caption);
  WriteString('Segundo', 'Nome', nm2.Caption);
  WriteString('Segundo', 'Pontos', pt2.Caption);
  WriteString('Terceiro', 'Nome', nm3.Caption);
  WriteString('Terceiro', 'Pontos', pt3.Caption);
  WriteString('Quarto', 'Nome', nm4.Caption);
  WriteString('Quarto', 'Pontos', pt4.Caption);
  WriteString('Quinto', 'Nome', nm5.Caption);
  WriteString('Quinto', 'Pontos', pt5.Caption);
  Free;
  end;
end;
procedure TForm2.Button1Click(Sender: TObject);
begin
Close;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  SalvarRecorde;
end;

Function TForm2.TestaRecorde(Numero: string): Boolean;
Begin
If (pt1.Caption='') or
(pt2.Caption='') or
(pt3.Caption='') or
(pt4.Caption='') or
(pt5.Caption='') then
  begin
   Result:=true;
   exit
  end else
If (strtoint(Numero)>strtoint(pt1.Caption))  or
(strtoint(Numero)>strtoint(pt2.Caption)) or
(strtoint(Numero)>strtoint(pt3.Caption)) or
(strtoint(Numero)>strtoint(pt4.Caption))  or
(strtoint(Numero)>strtoint(pt5.Caption))   then
   begin
   Result:=true;
   end
   else Result:= false;
end;

Procedure TForm2.AcrescentaRecorde(ptrecorde: string; nmrecorde: string);
var
lista: tstringlist;
begin
//  ptrecorde:=edit2.Text;
// nmrecorde:=edit1.Text;
 if Testarecorde(ptrecorde) then
 begin
 lista:=tstringlist.Create;
 lista.Add(formatFloat('000',StrToInt(pt1.Caption))+nm1.caption);
 lista.Add(formatFloat('000',StrToInt(pt2.Caption))+nm2.caption);
 lista.Add(formatFloat('000',StrToInt(pt3.Caption))+nm3.caption);
 lista.Add(formatFloat('000',StrToInt(pt4.Caption))+nm4.caption);
 lista.Add(formatFloat('000',StrToInt(pt5.Caption))+nm5.caption);
 lista.Add(formatFloat('000',StrToInt(ptrecorde))+nmrecorde);
 lista.sort;
 lista.Delete(0);
 nm1.Caption:=copy(lista[4], 4, 255);
 nm2.Caption:=copy(lista[3], 4, 255);
 nm3.Caption:=copy(lista[2], 4, 255);
 nm4.Caption:=copy(lista[1], 4, 255);
 nm5.Caption:=copy(lista[0], 4, 255);
 pt1.Caption:=InttoStr(Strtoint(copy(lista[4], 0, 3)));
 pt2.Caption:=InttoStr(Strtoint(copy(lista[3], 0, 3)));
 pt3.Caption:=InttoStr(Strtoint(copy(lista[2], 0, 3)));
 pt4.Caption:=InttoStr(Strtoint(copy(lista[1], 0, 3)));
 pt5.Caption:=InttoStr(Strtoint(copy(lista[0], 0, 3)));
 end else
 InputBox('Input Box', 'Prompt', 'Default string');
end;

Procedure  Tform2.CarregarRecorde;
Var
Iniciar : Tinifile;
dir: string;
begin
//bloco q lê as informações do atleta
 getdir(0, dir);
 if Length(dir) = 3 then //para evitar o bug no c:\
 Iniciar := Tinifile.Create(dir+'Recordes.ini')
 else
 Iniciar := Tinifile.Create(dir+'\Recordes.ini');
 nm1.Caption:=Iniciar.ReadString('Primeiro', 'Nome', '');
 pt1.Caption:=Iniciar.ReadString('Primeiro', 'Pontos', '');
 nm2.Caption:=Iniciar.ReadString('Segundo', 'Nome', '');
 pt2.Caption:=Iniciar.ReadString('Segundo', 'Pontos', '');
 nm3.Caption:=Iniciar.ReadString('Terceiro', 'Nome', '');
 pt3.Caption:=Iniciar.ReadString('Terceiro', 'Pontos', '');
 nm4.Caption:=Iniciar.ReadString('Quarto', 'Nome', '');
 pt4.Caption:=Iniciar.ReadString('Quarto', 'Pontos', '');
 nm5.Caption:=Iniciar.ReadString('Quinto', 'Nome', '');
 pt5.Caption:=Iniciar.ReadString('Quinto', 'Pontos', '');
 //corrige bug
 if nm1.Caption='' then nm1.Caption:='Empty';
 if pt1.Caption='' then pt1.Caption:='0';
 if nm2.Caption='' then nm2.Caption:='Empty';
 if pt2.Caption='' then pt2.Caption:='0';
 if nm3.Caption='' then nm3.Caption:='Empty';
 if pt3.Caption='' then pt3.Caption:='0';
 if nm4.Caption='' then nm4.Caption:='Empty';
 if pt4.Caption='' then pt4.Caption:='0';
 if nm5.Caption='' then nm5.Caption:='Empty';
 if pt5.Caption='' then pt5.Caption:='0';
 //fim da correção

 Iniciar.free;
end;
procedure TForm2.FormCreate(Sender: TObject);
begin
CarregarRecorde;
KeyPreview:=true;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
SalvarRecorde;
Action:= caFree;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
pt1.Caption:='0';
pt2.Caption:='0';
pt3.Caption:='0';
pt4.Caption:='0';
pt5.Caption:='0';
nm1.Caption:='Empty';
nm2.Caption:='Empty';
nm3.Caption:='Empty';
nm4.Caption:='Empty';
nm5.Caption:='Empty';
end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = VK_ESCAPE) then
Close;
end;

end.
