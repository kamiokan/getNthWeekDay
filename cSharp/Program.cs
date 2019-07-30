using System;

namespace Get1stMonday
{
    class Program
    {
        static void Main(string[] args)
        {
            // 今日の日付を取得する
            var dt = DateTime.Now;
            int year = dt.Year;
            int month = dt.Month;

            // 第1月曜日の日付を取得する
            int firstMonday = GetNthWeekDay(year, month, 1, 1);
            // 1桁の場合左に0を入れる
            String stMonth = String.Format("{0:00}", month);
            String stFirstMonday = String.Format("{0:00}", firstMonday);
            Console.WriteLine("{0}年{1}月{2}日（月）", year, stMonth, stFirstMonday);

            // 第2月曜日の日付を取得する
            int firstTuesday = GetNthWeekDay(year, month, 1, 2);
            // 1桁の場合左に0を入れる
            String stFirstTuesday = String.Format("{0:00}", firstTuesday);
            Console.WriteLine("{0}年{1}月{2}日（火）", year, stMonth, stFirstTuesday);

            // エンター押すまでコンソール消えないように
            Console.ReadKey();
        }

        /*
         * 指定年月の第〇番目の〇曜日の日付を返す。該当する日付が存在しないときはfalseを返す
         * @param int year 年を指定
         * @param int month 月を指定
         * @param int week 週番号（第〇週目）を指定
         * @param int weekday 曜日0（日曜）から6（土曜）の数値を指定
         * @return int resultDay | false
         */
        private static int GetNthWeekDay(int year, int month, int week, int weekday)
        {
            // 週の指定が正しいか判定
            if (week < 1 || week > 5)
            {
                throw new Exception("パラメータ:weekの値が範囲外です。");
            }
            // 曜日の指定が正しいか判定
            if (weekday < 0 || weekday > 6)
            {
                throw new Exception("パラメータ:weekdayの値が範囲外です。");
            }

            // 指定した年月の月初日（1日）の曜日を取得する
            var weekdayOfFirst = new DateTime(year, month, 1).DayOfWeek.ToString("d");
            // Console.WriteLine(weekdayOfFirst); // デバッグ用

            // 月初日の曜日を基にして第1〇曜日の日付を求める
            int firstDay = weekday - int.Parse(weekdayOfFirst) + 1;
            if (firstDay <= 0)
            {
                firstDay += 7;
            }

            // 第1〇曜日に7の倍数を加算して、結果の日付を求める
            int resultDay = firstDay + 7 * (week - 1);

            // 計算結果が妥当な日付かどうかチェックする
            DateTime dateTime;
            String checkDate = year.ToString() + "-" + month.ToString() + "-" + resultDay.ToString();
            if (!DateTime.TryParse(checkDate, out dateTime))
            {
                Console.WriteLine("バリデーション失敗！");
                throw new Exception("パラメータ:checkDateが日付としておかしいです。");
            }

            return resultDay;
        }
    }
}
