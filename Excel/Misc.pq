let
    fnFolderImport = (
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
