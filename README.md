twelite-famima.rb
====
TWE-Lite DIPとToCoStickを使用した扉の開閉を検知するサンプルプログラム。
家の扉を扉を空けたらファミマの入店音を再生する。

TWE-Lite DIP
* ![TWE-Lite DIP](http://tocos-wireless.com/assets/TWE-Lite-DIP-match.jpg)
* http://tocos-wireless.com/jp/products/TWE-Lite-DIP/

ToCoStick
* ![ToCoStick](http://tocos-wireless.com/jp/products/TWE-Lite-USB/IMG_0909.jpg)
* http://tocos-wireless.com/jp/products/TWE-Lite-USB/

使い方
====
扉にTWE-Lite DIP子機を設置して扉の開閉状態を検出し、子機から送られてくる扉の開閉状態をPC側に装着したToCoStickを通じて取得する。

TWE-Lite DIP子機はDI1-GND間に開閉を検知するためのスイッチを接続する。以下URLを参考。
* [TWE-Lite DIP使用方法（初級編） - TOCOS-WIRELESS.COM](http://tocos-wireless.com/jp/products/TWE-Lite-DIP/TWE-Lite-DIP-step1.html)

サンプルプログラムでは、扉が開いたときに接点が閉じるように配線していることを想定している。
スイッチは以下のスイッチを使用した。

  * [【VX-56-1A3】マイクロスイッチ 【マルツパーツ館WebShop】](http://www.marutsu.co.jp/shohin_9568/)

今回はTWE-Lite DIP子機とスイッチを強力な両面テープで扉に固定し、扉の開閉状態を検知できるように設置した。
* ![スイッチ接続例](https://farm4.staticflickr.com/3902/14618385336_f7f2065685_m.jpg) ![設置例](https://farm4.staticflickr.com/3840/14641373855_8eee119a91_m.jpg)

電池を接続してTWE-Lite DIP子機を起動すると、親機であるToCoStick側にデータが送信されてくる。

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
$ git clone 
$ cd 
$ sudo gem install serialport
$ open http://commons.nicovideo.jp/material/nc18763
  ※ ファミマ入店音(nc18763.mp3)をダウンロード

$ vi twelite-famima.rb
  ※ ToCoStickが接続されているデバイスファイル名を環境に合わせて変更。

$ ruby twelite-famima.rb

</pre>
