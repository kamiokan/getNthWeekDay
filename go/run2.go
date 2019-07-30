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
	format := "20060102"
	checkdate := fmt.Sprintf("%d%02d%02d", year, month, resultDay)
	_, err := time.Parse(format, checkdate)
	if err != nil {
		fmt.Println(err)
	}

	return resultDay
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
