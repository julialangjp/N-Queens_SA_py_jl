# N-queen by Simulated Annealing
# シミュレーティッドアニーリング（焼きなまし法）によるN-Queen
import random
import math

class Board:
    '''
    盤を管理
        size  = 盤の大きさ
    '''
    def __init__(self, size):
        '''
        初期化
        '''
        # ユニットの初期化
        self.size  = size
        self.unit = [[1 if i == j else 0 for i in range(size)] for j in range(size)]

        # energy計算用の、row, col, diagの座標一覧
        # row
        self.rows = [[(x, y) for x in range(size)] for y in range(size)]
        # col
        self.cols = [[(x, y) for y in range(size)] for x in range(size)]

        self.diags = []
        # rightup-diagonal
        self.diags += [[(x, a-x) for x in range(0, min(a + 1, size)) if a - x < size] for a in range(0, 2*size-1)]

        # rightdown-diagonal
        self.diags.append([(x, x) for x in range(0, size)])

        self.diags += [[(x, x - b) for x in range(b, size)] for b in range(1, size)]
        self.diags += [[(y - b, y) for y in range(b, size)] for b in range(1, size)]

    def energy(self):
        '''
        エネルギー計算
        最適解の場合に、エネルギー=0となる
        '''
        e = 0

        # row
        e += sum([(sum([self.unit[x][y] for x, y in row])-1)**2 for row in self.rows])

        # col
        e += sum([(sum([self.unit[x][y] for x, y in col])-1)**2 for col in self.cols])

        # diagonal
        e += sum([s * (s-1) for s in [sum([self.unit[x][y] for x, y in diag]) for diag in self.diags]])
 
        # queen
        e += (sum([self.unit[x][y] for x in range(0, self.size) for y in range(0, self.size)]) - self.size)**2

        return  e

    def change(self, x, y):
        '''
        盤上のQueenのある(1)なし(0)を逆転する
        '''
        self.unit[x][y] ^= 1

    def display(self):
        '''
        表示
        '''
        print()
        for x in range(self.size):
            print( self.unit[x] )

    def run(self, temp_start, temp_end, alpha, temp_iter):
        '''
        実行
        '''
        now_energy = self.energy()

        temperature = temp_start
        while temperature > temp_end and now_energy > 0:
            for i in range(temp_iter):

                # 一か所変化させる
                rx = random.randrange(size)
                ry = random.randrange(size)
                self.change(rx, ry)

                # エネルギー値の計算
                new_energy = self.energy()
                # 変化前とのエネルギー値の差分
                de = new_energy - now_energy

                # eval
                if math.exp(- de / temperature) > random.random():    # 条件 (de < 0) 含む 
                    # 変化を許す
                    now_energy = new_energy
                    #self.display()
                    #print("energy = {}, temp = {}".format(now_energy, temperature))

                    # 解に到達したら終了
                    if now_energy == 0:
                        return True, now_energy, temperature
                else:
                    # 変化を許さないので元に戻す
                    self.change(rx, ry)

            # 温度を減衰
            temperature = temperature * alpha
    
        return False, now_energy, temperature

if __name__ == '__main__':
    size = 8
    # 開始温度
    temp_start = size*size*10
    # 減衰率
    alpha = 0.99
    # 終了温度
    temp_end = 0.02
    # 温度当たりの繰り返し数
    temp_iter = size * size

    board = Board(size)
    #board.display()

    result, energy, temp = board.run(temp_start, temp_end, alpha, temp_iter)
    board.display()
    print("energy = {}, temp = {}".format(energy, temp))
    if result:
        print("OK")
