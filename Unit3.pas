unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, StrUtils, ShlObj,
  Vcl.ComCtrls, Vcl.Samples.Gauges, DateUtils, Vcl.ExtDlgs,
  Vcl.Imaging.pngimage,Updater, Vcl.WinXCtrls,MMSystem, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,ShellApi;

type

 Thread1 = class(TThread)
    protected
    procedure Execute; override;
  end;

  TForm3 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Memo2: TMemo;
    Label3: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label5: TLabel;
    Shape1: TShape;
    Memo1: TMemo;
    Label6: TLabel;
    Edit1: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Edit4: TEdit;
    Label9: TLabel;
    Edit5: TEdit;
    Label10: TLabel;
    Edit6: TEdit;
    Label11: TLabel;
    Edit7: TEdit;
    Edit8: TEdit;
    Label12: TLabel;
    Gauge1: TGauge;
    Timer1: TTimer;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Shape2: TShape;
    GroupBox1: TGroupBox;
    Shape3: TShape;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label20: TLabel;
    Timer2: TTimer;
    Label21: TLabel;
    OpenDialog1: TOpenDialog;
    Button5: TButton;
    Edit9: TEdit;
    Label22: TLabel;
    Image1: TImage;
    Label23: TLabel;
    Label24: TLabel;
    CheckBox1: TCheckBox;
    Label25: TLabel;
    Edit10: TEdit;
    Edit11: TEdit;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Edit12: TEdit;
    Label30: TLabel;
    IdHTTP1: TIdHTTP;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
    procedure Memo2KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
  czas: TDateTime;
  workerThread : Thread1;
  function GetPositionOfNthOccurence(sSubStr, sStr: string; iNth: integer): integer;
  end;

var
  Form3: TForm3;
  sciezka,nazwapliku,world,interior,player,draw,stream,nazwanew:string;
  pet,pet2,przedluzenie,q:integer;

  const
  wersja: String = '1.1.6';

implementation

{$R *.dfm}


function TForm3.GetPositionOfNthOccurence(sSubStr, sStr: string; iNth: integer): integer;
var
  sTempStr: string;
  iIteration: integer;
  iTempPos: integer;
  iTempResult: integer;
begin
  result := 0;
  if ((iNth < 1) or (sSubStr = '') or (sStr = '')) then exit;
  iIteration := 0;
  iTempResult := 0;
  sTempStr := sStr;
  while (iIteration < iNth) do
  begin
    iTempPos := Pos(sSubStr, sTempStr);
    if (iTempPos = 0) then exit;
    iTempResult := iTempResult + iTempPos;
    sTempStr := Copy(sStr, iTempResult + 1, Length(sStr) - iTempResult);
    inc(iIteration);
  end;
  result := iTempResult;
end;

procedure TForm3.Image1Click(Sender: TObject);
begin
opendialog1.Execute();
if (opendialog1.FileName <> '') then
    begin
     edit9.Text:=opendialog1.FileName;
     if (edit9.Text <>'') then
      Memo1.Lines.LoadFromFile(edit9.Text)
      else
      showmessage('Pole sciezki nie mo¿e byc puste!');
    end;
end;

procedure TForm3.Memo1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ^A then
  begin
    (Sender as TMemo).SelectAll;
    Key := #0;
  end;
end;

procedure TForm3.Memo2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ^A then
  begin
    (Sender as TMemo).SelectAll;
    Key := #0;
  end;
end;

procedure TForm3.Timer1Timer(Sender: TObject);
begin
Form3.Gauge1.Progress:=pet;
end;


procedure TForm3.Timer2Timer(Sender: TObject);
begin
czas:=IncSecond(czas,1);
label20.Caption:='Czas Konwersji: '+TimetoStr(czas);
end;

function Explode(wyrazenie: String; znak: Char):String;
var
i: Integer;
begin
  for i:=0 to length(wyrazenie) do
   begin
     if (wyrazenie[i] = znak) then
     begin
         wyrazenie:= StringReplace(wyrazenie, znak, '', [rfReplaceAll]);
     end;
   end;
    Result:=wyrazenie;
end;

function CounterFix(memo: String; znak: Char):integer;
var
B,licznik: Integer;
begin
licznik:=0;
  for b:=0 to length(memo) do
  begin
   if (memo[b] = znak) then
   begin
     licznik:=licznik+1;
   end;
  end;
  Result:= Licznik;
end;

