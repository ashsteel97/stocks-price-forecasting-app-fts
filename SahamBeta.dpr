program SahamBeta;

uses
  Vcl.Forms,
  uSahamBetaHome in 'uSahamBetaHome.pas' {MainFormHome},
  udm in 'udm.pas' {dm: TDataModule},
  uSahamBetaForecast in 'uSahamBetaForecast.pas' {MainFormForecast},
  uSahamBetaData in 'uSahamBetaData.pas' {MainFormData},
  uSahamBetaSplash in 'uSahamBetaSplash.pas' {MainFormSplash};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TMainFormSplash, MainFormSplash);
  Application.CreateForm(TMainFormForecast, MainFormForecast);
  Application.CreateForm(TMainFormHome, MainFormHome);
  Application.CreateForm(TMainFormData, MainFormData);
  Application.Run;
end.
