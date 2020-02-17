unit udm;

interface

uses
  System.SysUtils, System.Classes, ZAbstractConnection, ZConnection, Data.DB,
  ZAbstractRODataset, ZAbstractDataset, ZAbstractTable, ZDataset, Vcl.Controls,
  System.ImageList, Vcl.ImgList, Vcl.VirtualImageList, Vcl.BaseImageCollection,
  Vcl.ImageCollection, System.Actions, Vcl.ActnList;

type
  Tdm = class(TDataModule)
    ZConnection: TZConnection;
    ZTSahamAdd: TZTable;
    DSSaham: TDataSource;
    ZQViewExisted: TZQuery;
    DSViewExisted: TDataSource;
    ZQLocate: TZQuery;
    DSForecast: TDataSource;
    ZQForecast: TZQuery;
    ZQForecastid: TWideStringField;
    ZQForecastDate: TDateField;
    ZQForecastPrice: TLargeintField;
    ZQForecastCompany: TWideStringField;
    ZQLocateid: TWideStringField;
    ZQLocateDate: TDateField;
    ZQLocatePrice: TLargeintField;
    ZQLocateCompany: TWideStringField;
    ZQViewExistedid: TWideStringField;
    ZQViewExistedDate: TDateField;
    ZQViewExistedPrice: TLargeintField;
    ZQViewExistedCompany: TWideStringField;
    ZTSahamAddid: TWideStringField;
    ZTSahamAddDate: TDateField;
    ZTSahamAddPrice: TLargeintField;
    ZTSahamAddCompany: TWideStringField;
    ZTTempSaham: TZTable;
    ZTTempSahamPrice: TLargeintField;
    DSTempSaham: TDataSource;
    ZQFlr: TZQuery;
    DSFlr: TDataSource;
    ZQFLRG: TZQuery;
    DSFLRG: TDataSource;
    ZQFlrkuren: TIntegerField;
    ZQFlrnext: TIntegerField;
    DSHasil: TDataSource;
    ZTHasil: TZTable;
    ZQHasil: TZQuery;
    ZQHasilkuren: TIntegerField;
    ZTHasilnomor: TIntegerField;
    ZTHasiltanggal: TDateField;
    ZTHasildata: TIntegerField;
    ZTHasilhasil: TIntegerField;
    ZQTruncate: TZQuery;
    ZQHome: TZQuery;
    ZQHomeid: TWideStringField;
    ZQHomeDate: TDateField;
    ZQHomePrice: TLargeintField;
    ZQHomeCompany: TWideStringField;
    ZQHomeChart: TZQuery;
    ZQHomeChartid: TWideStringField;
    ZQHomeChartDate: TDateField;
    ZQHomeChartPrice: TLargeintField;
    ZQHomeChartCompany: TWideStringField;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses uSahamBetaData, uSahamBetaForecast, uSahamBetaHome, uSahamBetaSplash;

{$R *.dfm}




end.
