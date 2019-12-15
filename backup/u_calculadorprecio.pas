unit u_CalculadorPrecio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  Buttons, IniFiles, winpeimagereader, fileinfo, u_frmAcercaDe;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    btnCalcular: TButton;
    MenuItem3: TMenuItem;
    itmAcercaDe: TMenuItem;
    txtIVA: TEdit;
    txtCosto: TEdit;
    txtDolar: TEdit;
    txtGanancia: TEdit;
    txtGananciaNeta: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    lblPrecioVenta: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    itmSalir: TMenuItem;
    N1: TMenuItem;
    PopupMenu1: TPopupMenu;
    procedure btnCalcularClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure itmSalirClick(Sender: TObject);
    procedure itmAcercaDeClick(Sender: TObject);
    procedure txtCostoKeyPress(Sender: TObject; var Key: char);

  private

  public

  end;

var
  frmPrincipal: TfrmPrincipal;
  Importe: Currency;
  IVA: Double;
  Costo: Currency;
  Ganancia: Double;
  GananciaNeta: Currency;
  Dolar: Currency;
  ini : TINIFile;
  FileVerInfo: TFileVersionInfo;
  o_frmAcercaDe : TfrmAcercaDe;

implementation

{$R *.lfm}

{ TfrmPrincipal }


procedure TfrmPrincipal.btnCalcularClick(Sender: TObject);
begin
     ThousandSeparator := '.';
     DecimalSeparator:= ',';
     IVA := StrToFloat(txtIVA.Caption);
     Dolar := StrToCurr(txtDolar.Caption);
     Costo := StrToCurr(txtCosto.Caption);
     Ganancia := StrToCurr(txtGanancia.Caption);
     Importe := (Costo * Dolar)*((IVA/100)+1);
     GananciaNeta := Importe;
     Importe := Importe * ((Ganancia/100) + 1);
     GananciaNeta := Importe - GananciaNeta;
     lblPrecioVenta.Caption:= CurrToStrF(Importe, ffCurrency, 2);
     txtGananciaNeta.Caption := CurrToStrF(GananciaNeta, ffCurrency, 2);
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
     ini := TINIFile.Create('config.ini');
     ini.WriteString ('Configuracion', 'IVA', txtIVA.Text);
     ini.WriteString ('Configuracion', 'Dolar', txtDolar.Text);
     ini.WriteString ('Configuracion', 'Ganancia', txtGanancia.Text);
     ini.Free;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  lblPrecioVenta.Caption:= '';
  FileVerInfo := TFileVersionInfo.Create(nil);
  try
    //FileVerInfo.ReadFileInfo;
    //frmPrincipal.Caption := frmPrincipal.Caption + FileVerInfo.VersionStrings.Values['FileVersion'];
    //writeln('File version: ',FileVerInfo.VersionStrings.Values['FileVersion']);
    ini := TINIFile.Create('config.ini');
    txtIVA.Caption := ini.ReadString ('Configuracion', 'IVA', '');
    txtDolar.Caption := ini.ReadString ('Configuracion', 'Dolar', '');
    txtGanancia.Caption := ini.ReadString ('Configuracion', 'Ganancia', '');
    ini.free;
  except
    on E: Exception do
    showmessage('Error:' + E.ClassName + #13#10 + E.Message);
  end;
end;

procedure TfrmPrincipal.itmSalirClick(Sender: TObject);
begin
   Close;
end;

procedure TfrmPrincipal.itmAcercaDeClick(Sender: TObject);
begin
   o_frmAcercaDe := TfrmAcercaDe.Create(nil);
   o_frmAcercaDe.ShowModal;
end;

procedure TfrmPrincipal.txtCostoKeyPress(Sender: TObject; var Key: char);
begin
  if (Key = DecimalSeparator) and
          (Pos(Key, txtCosto.Text) > 0) then begin
    //ShowMessage('Invalid key: ' + Key);
    Key := ThousandSeparator;
  end
  else
  if not (Key in [#8, '0'..'9', DecimalSeparator]) then begin
   // ShowMessage('Invalid key: ' + Key);
    Key := #0;
  end
  else if (Key = DecimalSeparator) and
          (Pos(Key, txtCosto.Text) > 0) then begin
    //ShowMessage('Invalid Key: twice ' + Key);
    Key := #0;
  end;
  if Key = #13 then
  begin
    btnCalcular.Click;
    Key := #0;
  end;
end;

{procedure Validacion(): bo   ;
'begin

'end;}

end.

