unit uSahamBetaForecast;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  Vcl.CategoryButtons, Vcl.WinXCtrls, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, System.Actions, Vcl.ActnList, Vcl.StdCtrls, Math,
  Vcl.Imaging.pngimage, madExceptVcl, DateUtils, OleAuto, VclTee.TeeGDIPlus,
  VCLTee.TeEngine, VCLTee.DBChart, VCLTee.TeeDBCrossTab, VCLTee.TeeProcs,
  VCLTee.Chart, VCLTee.Series, System.UITypes, JvComponentBase, JvDBGridExport;

type
  TMainFormForecast = class(TForm)
    TopPanel: TPanel;
    SV: TSplitView;
    catButton: TCategoryButtons;
    imgMenu: TImage;
    ActionList: TActionList;
    actMenu: TAction;
    ImageList: TImageList;
    lbTop: TLabel;
    homePanel: TPanel;
    lbHome: TLabel;
    dbgForecastExisted: TDBGrid;
    actClear: TAction;
    actDefocus: TAction;
    actFormData: TAction;
    actFormForecast: TAction;
    CBForecastCompany: TComboBox;
    btnForecast: TButton;
    btnReset: TButton;
    lblExistedData: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    ListBox5: TListBox;
    StringGrid1: TStringGrid;
    ListBox6: TListBox;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    StringGrid5: TStringGrid;
    ListBox7: TListBox;
    ListBox8: TListBox;
    DBGrid1: TDBGrid;
    Chart1: TChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    actFormExit: TAction;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    btnSave: TButton;
    JvDBGridCSVExport: TJvDBGridCSVExport;
    SaveDialog: TSaveDialog;
    actFormHome: TAction;
    actCopy: TAction;
    Button1: TButton;
    StringGrid6: TStringGrid;
    StringGrid7: TStringGrid;


    procedure SVOpening(Sender: TObject);
    procedure SVOpened(Sender: TObject);
    procedure SVClosed(Sender: TObject);
    procedure imgMenuClick(Sender: TObject);
    procedure actMenuExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure catButtonClick(Sender: TObject);
    procedure SVClick(Sender: TObject);
    procedure actKeyPressExecute(Sender: TObject; var Key: Char);
    procedure actDefocusExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CBForecastCompanyChange(Sender: TObject);
    procedure btnForecastClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure actFormExitExecute(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actFormDataExecute(Sender: TObject);
    procedure actFormForecastExecute(Sender: TObject);
    procedure actFormHomeExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);







  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFormForecast: TMainFormForecast;
  //slline : TStringList;

implementation

{$R *.dfm}

uses udm, uSahamBetaData, uSahamBetaHome;


function RoundCorrect(R: Real): LongInt;
begin
  Result:= Trunc(R);       // extract the integer part
  if Frac(R) >= 0.5 then   // if fractional part >= 0.5 then...
    Result := Result + 1;   // ...add 1
end;



procedure TMainFormForecast.btnForecastClick(Sender: TObject);
var
i,q,xi,xj,xn : Integer;
Source, Target, Squared, NewTarget, NewSource, tempSource : array of Double;
FGroup : array of array of Double;
a,ax,sumabs,sumabsx,r,dr : Real;
ba,bw, bax, bwx, range, n, segmentL, roundDiff, maks, mins : Real;
lowerbound, leftcore, rightcore, upperbound : Real;
memberDegree : array of array of Double;
actValue : array of Double;
memValue : Integer;
memGroup : array of Integer;

order : Integer;

DFGroup : array of Real;
tanggal : array of TDateTime;
nilaitengah : array of Double;
totaldfg : Double;
pembagidfg, nilainext, nilaikuren : Integer;
dataHasil : array of Double;
totaldfgx : real;
arrMSE, arrMAPE : array of Double;
MSE, MAPE, sumMSE, sumMAPE : Double;

Anext : string;
arrAnext : array of string;




