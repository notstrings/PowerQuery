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
