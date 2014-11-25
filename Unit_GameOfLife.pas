unit Unit_GameOfLife;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Grids, ExtCtrls, StdCtrls;

type
  TstrArray = array [1 .. 127] of array [1 .. 127] of string;

  TformGameOfLife = class(TForm)
    strgrGameGrid: TStringGrid;
    menuMainMenu: TMainMenu;
    mainmenuFile: TMenuItem;
    mainmenuGame: TMenuItem;
    mainmenuFileNew: TMenuItem;
    mainmenuFileLoad: TMenuItem;
    mainmenuFileSave: TMenuItem;
    mainmenuGameClear: TMenuItem;
    mainmenuPauseplay: TMenuItem;
    timerGametick: TTimer;
    mainmenuGameRandomise: TMenuItem;
    mainmenuOptions: TMenuItem;
    listboxDebugOutput: TListBox;
    editCyclecountOutput: TEdit;
    labelCycleCount: TLabel;
    editLiveDead: TEdit;
    labelLiveDead: TLabel;
    mainmenuGameRotate: TMenuItem;
    mainmenuGameCounterclock: TMenuItem;
    mainmenuGameClock: TMenuItem;
    mainmenuGamePlacemarker: TMenuItem;
    popupmenuStrGrid: TPopupMenu;
    popupmenuAdd: TMenuItem;
    popupmenuAddGlider: TMenuItem;
    popupmenuAddLwss: TMenuItem;
    popupmenuAddHwss: TMenuItem;
    popupmenuAddPulsar: TMenuItem;
    popupmenuMarker: TMenuItem;
    procedure mainmenuFileNewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure strgrGameGridClick(Sender: TObject);
    procedure timerGametickTimer(Sender: TObject);
    procedure mainmenuPauseplayClick(Sender: TObject);
    procedure mainmenuGameClearClick(Sender: TObject);
    procedure mainmenuGameRandomiseClick(Sender: TObject);
    procedure mainmenuOptionsClick(Sender: TObject);
    procedure activateOptions;
    procedure mainmenuFileSaveClick(Sender: TObject);
    procedure mainmenuFileLoadClick(Sender: TObject);
    procedure mainmenuGameCounterclockClick(Sender: TObject);
    procedure mainmenuGameClockClick(Sender: TObject);
    procedure strgrGameGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure mainmenuGamePlacemarkerClick(Sender: TObject);
    procedure popupmenuMarkerClick(Sender: TObject);
    procedure popupmenuAddGliderClick(Sender: TObject);
    procedure popupmenuAddLwssClick(Sender: TObject);
    procedure popupmenuAddHwssClick(Sender: TObject);
    procedure popupmenuAddPulsarClick(Sender: TObject);
  private
    strArray: TstrArray;
  public

  end;

var
  formGameOfLife: TformGameOfLife;
  cycleCount, aliveCells, deadCells: Integer;
  pauseGame: boolean;
  numRows: Integer = 127;
  numCols: Integer = 127;
  colDisplace: Integer = 4;
  rowDisplace: Integer = 4;
  numRowsUse: Integer;
  numcolsUse: Integer;
  activeMarker: boolean;
  cellSize: Integer;

implementation

uses Unit_GameOfLifeOptions;

{$R *.dfm}

{ Load game options from file. Options are structured as:
  Description:VALUE#
  And anything between the ':' and '#' will be parsed into the options }
procedure TformGameOfLife.activateOptions;
var
  lineData, outputData: string;
  optionsFile: textfile;
  i, outputInteger: Integer;
  readData: boolean;
