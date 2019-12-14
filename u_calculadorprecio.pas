unit u_CalculadorPrecio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  Buttons, IniFiles;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    btnCalcular: TButton;
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
    procedure FormCreate(Sender: TObject);
    procedure itmSalirClick(Sender: TObject);
    procedure txtCostoKeyPress(Sender: TObject; var Key: char);

  private

  public

  end;

var
  frmPrincipal: TfrmPrincipal;
  Importe: Currency;
  IVA: Integer;
  Costo: Currency;
  Ganancia: Double;
  GananciaNeta: Currency;
  Dolar: Currency;
  ini : TINIFile;

implementation

{$R *.lfm}

{ TfrmPrincipal }


procedure TfrmPrincipal.btnCalcularClick(Sender: TObject);
begin
     ThousandSeparator := '.';
     DecimalSeparator:= ',';
     IVA := StrToInt(txtIVA.Caption);
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

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  lblPrecioVenta.Caption:= '';

try
ini := TINIFile.Create('config.ini');
txtIVA.Caption := ini.ReadString ('Configuracion', 'IVA', '');
txtDolar.Caption := ini.ReadString ('Configuracion', 'Dolar', '');
txtGanancia.Caption := ini.ReadString ('Configuracion', 'Ganancia', '');
ini.free;
except
showmessage('Error al conectar la base de datos');
end;
end;

procedure TfrmPrincipal.itmSalirClick(Sender: TObject);
begin
   Close;
end;

procedure TfrmPrincipal.txtCostoKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
  begin
    btnCalcular.Click;
    Key := #0;
  end;
end;

end.

