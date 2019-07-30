<?php
/*
 * 指定年月の第〇番目の〇曜日の日付を返す。該当する日付が存在しないときはfalseを返す
 * @param int $year 年を指定
 * @param int $month 月を指定
 * @param int $week 週番号（第〇週目）を指定
 * @param int $weekday 曜日0（日曜）から6（土曜）の数値を指定
 * @return int $resultDay | false
 */
function getNthWeekDay($year, $month, $week, $weekday)
{
    // 週の指定が正しいか判定
    if ($week < 1 || $week > 5) {
        return false;
    }
    // 曜日の指定が正しいか判定
    if ($weekday < 0 || $weekday > 6) {
        return false;
    }

    // 指定した年月の月初日（1日）の曜日を取得する
    $weekdayOfFirst = (int)date('w', mktime(0, 0, 0, $month, 1, $year));

    // 月初日の曜日を基にして第1〇曜日の日付を求める
    $firstDay = $weekday - $weekdayOfFirst + 1;
    if ($firstDay <= 0) {
        $firstDay += 7;
    }

    // 第1〇曜日に7の倍数を加算して、結果の日付を求める
    $resultDay = $firstDay + 7 * ($week - 1);

    // 計算結果が妥当な日付かどうかチェックする
    if (!checkdate($month, $resultDay, $year)) {
        return false;
    }

    return $resultDay;
}

// 今日の日付を取得する
$today = new DateTime();
$year = $today->format('Y');
$month = $today->format('m');

// 第1月曜日の日付を取得する
$firstMonday = getNthWeekDay($year, $month, 1, 1);
// 1桁の場合左に0を入れる
$firstMonday = sprintf('%02d', $firstMonday);
echo "{$year}年{$month}月{$firstMonday}日（月）";
echo "\n";

// 第1火曜日の日付を取得する（翌日を取得する）
$baseDay = new DateTime($year . '-' . $month . '-' . $firstMonday);
$nextDay = $baseDay->add(DateInterval::createFromDateString('1 day'));
echo $nextDay->format('Y年m月d日（火）');