function CounterLineFix(memo1: String; znak: Char):integer;
var
licznik:integer;
begin
licznik:=0;
  if AnsiContainsText(memo1, znak) then
  begin
  licznik:=licznik+1;
  end;
  Result:=Licznik;
end;


function GetSpecialFolderPath(CSIDLFolder: Integer): string;
var
   FilePath: array [0..MAX_PATH] of char;
begin
  SHGetFolderPath(0, CSIDLFolder, 0, 0, FilePath);
  Result := FilePath;
end;

procedure Thread1.Execute;
var
testowy,kom,licznik,licztext,licztexttexty,w,r:integer;
line,komentarz,creatka,creatka2,obiekt,poprawka:string;
begin
przedluzenie:=0;
licznik:=0;
licztext:=0;
licztexttexty:=0;
Form3.Label23.Caption:='';
Form3.Label24.Caption:='';
Form3.Label28.Caption:='';
Form3.Label29.Caption:='';
Form3.Memo2.Lines.Text:= StringReplace(Form3.memo2.Lines.Text, 'SetDynamicObjectMaterialText', 'SetObjectMaterialText', [rfReplaceAll]);//zamiana tymczasowa

for pet2:=0 to form3.Memo2.Lines.Count-1 do
   begin
   if (AnsiContainsText(form3.Memo2.Lines.Strings[pet2], form3.edit11.Text+'('+form3.Edit3.Text)) then
          begin
            przedluzenie:=przedluzenie+1;
          end;
   end;

     Form3.gauge1.MinValue:=0;
     Form3.gauge1.MaxValue:=form3.Memo2.Lines.Count+przedluzenie;
     Form3.timer1.Enabled:=True;
     form3.czas:=0;

