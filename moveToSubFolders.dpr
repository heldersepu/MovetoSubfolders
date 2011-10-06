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
  intChars: SmallInt;

procedure ShowHelp;
begin
  writeln(' ');
  writeln('Move all the files in the dir to subFolders.');
  writeln(' ');
  writeln(' USAGE: moveToSubFolders <Dir-To_Update> [-d] [-c8]');
  writeln('   -d to display the file processed');
  writeln('   -c chars to use in the subfolder (default = 6)');  
  writeln(' ');
end;

function doMoveFile(strFolderName: string; const FileName: string; intChars: SmallInt): Boolean;
var
  strFinalFolder, subFld: string;
begin
  Result := True;
  try
    subFld := AnsiRightStr(FileName,6);
    subFld := AnsiReplaceStr(subFld, ' ', '_');
    subFld := AnsiReplaceStr(subFld, '.', '_');
    subFld := AnsiReplaceStr(subFld, '\', '_');
    strFinalFolder := strFinalFolder + '\' + subFld;
    if not DirectoryExists(strFinalFolder) then CreateDir(strFinalFolder);
    MoveFile(PChar(strFolderName + '\' + FileName), PChar(strFinalFolder + '\' + FileName));
  except
    Result := False;
  end;
end;

procedure doMoveAll(strFolderName: string; showFiles: Boolean; intChars: SmallInt);
var
  tSR : TSearchRec;
begin
  if FindFirst(strFolderName + '\*.*', $20, tSR) = 0 then
  begin
    repeat
      if showFiles then
        Writeln(intToStr(tSR.Time) + '   ' + tSR.Name);
      if not doMoveFile(strFolderName, tSR.Name, intChars) then
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
      intChars := 6;

      for I := 1 to ParamCount do
      begin
        if UpperCase(ParamStr(I)) = '-D' then
          showFiles := True
        else if UpperCase(AnsiLeftStr(ParamStr(I), 2)) = '-C' then
          intChars := StrToInt(AnsiMidStr(ParamStr(I), 3, 5))
        else
          if DirectoryExists(ParamStr(I)) then
            strFolderName := ParamStr(I);
      end;

      if strFolderName <> '' then
        doMoveAll(strFolderName, showFiles, intChars)
      else
      begin
        writeln('   -d to display the file processed');
        writeln(' ');
        ShowHelp
      end;

    end;
  end;
end.
