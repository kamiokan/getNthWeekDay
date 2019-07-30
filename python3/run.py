# coding: utf-8
import datetime


def get_nth_week_day(year, month, week, weekday):
    """
    指定年月の第〇番目の〇曜日の日付を返す。該当する日付が存在しないときはfalseを返す
    :param year: 年を指定
    :param month: 月を指定
    :param week: 週番号（第〇週目）を指定
    :param weekday: 曜日0（日曜）から6（土曜）の数値を指定
    :return: int result_day | false
    """
    # 週の指定が正しいか判定
    if week < 1 or week > 5:
        return false
    # 曜日の指定が正しいか判定
    if weekday < 0 or weekday > 6:
        return false
    # 指定した年月の月初日（1日）の曜日を取得する
    # 0: 月, 1: 火, 2: 水, 3: 木, 4: 金, 5: 土, 6: 日
    d = datetime.datetime(year, month, 1, 0, 0, 0, 0)
    weekday_of_first = d.weekday()

    #  月初日の曜日を基にして第1〇曜日の日付を求める
    first_day = weekday - weekday_of_first + 1
    if first_day <= 0:
        first_day += 7

    # 第1〇曜日に7の倍数を加算して、結果の日付を求める
    result_day = first_day + 7 * (week - 1)

    # 計算結果が妥当な日付かどうかチェックする
    if not checkdate(month, result_day, year):
        return false

    return result_day


def checkdate(m, d, y):
    """
    日付の妥当性をチェックする
    :param m:
    :param d:
    :param y:
    :return: boolean
    see(https://www.php2python.com/wiki/function.checkdate/)
    """
    import datetime
    try:
        m, d, y = map(int, (m, d, y))
        datetime.date(y, m, d)
        return True
    except ValueError:
        return False


if __name__ == "__main__":
    # 今日の日付を取得する
    now = datetime.datetime.now()
    year = now.year
    month = now.month

    # 第1月曜日の日付を取得する
    first_monday = get_nth_week_day(year, month, 1, 0)
    print(str(year) + "年" + str(month).zfill(2) + "月" + str(first_monday).zfill(2) + "日（月）")

    # 第1火曜日の日付を取得する
    first_monday = get_nth_week_day(year, month, 1, 1)
    print(str(year) + "年" + str(month).zfill(2) + "月" + str(first_monday).zfill(2) + "日（火）")
