package main

import (
	"fmt"
	"log"
	"time"
)

/*
 * 指定年月の第〇番目の〇曜日の日付を返す。該当する日付が存在しないときはfalseを返す
 * @param int year 年を指定
 * @param int month 月を指定
 * @param int week 週番号（第〇週目）を指定
 * @param int weekday 曜日0（日曜）から6（土曜）の数値を指定
 * @return int resultDay | false
 */
func getNthWeekDay(year, month, week, weekday int) int {
	// 週の指定が正しいか判定
	if week < 1 || week > 5 {
		log.Fatalln("週の数字がおかしいです。")
	}
	// 曜日の指定が正しいか判定
	if weekday < 0 || weekday > 6 {
		log.Fatalln("曜日の数字がおかしいです。")
	}

	// 指定した年月の月初日（1日）の曜日を取得する
	t1 := time.Date(year, time.Month(month), 1, 0, 0, 0, 0, time.Local)
	weekdayOfFirst := int(t1.Weekday())

	// 月初日の曜日を基にして第1〇曜日の日付を求める
	firstDay := weekday - weekdayOfFirst + 1
	if firstDay <= 0 {
		firstDay += 7
	}

	// 第1〇曜日に7の倍数を加算して、結果の日付を求める
	resultDay := firstDay + 7*(week-1)

	// 計算結果が妥当な日付かどうかチェックする
	_, err := isExist(year, month, resultDay)
	if err != nil {
		fmt.Println(err)
	}

	return resultDay
}

// 指定の日付が存在するかどうか調べる。
// 存在しない日付を指定してもtime.Date()はよきに計らってくれるので、
// 指定した日付と違うtime.Timeが返ってくれば指定した日付が間違ってると判定。
// (See https://ashitani.jp/golangtips/tips_time.html)
func isExist(year, month, day int) (float64, error) {
	date := time.Date(year, time.Month(month), day, 0, 0, 0, 0, time.Local)
	if date.Year() == year && date.Month() == time.Month(month) && date.Day() == day {
		return Julian(date), nil
	} else {
		return 0, fmt.Errorf("%d-%d-%d is not exist", year, month, day)
	}
}

// ユリウス日を求める
func Julian(t time.Time) float64 {
	// Julian date, in seconds, of the "Format" standard time.
	// (See http://www.onlineconversion.com/julian_date.htm)
	const julian = 2453738.4195
	// Easiest way to get the time.Time of the Unix time.
	// (See comments for the UnixDate in package Time.)
	unix := time.Unix(1136239445, 0)
	const oneDay = float64(86400. * time.Second)
	return julian + float64(t.Sub(unix))/oneDay
}

func main() {
	// 今日の日付を取得する
	today := time.Now()
	year := today.Year()
	month := today.Month()

	// 第1月曜日の日付を取得する
	firstMonday := getNthWeekDay(year, int(month), 1, 1)
	fmt.Printf("%d年%02d月%02d日（月）\n", year, month, firstMonday)

	// 第1火曜日の日付を取得する
	firstTuesday := getNthWeekDay(year, int(month), 1, 2)
	fmt.Printf("%d年%02d月%02d日（火）", year, month, firstTuesday)
}
