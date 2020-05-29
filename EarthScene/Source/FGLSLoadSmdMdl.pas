unit FGLSLoadSmdMdl;
// USMD Stuff unit demo by Mrqzzz (mrqzzz@yahoo.it)
// printer by ilh 02
interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  VCL.Graphics, VCL.Controls, VCL.Forms, VCL.Dialogs,
  VCL.StdCtrls, VCL.Buttons, VCL.Printers, VCL.ComCtrls;


type
  TVec3 = array[0..2] of single;
  TVec4 = array[0..3] of single;

type
  TStudioHeader = record
    ID                   : array[0..3] of char;
    Version              : integer;
    Name                 : array[0..63] of char;
    FileSize             : integer;
    EyePosition          : TVec3;
    Min                  : TVec3;
    Max                  : TVec3;
    BBMin                : TVec3;
    BBMax                : TVec3;
    Flags                : integer;
    NumBones             : integer;
    BoneOffset           : integer;
    NumBoneContollers    : integer;
    BoneControllerOffset : integer;
    NumHitBoxes          : integer;
    HitBoxOffset         : integer;
    NumSeq               : integer;
    SeqOffset            : integer;
    NumSeqGroups         : integer;
    SeqGroupOffset       : integer;
    NumTextures          : integer;
    TextureOffset        : integer;
    TextureDataOffset    : integer;
    NumSkinRef           : integer;
    NumSkinFamilies      : integer;
    SkinOffset           : integer;
    NumBodyParts         : integer;
    BodyPartOffset       : integer;
    NumAttachements      : integer;
    AttachementOffset    : integer;
    SoundTable           : integer;
    SoundOffset          : integer;
    SoundGroups          : integer;
    SoundGroupOffset     : integer;
    NumTransitions       : integer;
    TransitionOffset     : integer;
  end;

type
  TStudioSeqHeader = record
    ID      : array[0..3] of char;//integer;
    Version : integer;
    Name    : array[0..63] of char;
    Laenge  : integer;
  end;

type
  TStudioBone = record
    Name           : array[0..31] of char;
    Parent         : integer;
    Flags          : integer;
    BoneController : array[0..5] of integer;
    Value          : array[0..5] of single;
    Scale          : array[0..5] of single;
  end;

type
  TStudioBoneController = record
    Bone  : integer;
    Typ   : integer;
    Start : integer;
    Ende  : integer;
    Rest  : integer;
    Index : integer;
  end;

type
  TStudioBoundingBox = record
    Bone  : integer;
    Group : integer;
    BBMin : TVec3;
    BBMax : TVec3;
  end;

type
  TCacheUser = pointer;

type
  TStudioSequenceGroup = record
    Bezeichnung : array[0..31] of char;
    Name        : array[0..63] of char;
    Cache       : TCacheUser;
    Data        : integer;
  end;

type
  TStudioSequenceDescription = record
    Bezeichnung         : array[0..31] of char;
    FPS                 : single;
    Flags               : integer;
    Activity            : integer;
    ActWeight           : integer;
    NumEvents           : integer;
    EventOffset         : integer;
    NumFrames           : integer;
    NumPivots           : integer;
    PivotOffset         : integer;
    MotionTyp           : integer;
    MotionBone          : integer;
    LinearMovement      : TVec3;
    AutoMovePosOffset   : integer;
    AutoMoveAngleOffset : integer;
    BBMin               : TVec3;
    BBMax               : TVec3;
    NumBlends           : integer;
    AnimOffset          : integer;
    BlendType           : array[0..1] of integer;
    BlendStart          : array[0..1] of single;
    BlendEnd            : array[0..1] of single;
    BlendParent         : integer;
    SequenceGroup       : integer;
    EntryNode           : integer;
    ExitNode            : integer;
    NodeFlags           : integer;
    NextSequence        : integer;
  end;

type
  TStudioEvent = record
    Frame   : integer;
    Event   : integer;
    Typ     : integer;
    Options : array[0..63] of char;
  end;

type
  TStudioPivots = record
    Origin : TVec3;
    Start  : integer;
    Ende   : integer;
  end;