begin
  AssignFile(optionsFile, 'options.txt');
  reset(optionsFile); // open options file for reading
  readln(optionsFile, lineData); // read the first line - timerGameTick
  readData := False;
  for i := 1 to length(lineData) do // parse the data
  begin
    if lineData[i] = '#' then
      readData := False;
    if readData = true then
      outputData := outputData + lineData[i];
    if lineData[i] = ':' then
      readData := true;
  end;
  timerGametick.Interval := strtoint(outputData);
  // assign it to the correct property
  listboxDebugOutput.Items.Add('game tick set to:' + outputData); // debug
  outputData := '';
  readln(optionsFile, lineData);
  // read the second line - Height/Width of col/row
  readData := False;
  for i := 1 to length(lineData) do
  begin
    if lineData[i] = '#' then
      readData := False;
    if readData = true then
      outputData := outputData + lineData[i];
    if lineData[i] = ':' then
      readData := true;
  end;
  listboxDebugOutput.Items.Add('height/width:' + outputData);
  strgrGameGrid.DefaultColWidth := strtoint(outputData);
  strgrGameGrid.DefaultRowHeight := strtoint(outputData);
  cellSize := strtoint(outputData);
  readData := False;
  outputData := '';
  readln(optionsFile, lineData);
  // read the third line - 1 or 0, decides whether to show debug
  for i := 1 to length(lineData) do
  begin
    if lineData[i] = '#' then
      readData := False;
    if readData = true then
      outputData := outputData + lineData[i];
    if lineData[i] = ':' then
      readData := true;
  end;
  outputInteger := strtoint(outputData);
  listboxDebugOutput.Items.Add('debug evaled to:' + outputData);
  case outputInteger of
    0:
      formGameOfLife.Width := 905;
    1:
      formGameOfLife.Width := 1067;
  else
    formGameOfLife.Width := 905;
  end;
  readData := False;
  outputData := '';
  readln(optionsFile, lineData); // read row number
  for i := 1 to length(lineData) do
  begin
    if lineData[i] = '#' then
      readData := False;
    if readData = true then
      outputData := outputData + lineData[i];
    if lineData[i] = ':' then
      readData := true;
  end;
  strgrGameGrid.RowCount := strtoint(outputData);
  numRowsUse := strtoint(outputData);
  readData := False;
  outputData := '';
  readln(optionsFile, lineData); // read col number
  for i := 1 to length(lineData) do
  begin
    if lineData[i] = '#' then
      readData := False;
    if readData = true then
      outputData := outputData + lineData[i];
    if lineData[i] = ':' then
      readData := true;
  end;
  strgrGameGrid.ColCount := strtoint(outputData);
  numcolsUse := strtoint(outputData);
  CloseFile(optionsFile); // close options file
end;

{ Runtime actions }
procedure TformGameOfLife.FormCreate(Sender: TObject);
var
  optionsFile: textfile;
begin
  timerGametick.Enabled := False;
  mainmenuGame.Enabled := False;
  // disable unusable menu options until new game started
  // if options file doesn't exist, create it with default settings
  if FileExists('options.txt') = False then
  begin
    AssignFile(optionsFile, 'options.txt');
    rewrite(optionsFile);
    writeln(optionsFile, 'GameTickTimer:1000#');
    writeln(optionsFile, 'GridSize:6#');
    writeln(optionsFile, 'ShowDebug:0#');
    writeln(optionsFile, 'NumRows:127#');
    writeln(optionsFile, 'NumCols:127#');
    CloseFile(optionsFile);
  end
  else
    activateOptions; // if file exists load options
end;

{ Create a new file, wipe the grid and reset all variables }
procedure TformGameOfLife.mainmenuFileNewClick(Sender: TObject);
var
  row, col: Integer;
begin
  for row := 1 to numRows do
  begin
    for col := 1 to numCols do
    begin
      strgrGameGrid.Cells[col, row] := '';
      strArray[col, row] := '';
    end;
  end;
  listboxDebugOutput.Items.Clear;
  listboxDebugOutput.Items.Add('==NEW GAME==');
  timerGametick.Enabled := true;
  pauseGame := False;
  mainmenuPauseplay.Caption := 'Pause';
  mainmenuPauseplay.Enabled := true;
  strgrGameGrid.Enabled := true;
  mainmenuGame.Enabled := true;
  cycleCount := 0;
  aliveCells := 0;
  deadCells := 0;