BEGIN

  if CBForecastCompany.Text = '--Select Company To Forecast--' then MessageDlg('Please Select Company To Forecast First', mtInformation, [mbOK], 0)

  else

      Begin

          if dm.ZQForecast.RecordCount <= 0 then
          begin

          MessageDlg('There is No Data To Perform Forecast For This Company', mtInformation, [mbOK], 0);

          actClearExecute(btnReset);

          actDefocusExecute(btnReset);

          end

          else if dm.ZQForecast.RecordCount <= 9 then
          begin

          MessageDlg('The Data is Not Enough To Perform Forecast For This Company', mtInformation, [mbOK], 0);

          actClearExecute(btnReset);

          actDefocusExecute(btnReset);

          end

          else if dm.ZQForecast.RecordCount >= 10 then
          Begin


            btnReset.Enabled := True;

            btnSave.Enabled := True;

            btnForecast.Enabled := False;

            CBForecastCompany.Enabled := False;

            homePanel.Cursor := crHourGlass;


          SetLength(Source, dm.ZQForecast.RecordCount-1);

          SetLength(Target, dm.ZQForecast.RecordCount-1);

          SetLength(Squared, dm.ZQForecast.RecordCount-1);

          SetLength(tempSource, dm.ZQForecast.RecordCount-1);

          //SetLength(NewTarget, dm.ZQForecast.RecordCount-1);

          //SetLength(NewSource, dm.ZQForecast.RecordCount-1);

          SetLength(actValue, dm.ZQForecast.RecordCount-1);

          //SetLength(arrMSE, dm.ZQForecast.RecordCount-1);

          //SetLength(arrMAPE, dm.ZQForecast.RecordCount-1);


             for i := 0 to Length(Source) do
             begin

             Source[i] := dm.ZQForecast.FieldByName('Price').AsFloat;

             dm.ZQForecast.Next;

             end;

             for i := 0 to Length(Target) do
             begin

             a := Abs(Source[i] - Source[i+1]);

             Target[i] := a;

             end;


             for i := 0 to Length(Target)-1  do
             begin

             ListBox1.Items.Add('Target[' + IntToStr(i) + '] : ' + FormatFloat('0', Target[i]));

             end;

             sumabs := (Sum(Target))/(udm.dm.ZQForecast.RecordCount-1);

             ListBox1.Items.Add('Sum : ' + FormatFloat('0.000000', sumabs));

             ListBox1.Items.Add('Pembulatan : ' + FloatToStr(RoundCorrect(sumabs)));


             for i := 0 to Length(Target)-1  do
             begin

             Squared[i] := (Sqr(Target[i]- RoundCorrect(sumabs)));

             ListBox2.Items.Add('Iterasi ke ' + IntToStr(i) + ' = ' + FormatFloat('0', Squared[i]));

             end;

             r := (Sum(Squared))/(udm.dm.ZQForecast.RecordCount-1);

             ListBox2.Items.Add('Sum : ' + FormatFloat('0.000000', r));

             ListBox2.Items.Add('Pembulatan : ' + FloatToStr(RoundCorrect(r)));

             dr := Sqrt(RoundCorrect(r));

             ListBox2.Items.Add('Square Root : ' + FormatFloat('0.000000' ,dr));

             ListBox2.Items.Add('Pembulatan Square Root : ' + FloatToStr(RoundCorrect(dr)));

             bw := RoundCorrect(sumabs)-RoundCorrect(dr);

             ListBox2.Items.Add('Batas Bawah = ' +  FormatFloat('0',bw));

             ba := RoundCorrect(sumabs)+ RoundCorrect(dr);

             ListBox2.Items.Add('Batas Atas = ' +  FormatFloat('0',ba));


             for i := 0 to Length(Target)  do
             begin


              if ((Target[i]>=bw) and (Target[i]<=ba)) then

                  begin

                  tempSource[i] := Target[i];

                  ListBox3.Items.Add('TARGET YANG SESUAI : ' + IntToStr(i) + ' : ' + FormatFloat('0', tempSource[i]) + ' || ' + FormatFloat('0', Source[i]));

                    with udm.dm.ZTTempSaham do
                    begin

                    Append;

                    udm.dm.ZTTempSaham.FieldByName('Price').AsFloat := tempSource[i];

                    Post;

                    end;


                  end;


             end;

             //////////////////////////////////////////////////////////////
             ///////////////////////NEW COUNT//////////////////////////////
             //////////////////////////////////////////////////////////////

             with udm.dm.ZTTempSaham do
             begin

              Active := False;

              Active := True;


             end;

             //SetLength(NewTarget, 0);

             //SetLength(NewSource, 0);

             SetLength(NewTarget, dm.ZTTempSaham.RecordCount-1);

             SetLength(NewSource, dm.ZTTempSaham.RecordCount-1);


             for q := 0 to Length(NewSource) do
             begin

             NewSource[q] := dm.ZTTempSaham.FieldByName('Price').AsFloat;

             dm.ZTTempSaham.Next;

             end;


             //////////////////////////CEK SUMABSX//////////////////////////////
             ///////////////////////////////////////////////////////////////////

             Begin

               sumabsx := (Sum(NewSource))/(udm.dm.ZTTempSaham.RecordCount);


               if sumabsx <= 0.5 then

                  begin

                  sumabsx := 1;

                  end

               else

                  begin

                  sumabsx := sumabsx;

                  end;

             End;

             ///////////////////////////////////////////////////////////////////
             ///////////////////////LANJUTAN NEW COUNT//////////////////////////
             ///////////////////////////////////////////////////////////////////

             dm.ZQForecast.First;

             bwx := dm.ZQForecast.FieldByName('Price').AsFloat - RoundCorrect(sumabsx);

             dm.ZQForecast.Last;

             bax := dm.ZQForecast.FieldByName('Price').AsFloat + RoundCorrect(sumabsx);

             range := bax-bwx;

             n := ((Range - RoundCorrect(sumabsx)) / (2 * RoundCorrect(sumabsx)));

             segmentL := ((range)/(2*RoundCorrect(n)+1));

             dm.ZQForecast.First;

             mins := dm.ZQForecast.FieldByName('Price').AsFloat;

             dm.ZQForecast.Last;

             maks := dm.ZQForecast.FieldByName('Price').AsFloat;

             roundDiff := (Maks-Mins-segmentL*((2*Round(n))-1)) / ((2*Round(n))-1);



             ///////////////////////////////////////////////////////////////////
             ////////////////////////// CEK XN /////////////////////////////////

             Begin

              //if Frac(n) = 0.5 then