type
  TStudioAttachement = record
    Name    : array[0..31] of char;
    Typ     : integer;
    Bone    : integer;
    Origin  : TVec3;
    Vectors : array[0..2] of TVec3;
  end;

type
  TStudioAnim = record
    Offset : array[0..5] of shortint;
  end;


type
  TStudioAnimValue = record
{
    case Byte of
      0 : Valid;
      1 : Total;
    end;
}
    Valid : byte;
    Total : byte;
    Value : byte;
  end;

type
  TStudioBodyParts = record
    Name        : array[0..63] of char;
    NumModels   : integer;
    Base        : integer;
    ModelOffset : integer;
  end;

type
  TStudioTexture = record
    Name   : array[0..63] of char;
    Flags  : integer;
    Width  : integer;
    Height : integer;
    Offset : integer;
  end;

type
  TStudioModel = record
    Name           : array[0..63] of char;
    Typ            : integer;
    BoundingRadius : single;
    NumMesh        : integer;
    MeshOffset     : integer;
    NumVerts       : integer;
    VertInfoOffset : integer;
    VertOffset     : integer;
    NumNorms       : integer;
    NormOffset     : integer;
    NumGroups      : integer;
    GroupOffset    : integer;
  end;

type
  TStudioMesh = record
    NumTris    : integer;
    TriOffset  : integer;
    SkinRef    : integer;
    NumNorms   : integer;
    NormOffset : integer;
  end;

type
  TStudioTriVert = record
    VertOffset : integer;
    NormOffset : integer;
    S          : integer;
    T          : integer;
  end;

type
  TGlsLoadSmdMdlFrm = class(TForm)
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    LBSequenz: TListBox;
    LBBones: TListBox;
    LBMDL: TListBox;
    LBBoneController: TListBox;
    FileNameLabel: TLabel;
    MDLoadBtn: TSpeedButton;
    PrintBtn: TSpeedButton;
    QcPrintBtn: TSpeedButton;
    QcLoadBtn: TSpeedButton;
    QcFileNameLabel: TLabel;
    RichEdit1: TRichEdit;
    QcSaveBtn: TSpeedButton;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure MDLoadBtnClick(Sender: TObject);
procedure DoMdlOpen(const FileName : TFileName);
    procedure PrintBtnClick(Sender: TObject);
    procedure QcPrintBtnClick(Sender: TObject);
    procedure QcLoadBtnClick(Sender: TObject);
    procedure QcSaveBtnClick(Sender: TObject);
  private
  public
  end;

var
  GlsLoadSmdMdlFrm: TGlsLoadSmdMdlFrm;

//---------------------------------------------------------------
implementation
//---------------------------------------------------------------

{$R *.DFM}

uses
 uGlobals;

procedure TGlsLoadSmdMdlFrm.FormCreate(Sender: TObject);
begin
  top := GlsSmdLoadMdlFormY;
  left := GlsSmdLoadMdlFormX;
end;
procedure TGlsLoadSmdMdlFrm.FormShow(Sender: TObject);
begin
  GlsLoadSmdMdlFrm.Cursor:=crDefault;
end;

procedure TGlsLoadSmdMdlFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  GlsSmdLoadMdlFormY := GlsLoadSmdMdlFrm.top;
  GlsSmdLoadMdlFormX := GlsLoadSmdMdlFrm.left;
  ModalResult:=mrOK;
end;


procedure TGlsLoadSmdMdlFrm.MDLoadBtnClick(Sender: TObject);
begin
  OpenDialog1.Filter := 'lifeless (*.mdl)|*.mdl';
 { OpenDialog1.InitialDir := TigerPath;}
  OpenDialog1.Filename:='*.mdl';
  if OpenDialog1.execute then
     DoMdlOpen(OpenDialog1.FileName);
