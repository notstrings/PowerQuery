# PowerQueryLibrary

PowerQuery先生の関数を共通管理するのがすごい面倒なのでどーにかしてみた実験リポジトリ。
多分同じ手口がPowerBIでも使えるんじゃね。知らんけど。

## 使い方

①GitHubとかで適当に公開したRawコードをEvaluateでテーブルに放り込む

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

※``#shared``はMSによるとEvaluateでは正式にサポートされてないそーだが、まぁ実験だし。

GitHub側に置いておく定義はこんな感じ
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
    Result = Library[GetXlsSheets]("C:\Your\File\Path","Sheet1",{".xlsx", ".xls"})
in
    Result
```

以上
