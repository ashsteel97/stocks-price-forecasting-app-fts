unit uSahamBetaData;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  Vcl.CategoryButtons, Vcl.WinXCtrls, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, System.Actions, System.UITypes, Vcl.ActnList, Vcl.StdCtrls,
  Vcl.Imaging.pngimage;

type
  TMainFormData = class(TForm)
    TopPanel: TPanel;
    SV: TSplitView;
    catButton: TCategoryButtons;
    imgMenu: TImage;
    ActionList: TActionList;
    actMenu: TAction;
    actAdd: TAction;
    actDelete: TAction;
    ImageList: TImageList;
    lbTop: TLabel;
    homePanel: TPanel;
    lbHome: TLabel;
    dbgAll: TDBGrid;
    edBrowse: TEdit;
    btnBrowse: TButton;
    gbxAddData: TGroupBox;
    CBCompany: TComboBox;
    LBItems: TListBox;
    lblExistedData: TLabel;
    lblNewData: TLabel;
    OpenDialog: TOpenDialog;
    actClear: TAction;
    actUbahTanggal: TAction;
    LBLoad: TListBox;
    dbgExisted: TDBGrid;
    actDefocus: TAction;
    actFormData: TAction;
    actFormForecast: TAction;
    actFormExit: TAction;
    actFormHome: TAction;
    actFormInit: TAction;
    Label1: TLabel;
    btnControlPanel: TPanel;
    addDataPanel: TPanel;
    addImage: TImage;
    deleteDataPanel: TPanel;
    deleteImage: TImage;
    clearDataPanel: TPanel;
    Image2: TImage;
    procedure SVOpening(Sender: TObject);
    procedure SVOpened(Sender: TObject);
    procedure SVClosed(Sender: TObject);
    procedure imgMenuClick(Sender: TObject);
    procedure actMenuExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure catButtonClick(Sender: TObject);
    procedure SVClick(Sender: TObject);
    procedure addDataPanelMouseEnter(Sender: TObject);
    procedure addDataPanelMouseLeave(Sender: TObject);
    procedure deleteDataPanelMouseEnter(Sender: TObject);
    procedure deleteDataPanelMouseLeave(Sender: TObject);
    procedure actKeyPressExecute(Sender: TObject; var Key: Char);
    procedure clearDataPanelMouseEnter(Sender: TObject);
    procedure clearDataPanelMouseLeave(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure actUbahTanggalExecute(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure CBCompanyChange(Sender: TObject);
    procedure actDefocusExecute(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actDeleteExecute(Sender: TObject);
    procedure actFormExitExecute(Sender: TObject);
    procedure actFormDataExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actFormForecastExecute(Sender: TObject);
    procedure actFormHomeExecute(Sender: TObject);
    procedure actFormInitExecute(Sender: TObject);



  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFormData: TMainFormData;
  slline : TStringList;

implementation

{$R *.dfm}

uses udm, uSahamBetaForecast, uSahamBetaHome;


procedure TMainFormData.actUbahTanggalExecute(Sender: TObject);
begin

  slline[0] := StringReplace(slline[0], ' ', '/', [rfReplaceAll]);

  slline[0] := StringReplace(slline[0], ',', '', [rfReplaceAll]);

  slline[0] := StringReplace(slline[0], 'Dec', '12', [rfReplaceAll]);

  slline[0] := StringReplace(slline[0], 'Nov', '11', [rfReplaceAll]);

  slline[0] := StringReplace(slline[0], 'Oct', '10', [rfReplaceAll]);

  slline[0] := StringReplace(slline[0], 'Sep', '09', [rfReplaceAll]);

  slline[0] := StringReplace(slline[0], 'Aug', '08', [rfReplaceAll]);

  slline[0] := StringReplace(slline[0], 'Jul', '07', [rfReplaceAll]);

  slline[0] := StringReplace(slline[0], 'Jun', '06', [rfReplaceAll]);

  slline[0] := StringReplace(slline[0], 'May', '05', [rfReplaceAll]);

  slline[0] := StringReplace(slline[0], 'Apr', '04', [rfReplaceAll]);

  slline[0] := StringReplace(slline[0], 'Mar', '03', [rfReplaceAll]);

  slline[0] := StringReplace(slline[0], 'Feb', '02', [rfReplaceAll]);

  slline[0] := StringReplace(slline[0], 'Jan', '01', [rfReplaceAll]);

  slline[1] := StringReplace(slline[1], ',', '', [rfReplaceAll]);

end;

procedure TMainFormData.catButtonClick(Sender: TObject);
begin

 if SV.Opened = True then

    begin
    homePanel.Enabled := True;
    SV.Close;
    end


end;

procedure TMainFormData.CBCompanyChange(Sender: TObject);
begin

 with udm.dm.ZQViewExisted do
  begin

  Active := True;

  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM sahambeta WHERE Company = "' + CBCompany.Text + '"');
  Open;

  end;

  LBLoad.Clear;
  LBItems.Clear;
  edBrowse.Clear;


end;

procedure TMainFormData.clearDataPanelMouseEnter(Sender: TObject);
begin

clearDataPanel.Color := $00D9902B;

end;

procedure TMainFormData.clearDataPanelMouseLeave(Sender: TObject);
begin

clearDataPanel.Color := $00C8AE9B;

end;

procedure TMainFormData.deleteDataPanelMouseEnter(Sender: TObject);
begin

deleteDataPanel.Color := $00D9902B;

end;

procedure TMainFormData.deleteDataPanelMouseLeave(Sender: TObject);
begin

deleteDataPanel.Color := $00C8AE9B;

end;



procedure TMainFormData.actAddExecute(Sender: TObject);
var line : string;
BEGIN

  if LBItems.Items.Count <= 0 then

          begin
          MessageDlg('THERE IS NO DATA THAT IS ENTERED', mtInformation, [mbOK], 0)
          end

      else

           Begin

           slline := TStringList.Create;

           addDataPanel.Cursor := crHourGlass;

                for line in LBLoad.Items do
                Begin

                slline.CommaText := line;

                actUbahTanggalExecute(slline);

                      with udm.dm.ZTSahamAdd do
                      begin

                        if udm.dm.ZQLocate.Locate('id',(slline[0]+'_'+CBCompany.Text),[]) then

                          begin

                          MessageDlg(('DATA FOR COMPANY ' + udm.dm.ZQLocate.FieldByName('Company').AsString + #13 + 'ON DATE ' + udm.dm.ZQLocate.FieldByName('Date').AsString + ' IS EXISTED' + #13 + 'PLEASE CHECK THE DATA') , mtWarning, [mbOK], 0);

                          addDataPanel.Cursor := crHandPoint;

                          Abort;

                          end

                        else

                            begin

                              with udm.dm.ZTSahamAdd do
                              begin

                              Append;
                              udm.dm.ZTSahamAdd.FieldByName('id').AsString := (slline[0]+'_'+CBCompany.Text);
                              udm.dm.ZTSahamAdd.FieldByName('Date').AsDateTime := StrToDate(slline[0]);
                              udm.dm.ZTSahamAdd.FieldByName('Price').AsFloat := StrToFloat(slline[1]);
                              udm.dm.ZTSahamAdd.FieldByName('Company').AsString := CBCompany.Text;
                              Post;

                              end;



                            end;

                      end;




                End;


            actClearExecute(MainFormData);

            MessageDlg('DATA SUCCESSFULLY ENTERED', mtInformation, [mbOK], 0);

            addDataPanel.Cursor := crHandPoint;

           End;


END;

procedure TMainFormData.actClearExecute(Sender: TObject);
Begin

LBLoad.Clear;

LBItems.Clear;

CBCompany.Text := '--Select Company--';

edBrowse.Clear;

  with udm.dm.ZQViewExisted do
  begin

  Close;

  SQL.Clear;

  SQL.Add('SELECT * FROM sahambeta');

  Open;

  end;

udm.dm.ZQViewExisted.Active := False;

udm.dm.ZTSahamAdd.Refresh;

udm.dm.ZTSahamAdd.First;

FreeAndNil(slline);

ShowScrollBar(dbgExisted.Handle, SB_VERT, False);

actDefocusExecute(MainFormData);

End;

procedure TMainFormData.actDefocusExecute(Sender: TObject);
begin

MainFormData.DefocusControl(MainFormData, False);

end;


procedure TMainFormData.actDeleteExecute(Sender: TObject);
var
date, company, price : string;

BEGIN

  {with udm.dm.ZTSahamAdd do
  begin

  date := udm.dm.ZTSahamAdd.FieldValues['Date'];
  company := udm.dm.ZTSahamAdd.FieldValues['Company'];
  price := udm.dm.ZTSahamAdd.FieldValues['Price'];

  end;}


  with udm.dm.ZQViewExisted do
  begin

  date := udm.dm.ZQViewExisted.FieldValues['Date'];
  company := udm.dm.ZQViewExisted.FieldValues['Company'];
  price := udm.dm.ZQViewExisted.FieldValues['Price'];

  end;


  if MessageDlg('Are You Sure You Will Delete This Stock Data?' +#13 + 'Date : ' + date + #13 +'Company : ' + Company + #13 +'Price : ' + Price, mtConfirmation, [mbYes,mbNo],0,mbNo)= mrYes then
  Begin

      with udm.dm.ZQViewExisted do
      begin

      udm.dm.ZQViewExisted.Delete;
      MessageDlg('Stock Data In : ' + #13 + 'Date : ' + date + #13 +'Company : ' + Company + #13 +'Price : ' + Price + #13 + 'Has Been Successfully Deleted', mtinformation,[mbOk],0);

      end;


   actClearExecute(clearDataPanel);
   dbgAll.Refresh;

  End;



END;

procedure TMainFormData.actFormDataExecute(Sender: TObject);
begin

  MainFormData.Show;

end;

procedure TMainFormData.actFormExitExecute(Sender: TObject);
begin

    with udm.dm.ZQTruncate do
    Begin

    SQL.Clear;
    SQL.Text := 'TRUNCATE TABLE sahamhasil';
    ExecSQL;

    End;

    with udm.dm.ZQTruncate do
    Begin

    SQL.Clear;
    SQL.Text := 'TRUNCATE TABLE flrsaham';
    ExecSQL;

    End;

    with udm.dm.ZQTruncate do
    Begin

    SQL.Clear;
    SQL.Text := 'TRUNCATE TABLE tempsaham';
    ExecSQL;

    End;

  actClearExecute(MainFormData);

  Application.Terminate;

end;

procedure TMainFormData.actFormForecastExecute(Sender: TObject);
begin

MainFormForecast.Show;

end;

procedure TMainFormData.actFormHomeExecute(Sender: TObject);
begin

MainFormHome.Show;

end;

procedure TMainFormData.actFormInitExecute(Sender: TObject);
Begin

      with udm.dm.ZQViewExisted do
      begin

      Close;

      SQL.Clear;

      SQL.Add('SELECT * FROM sahambeta');

      Open;

      end;

  udm.dm.ZQViewExisted.Active := False;

  udm.dm.ZTSahamAdd.Refresh;

  udm.dm.ZTSahamAdd.First;

  FreeAndNil(slline);

  ShowScrollBar(dbgExisted.Handle, SB_VERT, False);

  actDefocusExecute(MainFormData);

End;

procedure TMainFormData.actKeyPressExecute(Sender: TObject; var Key : Char);
begin
Key := #0;
end;

procedure TMainFormData.actMenuExecute(Sender: TObject);
begin

catButton.Width := SV.OpenedWidth;

  if SV.Opened = True then

    begin
    homePanel.Enabled := True;
    SV.Close;
    end

    else if SV.Opened = False then
      begin
      homePanel.Enabled := False;
      SV.Open;
      end;

end;


procedure TMainFormData.FormClose(Sender: TObject; var Action: TCloseAction);
begin

Action := caFree;

end;

procedure TMainFormData.FormCreate(Sender: TObject);
begin

if (SV.Opened = False) then catButton.Width := SV.CompactWidth

else if (SV.Opened = True) then catButton.Width := SV.OpenedWidth;


catButton.Width := SV.Width;

end;



procedure TMainFormData.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

if (Key = VK_F4) and (ssAlt in Shift) then actFormExitExecute(MainFormData);

end;


procedure TMainFormData.imgMenuClick(Sender: TObject);
begin

actMenuExecute(imgMenu);

end;


{procedure TMainFormData.searchDataPanelMouseEnter(Sender: TObject);
begin

searchDataPanel.Color := $00D9902B;

end;}

{procedure TMainFormData.searchDataPanelMouseLeave(Sender: TObject);
begin

searchDataPanel.Color := $00C8AE9B;

end;}

procedure TMainFormData.addDataPanelMouseEnter(Sender: TObject);
begin

addDataPanel.Color := $00D9902B;

end;

procedure TMainFormData.addDataPanelMouseLeave(Sender: TObject);
begin

addDataPanel.Color := $00C8AE9B;

end;

procedure TMainFormData.btnBrowseClick(Sender: TObject);
var line : string; lbindex : integer;

BEGIN

if CBCompany.Text = '--Select Company--' then MessageDlg('Please Select Company First', mtInformation, [mbOK], 0)

else
      begin

        if OpenDialog.Execute then

        begin

        edBrowse.Text := OpenDialog.FileName;

        LBLoad.Items.LoadFromFile(edBrowse.Text);

        end;


      LBLoad.Items.Delete(0);

        begin

        slline := TStringList.Create;

          for line in LBLoad.Items do
          begin

          slline.CommaText := line;

          actUbahTanggalExecute(slline);

          lbindex := LBItems.Items.Add(slline[0] + '--||--' + slline[1]);

          end;

        LBItems.TopIndex := lbindex;

        end;

       FreeAndNil(slline);

      end;

END;


procedure TMainFormData.SVClick(Sender: TObject);
begin

if SV.Opened = True then

    begin
    homePanel.Enabled := True;
    SV.Close;
    end


end;

procedure TMainFormData.SVClosed(Sender: TObject);
begin

catButton.Width := SV.CompactWidth;

end;

procedure TMainFormData.SVOpened(Sender: TObject);
begin

catButton.Width := SV.OpenedWidth;

end;

procedure TMainFormData.SVOpening(Sender: TObject);
begin

catButton.Width := SV.OpenedWidth;

end;

end.