for pet:=0 to form3.Memo2.Lines.Count-1+przedluzenie do
     begin

        if (AnsiContainsText(form3.Memo2.Lines.Strings[pet], 'new')) then
        begin
        poprawka:= form3.Memo2.Lines[pet];
        Delete(poprawka,1,4);
        Delete(poprawka,length(poprawka),1);
        if (nazwanew <> poprawka) then form3.Memo2.Lines.Text:= StringReplace(form3.Memo2.Lines.Text, poprawka, nazwanew, [rfReplaceAll]);
        end;


        if (AnsiContainsText(form3.Memo2.Lines.Strings[pet], form3.edit11.Text+'('+form3.Edit3.Text)) then
        begin

          Line:= form3.Memo2.Lines.Strings[pet];
          creatka := Copy(Form3.Memo2.Lines[pet],1,Pos('(',form3.Memo2.Lines[pet]));// SetDynamicObjectMaterial(
          creatka2:= Copy(Form3.Memo2.Lines[pet],Pos(')',form3.Memo2.Lines[pet])+1,length(Line));
          Delete(Line,Pos(')',Line),length(line));
          obiekt:= Copy(Line,Pos('(',form3.Memo2.Lines[pet])+1,length(Line));
          form3.Memo2.Lines[pet]:=nazwanew+' = '+obiekt+#13#10+creatka+nazwanew+creatka2; //wyodrebnienie calego
        q:=q+CounterLineFix(Form3.Memo2.Lines[pet],#59);
        end;

        if (AnsiContainsText(form3.Memo2.Lines.Strings[pet], form3.edit3.Text)) then
        begin
            licznik:=licznik+1;
            form3.Memo2.Lines.Strings[pet]:= StringReplace(form3.Memo2.Lines.Strings[pet], ');', '', [rfReplaceAll]);
            kom:= Pos('//',form3.memo1.Lines[pet]);
            if (kom > 0) then
            komentarz:= Copy(form3.memo1.Lines[pet],kom, length(form3.memo1.Lines[pet])+1 - kom );
            Line:= form3.Memo2.Lines.Strings[pet];
            testowy := form3.GetPositionOfNthOccurence(',',line,7);
            Delete(Line,testowy,length(Line));
            if (testowy = 0) then
            begin
            Delete(Line,Pos('//',form3.memo2.Lines[pet]),length(Line));
            end;
            form3.memo2.Lines[pet]:=line+world+interior+player+draw+stream+');'+komentarz;
            kom:=0;
            komentarz:='';
            q:=q+CounterLineFix(Form3.Memo2.Lines[pet],#59);
        end else
        begin
         Line:= form3.Memo2.Lines[pet];
         form3.memo2.Lines[pet]:=line;
        end;


        if (AnsiContainsText(Form3.Memo2.Lines[pet], Form3.edit10.Text+'Text') and (form3.Edit10.Text<>'')) then
        begin
          licztexttexty:= licztexttexty+1; //liczenie i wykrywanie SetObjectMaterialText
        q:=q+CounterLineFix(Form3.Memo2.Lines[pet],#59);
        end else if (AnsiContainsText(form3.Memo2.Lines[pet], form3.edit11.Text) and (form3.edit11.text<>'')) then
        begin
         licztext:= licztext+1;  //liczenie i wykrywanieSetDynamicObjectMaterial
         q:=q+CounterLineFix(Form3.Memo2.Lines[pet],#59);
        end;



     end;

     form3.timer1.Enabled:=false;
     form3.Timer2.Enabled:=false;
     Form3.Button1.Enabled:=True;
     Form3.Button2.Enabled:=True;
     Form3.Button3.Enabled:=True;
     Form3.Button4.Enabled:=True;
     Form3.Gauge1.Progress:=form3.Memo2.Lines.Count+przedluzenie;
     Form3.Label23.Caption:='Ilosc obiektów: '+InttoStr(licznik);
     Form3.Label24.Caption:='Ilosc linii: '+InttoStr(pet);
     Form3.Label28.Caption:='Ilosc textur: '+InttoStr(licztext);
     Form3.Label29.Caption:='Ilosc textur textów: '+InttoStr(licztexttexty);

      Licznik:= Licznik+licztext+licztexttexty;
      w:=CounterFix(form3.Memo2.Lines.Text,#40);  // (
      r:=CounterFix(form3.Memo2.Lines.Text,#41);  // )
       if (w=r) then
       begin
       end else showmessage('Wykryto b³¹d kodu!, Nawiasów"(" = '+InttoStr(w)+', Nawiasów")" = '+InttoStr(r));
       if (q=licznik) then
       begin
         q:=0;
       end else
       begin
        showmessage('Wykryto b³¹d kodu!, brakuj¹ce zamkniêcie ";"');
       q:=0;
       end;
     if (Form3.CheckBox1.Checked = True) then
     begin
     Form3.Memo2.Lines.Add('//'+Form3.Label28.Caption);
     Form3.Memo2.Lines.Add('//'+form3.Label23.Caption);
     Form3.Memo2.Lines.Add('//'+Form3.Label24.Caption);
     Form3.Memo2.Lines.Add('//'+Form3.Label29.Caption);
     end;
     PlaySound('SystemStart', 0, SND_ALIAS);

       end;


procedure TForm3.Button1Click(Sender: TObject);
begin
  if (memo1.Lines.Text<>'') then
  begin
  memo1.Lines.Text:= Explode(memo1.Lines.Text,#09);
  if Pos( 'CreateObject', memo1.lines.Text ) > 0 then
   begin
      edit2.Text:='CreateObject';
   end else if Pos( 'CreateDynamicObjectEx', memo1.Lines.Text) > 0 then
   begin
      edit2.Text:='CreateDynamicObjectEx';
   end else if  Pos( 'CreateDynamicObject', memo1.Lines.Text) > 0 then
   begin
        edit2.Text:='CreateDynamicObject';
   end else
   ShowMessage( 'Nie wykryto ¿adnego Streamera!' );
      //Textury
       if Pos( 'SetObjectMaterial', memo1.Lines.Text) > 0 then
       begin
       edit10.Text:='SetObjectMaterial';
       end else if Pos( 'SetDynamicObjectMaterial', memo1.Lines.Text) > 0 then
      begin
      edit10.Text:='SetDynamicObjectMaterial';
      end else
      ShowMessage('Nie wykryto ¿adnych Textur!');
  end else showmessage('Pole do konwersji nie mo¿e byc puste!');
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
if ((edit2.Text <>'') and (edit3.Text<>'' )or(edit10.Text<>'') and (edit11.Text<>''))then
  begin
    if (edit12.Text<>'') then
    begin
      if (memo1.Lines.Text<>'')then
      begin
      memo1.Lines.Text:= Explode(memo1.Lines.Text,#09);
     label20.Caption:='Czas Konwersji: 00:00:00';
     Gauge1.ForeColor:=clScrollBar;
     timer2.Enabled:=True;
      memo2.lines.text:= StringReplace(memo1.Lines.Text, edit2.Text, edit3.text, [rfReplaceAll]);
      memo2.lines.text:= StringReplace(memo2.Lines.Text, edit10.Text, edit11.text, [rfReplaceAll]);
     Button1.Enabled:=False;
     Button2.Enabled:=False;
     Button3.Enabled:=False;
     Button4.Enabled:=False;
        world:=','+edit1.Text;
        interior:=','+edit4.Text;
        player:=','+edit5.Text;
        draw:= ','+edit6.Text;
        stream:= ','+edit7.Text;
        nazwanew:=edit12.Text;
     if (edit1.Text='') then world:='';
     if (edit4.Text='') then interior:='';
     if (edit5.Text='') then player:='';
     if (edit6.Text='') then draw:='';
     if (edit7.Text='') then stream:='';
       workerThread:= Thread1.Create(false);  //Odpalanie drugiego w¹tka

    end else ShowMessage('Pole do konwertowania nie mo¿e byæ puste!');
   end else ShowMessage('Pole new obiektu jest puste!');
  end else ShowMessage('Pole podstawowe i pole zamiany lub pole podstawowe textur i do zamiany nie mo¿e byæ puste! U¿yj Wykryj, b¹dŸ wpisz nazwe streamera!');
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
Memo1.Text:='';
Memo2.Text:='';
czas:=0;
Button4.Enabled:=false;
label20.Caption:='Czas Konwersji: 00:00:00';
Form3.Gauge1.Progress:=0;
end;

procedure TForm3.Button4Click(Sender: TObject);
begin
if (edit8.Text <>'') and (memo2.Lines.Text <> '') then
  begin
    Memo2.Lines.SaveToFile(sciezka+'\'+edit8.Text);
end else showmessage('Pole nazwy pliku i pole po konwersji nie moze byc puste!');
end;

procedure TForm3.Button5Click(Sender: TObject);
var
x:integer;
begin
  if not(Gauge1.Progress=Memo2.Lines.Count) then
  begin
  x := Application.MessageBox('Czy napewno chcesz przerwaæ konwersje?','Przerwij Konwersje', MB_YESNO);
  if (x = 6) then //tak
  begin
  TerminateThread(workerthread.Handle,0);
  timer1.Enabled:=false;
  Timer2.Enabled:=false;
  Button1.Enabled:=True;
  Button2.Enabled:=True;
  Button3.Enabled:=True;
  Gauge1.ForeColor:=ClRed;
  czas:=0;
  end;
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
var
pobrane:string;
Stream: TStream;
const
  url2 : PWideChar = 'http://bartek5132.cba.pl/download/konwerter/version.css';//wersyjka
begin
pobrane:= idhttp1.Get(URL2);
  if ((pobrane <> wersja) and (pobrane<>'')) then
  begin
  If MessageBox(Application.Handle, PChar('Znaleziono nowsz¹ wersje launchera ver.'+pobrane+', kliknij OK aby zaktualizowaæ!'),PChar('Aktualizacja'), MB_OK + MB_ICONINFORMATION) = ID_OK then
  begin
    If not FileExists('updater.exe') then  //pobieranie autoupdatera!
      begin
      Stream := TFileStream.Create('updater.exe', fmCreate);
        try
          IdHTTP1.Get('http://bartek5132.cba.pl/download/konwerter/updater.exe',Stream);
          Stream.Free;
          ShellExecute(Handle, 'open','updater.exe', nil, nil, SW_SHOWNORMAL);//jesli sie udalo wlaczanie
        except
          Stream.Free;
          DeleteFile('updater.exe');
        end;
      end else ShellExecute(Handle, 'open','updater.exe', nil, nil, SW_SHOWNORMAL);
    end;
  end;

Button4.Enabled:=false;
Memo1.Text:='';
Memo2.Text:='';
edit3.Text:='CreateDynamicObject';
edit11.Text:='SetDynamicObjectMaterial';
//Sekcja wypelnienia
edit1.Text:='-1';           //world id
edit4.Text:='-1';           //interior id
edit5.Text:='-1';           //player id
edit6.Text:='300.00';       //draw distance
edit7.Text:='300.00';       //stream distance
edit8.Text:='konwersja.txt'; //Nazwa pliku
sciezka:= GetSpecialFolderPath(CSIDL_DESKTOP);
edit9.Text:=sciezka;
//if (Updater.PobierzPlikiRozpakuj('http://bartek5132.cba.pl/download/Konwerter.zip','C:\Users\barte\Desktop\Konwerterek.zip')) then
//begin
//end;

end;
end. //482 - 09.03.2019
