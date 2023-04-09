program Project1;

uses
  classes,
  System.DateUtils,
  System.SysUtils,
  System.Math;

const ArquivoEntrada = 'C:\Temp\Lab\Fase2\input.txt';
      ArquivoSaida = 'C:\temp\lab\fase2\output.txt';

      type caminho = array of integer;
type caminhos = array of caminho;

var
  vArena, vArena2: array of array of integer;
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

procedure RecalcArena;
var x, y, n1: integer;
begin
  for y := 1 to maxY - 2 do
  begin
    for x := 1 to maxX - 2 do
    begin
      n1 := vArena[y - 1][x - 1] + vArena[y - 1][x] + vArena[y - 1][x + 1]
          + vArena[y][x - 1]  + vArena[y][x +  1]
          + vArena[y + 1][x - 1] + vArena[y + 1][x] + vArena[y + 1][x + 1];

      if vArena[y][x] = 0 then
      begin
        if (n1 > 1) and (n1 < 5) then
          vArena2[y][x] := 1
        else
          vArena2[y][x] := 0;
      end
      else
      begin
        if (n1 > 3) and (n1 < 6) then
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
var x, nLen, nVidas: integer;
begin
  if bAchou then exit;

//  if (xv * yv < vMax - 400) then exit;
//  if (xv + yv < vMaxAdd * 0.95) then exit;
  if (xv + yv < vMaxAdd - 50) then exit;

  x := High(vAnt);
  nVidas := vAnt[x];

  if vArena[yv][xv] = 1 then
  begin
    inc(nVidas);
    if nVidas > 6 then
      exit;
  end;

  if high(vFinal) > 0 then
    for x := 0 to high(vFinal) div 3 do
      if (vFinal[x * 3] = xv) and (vFinal[x * 3 + 1] = yv) and (vFinal[x * 3 + 2] <= nVidas) then
        exit;

  nLen := length(vFinal);
  SetLength(vFinal, nLen + 3);
  vFinal[nLen] := xv;
  vFinal[nLen + 1] := yv;
  vFinal[nLen + 2] := nVidas;

  if (xv = endX) and (yv = endY) then
  begin
    bAchou := True;
    SetLength(vKeys, 0);
  end;

  nLen := length(vKeys);
  SetLength(vKeys, nLen + 1);
  SetLength(vKeys[nLen], length(vAnt) + 1);
  for x := 0 to High(vAnt) - 3 do
    vKeys[nLen][x] := vAnt[x];

  x := High(vAnt);
  vKeys[nLen][x - 2] := i;
  vKeys[nLen][x - 1] := xv;
  vKeys[nLen][x] := yv;
  vKeys[nLen][x + 1] := nVidas;
end;

procedure CopiaKeys;
var x1, x2, x3, xv, yv, nLenCopy, nLenKey: integer;
begin
  nLenCopy := -1;

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
var x, n: integer;
  ts : TStringList;
  s: string;
begin
  ts := TStringList.Create;
  for x := 0 to High(vKeys[0]) - 3 do
    s := s + vDir[vKeys[0][x]] + ' ';

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

