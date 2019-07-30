require 'date'

#  指定年月の第〇番目の〇曜日の日付を返す。該当する日付が存在しないときはfalseを返す
#  @param int year 年を指定
#  @param int month 月を指定
#  @param int week 週番号（第〇週目）を指定
#  @param int weekday 曜日0（日曜）から6（土曜）の数値を指定
#  @return int result_day | false
def get_nth_week_day(year, month, week, weekday)
  # 週の指定が正しいか判定
  if week < 1 || week > 5
    return false
  end
  # 曜日の指定が正しいか判定
  if weekday < 0 || weekday > 6
    return false
  end

  # 指定した年月の月初日（1日）の曜日を取得する
  t = Time.local(year, month, 1, 0, 0, 0, 0)
  # 曜日番号。0(日曜日) 〜 6(土曜日)
  weekday_of_first = t.wday

  # 月初日の曜日を基にして第1〇曜日の日付を求める
  first_day = weekday - weekday_of_first + 1
  if first_day <= 0
    first_day += 7
  end

  # 第1〇曜日に7の倍数を加算して、結果の日付を求める
  result_day = first_day + 7 * (week - 1)

  # 計算結果が妥当な日付かどうかチェックする
  if date_valid?(year, month, result_day)
    result_day
  else
    false
  end
end

# 日付のvalidationを行う関数
# see(https://masaki0303.hatenadiary.org/entry/20110606)
def date_valid?(y, m, d)
  if Date.valid_date?(y, m, d)
    true
  else
    false
  end
end

# 今日の日付を取得する
now = Time.new
year = now.year
month = now.month

# 第1月曜日の日付を取得する
first_monday = get_nth_week_day(year, month, 1, 1);
t = Time.local(year, month, first_monday, 0, 0, 0, 0)
str = t.strftime("%Y年%m月%d日（月）")
puts str

# 第1火曜日の日付を取得する
first_tuesday = get_nth_week_day(year, month, 1, 2);
t = Time.local(year, month, first_tuesday, 0, 0, 0, 0)
str = t.strftime("%Y年%m月%d日（火）")
puts str
