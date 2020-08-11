unit FEarthLocations;
{Only things INTERACTIVE with the GLS 3D Display
  need to be on the same page as it

To make this 'fit' into a tabsheet on main page
the stuff on the right side:
   Open,Save,Print and Memo would be on another 'page'

the stuff on the left would be divided into
 left and right sides with its own memo

The Earthform Main page People Display would be the 'front page'
It could be divided into 2 pages or not.. maybe 1 ..wider

The Planet maker (ABCDE) could be another page}

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  VCL.Graphics, VCL.Controls, VCL.Forms, VCL.Dialogs,
  VCL.StdCtrls, VCL.Buttons, VCL.ComCtrls, VCL.ExtCtrls,
   
  GLS.Texture, GLS.Color;

type
  TEarthLocationsFrm = class(TForm)
    Panel1: TPanel;
    OkBitBtn: TBitBtn;
    CancelBitBtn: TBitBtn;
    sDateEdit: TEdit;
    Label7: TLabel;
    Label6: TLabel;
    LatitudeEdit: TEdit;
    Label5: TLabel;
    LongitudeEdit: TEdit;
    Label4: TLabel;
    CountryEdit: TEdit;
    Label3: TLabel;
    CityEdit: TEdit;
    Label2: TLabel;
    NameEdit: TEdit;
    Label1: TLabel;
    Label8: TLabel;
    cbTypes: TComboBox;
    AddtoTypeBtn: TSpeedButton;
    ColorPanel: TPanel;
    TypeEdit: TEdit;
    Panel2: TPanel;
    RichEdit1: TRichEdit;
    ColorDialog1: TColorDialog;
    Panel3: TPanel;
    OpenBtn: TSpeedButton;
    SaveBtn: TSpeedButton;
    PrintBtn: TSpeedButton;
    ResetDefaultsBtn: TSpeedButton;
    SaveListBtn: TSpeedButton;
    SaveColorsBtn: TSpeedButton;
    NickNameEdit: TEdit;
    Label9: TLabel;
    EMailEdit: TEdit;
    Label10: TLabel;
    UrlEdit: TEdit;
    Label11: TLabel;
    DemoNameEdit: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    sDOBDateEdit: TEdit;
    Label14: TLabel;
    TypeNameEdit: TEdit;
    Label15: TLabel;
    StateEdit: TEdit;
    Label16: TLabel;
    ClearMemoBtn: TSpeedButton;
    Label17: TLabel;
    GlowTrackBar: TTrackBar;
    PhotoEdit: TEdit;
    Label18: TLabel;
    OpenDialog1: TOpenDialog;
    PhotoBtn: TSpeedButton;
    HelpBtn: TSpeedButton;
    WordWrapCB: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkBitBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure WordWrapCBClick(Sender: TObject);    
    procedure SaveBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure AddtoTypeBtnClick(Sender: TObject);
    procedure SaveTypeList;
    procedure SaveColors;
    procedure ColorPanelClick(Sender: TObject);
    procedure ResetDefaultsBtnClick(Sender: TObject);
    procedure SaveListBtnClick(Sender: TObject);
    procedure SaveColorsBtnClick(Sender: TObject);
    procedure PhotoBtnClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);

  private
     
  public
     
  end;

var
  EarthLocationsFrm: TEarthLocationsFrm;

//-------------------------------------------------------------------
implementation
//-------------------------------------------------------------------

uses
  FSpaceScene, uGlobals;

{$R *.DFM}

procedure TEarthLocationsFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
{}
end;

procedure TEarthLocationsFrm.FormCreate(Sender: TObject);
var
  S : string;
  F : TextFile;
begin
  AssignFile(F,EarthDataPath+'EarthLocoList.txt');
  Reset(F);
  try
    cbTypes.Clear;
    //EarthForm.cbTypes.Clear;
    while not eof(F) do
    begin
      Readln(F,S);
      {Delete the >Color part... or leave it as 'hint'
      If pos('>',S)>0 then
      S:=Copy(S,0,pos('>',S)-1);}
      cbTypes.Items.Add(S);
      //EarthForm.cbTypes.Items.Add(S);
    end;
  finally
    CloseFile(F);
    cbTypes.ItemIndex:=0;
    //EarthForm.cbTypes.ItemIndex:=0;
  end;
end;


procedure TEarthLocationsFrm.AddtoTypeBtnClick(Sender: TObject);
begin
  {cbTypes   TypeEdit.Text    ColorPanel.Color}
  cbTypes.Items.Add(TypeEdit.Text);
  Inc(ColorIndex);
  SetLength(DotColorArray,ColorIndex+1);     {GLS.Texture}
  DotColorArray[ColorIndex]:=ConvertWinColor(ColorPanel.Color);
  Application.ProcessMessages;
  SaveTypeList;
  SaveColors;