//                 begin
//
//                 xn := RoundCorrect(n);
//                 xn := xn-1
//
//                 end

              //else if Frac(n) < 0.5 then

                 begin

                 xn := RoundCorrect(n);

                 end

//              else if Frac(n) > 0.5 then
//
//                 begin
//
//                 xn := RoundCorrect(n);
//
//                 end

             End;


             /////////////////////////KETERANGAN VARIABEL///////////////////////
             ///////////////////////////////////////////////////////////////////


             ListBox4.Items.Add('Nilai AD : ' + FloatToStr(RoundCorrect(sumabs)));

             ListBox4.Items.Add('');

             ListBox4.Items.Add('Nilai Standart Deviasi : ' + FloatToStr(RoundCorrect(dr)));

             ListBox4.Items.Add('');

             ListBox4.Items.Add('Nilai Batas Pencilan Bawah : ' + FloatToStr(RoundCorrect(bw)));

             ListBox4.Items.Add('');

             ListBox4.Items.Add('Nilai Batas Pencilan Atas : ' + FloatToStr(RoundCorrect(ba)));

             ListBox4.Items.Add('');

             ListBox4.Items.Add('Nilai AD Revised : ' + FloatToStr(RoundCorrect(sumabsx)));

             ListBox4.Items.Add('');

             ListBox4.Items.Add('Batas Bawah Himpunan Fuzzy : ' + FloatToStr(RoundCorrect(bwx)));

             ListBox4.Items.Add('');

             ListBox4.Items.Add('Batas Atas Himpunan Fuzzy : ' + FloatToStr(RoundCorrect(bax)));

             ListBox4.Items.Add('');

             ListBox4.Items.Add('Nilai Range : ' + FloatToStr(RoundCorrect(range)));

             ListBox4.Items.Add('');

             ListBox4.Items.Add('Nilai n Interval : ' + FloatToStr((xn)));

             ListBox4.Items.Add('');

             ListBox4.Items.Add('Nilai Segment Length  : ' + FloatToStr((segmentL)));

             ListBox4.Items.Add('');

             ListBox4.Items.Add('Nilai Mininimum Data  : ' + FloatToStr(Mins));

             ListBox4.Items.Add('');

             ListBox4.Items.Add('Nilai Maksimum Data  : ' + FloatToStr(Maks));

             ListBox4.Items.Add('');

             ListBox4.Items.Add('Nilai Round Diff  : ' + FloatToStr(roundDiff));


             ///////////////////////////FUZZY GROUP////////////////////////////
             /////////////////////////////////////////////////////////////////
             /////////////////////////////////////////////////////////////////

             lowerBound := Mins - sumabsx;
             leftCore := Mins;
	           rightCore := leftCore + (segmentL + roundDiff);
		         upperBound := rightCore + (segmentL + roundDiff);


             SetLength(FGroup, xn, 4);

                    for xi := Low(FGroup) to High(FGroup) do
                    Begin


                              begin
                              FGroup[xi][0] := lowerBound;
                              FGroup[xi][1] := leftCore;
                              FGroup[xi][2] := rightcore;
                              FGroup[xi][3] := upperbound;
                              end;


                      if ( xi = xn-2) then

                              begin

                              lowerBound := rightCore;
                              leftCore := upperBound;
                              rightCore := leftCore + (segmentL + roundDiff);
                              upperbound := rightcore + sumabsx;

                              end

                           else


                             begin

                              lowerBound := rightCore;
                              leftCore := upperBound;
                              rightCore := leftCore + (segmentL + roundDiff);
                              upperBound := rightCore + (segmentL + roundDiff);

                             end;




                        for xj := Low(FGroup[xi]) to High (FGroup[xi]) do
                        Begin

                            ListBox5.Items.Add('Fuzzy Group ['+intToStr(xi)+','+intToStr(xj)+'] = '+ FloatToStr(FGroup[xi,xj]));


                        End;




                    End;


          ///////////////////////DISPLAY STRING GRID////////////////////////////

                    for xi := Low(FGroup) to High(FGroup) do
                      for xj := Low(FGroup[xi]) to High (FGroup[xi]) do
                      begin

                      StringGrid1.RowCount := xn+1;

                      FGroup[xi,xj] := RoundCorrect(FGroup[xi,xj]);

                      StringGrid1.Cells[0,0] := 'Group';

                      StringGrid1.Cells[1,0] := 'a';

                      StringGrid1.Cells[2,0] := 'b';

                      StringGrid1.Cells[3,0] := 'c';

                      StringGrid1.Cells[4,0] := 'd';

                      StringGrid1.Cells[0, xi+1] := 'Group A' + IntToStr(xi+1);

                      StringGrid1.Cells[xj+1, xi+1] := FloatToStr(FGroup[xi,xj]);

                      end;



          ///////////////////////MEMBERSHIP FUNCTION////////////////////////////

            SetLength(memberDegree, dm.ZQForecast.RecordCount, xn);

            SetLength(tanggal, dm.ZQForecast.RecordCount);



            dm.ZQForecast.SortedFields := 'Date';

            dm.ZQForecast.First;

            for xi := 0 to Length(tanggal)-1 do
            begin

            tanggal[xi] := dm.ZQForecast.FieldByName('Date').AsDateTime;
            dm.ZQForecast.Next;

            end;


            dm.ZQForecast.First;

            for xi := 0 to Length(actValue) do
            begin

            actValue[xi] := dm.ZQForecast.FieldByName('Price').AsFloat;
            dm.ZQForecast.Next;

            end;



            for xi := Low(memberDegree) to High(memberDegree) do
            BEGIN

              for xj := Low(memberDegree[xi]) to High(memberDegree[xi]) do
              Begin

                if ( (actValue[xi] >= FGroup[xj,0]) and (actValue[xi] <= FGroup[xj,1]) ) then

                    begin

                    memberDegree[xi,xj] := ((actValue[xi] - FGroup[xj,0]) / (FGroup[xj,1] - FGroup[xj,0]));

                    end;


                if ( (actValue[xi] >= FGroup[xj,1]) and (actValue[xi] <= FGroup[xj,2]) ) then


                    begin

                    memberDegree[xi,xj] := 1;

                    end;


                if ( (actValue[xi] >= FGroup[xj,2]) and (actValue[xi] <= FGroup[xj,3]) ) then

                    begin

                    memberDegree[xi,xj] := ((FGroup[xj,3] - actValue[xi]) / (FGroup[xj,3] - FGroup[xj,2]));

                    end;


                if ( (actValue[xi] < FGroup[xj,0]) or (actValue[xi] > FGroup[xj,3]) ) then

                    begin

                    memberDegree[xi,xj] := 0;

                    end;


              End;


            END;



            ////////////////// DISPLAY GRID 2 //////////////////////////////////
           /////////////////////////////////////////////////////////////////////
          //////////////////////////////////////////////////////////////////////

            StringGrid2.RowCount := Length(actValue) + 2;

            StringGrid2.ColCount := xn + 1;


              for xi := 0 to Length(actValue) do
              begin

              StringGrid2.Cells[0,xi+1] := FloatToStr(actValue[xi]);

              end;


            for xi := 1 to xn do
              for xj := 1 to xn do
              begin

              StringGrid2.Cells[xj, 0] := 'A' + IntToStr(xj);

              end;



            for xi := Low(memberDegree) to High(memberDegree) do
              for xj := Low(memberDegree[xi]) to High (memberDegree[xi]) do
              begin

              StringGrid2.Cells[xj+1, xi+1] := FloatToStr(memberDegree[xi,xj]);

              end;

          //////////////////////SET MEMBER WITH DATA////////////////////////////
          //////////////////////////////////////////////////////////////////////


          SetLength(memGroup, dm.ZQForecast.RecordCount);
          StringGrid3.RowCount := Length(actValue) + 2;

            for xi := Low(memberDegree) to High(memberDegree) do
            begin
            memValue := 0;

                for xj := Low(memberDegree[xi]) to High (memberDegree[xi]) do
                begin

                if memberDegree[xi,memValue] < memberDegree[xi,xj] then memValue := xj;

                end;

            memGroup[xi] := memValue+1;

            end;



            for xi := 0 to Length(actValue) do
            begin

            StringGrid3.FixedRows := 1;

            StringGrid3.Cells[0,0] := 'TANGGAL';
            StringGrid3.Cells[1,0] := 'DATA';
            StringGrid3.Cells[2,0] := 'GROUP';

            StringGrid3.Cells[0,xi+1] := DateTimeToStr(tanggal[xi]);
            StringGrid3.Cells[1,xi+1] := FloatToStr(actValue[xi]);
            StringGrid3.Cells[2,xi+1] := 'A' + IntToStr(memGroup[xi]);

            end;



          /////////////////////////////FLR//////////////////////////////////////
          //////////////////////////////////////////////////////////////////////

            StringGrid4.RowCount := Length(actValue) + 1;

            for xi := 0 to Length(actValue) do
            begin

            StringGrid4.Cells[0,0] := 'DATA PREV';
            StringGrid4.Cells[1,0] := 'DATA NEXT';

            StringGrid4.Cells[2,0] := 'LEFT HAND';
            StringGrid4.Cells[3,0] := 'RIGHT HAND';

            StringGrid4.Cells[0,xi+1] := DateToStr(tanggal[xi]);
            StringGrid4.Cells[1,xi+1] := DateToStr(tanggal[xi+1]);


            StringGrid4.Cells[2,xi+1] := 'A' + IntToStr(memGroup[xi]);
            StringGrid4.Cells[3,xi+1] := 'A' + IntToStr(memGroup[xi+1]);

            end;


          ////////////////////////////COBA ORDER////////////////////////////////
          //////////////////////////////////////////////////////////////////////


           {order := 3;

           SetLength(DFGroup, Length(actValue), order+1);

            for xi := Low(DFGroup) to High(DFGroup) do
            BEGIN

              for xj := Low(DFGroup[xi]) to High(DFGroup[xi]) do
              Begin


                DFGroup[xi,0] := memGroup[xi];
                DFGroup[xi,1] := memGroup[xi+1];
                DFGroup[xi,2] := memGroup[xi+2];
                DFGroup[xi,3] := memGroup[xi+3];


              End;


            END;


            StringGrid5.RowCount := Length(actValue);
            StringGrid5.ColCount := order+1;

            for xi := Low(DFGroup) to High(DFGroup) do

              for xj := Low(DFGroup[xi]) to High (DFGroup[xi]) do
              begin


               //DFGroup[xi,xj] := Round(DFGroup[xi,xj]);

               StringGrid5.Cells[0,0] := 'LEFT HAND';
               StringGrid5.Cells[1,0] := 'LEFT CORE';
               StringGrid5.Cells[2,0] := 'RIGHT CORE';
               StringGrid5.Cells[3,0] := 'RIGHT HAND';

               StringGrid5.Cells[0,1] := '#';
               StringGrid5.Cells[1,1] := 'A' + IntToStr(DFGroup[0,0]);
               StringGrid5.Cells[2,1] := 'A' + IntToStr(DFGroup[1,0]);
               StringGrid5.Cells[3,1] := 'A' + IntToStr(DFGroup[2,0]);

               StringGrid5.Cells[xj, xi+2] := 'A' + IntToStr(DFGroup[xi,xj]);


              end;}


          //////////////////////////INPUT FLR///////////////////////////////////
          //////////////////////////////////////////////////////////////////////

              for xi := 0 to Length(actValue)-1 do
              Begin


                with udm.dm.ZQFlr do
                begin

                  Append;
                  udm.dm.ZQFlr.FieldByName('kuren').Value := memGroup[xi];
                  udm.dm.ZQFlr.FieldByName('next').Value := memGroup[xi+1];
                  Post;


                end;


              End;



          /////////////////////CARI NILAI TENGAH///////////////////////////////
          /////////////////////////////////////////////////////////////////////


               SetLength(nilaitengah, xn);

               for xi := Low(FGroup) to High(FGroup) do
               begin

               nilaitengah[xi] := (((FGroup[xi, 1]) + (FGroup[xi, 2]))/2);

                  begin

                   ListBox7.Items.Add('Nilai Tengah ke ' + IntToStr(xi) + ' = ' +FloatToStr(nilaitengah[xi]));

                  end;

               end;

          //////////////////////SET NILAI DEFUZZY FLR GROUP/////////////////////
          //////////////////////////////////////////////////////////////////////


              SetLength(DFGroup, xn);
              SetLength(arrAnext, xn);


              for xi:=0 to xn-1 do
              BEGIN

                udm.dm.ZQFLRG.Close;
                udm.dm.ZQFLRG.SQL.Clear;
                udm.dm.ZQFLRG.SQL.Text := 'SELECT DISTINCT next FROM flrsaham WHERE kuren = :kuren';
                udm.dm.ZQFLRG.Params.ParamByName('kuren').Value := xi+1;
                udm.dm.ZQFLRG.Open;
                udm.dm.ZQFLRG.Active := True;

                totaldfg := 0;
                pembagidfg := 0;
                Anext := '';

                  if (not udm.dm.ZQFLRG.IsEmpty) then
                  Begin

                    while (not udm.dm.ZQFLRG.Eof) do
                    begin

                    nilainext := udm.dm.ZQFLRG.fieldbyname('next').AsInteger;
                    totaldfg := totaldfg + nilaitengah[nilainext-1];

                    Anext := Anext + ' A'+ IntToStr(nilainext) ;
                    arrAnext[xi] := Anext;

                    udm.dm.ZQFLRG.Next;
                    Inc(pembagidfg);

                    end;

                    totaldfgx := totaldfg / pembagidfg;
                    DFGroup[xi] := RoundCorrect(totaldfgx);

                  End

                  else

                  Begin

                  DFGroup[xi] := RoundCorrect(nilaitengah[xi]);

                  Anext := 'NULL';
                  arrAnext[xi] := Anext;

                  End;


              END;


             for xi:=0 to xn-1 do
             begin

             ListBox8.Items.Add('DFGroup = ' + FloatToStr(DFGroup[xi]));

             end;


          //////////////////////////DISPLAY FLRG///////////////////////////////////

             StringGrid6.RowCount := xn + 1;

             for xi:=0 to xn-1 do
             begin

              StringGrid6.Cells[0,0] := 'DATA PREV';
              StringGrid6.Cells[1,0] := 'DATA NEXT';


              StringGrid6.Cells[0,xi+1] := 'A' + IntToStr(xi+1);
              StringGrid6.Cells[1,xi+1] := arrAnext[xi];

             end;



          //////////////////////////DISPLAY HASIL FLRG///////////////////////////////////

             StringGrid7.RowCount := xn + 1;

             for xi:=0 to xn-1 do
             begin

              StringGrid7.Cells[0,0] := 'DATA PREV';
              StringGrid7.Cells[1,0] := 'DATA NEXT';

              StringGrid7.Cells[0,xi+1] := 'A' + IntToStr(xi+1);
              StringGrid7.Cells[1,xi+1] := FloatToStr(DFGroup[xi]);

             end;





          //////////////////////////////HASIL DEFUZZY///////////////////////////
          //////////////////////////////////////////////////////////////////////

            BEGIN

              Begin

                udm.dm.ZQHasil.Close;

                udm.dm.ZQHasil.SQL.Clear;

                udm.dm.ZQHasil.SQL.Add('SELECT kuren FROM flrsaham');

                udm.dm.ZQHasil.Open;

                SetLength(dataHasil, dm.ZQForecast.RecordCount-1);


                dataHasil[0]:=0;

                i := 1;

                if (not udm.dm.ZQHasil.IsEmpty) then
                  begin

                    while(not udm.dm.ZQHasil.Eof) do
                    begin

                    nilaikuren := udm.dm.ZQHasil.FieldByName('kuren').AsInteger;
                    dataHasil[i] := DFGroup[nilaikuren-1];
                    udm.dm.ZQHasil.Next;
                    inc(i);

                    end;

                  end

                else

                  begin

                  ShowMessage('Data is Empty');

                  end;

              End;

              Begin

                udm.dm.ZTHasil.Open;

                for i := 0 to Length(actValue) do

                begin

                  udm.dm.ZTHasil.Append;
                  udm.dm.ZTHasil.FieldByName('nomor').Value := i+1;
                  udm.dm.ZTHasil.FieldByName('tanggal').Value := tanggal[i];
                  udm.dm.ZTHasil.FieldByName('data').Value := actValue[i];
                  udm.dm.ZTHasil.FieldByName('hasil').Value := dataHasil[i];
                  udm.dm.ZTHasil.Post;

                end;

                udm.dm.ZTHasil.Close;

                udm.dm.ZTHasil.Open;

                udm.dm.ZTHasil.Active := True;

                DBGrid1.Refresh;

              End;


            END;

          /////////////////////////////////CHART////////////////////////////////
          //////////////////////////////////////////////////////////////////////


            BEGIN

              with Chart1 do
              Begin


                Chart1.Series[0].Clear;
                Chart1.Series[1].Clear;

                for i := 0 to Length(actValue) do
                begin

                  Chart1.Series[0].Add(actValue[i], IntToStr(i+1) ,clGreen);
                  Chart1.Series[1].Add(dataHasil[i], IntToStr(i+1) ,clRed);

                end;


                Series2.Delete(0);

              End;


            END;

          ////////////////////////////MSE DAN MAPE//////////////////////////////
          //////////////////////////////////////////////////////////////////////

            //SetLength(arrMSE, 0);

            //SetLength(arrMAPE, 0);

            SetLength(arrMSE, Length(dataHasil) );

            SetLength(arrMAPE, Length(dataHasil) );

            BEGIN

              for xi := Low(dataHasil) to High(dataHasil) do
              Begin

               MSE := Sqr(dataHasil[xi+1] - actValue[xi+1]) ;

               arrMSE[xi] := MSE;

               MAPE := ( ( (Abs(dataHasil[xi+1] - actValue[xi+1])) / actValue[xi+1] ) * 100);

               arrMAPE[xi] := MAPE;

              End;


              sumMSE := ( (Sum(arrMSE)) / (Length(actValue)));

              sumMSE := RoundCorrect(sumMSE);


              sumMAPE := ( (Sum(arrMAPE)) / (Length(actValue)));


              Edit1.Text :=  FloatToStr(sumMSE);

              Edit2.Text := FormatFloat('0.00000', sumMAPE) + ' %';


            END;


          //////////////////////////////////////////////////////////////////////

