# ruby-spectrum
Ruby でスペクトル解析を行う実験リポジトリです

## Requirement
```bash
$ brew install flac sox chromaprint
$ brew install gnuplot
$ gem install open3
$ gem install ruby-sox
$ gem intall numo-narray
$ gem install numo-fftw
```

#### fftw3
http://www.fftw.org/download.html
```bash
$ tar xvf fftw-3.3.8.tar.gz
$ cd fftw-3.3.8/
$ ./configure
$ make
$ sudo make install
```

## Important
### Before running examples

Make two directories:
```
mkdir tmp
mkdir tmp/files
mkdir tmp/gnuplot
```

## Example
### sample_01.rb
```bash
$ sample_01.rb lib/files/sample_01.wav
```
音源に対して波形を描画します (横軸：時間 / 縦軸：大きさ)
![image](https://user-images.githubusercontent.com/16236972/87400404-b9041a00-c5f3-11ea-8d8d-ba0a115bc14e.png)

### sample_02.rb
```bash
$ sample_02.rb lib/files/sample_02.wav
```
音源に対してスペクトル解析した結果を描画します (横軸：周波数 / 縦軸：大きさ)
![image](https://user-images.githubusercontent.com/16236972/87400503-dc2ec980-c5f3-11ea-9a21-5d54041471bd.png)

### sample_03.rb
```bash
$ sample_03.rb lib/files/sample_03.wav
```
音源に対してスペクトル解析した動画を生成します (横軸：周波数 / 縦軸：大きさ)

<img src="https://user-images.githubusercontent.com/16236972/87400613-03859680-c5f4-11ea-9fd4-0f6c54c14552.png" width="400">

#### 動画
https://twitter.com/kero_BIRUGE/status/1282946252703817728
