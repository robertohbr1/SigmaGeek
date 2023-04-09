import time

start_time = time.time()

vKeys = open('output1.txt', 'r', encoding='utf-8').read().splitlines()
vKeys = vKeys[0].replace(' ', '').replace('\ufeff', '')

cal = open('input1.txt', 'r', encoding='utf-8').read().splitlines()

# vKeys = open('output1.txt', 'r').read().splitlines()
# vKeys = vKeys[0].replace(' ', '').replace('\ufeff', '')

# cal = open('input.txt', 'r').read().splitlines()

vArena = []
for txt in cal:
    txt = '0' + txt.replace(' ', '') + '0'
    vArena.append([int(t) for t in txt])
    if txt.count('4') > 0:
        endX, endY = txt.index('4'), len(vArena)
vArena.insert(0, [0 for x in range(len(vArena[0]))])
vArena.append([0 for x in range(len(vArena[0]))])
vArena[1][1] = 0
vArena[endY][endX] = 0

maxX, maxY = len(vArena[0]) - 1, len(vArena) - 1

def RecalcArena():
    global vArena

    vArena2 = [[0 for x in range(maxX + 1)] for y in range(maxY + 1)]

    for y in range(1, maxY):
        for x in range(1, maxX):
            n1 = vArena[y - 1][x - 1] + vArena[y - 1][x] + vArena[y - 1][x + 1] \
                + vArena[y][x - 1]  + vArena[y][x +  1] \
                + vArena[y + 1][x - 1] + vArena[y + 1][x] + vArena[y + 1][x + 1]

            if vArena[y][x] == 0:
                if n1 > 1 and n1 < 5:
                    vArena2[y][x] = 1
                # else:
                #     vArena2[y][x] = 0
            else:
                if n1 > 3 and n1 < 6:
                    vArena2[y][x] = 1
                # else:
                #     vArena2[y][x] = 0

    vArena2[1][1] = 0
    vArena2[endY][endX] = 0
    vArena = vArena2[:]

xv, yv, i = 1, 1, 0
for keys in vKeys:
    i += 1
    print(i, keys)

    RecalcArena()

    if keys == 'R':
        xv += 1
        if xv == maxX:
            print(f'Erro em maxX {maxX} - {xv} {yv}')
            break
    elif keys == 'L':
        xv -= 1
        if xv == -1:
            print(f'Erro em {xv} {yv}')
            break
    elif keys == 'U':
        yv -= 1
        if yv == -1:
            print(f'Erro em {xv} {yv}')
            break
    elif  keys == 'D':
        yv += 1
        if yv == maxY:
            print(f'Erro em maxY {maxY} - {xv} {yv}')
            break
    else:
        print(f'Erro no arquivo {keys} em {xv} {yv}')
        break
    
    if vArena[yv][xv] == 1:
        print(f'Erro FATAL em {xv} {yv}')
        break

    if yv == endY and xv == endX:
        print(f'Encontrei em {xv} {yv}')
        break

if yv == endY and xv == endX:
    print(f'Finalizou no final {xv} {yv}- Certo')
else:
    print(f'Finalizou ERRADO {xv} {yv} - Certo {endX} {endY}')

print(maxX, maxY)

print(f"--- {time.time() - start_time} seconds ---")