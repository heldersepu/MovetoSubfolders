{**
Program will Move all the files in a folder to Sub-Folders 
for the name of the Sub-Folder it will use the last 6 chars of the file
**}

program moveToSubFolders;
{$APPTYPE CONSOLE}
uses
  SysUtils, Windows, StrUtils,
  ColorUtils in 'ColorUtils.pas';
var
  I: Integer;
  showFiles: Boolean;
  strFolderName: string;

procedure ShowHelp;
begin
  writeln(' ');
  writeln('Move all the files in the dir to subFolders .');
  writeln(' ');
  writeln(' USAGE: moveToSubFolders <Dir-To_Update> [-d]');
  writeln('   -d to display the file processed');
  writeln(' ');
end;

function doMoveFile(strFolderName: string; const FileName: string): Boolean;
var
  strFinalFolder, strExt, subFld: string;
begin
  Result := True;
  try
    subFld := AnsiRightStr(FileName,6);
    subFld := AnsiReplaceStr(subFld, ' ', '_');
    subFld := AnsiReplaceStr(subFld, '.', '_');
    subFld := AnsiReplaceStr(subFld, '\', '_');
    strExt := AnsiRightStr(subFld,3);
    strFinalFolder := strFolderName + '\' + strExt;
    if not DirectoryExists(strFinalFolder) then CreateDir(strFinalFolder);
    strFinalFolder := strFinalFolder + '\' + subFld;
    if not DirectoryExists(strFinalFolder) then CreateDir(strFinalFolder);
    MoveFile(PChar(strFolderName + '\' + FileName), PChar(strFinalFolder + '\' + FileName));
  except
    Result := False;
  end;
end;

procedure doMoveAll(strFolderName: string; showFiles: Boolean);
var
  tSR : TSearchRec;
begin
  if FindFirst(strFolderName + '\*.*', $20, tSR) = 0 then
  begin
    repeat
      if showFiles then
        Writeln(intToStr(tSR.Time) + '   ' + tSR.Name);
      if not doMoveFile(strFolderName, tSR.Name) then
        ColorWrite(' Failed:   ',12); ColorWrite('' + tSR.Name,14,True);
    until (FindNext(tSR) <> 0);
  end;
end;

begin
  if (ParamCount = 0) then
    ShowHelp
  else
  begin
    if (Pos(ParamStr(1), '/?') > 0) then
      ShowHelp
    else
    begin
      showFiles := False;
      strFolderName := 'C:\temp\QQ007907\QuickFL\Images';
      for I := 1 to ParamCount do
      begin
        if UpperCase(ParamStr(I)) = '-D' then
          showFiles := True
        else
          if DirectoryExists(ParamStr(I)) then
            strFolderName := ParamStr(I);
      end;
      if strFolderName <> '' then
        doMoveAll(strFolderName, showFiles)
      else
      begin
        writeln('   -d to display the file processed');
        writeln(' ');
        ShowHelp
      end;

    end;
  end;
end.