//              Begin
//
//               SetLength(Source, 0);
//
//               SetLength(Squared, 0);
//
//               SetLength(NewTarget, 0);
//
//               SetLength(NewSource, 0);
//
//               SetLength(tempSource, 0);
//
//               SetLength(actValue, 0);
//
//               SetLength(memGroup, 0);
//
//               SetLength(DFGroup, 0);
//
//               SetLength(tanggal, 0);
//
//               SetLength(nilaitengah, 0);
//
//               SetLength(dataHasil, 0);
//
//               SetLength(arrMSE, 0);
//
//               SetLength(arrMAPE, 0);
//
//               SetLength(FGroup, 0, 0);
//
//               SetLength(memberDegree, 0, 0);
//
//              End;


              homePanel.Cursor := crDefault;
              MessageDlg('FORECAST DONE SUCCESSFULLY', mtInformation, [mbOK], 0);

          End;



      End;


END;


procedure TMainFormForecast.btnResetClick(Sender: TObject);
begin

actClearExecute(btnReset);

actDefocusExecute(btnReset);

end;

procedure TMainFormForecast.btnSaveClick(Sender: TObject);
BEGIN

 if SaveDialog.Execute then
 Begin

  JvDBGridCSVExport.FileName := SaveDialog.FileName;
  JvDBGridCSVExport.ExportGrid;

  MessageDlg('FILE SAVED SUCCESSFULLY', mtInformation, [mbOK], 0);

  SaveDialog.FileName := '';

 End;



