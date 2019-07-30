use strict;
use warnings;
use Encode;
use utf8;
use DateTime;


#  指定年月の第〇番目の〇曜日の日付を返す。該当する日付が存在しないときはfalseを返す
#  @param int $year 年を指定
#  @param int $month 月を指定
#  @param int $week 週番号（第〇週目）を指定
#  @param int $weekday 曜日0（日曜）から6（土曜）の数値を指定
#  @return int $result_day | false
sub get_nth_week_day {
    my ($year, $month, $week, $weekday) = @_;

    # 週の指定が正しいか判定
    if ($week < 1 || $week > 5) {
        return 0;
    }
    # 曜日の指定が正しいか判定
    if ($weekday < 0 || $weekday > 6) {
        return 0;
    }

    # 指定した年月の月初日（1日）の曜日を取得する
    my $dt = DateTime->new(
        year   => $year,
        month  => $month,
        day    => 1,
        hour   => 0,
        minute => 0,
        second => 0,
    );
    my $weekday_of_first = $dt->day_of_week;

    # 月初日の曜日を基にして第1〇曜日の日付を求める
    my $first_day = $weekday - $weekday_of_first + 1;
    if ($first_day <= 0) {
        $first_day += 7;
    }

    # 第1〇曜日に7の倍数を加算して、結果の日付を求める
    my $result_day = $first_day + 7 * ($week - 1);

    # 計算結果が妥当な日付かどうかチェックする
    if (!day_exist($year, $month, $result_day)) {
        return 0;
    }

    return $result_day;
}

# 日付が存在するかを判定する関数
# see(https://tutorial.perlzemi.com/blog/20081013122391.html)
sub day_exist {
    my ($year, $mon, $mday) = @_;
    $year -= 1900;
    $mon--;

    require Time::Local;
    eval {
        Time::Local::timelocal(0, 0, 0, $mday, $mon, $year);
    };
    return $@ ? 0 : 1;
}

# 今日の日付を取得する
my $dt = DateTime->now(time_zone => 'Asia/Tokyo');
my $year = $dt->year;
my $month = $dt->month;

# 第1月曜日の日付を取得する
my $first_monday = get_nth_week_day($year, $month, 1, 1);
# 1桁の場合左に0を入れる
$first_monday = sprintf('%02d', $first_monday);
# Windowsコマンドプロンプト出力用に文字コードをCP932にエンコード
print encode('cp932', "${year}年${month}月${first_monday}日（月）");
print "\n";

# 第1月曜日の日付を取得する
my $first_tuesday = get_nth_week_day($year, $month, 1, 2);
# 1桁の場合左に0を入れる
$first_tuesday = sprintf('%02d', $first_tuesday);
# Windowsコマンドプロンプト出力用に文字コードをCP932にエンコード
print encode('cp932', "${year}年${month}月${first_tuesday}日（火）");
print "\n";
