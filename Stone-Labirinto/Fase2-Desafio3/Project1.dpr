program Project1;

uses
  classes,
  System.DateUtils,
  System.SysUtils,
  System.Math;

const ArquivoEntrada = 'C:\Temp\Lab\Fase3\input.txt';
      ArquivoSaida = 'C:\temp\lab\fase3\output.txt';

      type caminho = array of integer;
type caminhos = array of caminho;

var
  vArena, vArenaBack, vArena2: array of array of integer;
  endX, endY, maxX, maxY, vMax, vMaxAdd: integer;
  txt: string;
  bAchou: boolean;
  vKeys, vCopy: caminhos;
  vFinal: array of integer;
  Start, Start2: TDateTime;

procedure CriaArena2;
var x, y: integer;
begin
  SetLength(vArena2, maxY);
  for y := 0 to maxY - 1 do
  begin
    SetLength(vArena2[y], maxX);
    for x := 0 to maxX - 1 do
      vArena2[y][x] := 0;
  end;
end;

procedure CriaArenaBack;
var x, y: integer;
begin
  SetLength(vArenaBack, maxY);
  for y := 0 to maxY - 1 do
  begin
    SetLength(vArenaBack[y], maxX);
    for x := 0 to maxX - 1 do
      vArenaBack[y][x] := 0;
  end;
end;

procedure GuardaArena;
var x, y: integer;
begin
  for y := 1 to maxY - 2 do
    for x := 1 to maxX - 2 do
      vArenaBack[y, x] := vArena[y, x];
end;

procedure RecalcArena;
var x, y, nSum: integer;
begin
  GuardaArena;
  for y := 1 to maxY - 2 do
  begin
    for x := 1 to maxX - 2 do
    begin
      nSum := vArena[y - 1][x - 1] + vArena[y - 1][x] + vArena[y - 1][x + 1]
          + vArena[y][x - 1]  + vArena[y][x +  1]
          + vArena[y + 1][x - 1] + vArena[y + 1][x] + vArena[y + 1][x + 1];

      if vArena[y][x] = 0 then
      begin
        if (nSum > 1) and (nSum < 5) then
          vArena2[y][x] := 1
        else
          vArena2[y][x] := 0;
      end
      else
      begin
        if (nSum > 3) and (nSum < 6) then
          vArena2[y][x] := 1
        else
          vArena2[y][x] := 0;
      end;
    end;
    vArena2[1][1] := 0;
    vArena2[endY][endX] := 0;

  end;

  for y := 1 to maxY - 2 do
    for x := 1 to maxX - 2 do
      vArena[y, x] := vArena2[y, x];
end;

procedure printArena;
var x, y: integer;
begin
  for y := 1 to maxY - 2 do
  begin
    for x := 1 to maxX - 2 do
      write(vArena[y, x]);
    Writeln;
  end;
  Writeln;
end;

procedure CriaArena;
var ListaTexto: TStringList;
    x, y: integer;
begin
  ListaTexto := TStringList.Create;
  ListaTexto.LoadFromFile(ArquivoEntrada);

  maxY := ListaTexto.Count + 2;
  maxX := length(ListaTexto[0].replace(' ', '')) + 2;
  SetLength(vArena, maxY);

  SetLength(vArena[0], maxX);
  for x := 0 to maxX do
    vArena[0][x] := 0;

  for y := 0 to maxY - 3 do
  begin
    txt := '0' + ListaTexto[y].replace(' ', '') + '0';
    SetLength(vArena[y + 1], maxX);
    for x := 0 to maxX do
      vArena[y + 1][x] := ord(txt[x + 1]) - ord('0');
    if pos('4', txt) > 0 then
    begin
      endX := pos('4', txt) - 1;
      endY := y + 1;
    end;
  end;

  SetLength(vArena[maxY - 1], maxX);
  for x := 0 to maxX do
    vArena[maxY - 1][x] := 0;

  ListaTexto.Clear;
end;

procedure VeAdd(vAnt: caminho; i, xv, yv: integer);
var x, nLen, nVidas, nInv, nSum, nPos, xRef, yRef: integer;
    sVal: string;
    vInclui: array of integer;
begin
  if bAchou then exit;