end;
procedure TGlsLoadSmdMdlFrm.DoMdlOpen(const FileName : TFileName);
var
  MDL            : file;
  I              : integer;
  Header         : TStudioHeader;
  BoneController : TStudioBoneController;
  Bone           : TStudioBone;
  Sequenz        : TStudioSeqHeader;
  begin
 {   TigerPath:=ExtractFilePath(FileName);}
    FileNameLabel.Caption:=ExtractFileName(FileName);
  LBMDL.Items.Clear;
  LBBoneController.Items.Clear;
  LBBones.Items.Clear;
  LBSequenz.Items.Clear;
  AssignFile(MDL, FileName);
  Reset(MDL, 1);
  BlockRead(MDL, Header, SizeOf(Header));
  with LBMDL.Items do begin
    Add('ID : ' + Header.ID);
    Add('Version : ' + IntToStr(Header.Version));
    Add('Name : ' + Header.Name);
    Add('Length : ' + IntToStr(Header.FileSize));
    Add(Format('EyePosition : %3.2f, %3.2f, %3.2f', [Header.EyePosition[0], Header.EyePosition[1], Header.EyePosition[2]]));
    Add(Format('Min : %3.2f, %3.2f, %3.2f', [Header.Min[0], Header.Min[1], Header.Min[2]]));
    Add(Format('Max : %3.2f, %3.2f, %3.2f', [Header.Max[0], Header.Max[1], Header.Max[2]]));
    Add(Format('BBMin : %3.2f, %3.2f, %3.2f', [Header.BBMin[0], Header.BBMin[1], Header.BBMin[2]]));
    Add(Format('BBMax : %3.2f, %3.2f, %3.2f', [Header.BBMax[0], Header.BBMax[1], Header.BBMax[2]]));
    Add('Flags : ' + IntToStr(Header.Flags));
    Add('NumBones : ' + IntToStr(Header.NumBones));
    Add('BoneOffset : ' + IntToStr(Header.BoneOffset));
    Add('NumBoneControllers : ' + IntToStr(Header.NumBoneContollers));
    Add('BoneControllerOffset : ' + IntToStr(Header.BoneControllerOffset));
    Add('NumHitBoxes : ' + IntToStr(Header.NumHitBoxes));
    Add('HitBoxOffset : ' + IntToStr(Header.HitBoxOffset));
    Add('NumSeq : ' + IntToStr(Header.NumSeq));
    Add('SeqOffset : ' + IntToStr(Header.SeqOffset));
    Add('NumSeqGroups : ' + IntToStr(Header.NumSeqGroups));
    Add('SeqGroupOffset : ' + IntToStr(Header.SeqGroupOffset));
    Add('NumTextures : ' + IntToStr(Header.NumTextures));
    Add('TextureOffset : ' + IntToStr(Header.TextureOffset));
    Add('TextureDataOffset : ' + IntToStr(Header.TextureDataOffset));
    Add('NumSkinRef : ' + IntToStr(Header.NumSkinRef));
    Add('NumSkinFamilies : ' + IntToStr(Header.NumSkinFamilies));
    Add('SkinOffset : ' + IntToStr(Header.SkinOffset));
    Add('NumBodyParts : ' + IntToStr(Header.NumBodyParts));
    Add('BodyPartOffset : ' + IntToStr(Header.BodyPartOffset));
    Add('NumAttachements : ' + IntToStr(Header.NumAttachements));
    Add('AttachementOffset : ' + IntToStr(Header.AttachementOffset));
    Add('SoundTable : ' + IntToStr(Header.SoundTable));
    Add('SoundOffset : ' + IntToStr(Header.SoundOffset));
    Add('SoundGroups : ' + IntToStr(Header.SoundGroups));
    Add('SoundGroupOffset : ' + IntToStr(Header.SoundGroupOffset));
    Add('NumTransitions : ' + IntToStr(Header.NumTransitions));
    Add('TransitionOffset : ' + IntToStr(Header.TransitionOffset));
  end;
  Seek(MDL, Header.BoneControllerOffset);
  for I := 0 to Header.NumBoneContollers - 1 do begin
    BlockRead(MDL, BoneController, SizeOf(BoneController));
    with BoneController do begin
      LBBoneController.Items.Add('Bone  : ' + IntToStr(Bone));
      LBBoneController.Items.Add('Typ   : ' + IntToStr(Typ));
      LBBoneController.Items.Add('Start : ' + IntToStr(Start));
      LBBoneController.Items.Add('Ende  : ' + IntToStr(Ende));
      LBBoneController.Items.Add('Rest  : ' + IntToStr(Rest));
      LBBoneController.Items.Add('Index : ' + IntToStr(Index));
    end;
  end;
  Seek(MDL, Header.BoneOffset);
  for I := 0 to Header.NumBones - 1 do begin
    BlockRead(MDL, Bone, SizeOf(Bone));
    with Bone do begin
      LBBones.Items.Add('Name   : ' + Name);
      LBBones.Items.Add('Parent : ' + IntToStr(Parent));
      LBBones.Items.Add('Flags  : ' + IntToStr(Flags));
      LBBones.Items.Add(Format('BoneController : %3d, %3d, %3d, %3d, %3d', [BoneController[0], Bonecontroller[1], BoneController[2], BoneController[3], BoneController[4], BoneController[5]]));
      LBBones.Items.Add(Format('Value : %3.2f, %3.2f, %3.2f, %3.2f, %3.2f', [Value[0], Value[1], Value[2], Value[3], Value[4], Value[5]]));
      LBBones.Items.Add(Format('Scale : %3.2f, %3.2f, %3.2f, %3.2f, %3.2f', [Scale[0], Scale[1], Scale[2], Scale[3], Scale[4], Scale[5]]));
    end;
  end;
  Seek(MDL, Header.SeqOffset);
  for I := 0 to Header.NumSeq - 1 do begin
    BlockRead(MDL, Sequenz, SizeOf(Sequenz));
    with Sequenz do begin
      LBSequenz.Items.Add('ID : ' + ID);
      LBSequenz.Items.Add('Version : ' + IntToStr(Version));
      LBSequenz.Items.Add('Name : ' + Name);
      LBSequenz.Items.Add('Laenge : ' + IntToStr(Laenge));
    end;
  end;
  CloseFile(MDL);
