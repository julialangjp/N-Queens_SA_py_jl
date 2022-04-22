# N-QueensBySA_py_jl
SAを用いてN-Queenを解いてみる with Python , with Julia

SA=Simulated Annealing を用いて、N-Queenの解を求めてみました。  
PythonとJuliaで同じアルゴリズムを実装しています。  

## Usage
### コンソールで実行
```julia
> julia sa.jl
```

```python
> python sa.py
```

### 結果出力例
  
[1, 0, 0, 0, 0, 0, 0, 0]  
[0, 0, 0, 0, 0, 1, 0, 0]  
[0, 0, 0, 0, 0, 0, 0, 1]  
[0, 0, 1, 0, 0, 0, 0, 0]  
[0, 0, 0, 0, 0, 0, 1, 0]  
[0, 0, 0, 1, 0, 0, 0, 0]  
[0, 1, 0, 0, 0, 0, 0, 0]  
[0, 0, 0, 0, 1, 0, 0, 0]  
energy = 0, temp = 0.989111599179543  
  
「energy = 0」の場合が、最適解（正解）です。  
ところが、SA法では近似解を求めているので、必ずしも正解でない場合も出てきます。  
何度か繰り返していると、「energy = 0」となるパターンを得ることができます。  

## 備考
　初期設定は、8-queenになっています。  
　プログラムの最下行から20行目くらいにある「size = 8」の数字を変更することで、他のN-queenを解くことができます。  
　他のパラメータは自動的に計算されますが、必ずしも適切であるかはわかりません。  
　ある程度は問題ないことを確認していますが、sizeが大きいと解を得るまでに時間がかかるので試していません。

## 参照
　次のページに簡単な解説を書きました。  
　　  [N-QueenをSA（シミュレーティド・アニーリング）で解いてみる(julialang.jp)](https://julialang.jp/2022/04/22/nqueen_sa/)
