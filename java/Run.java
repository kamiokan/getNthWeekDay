import java.util.Calendar;
import java.text.DateFormat;

public class Run {

    public static void main(String[] args) {

        // 今日の日付を取得する
        Calendar calendar = Calendar.getInstance();
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH);
//        System.out.println("Year: " + year);
//        System.out.println("Month: " + month);

        // 第1月曜日の日付を取得する
        int firstMonday = getNthWeekDay(year, month, 1, 2);
        // 1桁の場合左に0を入れる
        String stFirstMonday = String.format("%02d", firstMonday);
        System.out.println(Integer.toString(year) + "年" + String.format("%02d", (month + 1)) + "月" + stFirstMonday + "日（月）");

        // 第1火曜日の日付を取得する
        int firstTuesday = getNthWeekDay(year, month, 1, 3);
        // 1桁の場合左に0を入れる
        String stFirstTuesday = String.format("%02d", firstTuesday);
        System.out.println(Integer.toString(year) + "年" + String.format("%02d", (month + 1)) + "月" + stFirstTuesday + "日（火）");
    }

    /**
     * 指定年月の第〇番目の〇曜日の日付を返す。
     *
     * @param int year 年を指定
     * @param int month 月を指定
     *            JANUARY(0), FEBRUARY(1), MARCH(2), APRIL(3), MAY(4), JUNE(5),
     *            JULY(6), AUGUST(7), SEPTEMBER(8), OCTOBER(9), NOVEMBER(10), DECEMBER(11)
     * @param int week 週番号（第〇週目）を指定
     * @param int weekday 曜日1（日曜）から7（土曜）の数値を指定
     * @return int resultDay
     */
    private static int getNthWeekDay(int year, int month, int week, int weekday) {
        // 週の指定が正しいか判定
        if (week < 1 || week > 5) {
            throw new IllegalArgumentException("引数weekの値が不正です");
        }
        // 曜日の指定が正しいか判定
        if (weekday < 0 || weekday > 6) {
            throw new IllegalArgumentException("引数のweekday値が不正です");
        }

        // 指定した年月の月初日（1日）の曜日を取得する
        Calendar calendar = Calendar.getInstance();
        calendar.set(year, month, 1, 0, 0);
        int weekdayOfFirst = calendar.get(Calendar.DAY_OF_WEEK);

        // 月初日の曜日を基にして第1〇曜日の日付を求める
        int firstDay = weekday - weekdayOfFirst + 1;
        if (firstDay <= 0) {
            firstDay += 7;
        }

        // 第1〇曜日に7の倍数を加算して、結果の日付を求める
        int resultDay = firstDay + 7 * (week - 1);

        // int => Stringへ型変換（月と日付は左をゼロ埋め）
        String stYear = Integer.toString(year);
        String stMonth = String.format("%02d", (month + 1));
        String stResultDay = String.format("%02d", resultDay);

        // 計算結果が妥当な日付かどうかチェックする
        String dateForCheck = stYear + "/" + stMonth + "/" + stResultDay;
//        System.out.println("dateForCheck: " + dateForCheck);

        if (!checkDate(dateForCheck)) {
            throw new IllegalArgumentException("日付の値が正しくありません");
        }

        return resultDay;
    }

    /**
     * 日付の妥当性チェックを行います。
     * 指定した日付文字列（yyyy/MM/dd or yyyy-MM-dd）が
     * カレンダーに存在するかどうかを返します。
     *
     * @param strDate チェック対象の文字列
     * @return 存在する日付の場合true
     * @see https://chat-messenger.com/blog/java/dateformat-setlenient
     */
    private static boolean checkDate(String strDate) {
        if (strDate == null || strDate.length() != 10) {
            throw new IllegalArgumentException(
                    "引数の文字列[" + strDate + "]" +
                            "は不正です。");
        }
        strDate = strDate.replace('-', '/');
        DateFormat format = DateFormat.getDateInstance();
        // 日付/時刻解析を厳密に行うかどうかを設定する。
        format.setLenient(false);
        try {
            format.parse(strDate);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
