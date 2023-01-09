{
  ai.planet
  http://aiplanet.sourceforge.net
  $Id: fAbout.pas,v 1.6 2003/07/28 08:02:22 aidave Exp $
}
unit fAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,Forms, Dialogs,
  StdCtrls, Vcl.ExtCtrls,Vcl.ComCtrls,Vcl.Buttons, jpeg;

  //JvGIF

type
  TfmAbout = class(TForm)
    Panel3: TPanel;
    Panel4: TPanel;
    btnRun: TBitBtn;
    Panel2: TPanel;
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    labVersion: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    labDate: TLabel;
    Label2: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    RichEdit2: TRichEdit;
    RichEdit1: TRichEdit;
    redIntro: TRichEdit;
    TabSheet4: TTabSheet;
    RichEdit3: TRichEdit;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private
  public
  end;

  TInfoItem = class(TObject)
  private
    fInternalName: string;
    fDisplayName: string;
    fValue: string;
  public
    property InternalName: string read fInternalName write fInternalName;
    property DisplayName: string read fDisplayName write fDisplayName;
    property Value: string read fValue write fValue;
    function DisplayValue: string;
    function DisplayValueForList: string;
  end;

  TAboutInfo = class(TObject)
  private
    fInfoItems: TList;
    fMajor:   Word;
    fMinor:   Word;
    fRelease: Word;
    fBuild:   Word;
    fBuildDateAsStr: string;
    procedure LoadInfoItems;
    procedure GetFileDetails(const sFile: string);

    function ReadVersionInfo(sProgram: string; Major, Minor,
                             Release, Build : pWord) :Boolean;
  public
    Constructor Create(const aFile: string);
    Destructor Destroy; override;
    property FileInfoItems: TList read fInfoItems;
    property FileBuildDate: string read fBuildDateAsStr;

    function FileVersion: string;
    function FileVersionNoBuild: string;
    function OSVersion: string;
  end;

var
  fmAbout: TfmAbout;

implementation

uses WinTypes, WinProcs, ShellApi;

{$R *.DFM}

{********************************************************************}

function TInfoItem.DisplayValue: string;
begin
  result := fDisplayName + ' = ' + fValue;
end;

function TInfoItem.DisplayValueForList: string;
begin
  result := Copy(fDisplayName + '                    ', 1, 19) + '= ' + fValue;
end;

{********************************************************************}

Constructor TAboutInfo.Create(const aFile: string);
begin
  inherited Create;
  fInfoItems := TList.Create;
  LoadInfoItems;
  GetFileDetails(aFile);
end;

{********************************************************************}

Destructor TAboutInfo.Destroy;
begin
  fInfoItems.Clear;
  fInfoItems.Free;
  inherited Destroy;
end;

{********************************************************************}

procedure TAboutInfo.LoadInfoItems;
const
  InfoNum = 11;
  InfoStr : array [1..InfoNum] of String =
    ('CompanyName',
     'FileDescription',
     'FileVersion',
     'InternalName',
     'LegalCopyright',
     'LegalTradeMarks',
     'OriginalFilename',
     'ProductName',
     'ProductVersion',
     'Comments',
     'Author');
  LabelStr : array [1..InfoNum] of String =
    ('Company Name',
     'Description',
     'File Version',
     'Internal Name',
     'Copyright',
     'TradeMarks',
     'Original File Name',
     'Product Name',
     'Product Version',
     'Comments',
     'Author');
var
  i: integer;
  myInfoItem :TInfoItem;
begin
  for i:= 1 to InfoNum do
  begin
    myInfoItem := TInfoItem.Create;
    myInfoItem.InternalName := InfoStr[i];
    myInfoItem.DisplayName := LabelStr[i];
    myInfoItem.Value := '';
    fInfoItems.Add(myInfoItem);
  end;
end;

{********************************************************************}

procedure TAboutInfo.GetFileDetails(const sFile: string);
var
  DosDate: integer;
  Major, Minor, Release, Build : Word;
begin
  DosDate := FileAge(sFile);
  if DosDate > 0 then
    fBuildDateAsStr := FormatDateTime('mm/dd/yyyy hh:mm', FileDateToDateTime(DosDate))
  else
    fBuildDateAsStr := '';

  if ReadVersionInfo(sFile, @Major, @Minor, @Release, @Build) then
  begin
    fMajor   := Major;
    fMinor   := Minor;
    fRelease := Release;
    fBuild   := Build;
  end
  else
  begin
    fMajor   := 0;
    fMinor   := 0;
    fRelease := 0;
    fBuild   := 0;
  end;

end;

{********************************************************************}

