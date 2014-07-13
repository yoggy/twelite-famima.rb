#!/usr/bin/ruby
# -*- encoding: utf-8 -*-
#
#   twelite-famima.rb - 家の扉を扉を空けたらファミマの入店音
#
#   TWE-Lite DIPを使用して扉の開閉を検知するサンプルプログラム。
#   TWE-Lite子機のDI1にボタンを接続して、扉が開いたときに接点が閉じるように配線する。
#

require 'rubygems'
require 'serialport'

$dev = '/dev/tty.usbserial-AHXDVUSV'
sp = SerialPort.new($dev, 115200, 8, 1, SerialPort::NONE)

def on_press_button
	puts "扉があいたよ!"
	system "afplay nc18763.mp3"
    # http://commons.nicovideo.jp/material/nc18763
end

def on_release_button
	puts "扉をしめたよ!"
end

old_button_state = false
loop do
	l = sp.gets.chomp
	puts l
	
	# error check
	next if l.size != 49
	next if l[0, 1] != ":"

	# check button state
	button_str = l[34, 1]

	if button_str == "1"
		button_state = true
	else
		button_state = false
	end

	# check edge trigger
	if button_state != old_button_state
		if button_state == true
			on_press_button
		else
			on_release_button
		end
	end

	old_button_state = button_state
end

