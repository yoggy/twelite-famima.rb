twelite-famima.rb
====
TWE-Lite DIPとToCoStickを使用した扉の開閉を検知するサンプルプログラム。

家の扉を扉を空けたらファミマの入店音を再生することを目的に試作を行い、
その際に得られたTWE-Lite DIPの使い方や考察についてまとめた。

* ![TWE-Lite DIP](http://tocos-wireless.com/assets/TWE-Lite-DIP-match.jpg) ![ToCoStick](http://tocos-wireless.com/jp/products/TWE-Lite-USB/IMG_0909.jpg)

材料
====

TWE-Lite DIP
* http://tocos-wireless.com/jp/products/TWE-Lite-DIP/

ToCoStick
* http://tocos-wireless.com/jp/products/TWE-Lite-USB/

VX-56-1A3マイクロスイッチ
* http://www.marutsu.co.jp/shohin_9568/

ボタン電池基板取付用ホルダー(CR2032用)
* http://akizukidenshi.com/catalog/g/gP-01443/

ボタン電池 CR2032
* http://akizukidenshi.com/catalog/g/gB-05694/

そこそこ粘着力が強力な両面テープ
* http://www.nichiban.co.jp/stationery/nt_sponge/index.html

使い方
====
一般的な住宅の玄関の扉付近にはコンセントがないため、センサやPCなどを設置するのが難しい。

そこでtwelite-famima.rbでは、扉にTWE-Lite DIP子機を設置して扉の開閉状態を検出し、
離れた場所に設置しているPCに装着したToCoStickを通じて子機から送られてくる扉の開閉状態を取得、
扉が開いたタイミングに合わせて曲を鳴らす構成とした。

TWE-Lite DIP子機は次のように配線を行った。
  * Vcc(pin28), GND(pin1)間にボタン電池(CR2032)を接続
  * M3(pin2), GND(pin1)間を接続 (間欠1秒モードを設定。後述)
  * DI1(pin15), GND(pin14)に開閉を検知するためのスイッチを接続

  * ![スイッチ接続例](https://farm4.staticflickr.com/3902/14618385336_f7f2065685_n.jpg) 

サンプルプログラムでは、扉が開いたときに接点が閉じるように配線していることを想定している。

TWE-Lite DIP子機とスイッチを強力な両面テープで扉に固定し、扉の開閉状態を検知できるように設置した。
目立たないように扉の上部に設置するため、両面テープで適当に止めている見た目は気にしない方向で。

* ![設置例1](https://farm4.staticflickr.com/3840/14641373855_8eee119a91_n.jpg) ![設置例2](https://farm4.staticflickr.com/3889/14647971722_ea714df95e_n.jpg) 

電池を接続してTWE-Lite DIP子機を起動すると、親機であるToCoStick側に子機の入力ピンの情報を表す文字列が送信されてくる。

<pre>
:7881150157810076ED780BE1000A942900013408190254DF  ←扉を閉じているとき
:788115014E810076ED780C2F000A932900013408190210DE
:788115014E810076ED780C77000A93290001330819025750
:788115015A810076ED780CAD000A93290001340819026400
:7881150154810076ED780CC7000A922901013408190254FC  ←扉を開いたとき
:788115014E810076ED780CFF000A922901013408190250CE
:7881150154810076ED780D35000A9229010134081902548D
</pre>

ToCoStickはPCに接続すると仮想シリアルポートとしてOSに認識される。
送信されてくるデータを確認する場合は、適当なターミナルアプリを使用して、
115200bps, 8bit, ストップビット1, パリティなしでシリアルポートを開く。

以下はMac OSでscreenを使用してシリアルポートを開く例。
デバイスファイル名は接続するポートなどによって名前が変わるため、環境に合わせて適切に変更すること。

  $ screen /dev/tty.usbserial-AHXDVUSV 115200

送られてくるデータのフォーマットについては、下記URL参照。

* [TWE-Lite DIP使用方法（上級編） - TOCOS-WIRELESS.COM](http://tocos-wireless.com/jp/products/TWE-Lite-DIP/TWE-Lite-DIP-step3.html)
* [相手端末からの状態通知：ステータス0x81 - TOCOS-WIRELESS.COM](http://tocos-wireless.com/jp/products/TWE-Lite-DIP/TWE-Lite-DIP-step3-81.html)

TWE-Lite DIP子機の動作確認ができたら、twelite-famima.rbスクリプトを以下の手順で実行する。

<pre>
$ cd ~
$ git clone https://github.com/yoggy/twelite-famima.rb.git
$ cd twelite-famima.rb/
$ sudo gem install serialport
$ open http://commons.nicovideo.jp/material/nc18763
  ※ 上記URLからファミマ入店音(nc18763.mp3)をダウンロード

$ vi twelite-famima.rb
  ※ ToCoStickが接続されているデバイスファイル名を環境に合わせて変更。

$ ruby twelite-famima.rb

</pre>

TWE-Lite DIPの動作モードについて
====
TWE-Lite DIPには子機として動作する際、数種類の動作モードが用意されている。

* [TWE-Lite DIP使用方法（中級編） - TOCOS-WIRELESS.COM](http://tocos-wireless.com/jp/products/TWE-Lite-DIP/TWE-Lite-DIP-step2.html)

動作モードによって連続動作・間欠動作や間欠動作の間隔などが異なり、
また間欠動作の間隔によってTWE-Lite DIPの消費電力が異なる。

扉の開閉動作を検知する際の反応速度を優先する場合は子機を連続モードで動作させるのが望ましいが、
今回はコンパクト＆簡単に扉に設置できることを目的としてボタン電池(CR2032)を使用しているため、
TWE-Lite DIP子機を間欠1秒モードで動作させている。

ボタン電池(CR2032)を使ってTWE-Lite DIP単体を間欠1秒モードで動作させた場合、
1ヶ月程度は駆動できると公式サイトには掲載されている。

TWE-Lite DIP子機を間欠1秒モードで動作させる場合は、モードピンM3(pin27)をGNDに接続する。

セキュリティについての考察
====
今回のサンプルプログラムでは状態通知パケットの35文字目が0か1かで扉の開閉状態をチェックしているだけで、
パケットの送信元のチェックは行っていない。

Blogなどで紹介されているTWE-Lite DIPを使用した工作例を検索してみると、
親機と子機が一対一で通信しているケースがほとんどで、複数台を同時に動かしている例をあまりみかけない。

そこで複数の子機が同時に動作していた場合、親機がどのような動作をするのが実際に試してみたところ、
特に何も設定しなくても、親機は複数の子機からの状態を同時に受信することができることがわかった。

twelite-famima.rbを実行している際に、扉に設置したTWE-Lite DIPとは別にDI1をGNDに接続した
偽装TWE-Lite DIP子機が近くに存在すると、親機は扉が開いている状態と同じパケットを受信してしまうため、
twelite-famima.rbは扉が開いていると誤検知してしまう。

そのため、今回作成したtwelite-famima.rbには、親機圏内に入ることができれば
遠隔でファミマ入店音を鳴らすことができる「遠隔ピンポンダッシュ脆弱性」が存在すると言える。

twelite-famima.rbを安全に使用するためには、以下のような工夫が必要であると考えられる。

* 周波数チャンネルやアプリケーションIDを変更することで、混信を避ける。
* 送信元の個体識別番号をチェックし、想定しない送信元からのパケットは無視する

TWE-Lite DIPの個体識別番号を書き換えることが可能かどうかについては調査していないため、
この点については引き続き調査を行いたい。