//  if (xv * yv < vMax - 400) then exit;
//  if (xv + yv < vMaxAdd * 0.95) then exit;
  if (xv + yv < vMaxAdd - 100) then exit;

  x := High(vAnt);
  nVidas := vAnt[x];

  if vArena[yv][xv] = 1 then
  begin
    nSum := vArenaBack[yv - 1][xv - 1] + vArenaBack[yv - 1][xv] + vArenaBack[yv - 1][xv + 1]
        + vArenaBack[yv][xv - 1]  + vArenaBack[yv][xv +  1]
        + vArenaBack[yv + 1][xv - 1] + vArenaBack[yv + 1][xv] + vArenaBack[yv + 1][xv + 1];
    sVal := IntToStr(vArenaBack[yv - 1][xv - 1])
          + IntToStr(vArenaBack[yv - 1][xv])
          + IntToStr(vArenaBack[yv - 1][xv + 1])
          + IntToStr(vArenaBack[yv][xv - 1])
          + ' '
          + IntToStr(vArenaBack[yv][xv +  1])
          + IntToStr(vArenaBack[yv + 1][xv - 1])
          + IntToStr(vArenaBack[yv + 1][xv])
          + IntToStr(vArenaBack[yv + 1][xv + 1]);

    if vArenaBack[yv][xv] = 0 then
    begin
      if (nSum = 2) then
        nInv := -1
      else if (nSum = 3) then
        nInv := -2
      else
        nInv := 1;
    end
    else
    begin
      if (nSum = 4) then
        nInv := -1
      else
        nInv := 1;
    end;

    SetLength(vInclui, 0);
    for x := 1 to abs(nInv) do
    begin
      inc(nVidas);
      if nVidas > 30 then
        exit;

      SetLength(vInclui, Length(vInclui) + 3);
      vInclui[Length(vInclui) - 3] := -1;
      if nInv > 0 then
      begin
        nPos := pos('0', sVal);
        sVal[nPos] := '1';
      end
      else
      begin
        nPos := pos('1', sVal);
        sVal[nPos] := '0';
      end;
      xRef := ((nPos - 1) mod 3) - 1;
      yRef := ((nPos + 2) div 3) - 2;
      vInclui[Length(vInclui) - 2] := xRef + xv;
      vInclui[Length(vInclui) - 1] := yRef + yv;
    end;
  end;

  if high(vFinal) > 0 then
    for x := 0 to high(vFinal) div 2 do
      if (vFinal[x * 2] = xv) and (vFinal[x * 2 + 1] = yv) then
        exit;

  nLen := length(vFinal);
  SetLength(vFinal, nLen + 2);
  vFinal[nLen] := xv;
  vFinal[nLen + 1] := yv;

  if (xv = endX) and (yv = endY) then
  begin
    bAchou := True;
    SetLength(vKeys, 0);
  end;

  nLen := length(vKeys);
  SetLength(vKeys, nLen + 1);
  SetLength(vKeys[nLen], length(vAnt) + length(vInclui) + 1);
  for x := 0 to High(vAnt) - 3 do
    vKeys[nLen][x] := vAnt[x];

  nPos := High(vAnt) - 2;
  for x := 0 to High(vInclui) do
    vKeys[nLen][nPos + x] := vInclui[x];

  x := High(vKeys[nLen]);
  vKeys[nLen][x - 3] := i;
  vKeys[nLen][x - 2] := xv;
  vKeys[nLen][x - 1] := yv;
  vKeys[nLen][x] := nVidas;
end;

procedure CopiaKeys;
var x1, x2, xv, yv, nLenKey: integer;
begin
  vMax := 0;
  vMaxAdd := 0;

  for x1 := 0 to High(vKeys) do
  begin
    nLenKey := Length(vKeys[x1]);
    xv := vKeys[x1][nLenKey - 3];
    yv := vKeys[x1][nLenKey - 2];

    vMaxAdd := max(vMaxAdd, xv + yv);
    vMax := max(vMax, xv * yv);
  end;

  SetLength(vCopy, Length(vKeys));
  for x1 := 0 to High(vKeys) do
  begin
    SetLength(vCopy[x1], length(vKeys[x1]));
    for x2 := 0 to High(vKeys[x1]) do
      vCopy[x1][x2] := vKeys[x1][x2];
  end;

  SetLength(vKeys, 0);
end;

procedure CriaNovosKeys;
var x1, xv, yv, nLenCopy: integer;
begin
  SetLength(vFinal, 0);

  for x1 := 0 to High(vCopy) do
  begin
    nLenCopy := Length(vCopy[x1]);
    xv := vCopy[x1][nLenCopy - 3];
    yv := vCopy[x1][nLenCopy - 2];

    if xv < maxX - 2 then
      VeAdd(vCopy[x1], 0, xv + 1, yv);
    if yv < maxY - 2 then
      VeAdd(vCopy[x1], 1, xv, yv + 1);
    if xv > 1 then
      VeAdd(vCopy[x1], 2, xv - 1, yv);
    if yv > 1 then
      VeAdd(vCopy[x1], 3, xv, yv - 1);

    if bAchou then
       exit;
  end;
end;

procedure printFinal;
const vDir : array of string = ['R', 'D', 'L', 'U'];
var x, nConv: integer;
  ts : TStringList;
  s: string;
begin
  ts := TStringList.Create;

  nConv := 0;
  for x := 0 to High(vKeys[0]) - 3 do
  begin
    if vKeys[0][x] = -1 then
    begin
      s := s + 'A ';
      nConv := 2;
    end
    else if nConv > 0 then
    begin
      dec(nConv);
      s := s + IntToStr(vKeys[0][x]) + ' ';
    end
    else
      s := s + vDir[vKeys[0][x]] + ' ';
  end;

  ts.Add(s);
  ts.Add(SecondsBetween(Start, Now).ToString);
  ts.Add(IntToStr(Length(vKeys[0]) - 3));
  ts.SaveToFile(ArquivoSaida);
  ts.Clear;
end;

var i: integer;
begin
  Start := Now();

  CriaArena;
  CriaArena2;
  CriaArenaBack;

//  printArena;

  vArena[1][1] := 0;
  vArena[endY][endX] := 0;

  RecalcArena;
  vKeys := [[0,2,1,0], [1,1,2,0]];
  bAchou := False;

  i := 0;
  Start2 := Now();

  while not bAchou do
//  for i := 0 to 0 do
  begin
    inc(i);
    if i mod 100 = 0 then
    begin
      writeln(IntToStr(i) + ' Chaves: ' + IntToStr(length(vKeys))
            + ' MaxAdd: ' + IntToStr(vMaxAdd)
            + ' Max: ' + IntToStr(vMax)
            + ' Time: ' + SecondsBetween(Start2, Now).ToString
            + ' Total Time: ' + SecondsBetween(Start, Now).ToString);
      Start2 := Now();
    end;

//    printArena;

    RecalcArena;

    CopiaKeys;
    CriaNovosKeys;
  end;

  printFinal;
end.

