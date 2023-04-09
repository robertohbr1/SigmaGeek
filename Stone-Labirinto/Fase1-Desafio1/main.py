import time

import pyautogui

vKeys = [[[0,1,0]], [[1,0,1]]]
bAchou = False
def Reiniciar():
    global xtentar, ytentar
    # time.sleep(1)
    pyautogui.click(xtentar, ytentar)
    # time.sleep(1)
    print('Reiniciou')

def VeAdd(vAnt, i, xv, yv):
    global vKeys, bAchou
    for v in vKeys:
        if v[-1][1] == xv and v[-1][2] == yv:
            return
    v_ = vAnt.copy()
    v_.append([i, xv, yv])

    if xv == 7 and yv == 6:
        bAchou = True
        vKeys.insert(0, v_.copy())
    else:
        vKeys.append(v_.copy())


while True:
    try:
        x1, y1 = pyautogui.locateCenterOnScreen('Start.png')
        print(x1, y1)

        x2, y2 = pyautogui.locateCenterOnScreen('End.png')
        print(x2, y2)

        xtentar, ytentar = pyautogui.locateCenterOnScreen('Tentar.png')
        break
    except:
        time.sleep(1)

Reiniciar()

vKeyPress = ['right', 'down', 'left', 'up']

x1, y1 = x1 - 50, y1 - 40
x2, y2 = x2 + 50 - x1, y2 + 40 - y1

vGrid = []

while not bAchou:
    nImg = -1
    print(vKeys[0])

    Reiniciar()

    for keys in vKeys[0]:
        key = keys[0]

        pyautogui.keyDown('ctrl')
        pyautogui.press(vKeyPress[key])
        pyautogui.keyUp('ctrl')
        print(vKeyPress[key])

        nImg += 1

        if len(vGrid) < nImg + 1:
            img = pyautogui.screenshot(region=(x1, y1, x2, y2))
            img.save(f't{nImg}.png')
            vGrid.append([])
            # print(img.getpixel((3 * 98 + 10, 0 * 81 + 40)))
            for i in range(7):
                vGrid[nImg].append([])
                for j in range(8):
                    if img.getpixel((j * 98 + 10, i * 81 + 40))[0] == 13:
                        vGrid[nImg][i].append(1)
                    else:
                        vGrid[nImg][i].append(0)
            
            # print(f'Imagem {nImg} salva')
            print(vGrid[nImg])
            
            vCopy = []
            for vTest in vKeys:
                k, xv, yv = vTest[-1][0], vTest[-1][1], vTest[-1][2]
                # print(f'Testando {vTest[-1]} em {nImg} {xv} {yv} {vGrid[nImg][yv][xv]}')
                if vGrid[nImg][yv][xv] == 1:
                    # vKeys.remove(vTest)
                    print(f'Removido {vTest}')
                else:
                    vCopy.append(vTest.copy())

            vKeys.clear()
            for v in vCopy:
                xv, yv = v[-1][1], v[-1][2]
                for i in range(4):
                    if i == 0 and xv < 7:
                        VeAdd(v, i, xv + 1, yv)
                    elif i == 2 and xv > 0:
                        VeAdd(v, i, xv - 1, yv)
                    elif i == 1 and yv < 6:
                        VeAdd(v, i, xv, yv + 1)
                    elif i == 3 and yv > 0:
                        VeAdd(v, i, xv, yv - 1)

        # try:
        #     xErro, yErro = pyautogui.locateCenterOnScreen('Stop.png')
        #     print(f'Erro {xErro} {yErro}')
        #     break
        # except:
        #     continue

print('Achei:')
print(vKeys[0])

# vKeys.clear()

# vKeys.append([[0, 1, 0], [0, 2, 0], [1, 2, 1], [2, 1, 1], [2, 0, 1], [0, 1, 1], [0, 2, 1], [2, 1, 1], [1, 1, 2], [0, 2, 2], [2, 1, 2], [0, 2, 2], [0, 3, 2], [0, 4, 2], [1, 4, 3], [0, 5, 3], [2, 4, 3], [0, 5, 3], [1, 5, 4], [1, 5, 5], [0, 6, 5], [0, 7, 5], [1, 7, 6]])
Reiniciar()
for keys in vKeys[0]:
    pyautogui.keyDown('ctrl')
    pyautogui.press(vKeyPress[keys[0]])
    pyautogui.keyUp('ctrl')