end;

{ Load a text file from disk to display on the grid }
procedure TformGameOfLife.mainmenuFileLoadClick(Sender: TObject);
var
  row, col: Integer;
  openDialog: TOpenDialog;
  inputFile: textfile;
  currentLine, temp: string;
begin
  mainmenuPauseplay.Enabled := true;
  strgrGameGrid.Enabled := true;
  mainmenuGame.Enabled := true;
  timerGametick.Enabled := true;
  pauseGame := true;
  mainmenuPauseplay.Caption := 'Play'; // enable menus and pause game
  openDialog := TOpenDialog.Create(self); // create object
  openDialog.InitialDir := GetCurrentDir; // set initial directory
  openDialog.Options := [ofFileMustExist];
  // allow only existing files to be shown
  openDialog.Filter := 'Text Files (.txt)|*.txt|Cells Files (.cells)|*.cells';
  openDialog.FilterIndex := 1; // filter files to only .txt
  if openDialog.Execute then
  begin
    AssignFile(inputFile, openDialog.FileName);
    reset(inputFile); // open file for reading
    for row := 1 to numRows do
    begin
      currentLine := '';
      readln(inputFile, currentLine); // read a line from the file
      for col := 1 to length(currentLine) do
      begin
        temp := currentLine[col]; // take a character from the line
        if temp = '.' then // transform '-' back to ''
          temp := '';
        if temp = 'O' then
          temp := '#';
        strgrGameGrid.Cells[col + colDisplace, row + rowDisplace] := temp;
        // write character to the grid
      end; // ENDFORCOL
    end; // ENDFORROW
    CloseFile(inputFile);
  end // ENDIF
  else
    ShowMessage('Open file was cancelled');
  openDialog.Free;
end;

{ Save the current file to a text file }
procedure TformGameOfLife.mainmenuFileSaveClick(Sender: TObject);
var
  row, col: Integer;
  temp, currentLine: string;
  saveFile: TSaveDialog;
  outputFile: textfile;
begin
  pauseGame := true;
  mainmenuPauseplay.Caption := 'Play'; // pause the game
  saveFile := TSaveDialog.Create(self); // create object
  saveFile.Title := 'Save Design'; // set title
  saveFile.InitialDir := GetCurrentDir; // set inital directory
  saveFile.Filter := 'Text files (.txt)|*.txt|Cells Files (.cells)|*.cells';
  saveFile.DefaultExt := 'txt';
  saveFile.FilterIndex := 1; // filter files to .txt files
  if saveFile.Execute then // if save pressed
  begin
    AssignFile(outputFile, saveFile.FileName);
    rewrite(outputFile); // create new file
    for row := 1 to numRows do
    begin
      currentLine := '';
      for col := 1 to numCols do
      begin
        temp := strgrGameGrid.Cells[col, row]; // get character
        if temp = '' then // turn '' into '-' for easy parsing
          temp := '.';
        if temp = '#' then
          temp := 'O';
        currentLine := currentLine + temp; // add to current line
      end; // ENDFORCOL
      writeln(outputFile, currentLine); // write to the file
    end; // ENDFORROW
    CloseFile(outputFile);
    ShowMessage('File saved successfully.');
    // close the file and output message
  end // ENDIF
  else
    ShowMessage('Save file was cancelled');
  saveFile.Free;
end;

{ Clear the grid without restarting the cycle count }
procedure TformGameOfLife.mainmenuGameClearClick(Sender: TObject);
var
  row, col: Integer;
begin
  for row := 1 to numRows do
  begin
    for col := 1 to numCols do
    begin
      strgrGameGrid.Cells[col, row] := '';
      strArray[col, row] := '';
    end;
  end;
end;

{ Generate a random pattern of pixels in the grid }
procedure TformGameOfLife.mainmenuGameRandomiseClick(Sender: TObject);
var
  row, col, rand: Integer;