END;


procedure TMainFormForecast.catButtonClick(Sender: TObject);
begin

 if SV.Opened = True then

    begin
    homePanel.Enabled := True;
    SV.Close;
    end


end;


procedure TMainFormForecast.CBForecastCompanyChange(Sender: TObject);
begin

  with udm.dm.ZQForecast do
  begin

  Active := True;

  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM sahambeta WHERE Company = "' + CBForecastCompany.Text + '"');
  Open;

  end;


end;



procedure TMainFormForecast.actClearExecute(Sender: TObject);
var
i : integer;

BEGIN


    Begin

        with udm.dm.ZQForecast do
        begin

        Active := True;

        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM sahambeta');
        Open;

        end;

        CBForecastCompany.ItemIndex := -1;
        CBForecastCompany.Text := '--Select Company To Forecast--';

        udm.dm.ZQForecast.SortedFields := 'Price';

        udm.dm.ZQForecast.Refresh;

        udm.dm.ZQForecast.First;

        udm.dm.ZQForecast.Active := False;

    End;


    Begin

      for i := 0 to StringGrid1.ColCount - 1 do
        begin
        StringGrid1.Cols[I].Clear;
        end;

      for i := 0 to StringGrid2.ColCount - 1 do
        begin
        StringGrid2.Cols[I].Clear;
        end;

      for i := 0 to StringGrid3.ColCount - 1 do
        begin
        StringGrid3.Cols[I].Clear;
        end;

      for i := 0 to StringGrid4.ColCount - 1 do
        begin
        StringGrid4.Cols[I].Clear;
        end;

      for i := 0 to StringGrid5.ColCount - 1 do
        begin
        StringGrid5.Cols[I].Clear;
        end;

      for i := 0 to StringGrid6.ColCount - 1 do
        begin
        StringGrid6.Cols[I].Clear;
        end;

      for i := 0 to StringGrid7.ColCount - 1 do
        begin
        StringGrid7.Cols[I].Clear;
        end;


        StringGrid1.ColCount := 5;
        StringGrid2.ColCount := 4;
        StringGrid3.ColCount := 3;
        StringGrid4.ColCount := 4;
        StringGrid5.ColCount := 2;
        StringGrid6.ColCount := 2;
        StringGrid7.ColCount := 2;


        StringGrid1.RowCount := 2;
        StringGrid2.RowCount := 2;
        StringGrid3.RowCount := 1;
        StringGrid4.RowCount := 2;
        StringGrid5.RowCount := 1;
        StringGrid6.RowCount := 2;
        StringGrid7.RowCount := 2;

    End;


    with Chart1 do
    Begin

    Chart1.Series[0].Clear;
    Chart1.Series[1].Clear;

    End;

    Begin

    Edit1.Clear;
    Edit2.Clear;

    End;


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


    with udm.dm.ZTHasil do
    begin

      udm.dm.ZTHasil.Close;

      udm.dm.ZTHasil.Open;

      udm.dm.ZTHasil.Refresh;

      udm.dm.ZTHasil.Close;

      udm.dm.ZTHasil.Active := False;

    end;



     Begin

    ListBox1.Clear;
    ListBox2.Clear;
    ListBox3.Clear;
    ListBox4.Clear;
    ListBox5.Clear;
    ListBox6.Clear;
    ListBox7.Clear;
    ListBox8.Clear;

    End;

    DBGrid1.Refresh;


    btnReset.Enabled := False;
    btnSave.Enabled := False;
    btnForecast.Enabled := True;
    CBForecastCompany.Enabled := True;