end;
procedure TEarthLocationsFrm.SaveTypeList;
var
  F :TextFile;
  i : integer;
  sType : string;
begin     {cbTypes   TypeEdit.Text    ColorPanel.Color}
  AssignFile(F,EarthDataPath+'EarthLocoList.txt');
  Rewrite(F);
  try
    For I:= 0 to cbTypes.items.Count- 1 do
    begin
      sType:=  cbTypes.items[I];
      Writeln(F,sType);
    end;
  finally
    CloseFile(F);
  end;
end;

procedure TEarthLocationsFrm.SaveColors;
var
  F :TextFile;
  i : integer;
  scolor : string;
begin
  AssignFile(F,EarthDataPath+'EarthLocoColors.txt');
  Rewrite(F);
  try
    For I:= 0 to ColorIndex do
    begin
      scolor:= inttostr(ConvertColorVector(DotColorArray[I]));
      Writeln(F,scolor);
    end;
  finally
    CloseFile(F);
  end;
end;



{Add to List AND Save}
procedure TEarthLocationsFrm.OkBitBtnClick(Sender: TObject);
var
  F:TextFile;
  Lat,Lon:single;
  byteType,byteType2 : byte;
  sDateFormat,
    sName, sNickName, sCity, sState, sCountry,sPhoto,
    sEMail, sUrl, sDemoName, sTypeName, sDescription,
  sDateGLS,sDateDOB,sWhoWhereFormat : string;
  mp : TMarkerPosition;
  {iIndex : integer;}
begin
  AssignFile(F,EarthDataPath+'EarthLoco.txt');
    Append(f);
    try
      Writeln(F);{End the last one ?}
      {makes the date read right.. ignored later...}
      sDateFormat := FormatSettings.ShortDateFormat; // save it
      FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
      mp := Tmarkerposition.Create;
      {inc(markerIndex);} {now or later}
      markers.AddObject(IntToStr(markerIndex),mp);
      with TMarkerPosition(markers.Objects[markerIndex]) do
      begin
        If Length(LatitudeEdit.Text)= 0 then
           LatitudeEdit.Text:='0';
        Lat := Strtofloat(LatitudeEdit.Text);
        Latitude := Lat;
        If Length(LongitudeEdit.Text)= 0 then
           LongitudeEdit.Text:='0';
        Lon := Strtofloat(LongitudeEdit.Text);
        Longitude := Lon;
        byteType :=cbTypes.ItemIndex;// StrToInt(cbTypes.Text);
        MemberType := byteType;
        byteType2 :=GlowTrackBar.Position;
        Glow := byteType2;
{     fLatitude : single;       ptsLocations         ptsFlashLocations
      fLongitude : single;
      fmembertype, fGlow  : byte; // 0..255
      fTypeName, fName, fNickName, fCity, fState, fCountry: String;
      fDateAdded, fDateDOB: TDate;
      fEMail, fUrl, fDemoName,  fDescription: String;}
        if Length(TypeNameEdit.Text)= 0 then
           TypeNameEdit.Text:=' ';
        sTypeName :=TypeNameEdit.Text;
        TypeName:=sTypeName;
        if Length(NameEdit.Text)= 0 then
           NameEdit.Text:=' ';
        sName :=NameEdit.Text;
        Name:=sName;
        if Length(NickNameEdit.Text)= 0 then
           NickNameEdit.Text:=' ';
        sNickName :=NickNameEdit.Text;
        NickName:=sNickName;
        if Length(CityEdit.Text)= 0 then
           CityEdit.Text:=' ';
        sCity :=CityEdit.Text;
        City:=sCity;
        If Length(StateEdit.Text)= 0 then
           StateEdit.Text:=' ';
        sState :=StateEdit.Text;
        State:=sState;
        If Length(CountryEdit.Text)= 0 then
           CountryEdit.Text:=' ';
        sCountry :=CountryEdit.Text;
        Country:=sCountry;
        If Length(sDateEdit.Text)= 0 then
           sDateEdit.Text:=Datetostr(Now);
        sDateGLS :=sDateEdit.Text;// StrToDate(Trim(sDate));
        DateAdded := StrToDate(Trim(sDateGLS));
        If Length(sDOBDateEdit.Text)= 0 then
           sDOBDateEdit.Text:=Datetostr(Now);
        sDateDOB :=sDOBDateEdit.Text;
        DateDOB := StrToDate(Trim(sDateDOB));
        If Length(PhotoEdit.Text)= 0 then
           PhotoEdit.Text:=' ';
        sPhoto :=PhotoEdit.Text;
        Photo:=sPhoto;
        If Length(EMailEdit.Text)= 0 then
           EMailEdit.Text:=' ';
        sEMail :=EMailEdit.Text;
        EMail:=sEMail;
        If Length(UrlEdit.Text)= 0 then
           UrlEdit.Text:=' ';
        sUrl :=UrlEdit.Text;
        Url:=sUrl;
        If Length(DemoNameEdit.Text)= 0 then
           DemoNameEdit.Text:=' ';
        sDemoName :=DemoNameEdit.Text;
        DemoName:=sDemoName;
        sDescription :=RichEdit1.Text;
        If Length(sDescription)= 0 then
           sDescription:=' ';
        Description:=sDescription;

        sWhoWhereFormat:=
        LongitudeEdit.Text +' '+
        LatitudeEdit.Text +' '+
        inttostr(byteType) +' '+
        inttostr(byteType2)+' '+
        sTypeName+','+
        sName+','+ sNickName+','+
        sCity+','+ sState+','+ sCountry+','+
        sDateGLS+','+sDateDOB+','+ sPhoto+','+
        sEMail+','+ sUrl+','+ sDemoName+','+sDescription;
        Writeln(F,{Lon,Lat,byteType,byteType2,}sWhoWhereFormat);
        Flush(f);{MAKE it write NOW}
      end;
      inc(markerIndex);
  finally
    CloseFile(F);
  end;//finally
  FormatSettings.ShortDateFormat := sDateFormat;
