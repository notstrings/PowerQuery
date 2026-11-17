# PowerQueryLibrary

PowerQuery先生の関数を共通管理するのがすごい面倒なのでどーにかしてみた実験リポジトリ。[^1][^2]

[^1]: 何かコレ、JS黎明期のオレオレライブラリ管理そのまんまだよね。正規管理機能はよ
[^2]: 多分同じ手口がPowerBIでも使えるんじゃね。知らんけど。

## 使い方

①GitHubとかで適当に公開したRawコードをEvaluateでテーブルに放り込む[^3][^4]

[^3]: どうもMSによるとEvaluateでは``#shared``は正式にサポートされてないらしい。きっと外部定義も混ざっちゃうと評価順序が微妙だからとかそんなんでしょ多分。赤信号みんなで渡れば集団自殺ってわけでこの辺はその筋の人ガンバッ。

[^4]: 参照先をどうするかは諸説あるけど、とりあえず実験なんでmainブランチ追従になってます。リポジトリ更新でイキナリ全参照先で処理が変わるのが怖いなら適当にブランチ切ればいいんじゃない？あとセキュリティ気にする場合とかはオンプレでGiteaとかGitLabとかにしてしまうのも手だし、何ならローカルリポジトリでも似たようなことができるはず。まぁ自分トコの都合でお好きにどーぞ。

ここでは適当に``クエリ1``とかにしておく

```PowerQuery
let
    Library = Expression.Evaluate(
        Text.FromBinary(
            Web.Contents("https://raw.githubusercontent.com/notstrings/PowerQuery/refs/heads/main/Excel/Misc.pq")
        ),
        #shared
    )
in
    Library
```

GitHub側に置いておく定義はこんな感じ。[^5]

[^5]: Readmeまで追従すんの面倒なんで初期の実験時のそれです。


```PowerQuery
let
    fnFolderImport = (path as text) =>
        Folder.Files(path),
    fnCsvImport = (path as text) =>
        Csv.Document(File.Contents(path)),
    fnDouble = (x as number) =>
        x * 2
in
    [
        FolderImport = fnFolderImport,
        CsvImport = fnCsvImport,
        Double = fnDouble
    ]
```

②テーブル越しに呼ぶ

```PowerQuery
let
    Library = クエリ1,
    Result = Library[Double](100)
in
    Result
```

以上
