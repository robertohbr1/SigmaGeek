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
    txt = txt.replace(' ', '')
    vArena.append([int(t) for t in txt])
    if txt.count('4') > 0:
        endX, endY = txt.index('4'), len(vArena)  - 1

maxX, maxY = len(vArena[0]) - 1, len(vArena) - 1

xv, yv, i = 0, 0, 0
for keys in vKeys:
    i += 1
    print(i, keys)

    if keys == 'R':
        xv += 1
        if xv == maxX + 1:
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
        if yv == maxY + 1:
            print(f'Erro em maxY {maxY} - {xv} {yv}')
            break
    else:
        print(f'Erro no arquivo {keys} em {xv} {yv}')
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