END;



procedure TMainFormForecast.actCopyExecute(Sender: TObject);
var
xls, wb, Range: OLEVariant;
arrData: Variant;
RowCount, ColCount, i, j: Integer;

begin

   //create variant array where we'll copy our data//
  RowCount := StringGrid7.RowCount;
  ColCount := StringGrid7.ColCount;
  arrData := VarArrayCreate([1, RowCount, 1, ColCount], varVariant);

  //fill array//
  for i := 1 to RowCount do
    for j := 1 to ColCount do
      arrData[i, j] := StringGrid7.Cells[j-1, i-1];

  //initialize an instance of Excel//
  xls := CreateOLEObject('Excel.Application');

  //create workbook//
  wb := xls.Workbooks.Add;

  //retrieve a range where data must be placed//
  Range := wb.WorkSheets[1].Range[wb.WorkSheets[1].Cells[1, 1],
                                  wb.WorkSheets[1].Cells[RowCount, ColCount]];

  //copy data from allocated variant array//
  Range.Value := arrData;

  //show Excel with our data//
  xls.Visible := True;

end;

procedure TMainFormForecast.actDefocusExecute(Sender: TObject);
begin

MainFormForecast.DefocusControl(MainFormForecast, False);

end;


procedure TMainFormForecast.actFormDataExecute(Sender: TObject);
begin

 MainFormData.Show;