end;




procedure TGlsLoadSmdMdlFrm.PrintBtnClick(Sender: TObject);
{FileNameLabel
LBMDL
LBBoneController
LBBones
LBSequenz}
{var  i: Integer; }
begin
    with Printer do
    begin
      BeginDoc;
{  for i := 0 to (LBMDL.Items.Count - 1) do
  begin    LBMDL.Items.Strings[i]       }
          LBMDL.PaintTo(Handle, 10, 10);
          NewPage;
          LBBoneController.PaintTo(Handle, 10, 10);
          NewPage;
          LBBones.PaintTo(Handle, 10, 10);
          NewPage;
          LBSequenz.PaintTo(Handle, 10, 10);
          NewPage;
      EndDoc;
    end;
end;



procedure TGlsLoadSmdMdlFrm.QcPrintBtnClick(Sender: TObject);
begin
  // The parameter string shows in the print queue under "Document   // name".
  RichEdit1.Print(QcFileNameLabel.Caption);
end;

procedure TGlsLoadSmdMdlFrm.QcLoadBtnClick(Sender: TObject);
begin
  OpenDialog1.Filter := 'qc files (*.qc)|*.qc';
 { OpenDialog1.InitialDir := TigerPath; }
  OpenDialog1.Filename:='*.qc';
  if OpenDialog1.execute then
  begin
   { TigerPath:=ExtractFilePath(OpenDialog1.FileName);}
    RichEdit1.Clear;
    RichEdit1.Lines.LoadFromFile(OpenDialog1.FileName);
    QcFileNameLabel.Caption:=ExtractFileName(OpenDialog1.FileName);
  end;
end;

procedure TGlsLoadSmdMdlFrm.QcSaveBtnClick(Sender: TObject);
begin
  SaveDialog1.Filter := 'qc files (*.qc)|*.qc';
{  SaveDialog1.InitialDir := TigerPath;}
  SaveDialog1.Filename:=OpenDialog1.FileName;
  if SaveDialog1.execute then
  begin
    {TigerPath:=ExtractFilePath(SaveDialog1.FileName);}
    RichEdit1.Lines.SavetoFile(SaveDialog1.FileName);
    QcFileNameLabel.Caption:=ExtractFileName(SaveDialog1.FileName);
  end;
end;

end.
