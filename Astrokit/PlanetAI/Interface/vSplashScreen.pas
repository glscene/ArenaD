{
  $Id: vSplashScreen.pas,v 1.2 2003/06/28 21:47:54 aidave Exp $
}
unit vSplashScreen;

interface

uses
  Windows,
  Winapi.Messages,
  System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,Forms, Dialogs,
  Vcl.Imaging.Jpeg, ExtCtrls;

type
  pCardinal = ^Cardinal;

function BitmapToRegion (hBmp: HBitmap; cTransparentColor:  COLORREF;
cTolerance: Byte): HRGN;

implementation

function BitmapToRegion (hBmp: HBitmap; cTransparentColor:  COLORREF;
  cTolerance: Byte): HRGN; 

  function min(i, j: LongInt): LongInt; 
  begin 
    if i < j then 
      result := i 
    else 
      result := j; 
  end; 

const                       
  ALLOC_UNIT = 100; 
var 
  rtnRgn: HRGN; 
  hMemDC: HDC; 
  tmphDC: HDC; 
  bm: Windows.TBitmap; 
  RGB32BITSBITMAPINFO: TBitmapInfoHeader; 
  RGB32BITSBITMAP: TBitmapInfo; 
  x, y: Longint;//for variables
  pbits32: Pointer;
  hbm32: HBITMAP;
  holdBMP, holdBMP2: HBITMAP;
  bm32: Windows.TBitmap; 
  MaxRects: DWORD;
  hData: Cardinal;
  pData: pRGNDATA;
  lr: BYTE;
  lg: BYTE;
  lb: BYTE;
  hr: BYTE;
  hg: BYTE;
  hb: BYTE;
  p32: pByte;
  h, h1: HRGN;
  x0: Longint;
  p: pCardinal;
  b: BYTE;
  pr: pRect;
  tmpRect: TRect;
begin
  rtnRgn := 0;
  if (hBmp <> 0) then
  begin
    (* Create a memory DC inside which we will scan the bitmap content *)
    hMemDC := CreateCompatibleDC(0);
    if (hMemDC <> 0) then
    begin
      (* Get bitmap size *)
      GetObject(hBmp, sizeof(bm), @bm);

      (* Create a 32 bits depth bitmap and select it into the memory DC *)
      with RGB32BITSBITMAPINFO do
      begin
        biSize := sizeof(TBITMAPINFOHEADER);
        biWidth := bm.bmWidth; 
        biHeight := bm.bmHeight; 
        biPlanes := 1;
        biBitCount := 32;
        biCompression := BI_RGB;
        biSizeImage := 0;
        biXPelsPerMeter := 0;
        biYPelsPerMeter := 0;
        biClrUsed := 0;
        biClrImportant := 0;
      end;

      RGB32BITSBITMAP.bmiHeader := RGB32BITSBITMAPINFO;
      pBits32 := nil;
      hbm32 := CreateDIBSection(hMemDC, RGB32BITSBITMAP,
        DIB_RGB_COLORS, pbits32, 0, 0);
