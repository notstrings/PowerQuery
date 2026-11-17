let
    fnGetXlsSheets = (
        FolderPath as text,
        SheetName as text,
        Extensions as list
    ) as table =>
        let
            // 拡張子を小文字に統一
            ExtList = List.Transform(Extensions, each Text.Lower(_)),
            // 対象ファイル抽出
            Source = Folder.Files(FolderPath),
            Files1 = Table.SelectRows(
                Source,
                each
                    List.Contains(ExtList, Text.Lower([Extension]))
                    and not Text.StartsWith([Name], "~$")
            ),
            // 指定シート取得
            Files2 = Table.AddColumn(
                Files1,
                "sheet",
                each
                    try
                        Excel.Workbook([Content]){[Item=SheetName, Kind="Sheet"]}[Data]
                    otherwise
                        null
            ),
            // 対象シートが存在するファイルのみ
            Files = Table.SelectRows(Files2, each [sheet] <> null)
        in
            Files,

    fnExpandSheets = (
        Source as table,
        SheetColumn as text,
        KeepColumns as list
    ) as table =>
        let
            // 各テーブルのカラム名を取得
            ColumnNames = List.Distinct(
                List.Combine(
                    List.Transform(
                        Table.Column(Source, SheetColumn),
                        each Table.ColumnNames(_)
                    )
                )
            ),
            // テーブル列を展開
            Expanded = Table.ExpandTableColumn(
                Source,
                SheetColumn,
                ColumnNames
            ),
            // 必要な列だけ残す
            Result = Table.SelectColumns(
                Expanded,
                List.Combine({KeepColumns, ColumnNames})
            )
        in
            Result,

    fnDouble = (x as number) =>
        x * 2
in
    [
        GetXlsSheets = fnGetXlsSheets,
        ExpandSheets = fnExpandSheets,
        Double = fnDouble
    ]
