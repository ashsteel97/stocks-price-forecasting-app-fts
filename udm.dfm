object dm: Tdm
  OldCreateOrder = False
  Height = 381
  Width = 771
  object ZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    Catalog = ''
    Connected = True
    HostName = 'localhost'
    Port = 3306
    Database = 'saham'
    User = 'root'
    Password = ''
    Protocol = 'mysql'
    Left = 32
    Top = 16
  end
  object ZTSahamAdd: TZTable
    Connection = ZConnection
    SortedFields = 'Date'
    SortType = stDescending
    Active = True
    TableName = 'sahambeta'
    IndexFieldNames = 'Date Desc'
    Left = 32
    Top = 80
    object ZTSahamAddid: TWideStringField
      Alignment = taCenter
      FieldName = 'id'
      Required = True
      Size = 15
    end
    object ZTSahamAddDate: TDateField
      Alignment = taCenter
      FieldName = 'Date'
      Required = True
    end
    object ZTSahamAddPrice: TLargeintField
      Alignment = taCenter
      FieldName = 'Price'
      Required = True
      DisplayFormat = '#,###'
    end
    object ZTSahamAddCompany: TWideStringField
      Alignment = taCenter
      FieldName = 'Company'
      Required = True
      Size = 255
    end
  end
  object DSSaham: TDataSource
    DataSet = ZTSahamAdd
    Left = 32
    Top = 136
  end
  object ZQViewExisted: TZQuery
    Connection = ZConnection
    SortedFields = 'Date'
    SortType = stDescending
    SQL.Strings = (
      'select * from sahambeta')
    Params = <>
    IndexFieldNames = 'Date Desc'
    Left = 128
    Top = 80
    object ZQViewExistedid: TWideStringField
      Alignment = taCenter
      FieldName = 'id'
      Required = True
      Size = 15
    end
    object ZQViewExistedDate: TDateField
      Alignment = taCenter
      FieldName = 'Date'
      Required = True
    end
    object ZQViewExistedPrice: TLargeintField
      Alignment = taCenter
      FieldName = 'Price'
      Required = True
      DisplayFormat = '#,###'
    end
    object ZQViewExistedCompany: TWideStringField
      Alignment = taCenter
      FieldName = 'Company'
      Required = True
      Size = 255
    end
  end
  object DSViewExisted: TDataSource
    DataSet = ZQViewExisted
    Left = 128
    Top = 136
  end
  object ZQLocate: TZQuery
    Connection = ZConnection
    Active = True
    SQL.Strings = (
      'select * from sahambeta;')
    Params = <>
    Left = 208
    Top = 80
    object ZQLocateid: TWideStringField
      FieldName = 'id'
      Required = True
      Size = 15
    end
    object ZQLocateDate: TDateField
      FieldName = 'Date'
      Required = True
    end
    object ZQLocatePrice: TLargeintField
      FieldName = 'Price'
      Required = True
      DisplayFormat = '#,###'
    end
    object ZQLocateCompany: TWideStringField
      FieldName = 'Company'
      Required = True
      Size = 255
    end
  end
  object DSForecast: TDataSource
    DataSet = ZQForecast
    Left = 424
    Top = 144
  end
  object ZQForecast: TZQuery
    Connection = ZConnection
    SortedFields = 'Price'
    SQL.Strings = (
      'select * from sahambeta;')
    Params = <>
    IndexFieldNames = 'Price Asc'
    Left = 424
    Top = 80
    object ZQForecastid: TWideStringField
      FieldName = 'id'
      Required = True
      Size = 15
    end
    object ZQForecastDate: TDateField
      FieldName = 'Date'
      Required = True
    end
    object ZQForecastPrice: TLargeintField
      FieldName = 'Price'
      Required = True
      DisplayFormat = '#,###'
    end
    object ZQForecastCompany: TWideStringField
      FieldName = 'Company'
      Required = True
      Size = 255
    end
  end
  object ZTTempSaham: TZTable
    Connection = ZConnection
    Active = True
    TableName = 'tempsaham'
    Left = 344
    Top = 80
    object ZTTempSahamPrice: TLargeintField
      FieldName = 'Price'
      Required = True
    end
  end
  object DSTempSaham: TDataSource
    DataSet = ZTTempSaham
    Left = 344
    Top = 144
  end
  object ZQFlr: TZQuery
    Connection = ZConnection
    Active = True
    SQL.Strings = (
      'select * from flrsaham;')
    Params = <>
    Left = 488
    Top = 80
    object ZQFlrkuren: TIntegerField
      FieldName = 'kuren'
      Required = True
    end
    object ZQFlrnext: TIntegerField
      FieldName = 'next'
      Required = True
    end
  end
  object DSFlr: TDataSource
    DataSet = ZQFlr
    Left = 488
    Top = 144
  end
  object ZQFLRG: TZQuery
    Connection = ZConnection
    SQL.Strings = (
      'select * from flrsaham;')
    Params = <
      item
        DataType = ftUnknown
        Name = 'kuren'
        ParamType = ptUnknown
      end>
    Left = 488
    Top = 224
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'kuren'
        ParamType = ptUnknown
      end>
  end
  object DSFLRG: TDataSource
    DataSet = ZQFLRG
    Left = 488
    Top = 288
  end
  object DSHasil: TDataSource
    DataSet = ZTHasil
    Left = 400
    Top = 288
  end
  object ZTHasil: TZTable
    Connection = ZConnection
    TableName = 'sahamhasil'
    Left = 400
    Top = 224
    object ZTHasilnomor: TIntegerField
      FieldName = 'nomor'
      Required = True
    end
    object ZTHasiltanggal: TDateField
      FieldName = 'tanggal'
      Required = True
    end
    object ZTHasildata: TIntegerField
      FieldName = 'data'
      Required = True
    end
    object ZTHasilhasil: TIntegerField
      FieldName = 'hasil'
      Required = True
    end
  end
  object ZQHasil: TZQuery
    Connection = ZConnection
    Active = True
    SQL.Strings = (
      'select kuren from flrsaham;')
    Params = <>
    Left = 344
    Top = 224
    object ZQHasilkuren: TIntegerField
      FieldName = 'kuren'
      Required = True
    end
  end
  object ZQTruncate: TZQuery
    Connection = ZConnection
    Active = True
    SQL.Strings = (
      'SELECT * FROM sahambeta;')
    Params = <>
    Left = 552
    Top = 80
  end
  object ZQHome: TZQuery
    Connection = ZConnection
    Active = True
    SQL.Strings = (
      'select * from sahambeta;')
    Params = <>
    Left = 32
    Top = 232
    object ZQHomeid: TWideStringField
      FieldName = 'id'
      Required = True
      Size = 15
    end
    object ZQHomeDate: TDateField
      FieldName = 'Date'
      Required = True
    end
    object ZQHomePrice: TLargeintField
      FieldName = 'Price'
      Required = True
    end
    object ZQHomeCompany: TWideStringField
      FieldName = 'Company'
      Required = True
      Size = 255
    end
  end
  object ZQHomeChart: TZQuery
    Connection = ZConnection
    SortedFields = 'Date'
    SQL.Strings = (
      'select * from sahambeta;')
    Params = <>
    IndexFieldNames = 'Date Asc'
    Left = 32
    Top = 296
    object ZQHomeChartid: TWideStringField
      FieldName = 'id'
      Required = True
      Size = 15
    end
    object ZQHomeChartDate: TDateField
      FieldName = 'Date'
      Required = True
    end
    object ZQHomeChartPrice: TLargeintField
      FieldName = 'Price'
      Required = True
    end
    object ZQHomeChartCompany: TWideStringField
      FieldName = 'Company'
      Required = True
      Size = 255
    end
  end
end
