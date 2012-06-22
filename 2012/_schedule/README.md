# Sapporo RubyKaigi 2012 Timetable

## English

This directory is for managing the timetable data for [Sappro RubyKaigi 2012][sprk2012].

If there is an error or revision required for your presentation, please change the master data and issue a pull request (Commit only your .yml file. Do not include generated htmls).
Once merged, it will be reflected on [Sappro RubyKaigi 2012][sprk2012].

The master data can be found under `2012/_schedule/presentations/`, where it is under a file with the same number as the presentation [pull request][sprk2012-cfp].
For example, `2012/_schedule/presentations/3.yml`

The master data is in [yaml][yaml] format. When modifying it, please preserve the schema, changing only the values.

If you wish to confirm the changes, you can do so using the method found below.

### Requirements
- [ruby](http://www.ruby-lang.org/) 1.9.3
- [bundler](http://gembundler.com/) =>1.1.0 (`gem install bundler` if you don't install it yet.)
- [jekyll](http://jekyllrb.com/) 0.11.2 (`gem install jekyll` if you don't install it yet.)

``` sh
$ cd 2012/_schedule
$ bundle install
$ rake # regenerate timetable
$ cd ../../ # Change directory to repository root.
$ jekyll --server
# And open 'http://localhost:4000/2012/{en|ja}/schedule/details/:pull_request_id.html' using your browser.
# Such as 'http://localhost:4000/2012/en/schedule/details/3.html'
```

## 日本語
このディレクトリは、[Sappro RubyKaigi 2012][sprk2012] のタイムテーブル出力用のデータ管理ディレクトリです。

発表内容の記載に誤りがあった場合や訂正を行いたい場合は、マスタデータを修正し pull request をお送りください
(コミットには .yml ファイルだけを含めてください。生成された HTML は含めないでください)。
随時マージし、[Sappro RubyKaigi 2012][sprk2012] に反映いたします。

マスタデータは `2012/_schedule/presentations/` に配置してあり、
[一般発表][sprk2012-cfp] への pull request 番号を ファイル名としてあります。
(例: `2012/_schedule/presentations/3.yml`)

お送りいただいた pull request は master にマージした後、
随時 [タイムテーブル][sprk2012-schedule] に反映いたします。

また、マスタデータは [yaml][yaml] ドキュメントとして管理しています。
修正する際は、スキーマを変更することなく、値の部分のみを修正してください。

また、表示形式の確認は以下の手順で行うことができます:

### 必須要件
- [ruby](http://www.ruby-lang.org/) 1.9.3
- [bundler](http://gembundler.com/) =>1.1.0 (`gem install bundler` if you don't install it yet.)
- [jekyll](http://jekyllrb.com/) 0.11.2 (`gem install jekyll` if you don't install it yet.)

``` sh
$ cd 2012/_schedule
$ bundle install
$ rake # タイムテーブルを生成します
$ cd ../../ # リポジトリのルートに移動します
$ jekyll --server
# ブラウザで詳細ページにアクセスしてください 'http://localhost:4000/2012/{en|ja}/schedule/details/:pull_request_id.html'
# 例えば次のような URL です 'http://localhost:4000/2012/en/schedule/details/3.html'
```

  [sprk2012]: http://sapporo.rubykaigi.org/2012
  [sprk2012-cfp]: https://github.com/sprk2012/sprk2012-cfp
  [sprk2012-schedule]: http://sapporo.rubykaigi.org/2012/en/schedule.html
  [yaml]: http://yaml.org/
