program Proj_GameOfLife;

uses
  Forms,
  Unit_GameOfLife in 'Unit_GameOfLife.pas' {formGameOfLife},
  Unit_GameOfLifeOptions in 'Unit_GameOfLifeOptions.pas' {optionsForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TformGameOfLife, formGameOfLife);
  Application.CreateForm(ToptionsForm, optionsForm);
  Application.CreateForm(ToptionsForm, optionsForm);
  Application.Run;
end.