function TAboutInfo.FileVersion: string;
begin
  result := IntToStr(fMajor) + '.' + IntToStr(fMinor) + '.' +
                IntToStr(fRelease) + '.' + IntToStr(fBuild);
end;


{********************************************************************}

function TAboutInfo.FileVersionNoBuild: string;
begin
  result := IntToStr(fMajor) + '.' + IntToStr(fMinor) + '.' +
                IntToStr(fRelease);
end;


{********************************************************************}
function TAboutInfo.OSVersion: string;
var
  Platform: string;
  BuildNumber: Integer;
begin
  result := '';

  case Win32Platform of
    VER_PLATFORM_WIN32_WINDOWS:
      begin
        Platform := 'Windows 95';
        BuildNumber := Win32BuildNumber and $0000FFFF;
      end;
    VER_PLATFORM_WIN32_NT:
      begin
        Platform := 'Windows NT';
        BuildNumber := Win32BuildNumber;
      end;
      else
      begin
        Platform := 'Windows';
        BuildNumber := 0;
      end;
  end;

  if (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) or
    (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    if Win32CSDVersion = '' then
      result := Format('%s %d.%d (Build %d)', [Platform, Win32MajorVersion,
        Win32MinorVersion, BuildNumber])
    else
      result := Format('%s %d.%d (Build %d: %s)', [Platform, Win32MajorVersion,
        Win32MinorVersion, BuildNumber, Win32CSDVersion]);
  end
  else
    result := Format('%s %d.%d', [Platform, Win32MajorVersion,
      Win32MinorVersion])
end;

{********************************************************************}

function TAboutInfo.ReadVersionInfo(sProgram: string; Major, Minor, Release, Build : pWord) :Boolean;
var
  i: integer;
  Info : PVSFixedFileInfo;
{$ifdef VER120}
  InfoSize : Cardinal;
{$else}
  InfoSize : UINT;
{$endif}
  nHwnd : DWORD;
  BufferSize : DWORD;
  Buffer : Pointer;
  Value: PChar;
begin
  BufferSize := GetFileVersionInfoSize(pchar(sProgram),nHWnd); {Get buffer size}
  Result := True;
  if BufferSize <> 0 then begin {if zero, there is no version info}
    GetMem( Buffer, BufferSize); {allocate buffer memory}
    try
      if GetFileVersionInfo(PChar(sProgram),nHWnd,BufferSize,Buffer) then begin
        {got version info}
        for i:= 0 to fInfoItems.Count - 1 do
        begin
          if VerQueryValue(Buffer,PChar('StringFileInfo\040904E4\'+
              TInfoItem(fInfoItems[i]).InternalName),Pointer(Value),InfoSize) then
            if Length(value) > 0 then
              TInfoItem(fInfoItems[i]).Value := value;
        end;

        if VerQueryValue(Buffer, '\', Pointer(Info), InfoSize) then begin
          {got root block version information}
          if Assigned(Major) then begin
            Major^ := HiWord(Info^.dwFileVersionMS); {extract major version}
          end;
          if Assigned(Minor) then begin
            Minor^ := LoWord(Info^.dwFileVersionMS); {extract minor version}
          end;
          if Assigned(Release) then begin
            Release^ := HiWord(Info^.dwFileVersionLS); {extract release version}
          end;
          if Assigned(Build) then begin
            Build^ := LoWord(Info^.dwFileVersionLS); {extract build version}
          end;
        end else begin
          Result := False; {no root block version info}
        end;
      end else begin
        Result := False; {couldn't get version info}
      end;
    finally
      FreeMem(Buffer, BufferSize); {release buffer memory}
    end;
  end else begin
    Result := False; {no version info at all}
  end;
end;

{********************************************************************}

procedure TfmAbout.Button1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

{********************************************************************}

procedure TfmAbout.FormShow(Sender: TObject);
var
  myAboutInfo: TAboutInfo;
begin
//  Image1.Picture.Icon := Application.Icon;
  Caption := 'About ' + Application.Title;

  myAboutInfo := TAboutInfo.Create(ParamStr(0));

  labVersion.Caption := 'Pre-Release v' + myAboutInfo.FileVersion;
  labDate.Caption := 'Last Build: ' + myAboutInfo.FileBuildDate;
//  EditVer.Text := myAboutInfo.FileVersion + '    ' + myAboutInfo.FileBuildDate;
//  EditOS.Text := myAboutInfo.OSVersion;

  myAboutInfo.Free;
end;

procedure TfmAbout.Label2Click(Sender: TObject);
begin
  ShellExecute(0,'open','http://aiplanet.sourceforge.net','','',SW_SHOW);
end;

end.
