unit Unit_GameOfLifeOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  ToptionsForm = class(TForm)
    timeEdit: TEdit;
    timeLabel: TLabel;
    buttonSaveOptions: TButton;
    gridsizeEdit: TEdit;
    gridsizeLabel: TLabel;
    checkboxDebug: TCheckBox;
    labelRownum: TLabel;
    labelColnum: TLabel;
    editRownum: TEdit;
    editColnum: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure timeEditKeyPress(Sender: TObject; var Key: Char);
    procedure gridsizeEditKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure buttonSaveOptionsClick(Sender: TObject);
    procedure editColnumKeyPress(Sender: TObject; var Key: Char);
    procedure editRownumKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  optionsForm: ToptionsForm;

implementation

uses Unit_GameOfLife;

{$R *.dfm}

{ Save the options to file }
procedure ToptionsForm.buttonSaveOptionsClick(Sender: TObject);
var
  optionsFile: textfile;
  debugShow: integer;
begin
  if (strtoint(editRownum.Text) <= 127) and (strtoint(editColnum.Text) <= 127) then
  begin

  case checkboxDebug.Checked of // fix checkbox saving
    True:
      debugShow := 1;
    False:
      debugShow := 0;
  else
    debugShow := 0;
  end;
  AssignFile(optionsFile, 'options.txt');
  rewrite(optionsFile); // overwrite old file
  writeln(optionsFile, 'GameTickTimer:', strtoint(timeEdit.Text), '#');
  writeln(optionsFile, 'GridSize:', strtoint(gridsizeEdit.Text), '#');
  writeln(optionsFile, 'ShowDebug:', debugShow, '#'); // write the options
  writeln(optionsFile, 'NumRows:',strtoint(editRownum.Text),'#');
  writeln(optionsFile, 'NumCols:',strtoint(editColnum.Text),'#');
  CloseFile(optionsFile); // close the file
  optionsForm.close; // close the dialog box
  end
  else
    application.MessageBox('Row Number and Col number cannot be above 127!', 0, 0)
end;

{ When the form loads, assign data from the file to the edit boxes }
procedure ToptionsForm.FormActivate(Sender: TObject);
var
  lineData, outputData: string;
  optionsFile: textfile;
  i, outputInteger: integer;
  readData: boolean;
begin
  if FileExists('options.txt') = False then // check if there's an options file
    Application.MessageBox('No options file found! Please restart program!',
      'Error', 0)
  else // if there is, parse the data in it and assign to variables
  begin
    readData := False;
    AssignFile(optionsFile, 'options.txt');
    reset(optionsFile); // open file for reading
    readln(optionsFile, lineData);
    // similar procedure to activateOptions; , except assigning values to edit boxes
    for i := 1 to length(lineData) do       //time interval
    begin
      if lineData[i] = '#' then
        readData := False;
      if readData = True then
        outputData := outputData + lineData[i];
      if lineData[i] = ':' then
        readData := True;
    end;
    timeEdit.Text := outputData;
    readData := False;
    outputData := '';
    lineData := '';
    readln(optionsFile, lineData);     //grid squaresize
    for i := 1 to length(lineData) do
    begin
      if lineData[i] = '#' then
        readData := False;
      if readData = True then
        outputData := outputData + lineData[i];
      if lineData[i] = ':' then
        readData := True;
    end;
    gridsizeEdit.Text := outputData;
    readData := False;
    outputData := '';
    lineData := '';
    readln(optionsFile, lineData);   // Show debug menu
    for i := 1 to length(lineData) do
    begin
      if lineData[i] = '#' then
        readData := False;
      if readData = True then
        outputData := outputData + lineData[i];
      if lineData[i] = ':' then
        readData := True;
    end;
    outputInteger := strtoint(outputData);
    case outputInteger of
      1:
        checkboxDebug.State := cbChecked;
      0:
        checkboxDebug.State := cbUnchecked;
    else
      checkboxDebug.State := cbUnchecked;
    end; //ENDCASE
    outputData := '';
    lineData := '';
    readln(optionsFile, lineData);      //number of rows
    for i := 1 to length(lineData) do
    begin
      if lineData[i] = '#' then
        readData := False;
      if readData = True then
        outputData := outputData + lineData[i];
      if lineData[i] = ':' then
        readData := True;
    end;
    editRownum.Text := outputData;
    outputData := '';
    lineData := '';
    readln(optionsFile, lineData);  //number of columns
    for i := 1 to length(lineData) do
    begin
      if lineData[i] = '#' then
        readData := False;
      if readData = True then
        outputData := outputData + lineData[i];
      if lineData[i] = ':' then
        readData := True;
    end;
    editColnum.Text := outputData;
    CloseFile(optionsFile); //close the file
  end;
end;

{Enable form and put changes into action}
procedure ToptionsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  formGameofLife.Enabled := True;
  formGameofLife.activateOptions;
end;

{ These procedures are for sanitisation and allow only numbers/backspace to be
  entered in these boxes }
procedure ToptionsForm.gridsizeEditKeyPress(Sender: TObject; var Key: Char);
begin
  // #8 is Backspace
  if not(Key in [#8, '0' .. '9']) then
  begin
    Application.MessageBox('Invalid Key.', 'Game Of Life Options', 0);
    // Discard the key
    Key := #0;
  end;
end;

procedure ToptionsForm.timeEditKeyPress(Sender: TObject; var Key: Char);
begin
  // #8 is Backspace
  if not(Key in [#8, '0' .. '9']) then
  begin
    Application.MessageBox('Invalid Key.', 'Game Of Life Options', 0);
    // Discard the key
    Key := #0;
  end;
end;

procedure ToptionsForm.editColnumKeyPress(Sender: TObject; var Key: Char);
begin
  // #8 is Backspace
  if not(Key in [#8, '0' .. '9']) then
  begin
    Application.MessageBox('Invalid Key.', 'Game Of Life Options', 0);
    // Discard the key
    Key := #0;
  end;
end;

procedure ToptionsForm.editRownumKeyPress(Sender: TObject; var Key: Char);
begin
  // #8 is Backspace
  if not(Key in [#8, '0' .. '9']) then
  begin
    Application.MessageBox('Invalid Key.', 'Game Of Life Options', 0);
    // Discard the key
    Key := #0;
  end;
end;

end.