begin
  for row := 1 to numRows do
  begin
    for col := 1 to numCols do
    begin
      strgrGameGrid.Cells[row, col] := '';
      rand := random(2); // pick a 1 or 0
      if rand = 1 then
        strgrGameGrid.Cells[row, col] := '#' // then turn that into a cell
      else
        strgrGameGrid.Cells[row, col] := ''; // or a dead cell
    end; // ENDFORCOL
  end; // ENDFORROW
end;

{ Show the options form }
procedure TformGameOfLife.mainmenuOptionsClick(Sender: TObject);
begin
  optionsForm.show;
end;

{ Toggles the state of the game, if paused, it will play it, if running it will
  stop it. }
procedure TformGameOfLife.mainmenuPauseplayClick(Sender: TObject);
begin
  case pauseGame of
    true:
      begin
        pauseGame := False;
        mainmenuPauseplay.Caption := 'Pause';
      end;
    False:
      begin
        pauseGame := true;
        mainmenuPauseplay.Caption := 'Play';
      end;
  end;

end;

procedure TformGameOfLife.popupmenuAddGliderClick(Sender: TObject);
var
  row, col: Integer;
begin
  colDisplace := strgrGameGrid.col;
  rowDisplace := strgrGameGrid.row;
  col := colDisplace;
  row := rowDisplace;
  strgrGameGrid.Cells[col + 3, row + 1] := '#';
  strgrGameGrid.Cells[col + 4, row + 2] := '#';
  strgrGameGrid.Cells[col + 4, row + 3] := '#';
  strgrGameGrid.Cells[col + 3, row + 3] := '#';
  strgrGameGrid.Cells[col + 2, row + 3] := '#';
end;

procedure TformGameOfLife.popupmenuAddHwssClick(Sender: TObject);
var
  row, col: Integer;
begin
  colDisplace := strgrGameGrid.col;
  rowDisplace := strgrGameGrid.row;
  col := colDisplace;
  row := rowDisplace;
  strgrGameGrid.Cells[col + 5, row + 2] := '#';
  strgrGameGrid.Cells[col + 5, row + 2] := '#';
  strgrGameGrid.Cells[col + 3, row + 3] := '#';
  strgrGameGrid.Cells[col + 8, row + 3] := '#';
  strgrGameGrid.Cells[col + 2, row + 4] := '#';
  strgrGameGrid.Cells[col + 2, row + 5] := '#';
  strgrGameGrid.Cells[col + 8, row + 5] := '#';
  strgrGameGrid.Cells[col + 2, row + 6] := '#';
  strgrGameGrid.Cells[col + 3, row + 6] := '#';
  strgrGameGrid.Cells[col + 4, row + 6] := '#';
  strgrGameGrid.Cells[col + 5, row + 6] := '#';
  strgrGameGrid.Cells[col + 6, row + 6] := '#';
  strgrGameGrid.Cells[col + 7, row + 6] := '#';
end;

procedure TformGameOfLife.popupmenuAddLwssClick(Sender: TObject);
var
  row, col: Integer;
begin
  colDisplace := strgrGameGrid.col;
  rowDisplace := strgrGameGrid.row;
  col := colDisplace;
  row := rowDisplace;
  strgrGameGrid.Cells[col + 3, row + 2] := '#';
  strgrGameGrid.Cells[col + 6, row + 2] := '#';
  strgrGameGrid.Cells[col + 2, row + 3] := '#';
  strgrGameGrid.Cells[col + 2, row + 4] := '#';
  strgrGameGrid.Cells[col + 6, row + 4] := '#';
  strgrGameGrid.Cells[col + 2, row + 5] := '#';
  strgrGameGrid.Cells[col + 3, row + 5] := '#';
  strgrGameGrid.Cells[col + 4, row + 5] := '#';
  strgrGameGrid.Cells[col + 5, row + 5] := '#';
end;

procedure TformGameOfLife.popupmenuAddPulsarClick(Sender: TObject);
var
  row, col: Integer;