end;

procedure TEarthLocationsFrm.OpenBtnClick(Sender: TObject);
begin
  RichEdit1.Lines.LoadFromFile(EarthDataPath+'EarthLoco.txt');
end;

procedure TEarthLocationsFrm.WordWrapCBClick(Sender: TObject);
begin
  RichEdit1.WordWrap:= WordWrapCB.Checked;
end;

procedure TEarthLocationsFrm.SaveBtnClick(Sender: TObject);
begin
  RichEdit1.Lines.SavetoFile(EarthDataPath+'EarthLoco.txt');
end;

procedure TEarthLocationsFrm.PrintBtnClick(Sender: TObject);
begin
  RichEdit1.Print(EarthDataPath+'EarthLoco.txt');
end;



procedure TEarthLocationsFrm.ColorPanelClick(Sender: TObject);
begin
  ColorDialog1.Color:= ColorPanel.Color;
  if ColorDialog1.Execute then
  ColorPanel.Color := ColorDialog1.Color;
end;

procedure TEarthLocationsFrm.ResetDefaultsBtnClick(Sender: TObject);
begin
  ColorIndex:=7;
    SetLength(DotColorArray,ColorIndex+1);
    DotColorArray[0]:=clrSilver;
    DotColorArray[1]:=clrMandarinOrange;
    DotColorArray[2]:=clrYellow;
    DotColorArray[3]:=clrBlue;
    DotColorArray[4]:=clrRed;
    DotColorArray[5]:=clrPurple;
    DotColorArray[6]:=clrLime;
    DotColorArray[7]:=clrFlesh;
    cbTypes.Clear;
    cbTypes.Items.Add('0: Undecided Dabbler [clrSilver]');
    cbTypes.Items.Add('1: GLS Developer [clrMandarinOrange]');
    cbTypes.Items.Add('2: Content Creator [clrYellow]');
    cbTypes.Items.Add('3: Game Developer FPS [clrBlue]');
    cbTypes.Items.Add('4: Game Developer RTS Sims [clrRed]');
    cbTypes.Items.Add('4: VR Simulation [clrPurple]');
    cbTypes.Items.Add('6: Scientific Visualization [clrLime]');
    cbTypes.Items.Add('7: Others [clrFlesh]');
    cbTypes.Itemindex:=0;
    SpaceSceneFrm.cbTypes.Clear;
    {EarthForm.cbTypes.Items.Add(S);}
    SpaceSceneFrm.cbTypes.Items:=cbTypes.Items; // copied items to main form
    SpaceSceneFrm.cbTypes.ItemIndex:=0;
end;

procedure TEarthLocationsFrm.SaveListBtnClick(Sender: TObject);
begin
  SaveTypeList;
end;

procedure TEarthLocationsFrm.SaveColorsBtnClick(Sender: TObject);
begin
  SaveColors;
end;

procedure TEarthLocationsFrm.PhotoBtnClick(Sender: TObject);
begin
  OpenDialog1.InitialDir:=EarthPhotoPath;
  if OpenDialog1.Execute then
  begin
    EarthPhotoPath:=OpenDialog1.InitialDir;
    PhotoEdit.Text:= ExtractFileName(OpenDialog1.FileName);
  end;
end;

procedure TEarthLocationsFrm.HelpBtnClick(Sender: TObject);
begin
  Application.HelpContext(1300);
end;



end.
