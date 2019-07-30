#!/bin/bash

# 指定年月の第〇番目の〇曜日の日付を返す。
# @param int $year 年を指定
# @param int $month 月を指定
# @param int $week 週番号（第〇週目）を指定
# @param int $weekday 曜日0（日曜）から6（土曜）の数値を指定
# @return int $resultDay
function getNthWeekDay() {
    year=$1
    month=$2
    week=$3
    weekday=$4
    day=01
    # 月初の曜日を出す
    weekdayOfFirst=`date -d $year$month$day '+%w'`

    # 月初日の曜日を基にして第1〇曜日の日付を求める
    firstDay=$(($weekday-$weekdayOfFirst+1))
    if [ $firstDay -le 0 ] ; then
        firstDay+=7
    fi

    # 第1〇曜日に7の倍数を加算して、結果の日付を求める
    resultDay=$(($firstDay+7*($week - 1)));

    # 1桁のときは左に0を入れる
    if [ $resultDay -lt 10 ] ; then
        resultDay=0$resultDay
    fi

    echo $resultDay
}

# 現在の年月を取得
year=`date '+%Y'`
month=`date '+%m'`

# 第1月曜日の日付を取得する
firstMonday=`getNthWeekDay $year $month 1 1`
echo "$year年$month月${firstMonday}日（月）"

# 第1火曜日の日付を取得する
firstTuesday=`getNthWeekDay $year $month 1 2`
echo "$year年$month月${firstTuesday}日（火）"
