
  //  Функция основана на VectorGeometry.PointInPolygon
  function PointInPolygon2 (p: {$IFDEF SCHEMEMODE}
    TGLLines {$ELSE} TGLPolygonBase {$ENDIF}; v:TGLVector): boolean;
  var
    i,c: integer;
    px,pz: single;
  begin
  Result:=false;
  c:=p.Nodes.Count-1;
  px:=v.X;  pz:=v.Z;
  for i:=0 to p.Nodes.Count-1 do
    with p do
      begin
      if ((((Nodes[i].Z<=pz)and(pz<Nodes[c].Z))or
        ((Nodes[c].Z<=pz)and(pz<Nodes[i].Z)))and
        (px<(Nodes[c].X-Nodes[i].X)*(pz-Nodes[i].Z)/
        (Nodes[c].Z-Nodes[i].Z)+Nodes[i].X)) then
        Result:=not Result;
      c:=i;
      end;
  end;

  function AbsNodePos (line: {$IFDEF SCHEMEMODE}
    TGLLines {$ELSE} TGLPolygonBase {$ENDIF};
    node:integer): TGLVector;
  begin
  with line do
    Result:=LocalToAbsolute(Nodes[node].AsVector);
  end;

  procedure UnitePolygons (line1,line2: {$IFDEF SCHEMEMODE}
    TGLLines {$ELSE} TGLPolygonBase {$ENDIF});
  var
    i,j: integer;
    min_i,min_j: integer;
    min_d,t: single;
    tn: array of TGLVector;
  begin
  //  Точки II линии внутри I удаляем
  j:=0;
  while j<line2.Nodes.Count do
    if PointInPolygon2(line1,line1.
      AbsoluteToLocal(AbsNodePos(line2,j))) then
      line2.Nodes.Delete(j)
    else
      j:=j+1;

  //  И наоборот
  i:=0;
  while i<line1.Nodes.Count do
    if PointInPolygon2(line2,line2.
      AbsoluteToLocal(AbsNodePos(line1,i))) then
      line1.Nodes.Delete(i)
    else
      i:=i+1;

  min_i:=0;
  min_j:=0;
  min_d:=100;
  //  Находим 2 наиболее близких узла
  for i:=0 to line1.Nodes.Count-1 do
    for j:=0 to line2.Nodes.Count-1 do
      begin
      t:=VectorDistance2(AbsNodePos(line1,i),
        AbsNodePos(line2,j));
      if t<min_d then
        begin
        min_d:=t;
        min_i:=i;
        min_j:=j;
        end;
      end;

  //  Все узлы I линии после min_i временно убираем,
  //  чтобы новые вставить между i_min и i_min+1 узлами
  SetLength(tn,line1.Nodes.Count-1-min_i-1+1);
  for i:=min_i+1 to line1.Nodes.Count-1 do
    begin
    tn[i-min_i-1]:=line1.Nodes[min_i+1].AsVector;
    line1.Nodes.Delete(min_i+1);
    end;

  //  Все узлы II линии добавляем в конец I линии
  for j:=min_j to line2.Nodes.Count-1 do
    line1.AddNode(line1.AbsoluteToLocal(
      AbsNodePos(line2,j)));
  for j:=0 to min_j-1 do
    line1.AddNode(line1.AbsoluteToLocal(
      AbsNodePos(line2,j)));

  //  Возвращаем убранные узлы
  for i:=0 to Length(tn)-1 do
    line1.AddNode(tn[i]);

  line2.Nodes.Clear;
  SetLength(tn,0);
  end;
