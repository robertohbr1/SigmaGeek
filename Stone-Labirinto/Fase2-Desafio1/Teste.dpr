program Teste;

uses
  classes,
  System.DateUtils,
  System.SysUtils,
  System.Math;

const ArquivoEntrada = 'C:\Temp\Lab\Fase1\input3.txt';
      ArquivoSaida = 'C:\temp\lab\fase1\output.txt';

      type caminho = array of integer;
type caminhos = array of caminho;

var
  vArena, vArena2: array of array of integer;
  endX, endY, maxX, maxY, vMax, vMaxAdd: integer;
  txt: string;
  bAchou: boolean;
  vKeys: string;
  Start: TDateTime;

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
var ListaTexto, ListaKeys: TStringList;
    x, y: integer;
begin
  ListaTexto := TStringList.Create;
  ListaTexto.LoadFromFile(ArquivoEntrada);

  ListaKeys := TStringList.Create;
  ListaKeys.LoadFromFile(ArquivoSaida);
  vKeys := ListaKeys[0].Replace(' ', '');

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

var i, xv, yv: integer;
keys: char;
a: string;
begin
  Start := Now();

  CriaArena;
  CriaArena2;

//  printArena;

  vArena[1][1] := 0;
  vArena[endY][endX] := 0;

  xv := 1;
  yv := 1;
  for I := 1 to length(vKeys) do
  begin
    RecalcArena;

    keys := vKeys[I];

    if (i mod 100 = 0) then
      writeln(intToStr(i) + ' ' + keys + ' y ' + inttostr(yv) + '  x ' + inttostr(xv));

    if keys = 'R' then
    begin
      inc(xv);
      if xv = maxX then
      begin
        writeln('Erro em maxX {maxX} - {xv} {yv}');
        break;
      end;
    end
    else if keys = 'L' then
    begin
      dec(xv);
      if xv = 0 then
      begin
        writeln('Erro em {xv} {yv}');
        break;
      end;
    end
    else if keys = 'U' then
    begin
      dec(yv);
      if yv = 0 then
      begin
        writeln('Erro em {xv} {yv}');
        break;
      end;
    end
    else if  keys = 'D' then
    begin
      inc(yv);
      if yv = maxY then
      begin
        writeln('Erro em maxY {maxY} - {xv} {yv}');
        break;
      end;
    end
    else
    begin
      writeln('Erro no arquivo {keys} em {xv} {yv}');
      break;
    end;

    if vArena[yv][xv] = 1 then
    begin
      writeln('Erro FATAL em {xv} {yv}');
      break;
    end;

    if (yv = endY) and (xv = endX) then
    begin
      writeln('Encontrei em {xv} {yv}');
      break;
    end;
  end;

  if (yv = endY) and (xv = endX) then
      writeln('Finalizou no final {xv} {yv}- Certo')
  else
      writeln('Finalizou ERRADO {xv} {yv} - Certo {endX} {endY}');

  writeln(maxX, maxY);

  writeln(SecondsBetween(Start, Now).ToString);

  read(a);
end.