if (hbm32 <> 0) then
      begin
        holdBmp := HBITMAP(SelectObject(hMemDC, hbm32));

        (* Create a DC just to copy the bitmap into the memory DC *)
        tmphDC := CreateCompatibleDC(hMemDC);
        if (tmphDC <> 0) then
        begin
          (*Get how many bytes per row we have for the bitmap
            bits (rounded up to 32 bits) *)
          GetObject(hbm32, sizeof(bm32), @bm32);
          while (bm32.bmWidthBytes mod 4) <> 0 do 
            Inc(bm32.bmWidthBytes); 

          // Copy the bitmap into the memory DC
          holdBmp2 := HBITMAP(SelectObject(tmphDC, hBmp));
          Windows.BitBlt(hMemDC, 0, 0, bm.bmWidth, bm.bmHeight, tmphDC, 
            0, 0, SRCCOPY);

          (* For better performances, we will use the ExtCreateRegion()
            function to create the region. This function take a RGNDATA
            structure on entry. We will add rectangles by amount of
            ALLOC_UNIT number in this structure. *)
          maxRects := ALLOC_UNIT;
          hData := GlobalAlloc(GMEM_MOVEABLE, sizeof(TRGNDATAHEADER) +
            (sizeof(TRECT) * maxRects));
          pData := pRGNDATA(GlobalLock(hData));
          pData.rdh.dwSize := sizeof(TRGNDATAHEADER);
          pData.rdh.iType := RDH_RECTANGLES;
          pData.rdh.nCount := 0;
          pData.rdh.nRgnSize := 0; 
          SetRect(pData.rdh.rcBound, MAXLONG, MAXLONG, 0, 0); 

          (* Keep on hand highest and lowest values 
            for the "transparent" pixels *) 
          lr := GetRValue(cTransparentColor); 
          lg := GetGValue(cTransparentColor); 
          lb := GetBValue(cTransparentColor); 
          hr := min($ff, lr + cTolerance); 
          hg := min($ff, lg + cTolerance); 
          hb := min($ff, lb + cTolerance); 

          (* Scan each bitmap row from bottom to top (the bitmap 
            is inverted vertically) *) 
          p32 := pByte(Cardinal(bm32.bmBits) + ((Cardinal(bm32.bmHeight) - 1) *
            Cardinal(bm32.bmWidthBytes))); 
          for y := 1  to bm.bmHeight do 
          begin 
            (* Scan each bitmap pixel from left to right *) 
            x := 0; 
            while x < bm.bmWidth do 
            begin 
              (* Search for a continuous range of "non transparent pixels" *) 
              x0 := x; 
              p := pCardinal(Cardinal(p32) + (sizeof(Cardinal)* Cardinal(x))); 
              while (x < bm.bmWidth) do 
              begin 
                b := GetRValue(p^); 
                if (b >= lr) and (b <= hr) then 
                begin 
                  b := GetGValue(p^); 
                  if (b >= lg) and (b <= hg) then 
                  begin 
                    b := GetBValue(p^); 
                    if (b >= lb) and (b <= hb) then 
                    begin 
                      (* This pixel is "transparent" *) 
                      x0 := x0; 
                      break; 
                    end; 
                  end; 
                end; 
                Inc(p); 
                Inc(x);
              end; 

              if (x > x0) then 
              begin 
                (* Add the pixels (x0, y) to (x, y+1) as a new 
                  rectangle in the region *) 
                if (pData.rdh.nCount >= maxRects) then 
                begin 
                  GlobalUnlock(hData); 
                  maxRects := maxRects + ALLOC_UNIT; 
                  hData := GlobalReAlloc(hData, sizeof(TRGNDATAHEADER) + 
                    (sizeof(TRECT) * maxRects), GMEM_MOVEABLE); 
                  pData := pRGNDATA(GlobalLock(hData)); 
                end; 
                pr := pRECT(@pData.Buffer); 
                Windows.SetRect(tmpRect, x0, y, x, y+1); 
                pRect(Cardinal(pr) + (Cardinal(pData.rdh.nCount) 
                  * SizeOf(TRect)))^ := tmpRect; 
                if (x0 < pData.rdh.rcBound.left) then 
                  pData.rdh.rcBound.left := x0; 
                if (y < pData.rdh.rcBound.top) then 
                  pData.rdh.rcBound.top := y; 
                if (x > pData.rdh.rcBound.right) then 
                  pData.rdh.rcBound.right := x; 
                if (y+1 > pData.rdh.rcBound.bottom) then 
                  pData.rdh.rcBound.bottom := y+1; 
                inc(pData.rdh.nCount); 

                (* On Windows98, ExtCreateRegion() may fail if the number
                  of rectangles is too large (ie: > 4000). Therefore, we have 
                  to create the region by multiple steps. *) 
                if (pData.rdh.nCount = 2000) then 
                begin 
                  h1 := ExtCreateRegion(nil, sizeof(TRGNDATAHEADER) + 
                    (sizeof(TRECT) * maxRects), pData^); 
                  if (rtnRgn <> 0) then 
                  begin 
                    CombineRgn(rtnRgn, rtnRgn, h1, RGN_OR); 
                    DeleteObject(h1); 
                  end else 
                    rtnRgn := h1; 
                  pData.rdh.nCount := 0; 
                  SetRect(pData.rdh.rcBound, MAXLONG, MAXLONG, 0, 0); 
                end; 
              end; 
              Inc(x); 
            end; 

            (* Go to next row (remember, the bitmap is inverted vertically) *) 
            p32 := pByte(LongInt(p32) - LongInt(bm32.bmWidthBytes)); 
          end; 

          (* Create or extend the region with the remaining rectangles *) 
          h := ExtCreateRegion(NIL, sizeof(TRGNDATAHEADER) + (sizeof(TRECT) * 
            maxRects), pData^); 
          if (rtnRgn <> 0) then
          begin 
            CombineRgn(rtnRgn, rtnRgn, h, RGN_OR);
            DeleteObject(h); 
          end else 
            rtnRgn := h; 

          (* Clean up *) 
          GlobalFree(hData); 
          SelectObject(tmphDC, holdBMP2); 
          DeleteDC(tmphDC); 
        end; 
        DeleteObject(SelectObject(hMemDC, holdBmp)); 
      end;
      DeleteDC(hMemDC);
    end;
  end;
  Result := rtnRgn;
end;

end.
