#include <stdio.h>
#include <time.h>

/* functions */
int GetNthWeekDay(int year, int month, int week, int weekday);
int checkYmd(int y, int m, int d);

/* main */
int main(void)
{
    time_t timer;
    struct tm *local;

    /* 現在時刻を取得 */
    timer = time(NULL);

    /* ローカルタイムに変換 */
    local = localtime(&timer);

    // printf("ローカルタイム: ");
    // printf("%4d/", local->tm_year + 1900);
    // printf("%02d/", local->tm_mon + 1);
    // printf("%02d\n", local->tm_mday);
    // => ローカルタイム: 2019/07/28

    int year = local->tm_year + 1900;
    int month = local->tm_mon + 1;
    // int day = local->tm_mday;

    // 第1月曜日の日付を取得する
    int firstMonday = GetNthWeekDay(year, month, 1, 1);
    // 1桁の場合左に0を入れる
    printf("%4d年%02d月%02d日（月）\n", year, month, firstMonday);

    // 第1火曜日の日付を取得する
    int firstTuesday = GetNthWeekDay(year, month, 1, 2);
    // 1桁の場合左に0を入れる
    printf("%4d年%02d月%02d日（火）\n", year, month, firstTuesday);

    return 0;
}

/**
 * 指定年月の第〇番目の〇曜日の日付を返す。該当する日付が存在しないときはfalseを返す
 * @param int year 年を指定
 * @param int month 月を指定
 * @param int week 週番号（第〇週目）を指定
 * @param int weekday 曜日0（日曜）から6（土曜）の数値を指定
 * @return resultDay
 * @see http://www.c-tipsref.com/tips/time/mktime.html
 */
int GetNthWeekDay(int year, int month, int week, int weekday)
{
    struct tm time_in, *local;
    time_t t;

    /* 年月日を入力 */
    time_in.tm_year = year - 1900; /* 年 */
    time_in.tm_mon = month - 1;    /* 月 */
    time_in.tm_mday = 1;           /* 日 */

    /* 時分秒曜日を適当に入力 */
    time_in.tm_hour = 1; /* 時 (適当に入力)  */
    time_in.tm_min = 0;  /* 分 (適当に入力)  */
    time_in.tm_sec = 0;  /* 秒 (適当に入力)  */
    time_in.tm_wday = 0; /* 曜日 (適当に入力) */
    time_in.tm_yday = 0; /* 1月1日からの日数 (適当に入力) */

    /* mktime 関数で変換 */
    if ((t = mktime(&time_in)) == (time_t)(-1))
    {
        return -1;
    }

    /* 地方時に変換 */
    local = localtime(&t);

    /* 月初日の曜日を求める */
    int weekdayOfFirst = local->tm_wday;

    // 月初日の曜日を基にして第1〇曜日の日付を求める
    int firstDay = weekday - weekdayOfFirst + 1;
    if (firstDay <= 0)
    {
        firstDay += 7;
    }

    // 第1〇曜日に7の倍数を加算して、結果の日付を求める
    int resultDay = firstDay + 7 * (week - 1);

    // 計算結果が妥当な日付かどうかチェックする
    int retc;
    if ((retc = checkYmd(year, month, resultDay)) == 0)
    {
        //printf("有効な日付です\n");
        return resultDay;
    }
    else
    {
        if (retc == -1)
            printf("月指定が正しくありません。\n");
        if (retc == -2)
            printf("日指定が正しくありません。\n");
    }

    return 0;
}

/**
 * 有効な日付かチェックする
 * @param[in] y 年
 * @param[in] m 月
 * @param[in] d 日
 * @return int 0=>問題無し, 1=>月の値がおかしい, 2=>日の値がおかしい
 * @see https://edu.clipper.co.jp/pg-2-49.html
 */
int checkYmd(int y, int m, int d)
{
    int lastd;
    int days[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

    // 月の範囲チェック
    if (m < 1 || m > 12)
        return -1;

    // 日の範囲チェック
    lastd = days[m - 1];
    if (m == 2)
    {
        if (y % 4 == 0 && (y % 100 != 0 || y % 400 == 0))
            lastd = 29; // うるう年は2月29日まである
    }
    if (d < 1 || d > lastd)
        return -2;

    return 0;
}