end;

procedure TMainFormForecast.actFormExitExecute(Sender: TObject);
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

  actClearExecute(MainFormForecast);

  Application.Terminate;

end;


procedure TMainFormForecast.actFormForecastExecute(Sender: TObject);
begin

MainFormForecast.Show;

end;

procedure TMainFormForecast.actFormHomeExecute(Sender: TObject);
begin

MainFormHome.Show;

end;

procedure TMainFormForecast.actKeyPressExecute(Sender: TObject; var Key : Char);
begin
Key := #0;
end;


procedure TMainFormForecast.actMenuExecute(Sender: TObject);
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


procedure TMainFormForecast.FormClose(Sender: TObject; var Action: TCloseAction);
begin

Action := caFree;

end;

procedure TMainFormForecast.FormCreate(Sender: TObject);
begin

if (SV.Opened = False) then catButton.Width := SV.CompactWidth

else if (SV.Opened = True) then catButton.Width := SV.OpenedWidth;


catButton.Width := SV.Width;

end;


procedure TMainFormForecast.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

if (Key = VK_F4) and (ssAlt in Shift) then actFormExitExecute(MainFormForecast);

end;


procedure TMainFormForecast.imgMenuClick(Sender: TObject);
begin

actMenuExecute(imgMenu);

end;



procedure TMainFormForecast.SVClick(Sender: TObject);
begin

if SV.Opened = True then

    begin
    homePanel.Enabled := True;
    SV.Close;
    end


end;

procedure TMainFormForecast.SVClosed(Sender: TObject);
begin

catButton.Width := SV.CompactWidth;

end;

procedure TMainFormForecast.SVOpened(Sender: TObject);
begin

catButton.Width := SV.OpenedWidth;

end;

procedure TMainFormForecast.SVOpening(Sender: TObject);
begin

catButton.Width := SV.OpenedWidth;

end;

end.