begin
  colDisplace := strgrGameGrid.col;
  rowDisplace := strgrGameGrid.row;
  col := colDisplace+2;
  row := rowDisplace+2;
  strgrGameGrid.Cells[col + 2, row + 2] := '#';
  strgrGameGrid.Cells[col + 3, row + 2] := '#';
  strgrGameGrid.Cells[col + 4, row + 2] := '#';
  strgrGameGrid.Cells[col + 8, row + 2] := '#';
  strgrGameGrid.Cells[col + 9, row + 2] := '#';
  strgrGameGrid.Cells[col + 10, row + 2] := '#';
  strgrGameGrid.Cells[col + 2, row + 3] := '#';
  strgrGameGrid.Cells[col + 4, row + 3] := '#';
  strgrGameGrid.Cells[col + 8, row + 3] := '#';
  strgrGameGrid.Cells[col + 10, row + 3] := '#';
  strgrGameGrid.Cells[col + 2, row + 4] := '#';
  strgrGameGrid.Cells[col + 3, row + 4] := '#';
  strgrGameGrid.Cells[col + 4, row + 4] := '#';
  strgrGameGrid.Cells[col + 8, row + 4] := '#';
  strgrGameGrid.Cells[col + 9, row + 4] := '#';
  strgrGameGrid.Cells[col + 10, row + 4] := '#';
end;

procedure TformGameOfLife.popupmenuMarkerClick(Sender: TObject);
begin
  colDisplace := strgrGameGrid.col;
  rowDisplace := strgrGameGrid.row;
end;

procedure TformGameOfLife.mainmenuGamePlacemarkerClick(Sender: TObject);
begin
  activeMarker := true;
end;

{ Procedure for toggling state of an individual cell via clicking, allowing
  for manual input }
procedure TformGameOfLife.strgrGameGridClick(Sender: TObject);
begin
  if activeMarker then
  begin
    activeMarker := False;
    colDisplace := strgrGameGrid.col;
    rowDisplace := strgrGameGrid.row;
  end
  else
  begin
    if strgrGameGrid.Cells[strgrGameGrid.col, strgrGameGrid.row] = '#' then
      strgrGameGrid.Cells[strgrGameGrid.col, strgrGameGrid.row] := ''
    else
      strgrGameGrid.Cells[strgrGameGrid.col, strgrGameGrid.row] := '#';
  end;
end;

procedure TformGameOfLife.strgrGameGridDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (ACol = colDisplace) and (ARow = rowDisplace) then
  begin
    strgrGameGrid.canvas.Brush.Color := clGreen;
    strgrGameGrid.canvas.Fillrect(Rect)
  end
  else
  begin
    if strgrGameGrid.Cells[ACol, ARow] = '#' then
      strgrGameGrid.canvas.Brush.Color := clBlack;
    if strgrGameGrid.Cells[ACol, ARow] = '' then
    begin
      strgrGameGrid.canvas.Brush.Color := clwhite;
    end;
    strgrGameGrid.canvas.Fillrect(Rect)
  end;
end;

{ MAIN CODE TO CALCULATE THE NEXT STATE OF EVERY CELL }
procedure TformGameOfLife.timerGametickTimer(Sender: TObject);
var
  col, row, count: Integer;
