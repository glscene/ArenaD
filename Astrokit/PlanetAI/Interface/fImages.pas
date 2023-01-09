{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: fImages.pas,v 1.4 2003/06/28 21:47:54 aidave Exp $
}
unit fImages;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,Forms, Dialogs,
  ImgList, Vcl.ExtCtrls,System.ImageList;

type
  TfmImages = class(TForm)
    panImages: TPanel;
    imgIcons: TImageList;
  private
     
  public
     
  end;

var
  fmImages: TfmImages;

implementation

uses fFirstForm;

{$R *.DFM}

end.
