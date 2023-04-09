import time

start_time = time.time()

cal = open('input.txt', 'r', encoding='utf-8').read().splitlines()

vDir = ['R', 'D', 'L', 'U']

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

vKeys = [[[0,2,1]], [[1,1,2]]]
bAchou = False


def RecalcArena():
    global vArena, vArena2

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

vFinal = []

def VeAdd(vAnt, i, xv, yv):
    global vKeys, bAchou, endX, endY
    if [xv, yv] in vFinal:
        return
    vFinal.append([xv, yv])

    if xv == endX and yv == endY:
        bAchou = True
        vKeys.clear()

    v_ = vAnt.copy()
    v_.append([i, xv, yv])
    vKeys.append(v_)

while not bAchou:
    RecalcArena()

    vCopy = vKeys.copy()

    vFinal.clear()
    vKeys.clear()
    vMax = 0
    for v in vCopy:
        xv, yv = v[-1][1], v[-1][2]
        if vArena[yv][xv] == 1:
            ...
        else:
            vMax = max(vMax, xv *  yv)
            if xv < maxX - 1:
                VeAdd(v, 0, xv + 1, yv)
            if yv < maxY - 1:
                VeAdd(v, 1, xv, yv + 1)
            if xv > 1:
                VeAdd(v, 2, xv - 1, yv)
            if yv > 1:
                VeAdd(v, 3, xv, yv - 1)
               
        if bAchou:
            break
    
    print(maxX * maxY - vMax)

sRet = ''
for keys in vKeys[0]:
    sRet += vDir[keys[0]] # + ' '
print(sRet)
print(sRet == 'RRRRRRRRRRRRRRRRRRRRRRRRRRRDUDLRDDRDLLRDRDDLDRRRRURRDRRRDRRURRRDDDDUDRDRURUUURULRDRRRRUDDLDLRDDRDRRRRURRULRURDRDRLLDUDLRRRRDDDDDDDRDDLDDUDLDLRRURLRRRRDRRRDDDLLRDDDRDRDDURUDLURRLDRRRDRURRDRDLUDDUDDDDLRDRDRDLDLURRDDRDUDRRRRDDRDDLDLDRDDRUUDRLDRLDRDLDRDLDRLDRDDLRUULLRDDDDUDRR')

with open('Final.txt', 'w') as f:
    f.writelines(sRet)

print(f"--- {time.time() - start_time} seconds ---")