begin
  if pauseGame = False then
  begin
    aliveCells := 0;
    inc(cycleCount);
    editCyclecountOutput.Text := inttostr(cycleCount);
    for row := 2 to numRows - 1 do
    begin
      for col := 2 to numCols - 1 do // for every cell except padding cells
      begin
        count := 0;
        if strgrGameGrid.Cells[col - 1, row - 1] = '#' then
          // count the number of cells surrounding it
          inc(count);
        if strgrGameGrid.Cells[col - 1, row] = '#' then
          inc(count);
        if strgrGameGrid.Cells[col - 1, row + 1] = '#' then
          inc(count);
        if strgrGameGrid.Cells[col, row - 1] = '#' then
          inc(count);
        if strgrGameGrid.Cells[col, row + 1] = '#' then
          inc(count);
        if strgrGameGrid.Cells[col + 1, row - 1] = '#' then
          inc(count);
        if strgrGameGrid.Cells[col + 1, row] = '#' then
          inc(count);
        if strgrGameGrid.Cells[col + 1, row + 1] = '#' then
          inc(count);
        if strgrGameGrid.Cells[col, row] = '#' then // if the cell is alive
        begin
          case count of
            2:
              strArray[row, col] := 'T';
            // and it has two or three neighbours
            3:
              strArray[row, col] := 'T'; // mark it as alive for next pattern
          else
            strArray[row, col] := 'F'; // else mark it as dead
          end; // ENDCASE
        end // ENDIF#
        else if strgrGameGrid.Cells[col, row] = '' then // else if it's dead
        begin
          case count of
            3:
              strArray[row, col] := 'T';
            // and has three partners, mark it as alive for next pattern
          else
            strArray[row, col] := 'F'; // else mark it as dead
          end; // ENDCASE
        end; // ENDELSE
      end; // ENDFORCOL
    end; // ENDFORROW
    for row := 1 to numRows do // for every cell
    begin
      for col := 1 to numCols do
      begin
        if strArray[row, col] = 'T' then
        begin
          strgrGameGrid.Cells[col, row] := '#';
          // transcribe next pattern into displayed pattern
          inc(aliveCells);
        end
        else
          strgrGameGrid.Cells[col, row] := '';
      end; // ENDFORCOL
    end; // ENDFORROW
    editLiveDead.Text := inttostr(aliveCells) + ' : ' +
      inttostr(15876 - aliveCells);
  end; // ENDIFPAUSE
end;


procedure TformGameOfLife.mainmenuGameCounterclockClick(Sender: TObject);
var
  row, col: Integer;
begin
  pauseGame := true;
  mainmenuPauseplay.Caption := 'Play';
  for row := 2 to numRowsUse - 1 do
  begin
    for col := 2 to numcolsUse - 1 do
    begin
      strArray[row, col] := 'F';
      if strgrGameGrid.Cells[numRowsUse - row, col] = '#' then
        strArray[row, col] := 'T'
      else
        strArray[row, col] := 'F';
    end; // endCols
  end; // endRows
  for row := 1 to numRows do // for every cell
  begin
    for col := 1 to numCols do
    begin
      if strArray[row, col] = 'T' then
      begin
        strgrGameGrid.Cells[col, row] := '#';
        // transcribe next pattern into displayed pattern
        inc(aliveCells);
      end
      else
        strgrGameGrid.Cells[col, row] := '';
    end; // ENDFORCOL
  end; // ENDFORROW
  editLiveDead.Text := inttostr(aliveCells) + ' : ' +
    inttostr(numcolsUse * numRowsUse - aliveCells);
end;

procedure TformGameOfLife.mainmenuGameClockClick(Sender: TObject);
var
  row, col: Integer;
begin
  pauseGame := true;
  mainmenuPauseplay.Caption := 'Play';
  for row := 2 to numRowsUse - 1 do
  begin
    for col := 2 to numcolsUse - 1 do
    begin
      strArray[row, col] := 'F';
      if strgrGameGrid.Cells[row, numcolsUse - col] = '#' then
        strArray[row, col] := 'T'
      else
        strArray[row, col] := 'F';
    end; // endCols
  end; // endRows
  for row := 1 to numRows do // for every cell
  begin
    for col := 1 to numCols do
    begin
      if strArray[row, col] = 'T' then
      begin
        strgrGameGrid.Cells[col, row] := '#';
        // transcribe next pattern into displayed pattern
        inc(aliveCells);
      end
      else
        strgrGameGrid.Cells[col, row] := '';
    end; // ENDFORCOL
  end; // ENDFORROW
  editLiveDead.Text := inttostr(aliveCells) + ' : ' +
    inttostr(numcolsUse * numRowsUse - aliveCells);
end;

end.
