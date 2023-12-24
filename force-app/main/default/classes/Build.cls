/**
 * @description       : Clase Root que implementa un patron builder para los distintos objetos/tablas de salesforce
 * @author            : Victor M. Degano
 * @group             : Globant
 * @affected jiras    : SIN-142, INT-267, EV-2041
 * @last modified on  : 26-09-2023
 * @last modified by  : Victor M. Degano
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   26-06-2023   Victor M. Degano   Initial Version
**/
@IsTest
public with sharing class Build {
    //---------------------------------------------------------------------------------------------------------------------------
    // Encuestado
    //---------------------------------------------------------------------------------------------------------------------------

    public class EncuestadoBuilder {
        private Encuestado__c encuestado;

        public EncuestadoBuilder() {
            this.encuestado = new Encuestado__c();
        }

        public EncuestadoBuilder withCuenta(Account acc) {
            this.encuestado.Cuenta__c = acc.id;
            return this;
        }

        public EncuestadoBuilder withEstado(String status) {
            this.encuestado.estado__c = status;
            return this;
        }

        public EncuestadoBuilder withIdClienteBhseg(String cedulaRif) {
            this.encuestado.Id_Cliente_BHSeg__c = cedulaRif;
            return this;
        }

        public EncuestadoBuilder withIdEncuesta(String idEncuesta) {
            this.encuestado.Id_Encuesta__c = idEncuesta;
            return this;
        }

        public EncuestadoBuilder withNombreCliente(String nombreCliente) {
            this.encuestado.Nombre_de_Cliente__c = nombreCliente;
            return this;
        }

        public EncuestadoBuilder withApellidoCliente(String apellidoCliente) {
            this.encuestado.Apellido_de_Cliente__c = apellidoCliente;
            return this;
        }

        public EncuestadoBuilder withEmailCliente(String emailCliente) {
            this.encuestado.Email_de_Cliente__c = emailCliente;
            return this;
        }

        public EncuestadoBuilder withIdEncuestaTemplate(String idTemplate) {
            this.encuestado.Id_Encuesta_Template__c = idTemplate;
            return this;
        }

        public Encuestado__c build() {
            return this.encuestado;
        }
    }

    public static EncuestadoBuilder aEncuestado() {
        return new EncuestadoBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Lead
    //---------------------------------------------------------------------------------------------------------------------------
    public class LeadBuilder {
        public Lead record = new Lead();

        public LeadBuilder withFirstName(String value) {
            this.record.FirstName = value;
            return this;
        }
        public LeadBuilder withPhoneTwo(String value) {
            this.record.Telefono_2__c = value;
            return this;
        }

        public LeadBuilder withLastName(String value) {
            this.record.LastName = value;
            return this;
        }

        public LeadBuilder withStatus(String value) {
            this.record.Status = value;
            return this;
        }

        public LeadBuilder withPhone(String value) {
            this.record.Phone = value;
            return this;
        }

        public LeadBuilder withEmail(String value) {
            this.record.Email = value;
            return this;
        }

        public LeadBuilder withDNI(String value) {
            this.record.DNI__c = value;
            return this;
        }

        public LeadBuilder withAreaCode(String value) {
            this.record.Codigo_de_area__c = value;
            return this;
        }

        public LeadBuilder withMobilePhone(String value) {
            this.record.mobilePhone = value;
            return this;
        }

        public LeadBuilder withGender(String value) {
            this.record.Sexo__c = value;
            return this;
        }

        public LeadBuilder withBorningCountry(String value) {
            this.record.Pais_Nacimiento__c = value;
            return this;
        }

        public LeadBuilder withDepartment(String value) {
            this.record.DPTO_DOMICILIO__c = value;
            return this;
        }

        public LeadBuilder withBirthDate(Date value) {
            this.record.FECHA_NACIMIENTO__c = value;
            return this;
        }

        public LeadBuilder withLeadSource(String value) {
            this.record.LeadSource = value;
            return this;
        }

        public LeadBuilder withPasarAVenta(Boolean value) {
            this.record.PASAR_A_VENTA__c = value;
            return this;
        }

        public LeadBuilder withConvertidoAVenta(Boolean value) {
            this.record.Convertido_a_Venta__c = value;
            return this;
        }

        public LeadBuilder withIntentosDeConversionFallidos(Integer value) {
            this.record.Intentos_de_Conversion_Fallidos__c = value;
            return this;
        }
        public LeadBuilder withIntentosDeConversion(Integer value) {
            this.record.Intentos_de_Conversion__c = value;
            return this;
        }

        public LeadBuilder withCodigoPlan(String code) {
            this.record.Cod_Plan__c = code;
            return this;
        }

        public LeadBuilder withCodigoRamo(Integer code) {
            this.record.Cod_Ramo__c = code;
            return this;
        }

        public LeadBuilder withCodigoProducto(Integer code) {
            this.record.Cod_Producto__c = code;
            return this;
        }

        public LeadBuilder withCombinatoria(String value) {
            this.record.Combinatoria__c = value;
            return this;
        }

        public LeadBuilder withAddons(String value) {
            this.record.AddOns__c = value;
            return this;
        }

        public LeadBuilder withOffer(String value) {
            this.record.Oferta__c = value;
            return this;
        }

        public LeadBuilder withAmbientes(Integer value) {
            this.record.Ambiente__c = value;
            return this;
        }

        public LeadBuilder withPremio(Integer value) {
            this.record.premio__c = value;
            return this;
        }

        public LeadBuilder withTipoDeDocumento(String value) {
            this.record.Tipo_de_Documento__c = value;
            return this;
        }

        public LeadBuilder withNacionalidad(String value) {
            this.record.Nacionalidad__c = value;
            return this;
        }

        public LeadBuilder withEstadoCivil(String value) {
            this.record.estado_civil__c = value;
            return this;
        }

        public LeadBuilder withDomicilioProvincia(String value) {
            this.record.Domicilio_Provincia__c = value;
            return this;
        }

        public LeadBuilder withDomicilioLocalidad(String value) {
            this.record.Domicilio_Localidad__c = value;
            return this;
        }

        public LeadBuilder withNumeroDomicilio(Integer value) {
            this.record.NUMERO_DOMICILIO__c = value;
            return this;
        }

        public LeadBuilder withPisoDomicilio(String value) {
            this.record.Piso_Domicilio__c = value;
            return this;
        }

        public LeadBuilder withTipoVivienda(String value) {
            this.record.tipo_vivienda__c = value;
            return this;
        }

        public LeadBuilder withNumeroLote(String value) {
            this.record.numero_lote__c = value;
            return this;
        }

        public LeadBuilder withPostalCode(String value) {
            this.record.PostalCode = value;
            return this;
        }

        public LeadBuilder withStreet(String value) {
            this.record.Street = value;
            return this;
        }

        public LeadBuilder withTCTitularApellido(String value) {
            this.record.TC_Titular_Apellido__c = value;
            return this;
        }

        public LeadBuilder withTCTitularNombre(String value) {
            this.record.TC_Titular_Nombre__c = value;
            return this;
        }

        public LeadBuilder withTCVencimiento(String value) {
            this.record.TC_Vencimiento__c = value;
            return this;
        }

        public LeadBuilder withPagoResultado(String value) {
            this.record.Pago_Resultado__c = value;
            return this;
        }

        public LeadBuilder withOrigenDePago(String value) {
            this.record.Origen_de_Pago__c = value;
            return this;
        }

        public LeadBuilder withMedioDePago(String value) {
            this.record.Medio_de_Pago__c = value;
            return this;
        }

        public LeadBuilder withPago(String value) {
            this.record.Pago__c = value;
            return this;
        }

        /** (2021-01-25 13:23:28) Valores disponibles:  'HOT', 'COLD', 'CONVERTIDO', 'DUPLICADO', 'COLD_ERROR', 'COLD_CONVERTIDO', 'HOT_A', 'HOT_B', 'HOT_TEST', 'RE_MARKETING', 'NO_REMARKETING' */
        public LeadBuilder withEstadoRemarketing(String value) {
            this.record.Estado_Remarketing__c = value;
            return this;
        }

        /** (2021-01-25 13:23:28) Valores disponibles:  '2', '3', '4', '5', 'VENTA' */
        public LeadBuilder withPasodeVenta(String value) {
            this.record.Paso_de_Venta__c = value;
            return this;
        }

        public LeadBuilder withSponsor(String value) {
            this.record.Sponsor__c = value;
            return this;
        }

        public LeadBuilder withGenesysAPI(String value) {
            this.record.Genesys_API__c = value;
            return this;
        }

        public LeadBuilder withControlRemarketing(Boolean value) {
            this.record.Control_Remarketing__c = value;
            return this;
        }

        public LeadBuilder withUtmCampaign(String value) {
            this.record.utm_Campaign__c = value;
            return this;
        }

        public LeadBuilder withUtmMedium(String value) {
            this.record.utm_Medium__c = value;
            return this;
        }

        public LeadBuilder withUtmSource(String value) {
            this.record.utm_Source__c = value;
            return this;
        }

        public LeadBuilder withUtmContent(String value) {
            this.record.utm_Content__c = value;
            return this;
        }

        public LeadBuilder withCUIL(String value) {
            this.record.CUIL__c = value;
            return this;
        }

        public LeadBuilder withMKTCloudSync(Boolean value) {
            this.record.mkt_cloud_sync__c = value;
            return this;
        }

        public LeadBuilder withOferta(String value) {
            this.record.oferta__c = value;
            return this;
        }

        public LeadBuilder withCupon(String value) {
            this.record.Cupon__c = value;
            return this;
        }

        public LeadBuilder withObservacion(String value) {
            this.record.Observacion__c = value;
            return this;
        }

        public Lead build() {
            return record;
        }
    }

    public static LeadBuilder aLead() {
        return new LeadBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Rest Request
    //---------------------------------------------------------------------------------------------------------------------------
    public class RestRequestBuilder {
        public RestRequest record = new RestRequest();

        public RestRequestBuilder withRequestURI(String value) {
            this.record.requestURI = value;
            return this;
        }

        public RestRequestBuilder withRequestBody(Blob value) {
            this.record.requestBody = value;
            return this;
        }

        public RestRequestBuilder withHttpMethod(String value) {
            this.record.httpMethod = value;
            return this;
        }

        public RestRequest build() {
            return record;
        }
    }

    public static RestRequestBuilder aRestRequest() {
        return new RestRequestBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // CMDP Prestamo
    //---------------------------------------------------------------------------------------------------------------------------
    public class CMDPPrestamoBuilder {
        public CMDP_Prestamo__c record = new CMDP_Prestamo__c();

        public CMDP_Prestamo__c build() {
            return record;
        }
    }

    public static CMDPPrestamoBuilder aCMDP() {
        return new CMDPPrestamoBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Bonificacion Lider
    //---------------------------------------------------------------------------------------------------------------------------

    public class BonificacionLiderBuilder {
        public Bonificacion_Lider__c bonificacion = new Bonificacion_Lider__c();

        public BonificacionLiderBuilder withDescription(String value) {
            this.bonificacion.descripcion__c = value;
            return this;
        }

        public BonificacionLiderBuilder withPlan(String value) {
            this.bonificacion.plan__c = value;
            return this;
        }

        public BonificacionLiderBuilder withProducto(String value) {
            this.bonificacion.producto__c = value;
            return this;
        }

        public BonificacionLiderBuilder withRamo(String value) {
            this.bonificacion.ramo__c = value;
            return this;
        }

        public BonificacionLiderBuilder withRPP(String ramo, String producto, String plan) {
            this.bonificacion.ramo__c = ramo;
            this.bonificacion.producto__c = producto;
            this.bonificacion.plan__c = plan;
            return this;
        }

        public BonificacionLiderBuilder withPorcentajeCuotas(String value) {
            this.bonificacion.porcentaje_cuota__c = value;
            return this;
        }

        public BonificacionLiderBuilder withCantidadCuotas(String value) {
            this.bonificacion.cantidad_cuotas__c = value;
            return this;
        }

        public BonificacionLiderBuilder active(boolean value) {
            this.bonificacion.estado__c = value;
            return this;
        }

        public BonificacionLiderBuilder withUntilDate(Date value) {
            this.bonificacion.hasta__c = value;
            return this;
        }

        public Bonificacion_Lider__c build() {
            if (String.isBlank(this.bonificacion.descripcion__c)) {
                this.bonificacion.descripcion__c = 'Bonificacion Insertada VISA';
            }

            String medioPago = '';
            if (this.bonificacion.descripcion__c.contains('VISA')) {
                medioPago = 'VISA';
            } else if (this.bonificacion.descripcion__c.contains('NARANJA')) {
                medioPago = 'NARANJA';
            } else if (this.bonificacion.descripcion__c.contains('MASTERCARD')) {
                medioPago = 'MASTERCARD';
            } else {
                medioPago = 'SE';
            }
            /* Comentado por el pasaje del jira 1205 V2
			  if (String.isBlank(this.bonificacion.Importe_fijo__c)) {
			  this.bonificacion.Importe_fijo__c = '200';
			  }*/

            this.bonificacion.name =
                this.bonificacion.ramo__c +
                '-' +
                this.bonificacion.producto__c +
                '-' +
                this.bonificacion.plan__c +
                '-' +
                medioPago;
            return bonificacion;
        }
    }

    public static BonificacionLiderBuilder aLeaderBonification() {
        return new BonificacionLiderBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // BeanGestion
    //---------------------------------------------------------------------------------------------------------------------------

    public class BeanGestionBuilder {
        public BeanGestion gestion = new BeanGestion();
        public Integer i;

        public BeanGestionBuilder withValues(Integer value) {
            this.i = value;
            return this;
        }

        public BeanGestionBuilder withId(String value) {
            this.gestion.id = value;
            return this;
        }

        public BeanGestionBuilder withCode(String value) {
            this.gestion.codigoGestion = value;
            return this;
        }

        public BeanGestion build() {
            if (i == null) {
                i = 0;
            }

            gestion.cliente = String.valueOf(i);
            gestion.certificado = String.valueOf(i);
            gestion.codigoCanal1 = String.valueOf(i);
            gestion.codigoCanal2 = String.valueOf(i);
            gestion.codigoCanal4 = String.valueOf(i);
            gestion.resultado = String.valueOf(i);
            gestion.estado = String.valueOf(i);
            gestion.tipoTramite = String.valueOf(i);
            gestion.fechaActualizacion = String.valueOf(i);
            gestion.codigoUsuario = String.valueOf(i);

            gestion.numeroLote = String.valueOf(i);
            gestion.numeroSecuencia = String.valueOf(i);
            gestion.errores = String.valueOf(i);
            gestion.producto = String.valueOf(i);
            gestion.codigoRes = String.valueOf(i);
            gestion.reintegro = String.valueOf(i);
            gestion.cantidadBeneficiarios = String.valueOf(i);
            gestion.apellido = String.valueOf(i);
            gestion.nombre = String.valueOf(i);
            gestion.tipoDoc = String.valueOf(i);

            gestion.numDoc = String.valueOf(i);
            gestion.fechaNacimiento = String.valueOf(i);
            gestion.sexo = String.valueOf(i);
            gestion.estadoCivil = String.valueOf(i);
            gestion.codProfesion = String.valueOf(i);
            gestion.paisNacimiento = String.valueOf(i);
            gestion.actividad = String.valueOf(i);
            gestion.drCalle = String.valueOf(i);
            gestion.drNumero = String.valueOf(i);
            gestion.drDto = String.valueOf(i);
            gestion.drPiso = String.valueOf(i);
            gestion.drProv = String.valueOf(i);
            gestion.drLocalidad = String.valueOf(i);

            gestion.drCcp = String.valueOf(i);
            gestion.tepais = String.valueOf(i);
            gestion.teArea = String.valueOf(i);
            gestion.teRef = String.valueOf(i);
            gestion.tecarac = String.valueOf(i);
            gestion.num = String.valueOf(i);
            gestion.celPais = String.valueOf(i);
            gestion.celArea = String.valueOf(i);
            gestion.celRef = String.valueOf(i);
            gestion.celCarac = String.valueOf(i);

            gestion.celNum = String.valueOf(i);
            gestion.mail = String.valueOf(i);
            gestion.plan = String.valueOf(i);
            gestion.canal1 = String.valueOf(i);
            gestion.canal2 = String.valueOf(i);
            gestion.canal4 = String.valueOf(i);
            gestion.deNumero = String.valueOf(i);
            gestion.deProv = String.valueOf(i);
            gestion.deLocalidad = String.valueOf(i);
            gestion.deCp = String.valueOf(i);

            gestion.dbNumero = String.valueOf(i);
            gestion.dbProv = String.valueOf(i);
            gestion.dbLocalidad = String.valueOf(i);
            gestion.dbCp = String.valueOf(i);
            gestion.benNumDoc1 = String.valueOf(i);
            gestion.benSexo1 = String.valueOf(i);
            gestion.benIdRel1 = String.valueOf(i);
            gestion.benParticipacion1 = String.valueOf(i);
            gestion.benNumDoc2 = String.valueOf(i);
            gestion.benSexo2 = String.valueOf(i);

            gestion.benRel2 = String.valueOf(i);
            gestion.benParticipacion2 = String.valueOf(i);
            gestion.benNumDoc3 = String.valueOf(i);
            gestion.benSexo3 = String.valueOf(i);
            gestion.benIdRel3 = String.valueOf(i);
            gestion.benParticipacion3 = String.valueOf(i);
            gestion.benNumDoc4 = String.valueOf(i);
            gestion.benSexo4 = String.valueOf(i);
            gestion.benIdRel4 = String.valueOf(i);
            gestion.benParticipacion4 = String.valueOf(i);

            gestion.codMailPrincipal = String.valueOf(i);
            gestion.codMailAlternatico = String.valueOf(i);
            gestion.combinatoria = String.valueOf(i);
            gestion.sumaAseg01 = String.valueOf(i);
            gestion.sumaAseg02 = String.valueOf(i);
            gestion.sumaAseg03 = String.valueOf(i);
            gestion.sumaAseg04 = String.valueOf(i);
            gestion.sumaAseg05 = String.valueOf(i);
            gestion.sumaAseg06 = String.valueOf(i);
            gestion.sumaAseg07 = String.valueOf(i);

            gestion.sumaAseg08 = String.valueOf(i);
            gestion.sumaAseg09 = String.valueOf(i);
            gestion.sumaAseg10 = String.valueOf(i);
            gestion.sumaAseg11 = String.valueOf(i);
            gestion.sumaAseg12 = String.valueOf(i);
            gestion.sumaAseg13 = String.valueOf(i);
            gestion.sumaAseg14 = String.valueOf(i);
            gestion.sumaAseg15 = String.valueOf(i);
            gestion.tipoVivienda = String.valueOf(i);
            gestion.viviendaPermanente = String.valueOf(i);

            gestion.paredesMaterial = String.valueOf(i);
            gestion.metrosCuadrados = String.valueOf(i);
            gestion.cantidadObjetos = String.valueOf(i);
            gestion.promocion = String.valueOf(i);

            return gestion;
        }
    }

    public static BeanGestionBuilder aBeanGestion() {
        return new BeanGestionBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Motivos no venta
    //---------------------------------------------------------------------------------------------------------------------------

    public class MotivosNoVentaBuilder {
        private Motivos_No_Venta__c motivo = new Motivos_No_Venta__c();
        private Integer i;
        private Boolean buildMockData = true;

        public MotivosNoVentaBuilder withValues(Integer value) {
            this.i = value;
            this.motivo.name = String.valueOf(value);
            return this;
        }

        public MotivosnoVentaBuilder withName(String value) {
            this.motivo.Name = value;
            this.i = Integer.valueOf(value);
            return this;
        }

        public MotivosNoVentaBuilder withCodigo(String codigo) {
            this.motivo.codigo__c = codigo;
            return this;
        }

        public MotivosNoVentaBuilder withDescripcion(String descripcion) {
            this.motivo.Descripcion__c = descripcion;
            return this;
        }

        public MotivosnoVentaBuilder withActivo(Boolean value) {
            this.motivo.Activo__c = value;
            return this;
        }

        public MotivosnoVentaBuilder withCanales(String value) {
            this.motivo.Canales__c = value;
            return this;
        }

        public MotivosnoVentaBuilder withHit(String value) {
            this.motivo.Hit__c = value;
            return this;
        }

        public MotivosnoVentaBuilder withGrupo(String value) {
            this.motivo.Grupo__c = value;
            return this;
        }

        public MotivosnoVentaBuilder withTipificacionporDias(Boolean value) {
            this.motivo.Tipificacion_por_Dias__c = value;
            return this;
        }

        public MotivosNoVentaBuilder buildWithOutMockData() {
            this.buildMockData = false;
            return this;
        }

        public Motivos_No_Venta__c build() {
            if (this.buildMockData) {
                if (this.i == null) {
                    this.i = 0;
                }

                this.motivo.codigo__c = String.valueOf(this.i);
                this.motivo.descripcion__c = String.valueOf(this.i);
            }

            return this.motivo;
        }
    }

    public static MotivosNoVentaBuilder aMotivoNoVenta() {
        return new MotivosNoVentaBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Opciones como nos conocio
    //---------------------------------------------------------------------------------------------------------------------------

    public class OpcionesComoNosConocioBuilder {
        private Opciones_Como_Nos_Conocio__c opcion = new Opciones_Como_Nos_Conocio__c();
        private Integer i;
        private Boolean buildMockData = true;

        public OpcionesComoNosConocioBuilder withValues(Integer value) {
            this.i = value;
            this.opcion.name = String.valueOf(value);
            return this;
        }

        public OpcionesComoNosConocioBuilder withCodigo(String codigo) {
            this.opcion.codigo__c = codigo;
            return this;
        }

        public OpcionesComoNosConocioBuilder withDescripcion(String descripcion) {
            this.opcion.Descripcion__c = descripcion;
            return this;
        }

        public OpcionesComoNosConocioBuilder buildWithOutMockData() {
            this.buildMockData = false;
            return this;
        }

        public Opciones_Como_Nos_Conocio__c build() {
            if (this.buildMockData) {
                if (i == null) {
                    i = 0;
                }

                this.opcion.codigo__c = String.valueOf(this.i);
                this.opcion.descripcion__c = String.valueOf(this.i);
            }

            return this.opcion;
        }
    }

    public static OpcionesComoNosConocioBuilder aOpcionComoNosConocio() {
        return new OpcionesComoNosConocioBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Combinacion Modulo Servicios
    //---------------------------------------------------------------------------------------------------------------------------

    public class CombinacionModuloServiciosBuilder {
        public Combinacion_Modulo_Servicios__c combinacion = new Combinacion_Modulo_Servicios__c();
        public Integer i;

        public CombinacionModuloServiciosBuilder withValues(Integer value) {
            this.i = value;
            this.combinacion.name = String.valueOf(value);
            return this;
        }

        public Combinacion_Modulo_Servicios__c build() {
            if (i == null) {
                i = 0;
            }

            combinacion.codigo__c = String.valueOf(i);
            combinacion.descripcion__c = String.valueOf(i);

            return combinacion;
        }
    }

    public static CombinacionModuloServiciosBuilder aCombinacionModuloServicios() {
        return new CombinacionModuloServiciosBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Dimensiones Viviendas
    //---------------------------------------------------------------------------------------------------------------------------

    public class DimensionesViviendaBuilder {
        public Dimensiones_Vivienda__c dimension = new Dimensiones_Vivienda__c();
        public Integer i;
        private boolean buildMockData = true;

        public DimensionesViviendaBuilder withValues(Integer value) {
            this.i = value;
            this.dimension.name = String.valueOf(value);
            return this;
        }

        public DimensionesViviendaBuilder withCodigo(String value) {
            this.dimension.codigo__c = value;
            return this;
        }

        public DimensionesViviendaBuilder withDescripcion(String value) {
            this.dimension.Descripcion__c = value;
            return this;
        }

        public DimensionesViviendaBuilder buildWithOutMockData() {
            this.buildMockData = false;
            return this;
        }

        public Dimensiones_Vivienda__c build() {
            if (this.buildMockData) {
                if (i == null) {
                    i = 0;
                }

                dimension.codigo__c = String.valueOf(i);
                dimension.descripcion__c = String.valueOf(i);
            }
            return dimension;
        }
    }

    public static DimensionesViviendaBuilder aDimensionesVivienda() {
        return new DimensionesViviendaBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Cantidades Bienes Posee
    //---------------------------------------------------------------------------------------------------------------------------

    public class CantidadesBienesPoseeBuilder {
        public Cantidades_Bienes_Posee__c cantidad = new Cantidades_Bienes_Posee__c();
        public Integer i;
        private Boolean buildMockData = true;

        public CantidadesBienesPoseeBuilder withValues(Integer value) {
            this.i = value;
            this.cantidad.name = String.valueOf(value);
            return this;
        }

        public CantidadesBienesPoseeBuilder withCodigo(String value) {
            this.cantidad.codigo__c = value;
            return this;
        }

        public CantidadesBienesPoseeBuilder withDescripcion(String value) {
            this.cantidad.Descripcion__c = value;
            return this;
        }

        public CantidadesBienesPoseeBuilder buildWithOutMockData() {
            this.buildMockData = false;
            return this;
        }

        public Cantidades_Bienes_Posee__c build() {
            if (this.buildMockData) {
                if (i == null) {
                    i = 0;
                }

                cantidad.codigo__c = String.valueOf(i);
                cantidad.descripcion__c = String.valueOf(i);
            }
            return cantidad;
        }
    }

    public static CantidadesBienesPoseeBuilder aCantidadesBienesPosee() {
        return new CantidadesBienesPoseeBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Sumas COberturas
    //---------------------------------------------------------------------------------------------------------------------------

    public class SumasCoberturasBuilder {
        private Suma_Cobertura__c suma = new Suma_Cobertura__c();
        private Integer i;
        private Boolean buildMockData = true;

        public SumasCoberturasBuilder withValues(Integer value) {
            this.i = value;
            this.suma.name = String.valueOf(value);
            return this;
        }

        public SumasCoberturasBuilder withModulo(String modulo) {
            this.suma.modulo__c = modulo;
            return this;
        }

        public SumasCoberturasBuilder withSegmento(String segmento) {
            this.suma.segmento__c = segmento;
            return this;
        }

        public SumasCoberturasBuilder withSuma(String suma) {
            this.suma.suma__c = suma;
            return this;
        }

        public SumasCoberturasBuilder withCobertura(String cobertura) {
            this.suma.cobertura__c = cobertura;
            return this;
        }

        public SumasCoberturasBuilder withRamo(String ramo) {
            this.suma.ramo__c = ramo;
            return this;
        }

        public SumasCoberturasBuilder withPlan(String plan) {
            this.suma.plan__c = plan;
            return this;
        }

        public SumasCoberturasBuilder withProducto(String prod) {
            this.suma.producto__c = prod;
            return this;
        }

        public SumasCoberturasBuilder buildWithOutMockData() {
            this.buildMockData = false;
            return this;
        }

        public Suma_Cobertura__c build() {
            if (this.buildMockData) {
                if (this.i == null) {
                    this.i = 0;
                }

                this.suma.ramo__c = String.valueOf(this.i);
                this.suma.producto__c = String.valueOf(this.i);
                this.suma.plan__c = String.valueOf(this.i);
                this.suma.fecha_actualizacion__c = System.today().format();
                this.suma.modulo__c = String.valueOf(this.i);
                this.suma.usuario__c = String.valueOf(this.i);
            }

            return this.suma;
        }
    }

    public static SumasCoberturasBuilder aSumaCobertura() {
        return new SumasCoberturasBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Cotizaciones
    //---------------------------------------------------------------------------------------------------------------------------

    public class CotizacionBuilder {
        private Cotizacion__c cotizacion = new Cotizacion__c();
        private Integer i;
        private Boolean buildMockData = true;

        public CotizacionBuilder withValues(Integer value) {
            this.i = value;
            this.cotizacion.name = String.valueOf(value);
            return this;
        }

        public CotizacionBuilder buildWithOutMockData() {
            this.buildMockData = false;
            return this;
        }

        public CotizacionBuilder withCamara(String camara) {
            this.cotizacion.camara__c = camara;
            return this;
        }

        public CotizacionBuilder withCombinatoria(String combinatoria) {
            this.cotizacion.combinatoria__c = combinatoria;
            return this;
        }

        public CotizacionBuilder withRamo(String ramo) {
            this.cotizacion.ramo__c = ramo;
            return this;
        }

        public CotizacionBuilder withProducto(String producto) {
            this.cotizacion.producto__c = producto;
            return this;
        }

        public CotizacionBuilder withPlan(String plan) {
            this.cotizacion.plan__c = plan;
            return this;
        }

        public CotizacionBuilder withFecha(String fecha) {
            this.cotizacion.fecha__c = fecha;
            return this;
        }

        public CotizacionBuilder withModuloUno(String moduloUno) {
            this.cotizacion.modulo_1__c = moduloUno;
            return this;
        }

        public CotizacionBuilder withModuloDos(String moduloDos) {
            this.cotizacion.modulo_2__c = moduloDos;
            return this;
        }

        public CotizacionBuilder withModuloTres(String moduloTres) {
            this.cotizacion.modulo_3__c = moduloTres;
            return this;
        }

        public CotizacionBuilder withUsuario(String usuario) {
            this.cotizacion.Usuario__c = usuario;
            return this;
        }

        public CotizacionBuilder withPremio(String premio) {
            this.cotizacion.premio__c = premio;
            return this;
        }

        public Cotizacion__c build() {
            if (this.buildMockData) {
                if (this.i == null) {
                    this.i = 0;
                }

                this.cotizacion.camara__c = String.valueOf(this.i);
                this.cotizacion.combinatoria__c = String.valueOf(this.i);
                this.cotizacion.ramo__c = String.valueOf(this.i);
                this.cotizacion.producto__c = String.valueOf(this.i);
                this.cotizacion.plan__c = String.valueOf(this.i);
                this.cotizacion.fecha__c = System.today().format();
                this.cotizacion.modulo_1__c = String.valueOf(this.i);
                this.cotizacion.modulo_2__c = String.valueOf(this.i);
                this.cotizacion.modulo_3__c = String.valueOf(this.i);
                this.cotizacion.usuario__c = String.valueOf(this.i);
            }

            return cotizacion;
        }
    }

    public static CotizacionBuilder aCotizacion() {
        return new CotizacionBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Bonificacion de cliente
    //---------------------------------------------------------------------------------------------------------------------------

    public class ClientBonificationBuilder {
        Bonificacion_Cliente__c bonificacion = new Bonificacion_Cliente__c();

        public ClientBonificationBuilder withExternalId(String nroGestion) {
            this.bonificacion.nroGestion__c = nroGestion;
            return this;
        }

        public Bonificacion_Cliente__c build() {
            Integer i = 1;

            bonificacion.Descripcion__c = String.valueOf(i);
            bonificacion.Fecha__c = Date.newInstance(2018, 1, 1);
            bonificacion.cuotas__c = String.valueOf(i);
            bonificacion.porCuota__c = String.valueOf(i);
            bonificacion.importe__c = String.valueOf(i);

            return bonificacion;
        }
    }

    public static ClientBonificationBuilder aClientBonification() {
        return new ClientBonificationBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Bonificacion
    //---------------------------------------------------------------------------------------------------------------------------

    public class BonificacionBuilder {
        Bonificacion__c bonificacion = new Bonificacion__c();

        public BonificacionBuilder withCantidadCuotas(String value) {
            this.bonificacion.cant_cuotas__c = value;
            return this;
        }

        public BonificacionBuilder withRPP(String ramo, String producto, String plan) {
            this.bonificacion.ramo__c = ramo;
            this.bonificacion.producto__c = producto;
            this.bonificacion.plan__c = plan;
            return this;
        }

        public BonificacionBuilder withPorcentajeCuotas(String value) {
            this.bonificacion.po_cuota__c = value;
            return this;
        }

        public BonificacionBuilder withRamo(String ramo) {
            this.bonificacion.ramo__c = ramo;
            return this;
        }

        public BonificacionBuilder withUntilDate(Date value) {
            this.bonificacion.hasta__c = value.format();
            return this;
        }

        public BonificacionBuilder withProducto(String producto) {
            this.bonificacion.producto__c = producto;
            return this;
        }

        public BonificacionBuilder withPlan(String plan) {
            this.bonificacion.plan__c = plan;
            return this;
        }

        public BonificacionBuilder withDescription(String des) {
            this.bonificacion.de_bonificacion__c = des;
            return this;
        }

        public Bonificacion__c build() {
            Integer i = 1;

            if (String.isBlank(bonificacion.ramo__c)) {
                bonificacion.ramo__c = '18';
            }

            if (String.isBlank(bonificacion.producto__c)) {
                bonificacion.producto__c = '179';
            }

            if (String.isBlank(bonificacion.plan__c)) {
                bonificacion.plan__c = '01';
            }

            if (String.isBlank(bonificacion.de_bonificacion__c)) {
                bonificacion.de_bonificacion__c = String.valueOf(i);
            }
            bonificacion.tp_bonificacion__c = String.valueOf(i);

            if (String.isBlank(bonificacion.cant_cuotas__c)) {
                bonificacion.cant_cuotas__c = String.valueOf(i);
            }

            if (String.isBlank(bonificacion.po_cuota__c)) {
                bonificacion.po_cuota__c = String.valueOf(i);
            }

            bonificacion.mt_cuota__c = String.valueOf(i);
            bonificacion.transaccion__c = String.valueOf(i);
            bonificacion.desde__c = String.valueOf(i);

            if (String.isBlank(bonificacion.hasta__c)) {
                bonificacion.hasta__c = String.valueOf(i);
            }

            bonificacion.origen_venta__c = String.valueOf(i);
            bonificacion.canal_1__c = String.valueOf(i);
            bonificacion.canal_2__c = String.valueOf(i);
            bonificacion.medio_pago__c = String.valueOf(i);
            bonificacion.origen__c = String.valueOf(i);
            bonificacion.usuario__c = String.valueOf(i);
            bonificacion.fecha_actualizacion__c = String.valueOf(i);

            String medioPago = '';
            if (this.bonificacion.de_bonificacion__c.contains('VISA')) {
                medioPago = 'VISA';
            } else if (this.bonificacion.de_bonificacion__c.contains('NARANJA')) {
                medioPago = 'NARANJA';
            } else if (this.bonificacion.de_bonificacion__c.contains('MASTERCARD')) {
                medioPago = 'MASTERCARD';
            } else {
                medioPago = 'SE';
            }

            bonificacion.name =
                bonificacion.ramo__c +
                '-' +
                bonificacion.producto__c +
                '-' +
                bonificacion.plan__c +
                '-' +
                medioPago;

            return bonificacion;
        }
    }

    public static BonificacionBuilder aBonification() {
        return new BonificacionBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // SendRequestToRectorMock
    //---------------------------------------------------------------------------------------------------------------------------

    public class SendRequestToRectorMockBuilder {
        public SendRequestToRectorMockBuilder withResult(Boolean r) {
            result = r;
            return this;
        }

        Boolean result;

        public SendRequestToRectorMock build() {
            SendRequestToRectorMock mock = new SendRequestToRectorMock(result);

            return mock;
        }
    }

    public static SendRequestToRectorMockBuilder aSendRequestToRectorMock() {
        return new SendRequestToRectorMockBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // WebServicesRequest
    //---------------------------------------------------------------------------------------------------------------------------
    public class WebServicesRequestMockBuilder {
        public WebServicesRequestMock mock;

        public WebServicesRequestMockBuilder() {
            this.mock = new WebServicesRequestMock();
        }

        public WebServicesRequestMockBuilder withResponseCode(Integer responseStatusCode) {
            this.mock.setResponseStatusCode(responseStatusCode);
            return this;
        }

        public WebServicesRequestMockBuilder withResponseBody(String responseBody) {
            this.mock.setResponseBody(responseBody);
            return this;
        }

        public WebServicesRequestMockBuilder withResponseHeaderContentTypeXML() {
            this.mock.setResponseHeaderContentTypeXML();
            return this;
        }

        public WebServicesRequestMockBuilder withResponseHeaderContentTypeJSON() {
            this.mock.setResponseHeaderContentTypeJSON();
            return this;
        }

        public WebServicesRequestMock build() {
            return this.mock;
        }
    }

    public static WebServicesRequestMockBuilder aWebServicesRequestMock() {
        return new WebServicesRequestMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // EstadoCivilUpdater
    //---------------------------------------------------------------------------------------------------------------------------
    public class EstadoCivilUpdaterMockBuilder {
        public EstadoCivilUpdaterMockBuilder withMaritalStatus(String i, String n) {
            maritalStatus.put(i, n);
            return this;
        }

        public EstadoCivilUpdaterMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        Map<String, String> maritalStatus = new Map<String, String>();
        Boolean syntaxisError = false;

        public EstadoCivilUpdaterMock build() {
            EstadoCivilUpdaterMock mock = new EstadoCivilUpdaterMock(maritalStatus, syntaxisError);

            return mock;
        }
    }

    public static EstadoCivilUpdaterMockBuilder anEstadoCivilUpdaterMock() {
        return new EstadoCivilUpdaterMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // PaisUpdater
    //---------------------------------------------------------------------------------------------------------------------------
    public class PaisUpdaterMockBuilder {
        public PaisUpdaterMockBuilder withCountry(String cod, String descrip) {
            countries.put(cod, descrip);
            return this;
        }

        public PaisUpdaterMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        Map<String, String> countries = new Map<String, String>();
        Boolean syntaxisError = false;

        public PaisUpdaterMock build() {
            PaisUpdaterMock mock = new PaisUpdaterMock(countries, syntaxisError);

            return mock;
        }
    }

    public static PaisUpdaterMockBuilder aPaisUpdaterMock() {
        return new PaisUpdaterMockBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // ClientFinderCompleteMock
    //---------------------------------------------------------------------------------------------------------------------------
    /*
	  public class ClientFinderCompleteMockBuilder {
	 
	  public ClientFinderCompleteMockBuilder withClient (Account c) {
	  client = c;
	  return this;
	  }
	  Account client;
	 
	  public ClientFinderCompleteMock build () {
	  <EOF>
	  ClientFinderCompleteMock mock = new ClientFinderCompleteMock(client);
	 
	  return mock;
	  }
	  }
	  public static ClientFinderCompleteMockBuilder aClientFinderCompleteMock () { return new ClientFinderCompleteMockBuilder(); }
	 */
    //---------------------------------------------------------------------------------------------------------------------------
    // ProvinciaUpdater
    //---------------------------------------------------------------------------------------------------------------------------
    public class ProvinciaUpdaterMockBuilder {
        public ProvinciaUpdaterMockBuilder withProvince(
            String cod,
            String descrip,
            String country,
            String ssnCode,
            String IberoCode
        ) {
            provDesc.put(cod, descrip);
            provCountry.put(cod, country);
            provSsnCode.put(cod, ssnCode);
            provIberoCode.put(cod, IberoCode);
            return this;
        }

        public ProvinciaUpdaterMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        Map<String, String> provDesc = new Map<String, String>();
        Map<String, String> provCountry = new Map<String, String>();
        Map<String, String> provSsnCode = new Map<String, String>();
        Map<String, String> provIberoCode = new Map<String, String>();
        Boolean syntaxisError = false;

        public ProvinciaUpdaterMock build() {
            ProvinciaUpdaterMock mock = new ProvinciaUpdaterMock(
                provDesc,
                provCountry,
                provSsnCode,
                provIberoCode,
                syntaxisError
            );

            return mock;
        }
    }

    public static ProvinciaUpdaterMockBuilder aProvinciaUpdaterMock() {
        return new ProvinciaUpdaterMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // LocalidadUpdater
    //---------------------------------------------------------------------------------------------------------------------------
    public class LocalidadUpdaterMockBuilder {
        public LocalidadUpdaterMockBuilder withRegion(String Id, String province, String cod, String descrip) {
            regCod.put(Id, cod);
            regDesc.put(Id, descrip);
            regProv.put(Id, province);
            return this;
        }

        public LocalidadUpdaterMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        Map<String, String> regCod = new Map<String, String>();
        Map<String, String> regDesc = new Map<String, String>();
        Map<String, String> regProv = new Map<String, String>();
        Boolean syntaxisError = false;

        public LocalidadUpdaterMock build() {
            LocalidadUpdaterMock mock = new LocalidadUpdaterMock(regCod, regDesc, regProv, syntaxisError);

            return mock;
        }
    }

    public static LocalidadUpdaterMockBuilder aLocalidadUpdaterMock() {
        return new LocalidadUpdaterMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // CategoriaIVAUpdater
    //---------------------------------------------------------------------------------------------------------------------------
    public class CategoriaIVAUpdaterMockBuilder {
        public CategoriaIVAUpdaterMockBuilder withCategory(
            String Id,
            String codOrigen,
            String codDestino,
            String descrip
        ) {
            catCodOri.put(Id, codOrigen);
            catCodDest.put(Id, codDestino);
            catDesc.put(Id, descrip);
            return this;
        }

        public CategoriaIVAUpdaterMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        Map<String, String> catCodOri = new Map<String, String>();
        Map<String, String> catCodDest = new Map<String, String>();
        Map<String, String> catDesc = new Map<String, String>();
        Boolean syntaxisError = false;

        public CategoriaIVAUpdaterMock build() {
            CategoriaIVAUpdaterMock mock = new CategoriaIVAUpdaterMock(catCodOri, catCodDest, catDesc, syntaxisError);

            return mock;
        }
    }

    public static CategoriaIVAUpdaterMockBuilder aCategoriaIVAUpdaterMock() {
        return new CategoriaIVAUpdaterMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RelacionLaboralUpdater
    //---------------------------------------------------------------------------------------------------------------------------
    public class RelacionLaboralUpdaterMockBuilder {
        public RelacionLaboralUpdaterMockBuilder withWorkRelationship(String c, String d) {
            relations.put(c, d);
            return this;
        }

        public RelacionLaboralUpdaterMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        Map<String, String> relations = new Map<String, String>();
        Boolean syntaxisError = false;

        public RelacionLaboralUpdaterMock build() {
            RelacionLaboralUpdaterMock mock = new RelacionLaboralUpdaterMock(relations, syntaxisError);

            return mock;
        }
    }

    public static RelacionLaboralUpdaterMockBuilder aRelacionLaboralUpdaterMock() {
        return new RelacionLaboralUpdaterMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ParentescoUpdater
    //---------------------------------------------------------------------------------------------------------------------------
    public class ParentescoUpdaterMockBuilder {
        public ParentescoUpdaterMockBuilder withRelation(String c, String d) {
            relations.put(c, d);
            return this;
        }

        public ParentescoUpdaterMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        Map<String, String> relations = new Map<String, String>();
        Boolean syntaxisError = false;

        public ParentescoUpdaterMock build() {
            ParentescoUpdaterMock mock = new ParentescoUpdaterMock(relations, syntaxisError);

            return mock;
        }
    }

    public static ParentescoUpdaterMockBuilder aParentescoUpdaterMock() {
        return new ParentescoUpdaterMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ClientRetriever
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClientBasicDataRetrieverMockBuilder {
        public ClientBasicDataRetrieverMockBuilder withClient(Account c) {
            client = c.clone();

            client.Genero__c = XMLDataConversion.genderToXml(client.Genero__c);
            client.Tipo_de_Documento__c = XMLDataConversion.docTypeToXml(client.Tipo_de_Documento__c);
            client.Estado_Civil__c = XMLDataConversion.maritalStatusToXml(client.Estado_Civil__c);

            return this;
        }

        public ClientBasicDataRetrieverMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        public ClientBasicDataRetrieverMockBuilder withMoreThanOneClient(List<Account> clients) {
            this.clients = clients;
            return this;
        }

        Account client = new Account();
        Boolean syntaxisError = false;
        List<Account> clients = new List<Account>();

        public ClientBasicDataRetrieverMock build() {
            ClientBasicDataRetrieverMock mock = new ClientBasicDataRetrieverMock(client, syntaxisError);
            if (clients.size() > 0) {
                mock = new ClientBasicDataRetrieverMock(client, syntaxisError);
                mock.clients = clients;
            }

            return mock;
        }
    }

    public static ClientBasicDataRetrieverMockBuilder aClientBasicDataRetrieverMock() {
        return new ClientBasicDataRetrieverMockBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // ClientRetriever
    //---------------------------------------------------------------------------------------------------------------------------
    /*
	  public class ClientBasicDataRetrieverJsonMockBuilder {
	 
	  public ClientBasicDataRetrieverJsonMockBuilder withClient(Account c) {
	 
	  client = c.clone();
	 
	  client.Genero__c = XMLDataConversion.genderToXml(client.Genero__c);
	  client.Tipo_de_Documento__c = XMLDataConversion.docTypeToXml(client.Tipo_de_Documento__c);
	  client.Estado_Civil__c = XMLDataConversion.maritalStatusToXml(client.Estado_Civil__c);
	 
	  return this;
	  }
	 
	  public ClientBasicDataRetrieverJsonMockBuilder withSyntaxisError() {
	  syntaxisError = true;
	  return this;
	  }
	 
	  public ClientBasicDataRetrieverJsonMockBuilder withMoreThanOneClient(List<Account> clients) {
	  this.clients = clients;
	  return this;
	  }
	 
	  Account client = new Account();
	  Boolean syntaxisError = false;
	  List<Account> clients = new List<Account> ();
	 
	  public ClientBasicDataRetrieverJsonMock build() {
	 
	  ClientBasicDataRetrieverJsonMock mock = new ClientBasicDataRetrieverJsonMock(client, syntaxisError);
	  if (clients.size() > 0) {
	  mock = new ClientBasicDataRetrieverJsonMock(client, syntaxisError);
	  mock.clients = clients;
	  }
	 
	  return mock;
	  }
	  }
	 
	  public static ClientBasicDataRetrieverJsonMockBuilder aClientBasicDataRetrieverJsonMock() {
	  return new ClientBasicDataRetrieverJsonMockBuilder();
	  }
	 */
    //---------------------------------------------------------------------------------------------------------------------------
    // Policy extraordinary reinstatement amount
    //---------------------------------------------------------------------------------------------------------------------------
    public class PolicyReinstatementAmountMockBuilder {
        public PolicyReinstatementAmountMockBuilder withAmount(Decimal amount) {
            this.amount = amount;
            return this;
        }

        Decimal amount;

        public PolicyReinstatementAmountMock build() {
            PolicyReinstatementAmountMock mock = new PolicyReinstatementAmountMock(amount);
            return mock;
        }
    }

    public static PolicyReinstatementAmountMockBuilder aPolicyReinstatementAmountMock() {
        return new PolicyReinstatementAmountMockBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // BM Campaign
    //---------------------------------------------------------------------------------------------------------------------------
    public class BMCampaignBuilder {
        public BMCampaignBuilder withEmail(String value) {
            this.bm.Email__c = value;
            return this;
        }

        public BMCampaignBuilder withTemplateId(String value) {
            this.bm.templateId__c = value;
            return this;
        }

        public BMCampaignBuilder withClientId(String value) {
            this.bm.clientId__c = value;
            return this;
        }

        BMCampaign__c bm = new BMCampaign__c();

        public BMCampaign__c build() {
            return bm;
        }
    }

    public static BMCampaignBuilder aBMCampaign() {
        return new BMCampaignBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Client
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClientBuilder {
        private Account client;

        public ClientBuilder() {
            this.client = new Account();
            this.withMockData();
        }

        public ClientBuilder withMockData() {
            this.client.IdBHSeg__c = '183262';
            this.client.FirstName = 'MARTIN GABRIEL';
            this.client.LastName = 'NASCARELLA';
            this.client.Genero__c = 'Masculino';
            this.client.PersonBirthdate = date.valueOf('1975-02-26');
            this.client.Tipo_de_Documento__c = 'D.N.I.';
            this.client.CUIT__c = '20243233616';
            this.client.Id_Cliente_BHSeg__c = '170514';
            this.client.Numero_de_Documento__c = '24323361';
            return this;
        }

        public ClientBuilder cleanMockData() {
            this.client.clear();
            return this;
        }

        public ClientBuilder withMaritalStatus(Estado_Civil__c maritalStatus) {
            this.client.Estado_Civil__c = maritalStatus.Descripcion__c;
            return this;
        }

        public ClientBuilder withLastName(String lastName) {
            this.client.LastName = lastName;
            return this;
        }

        public ClientBuilder withFirstName(String firstName) {
            this.client.FirstName = firstName;
            return this;
        }

        public ClientBuilder withIdBHSeg(String idBHSeg) {
            this.client.IdBHSeg__c = idBHSeg;
            return this;
        }

        public ClientBuilder withIdClienteBHSeg(String idClienteBHSeg) {
            this.client.Id_Cliente_BHSeg__c = idClienteBHSeg;
            return this;
        }

        public ClientBuilder withCUIT(String cuit) {
            this.client.CUIT__c = cuit;
            return this;
        }

        public ClientBuilder withDocNumber(String docNumber) {
            this.client.Numero_de_Documento__c = docNumber;
            return this;
        }

        public ClientBuilder withDocType(String docType) {
            this.client.Tipo_de_Documento__c = docType;
            return this;
        }

        public ClientBuilder withEmail(String mail) {
            this.client.PersonEmail = mail;
            return this;
        }

        public ClientBuilder withAltEmail(String mail) {
            this.client.Email_Secundario__c = mail;
            return this;
        }

        public ClientBuilder withVerifiedDate(Date verDate) {
            this.client.Fecha_ultima_verificacion__c = verDate;
            return this;
        }

        public ClientBuilder withPersonHomePhone(String phone) {
            this.client.PersonHomePhone = phone;
            return this;
        }

        public ClientBuilder withPersonMobilePhone(String phone) {
            this.client.PersonMobilePhone = phone;
            return this;
        }

        public ClientBuilder withPersonBirthdate(Date birthDate) {
            this.client.PersonBirthdate = birthDate;
            return this;
        }

        public ClientBuilder withPhone(String phone) {
            this.client.Phone = phone;
            return this;
        }

        public ClientBuilder withGenero(String gender) {
            this.client.Genero__c = gender;
            return this;
        }

        public clientBuilder isAPIUpdate(boolean IsAPIUpdate) {
            this.client.Is_API_Update__c = IsAPIUpdate;
            return this;
        }

        public ClientBuilder withPantallaProtegidaActive() {
            this.client.Pantalla_Protegida_Activa__c = true;
            return this;
        }

        public ClientBuilder withPantallaProtegidaActiveDate(Date protectDate) {
            this.client.Pantalla_Protegida_Fecha_Activacion__c = protectDate;
            return this;
        }

        public ClientBuilder withContactData() {
            this.client.PersonEmail = 'primary@mail.com';
            this.client.Email_Secundario__c = 'secondary@mail.com';
            this.client.Phone = '(54-11)()4347-5000 INT';
            this.client.PersonMobilePhone = '(54-11)()4347-1095 INT';
            this.client.PersonHomePhone = '(54-11)()4347-1095 INT';

            return this;
        }

        public ClientBuilder isPEP() {
            this.client.PEP__c = true;
            return this;
        }

        public ClientBuilder isNotPEP() {
            this.client.PEP__c = false;
            return this;
        }

        public ClientBuilder withBienvenida(Boolean bienvenidaValue) {
            //this.client.Bienvenida__c = bienvenidaValue;
            return this;
        }

        public ClientBuilder withFechaDeBienvenida(Date fecha) {
            //this.client.Fecha_de_Bienvenida__c = fecha;
            return this;
        }

        public Account build() {
            return client;
        }
    }

    public static ClientBuilder aClient() {
        return new ClientBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Empty client Client
    //---------------------------------------------------------------------------------------------------------------------------
    public class EmptyClientBuilder {
        public EmptyClientBuilder withName(String name) {
            client.FirstName = name;
            return this;
        }

        public EmptyClientBuilder withLastName(String lastName) {
            client.LastName = lastName;
            return this;
        }

        public EmptyClientBuilder withCUIT(String cuit) {
            client.CUIT__c = cuit;
            return this;
        }

        public EmptyClientBuilder withDocNum(String docNum) {
            client.Numero_de_Documento__c = docNum;
            return this;
        }

        public EmptyClientBuilder withIdBHSeg(String idBHSeg) {
            client.IdBHSeg__c = idBHSeg;
            return this;
        }

        public EmptyClientBuilder withIdClienteBHSeg(String idClienteBHSeg) {
            client.Id_Cliente_BHSeg__c = idClienteBHSeg;

            return this;
        }

        Account client = new Account();

        public Account build() {
            return client;
        }
    }

    public static EmptyClientBuilder anEmptyClient() {
        return new EmptyClientBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // EstadoCivil
    //---------------------------------------------------------------------------------------------------------------------------
    public class MaritalStatusBuilder {
        public MaritalStatusBuilder withCode(String c) {
            code = c;
            return this;
        }

        public MaritalStatusBuilder withDescription(String d) {
            descrip = d;
            return this;
        }

        String code = 'C';
        String descrip = 'CASADO/A';

        public Estado_Civil__c build() {
            Estado_Civil__c status = new Estado_Civil__c();
            status.Name = code;
            status.Codigo__c = code;
            status.Descripcion__c = descrip;

            return status;
        }
    }

    public static MaritalStatusBuilder aMaritalStatus() {
        return new MaritalStatusBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // PhoneNumber
    //---------------------------------------------------------------------------------------------------------------------------
    public class PhoneNumberBuilder {
        public PhoneNumberBuilder withSequenceCode(String sc) {
            sequenceCode = sc;
            return this;
        }

        public PhoneNumberBuilder withContactCode(String cc) {
            contactCode = cc;
            return this;
        }

        public PhoneNumberBuilder withDescription(String d) {
            description = d;
            return this;
        }

        String sequenceCode;
        String contactCode;
        String description;

        public PhoneNumber build() {
            PhoneNumber phone = new PhoneNumber(sequenceCode, contactCode, description);

            return phone;
        }
    }

    public static PhoneNumberBuilder aPhoneNumber() {
        return new PhoneNumberBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ClientPhoneDataRetrieverMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClientPhoneDataRetrieverMockBuilder {
        public ClientPhoneDataRetrieverMockBuilder forClient(Account c) {
            client = c;
            return this;
        }

        public ClientPhoneDataRetrieverMockBuilder withPhone(PhoneNumber p) {
            phones.add(p);
            return this;
        }

        public ClientPhoneDataRetrieverMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        Account client;
        List<PhoneNumber> phones = new List<PhoneNumber>();
        Boolean syntaxisError = false;

        public ClientPhoneDataRetrieverMock build() {
            ClientPhoneDataRetrieverMock mock = new ClientPhoneDataRetrieverMock(client, phones, syntaxisError);

            return mock;
        }
    }

    public static ClientPhoneDataRetrieverMockBuilder aClientPhoneDataRetrieverMock() {
        return new ClientPhoneDataRetrieverMockBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // WebServicesFindClienteMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class WebServicesFindClienteMockBuilder {
        public WebServicesFindClienteMockBuilder forClient(Account client) {
            this.mock.setClient(client);
            return this;
        }

        public WebServicesFindClienteMockBuilder withEmptyResponse() {
            this.mock.isEmptyResponse(true);
            return this;
        }

        WebServiceFindClienteMock mock = new WebServiceFindClienteMock();

        public WebServiceFindClienteMock build() {
            return mock;
        }
    }

    public static WebServicesFindClienteMockBuilder aWebServicesFindClienteMock() {
        return new WebServicesFindClienteMockBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // EMailAdress
    //---------------------------------------------------------------------------------------------------------------------------
    public class EMailAdressBuilder {
        public EMailAdressBuilder withSequenceCode(String sc) {
            sequenceCode = sc;
            return this;
        }

        public EMailAdressBuilder withContactCode(String cc) {
            contactCode = cc;
            return this;
        }

        public EMailAdressBuilder withDescription(String d) {
            description = d;
            return this;
        }

        String sequenceCode;
        String contactCode;
        String description;

        public EMailAdress build() {
            EMailAdress phone = new EMailAdress(sequenceCode, contactCode, description);

            return phone;
        }
    }

    public static EMailAdressBuilder anEMailAdress() {
        return new EMailAdressBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ClientEMailDataRetrieverMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClientEMailDataRetrieverMockBuilder {
        public ClientEMailDataRetrieverMockBuilder forClient(Account c) {
            client = c;
            return this;
        }

        public ClientEMailDataRetrieverMockBuilder withEMail(EMailAdress e) {
            mails.add(e);
            return this;
        }

        public ClientEMailDataRetrieverMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        Account client;
        List<EMailAdress> mails = new List<EMailAdress>();
        Boolean syntaxisError = false;

        public ClientEMailDataRetrieverMock build() {
            ClientEMailDataRetrieverMock mock = new ClientEMailDataRetrieverMock(client, mails, syntaxisError);

            return mock;
        }
    }

    public static ClientEMailDataRetrieverMockBuilder aClientEMailDataRetrieverMock() {
        return new ClientEMailDataRetrieverMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Address
    //---------------------------------------------------------------------------------------------------------------------------
    public class AddressBuilder {
        AddressBuilder() {
            addr.Calle__c = 'Una calle';
            addr.Numero__c = 1234;
            addr.Piso__c = 'SS1';
            addr.Depto__c = 'Oficina A';
            addr.Codigo_Postal__c = '1122';
        }

        public AddressBuilder forClient(String client) {
            addr.Cuenta__c = client;
            return this;
        }

        public AddressBuilder withType(String addrType) {
            addr.Tipo__c = addrType;
            return this;
        }

        public AddressBuilder withStreet(String street) {
            addr.Calle__c = street;
            return this;
        }

        public AddressBuilder withStreetNumber(Integer stNumber) {
            addr.Numero__c = stNumber;
            return this;
        }

        public AddressBuilder withPostalCode(string postalCode) {
            addr.Codigo_Postal__c = postalCode;
            return this;
        }

        public AddressBuilder withFloor(string floor) {
            addr.Piso__c = floor;
            return this;
        }

        public AddressBuilder withAppartment(string appartment) {
            addr.Depto__c = appartment;
            return this;
        }

        public AddressBuilder withProvince(string province) {
            addr.Provincia__c = province;
            return this;
        }

        public AddressBuilder withCity(string city) {
            addr.Ciudad__c = city;
            return this;
        }

        Domicilio__c addr = new Domicilio__c();

        public Domicilio__c build() {
            return addr;
        }
    }

    public static AddressBuilder anAddress() {
        return new AddressBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ClientAddressDataRetrieverMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClientAddressDataRetrieverMockBuilder {
        public ClientAddressDataRetrieverMockBuilder forClient(Account c) {
            client = c;
            return this;
        }

        public ClientAddressDataRetrieverMockBuilder withRectorAddress(RectorAddress r) {
            addrs.add(r);
            return this;
        }

        public ClientAddressDataRetrieverMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        Account client;
        List<RectorAddress> addrs = new List<RectorAddress>();
        Boolean syntaxisError = false;

        public ClientAddressDataRetrieverMock build() {
            ClientAddressDataRetrieverMock mock = new ClientAddressDataRetrieverMock(client, addrs, syntaxisError);

            return mock;
        }
    }

    public static ClientAddressDataRetrieverMockBuilder aClientAddressDataRetrieverMock() {
        return new ClientAddressDataRetrieverMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RectorAddress
    //---------------------------------------------------------------------------------------------------------------------------
    public class RectorAddressBuilder {
        RectorAddressBuilder() {
            addr.sequenceCode = '1';
            addr.typeCode = '1';
            addr.postalCodeId = '123';
            addr.addressSt = 'Una calle';
            addr.addressNum = '1234';
            addr.addressFl = 'SS1';
            addr.addressDp = 'Oficina A';

            addr.hasFloor = true;
            addr.hasApartment = true;
        }

        public RectorAddressBuilder withStreet(String s) {
            addr.addressSt = s;
            return this;
        }

        public RectorAddressBuilder withNumber(String s) {
            addr.addressNum = s;
            return this;
        }

        public RectorAddressBuilder withSeqNumber(String s) {
            addr.sequenceCode = s;
            return this;
        }

        public RectorAddressBuilder withType(String s) {
            addr.typeCode = s;
            return this;
        }

        public RectorAddressBuilder withPostalCode(Codigo_Postal__c c) {
            addr.postalCodeId = c.Name;
            return this;
        }

        public RectorAddressBuilder withoutFloor() {
            addr.hasFloor = false;
            return this;
        }

        public RectorAddressBuilder withoutApartment() {
            addr.hasApartment = false;
            return this;
        }

        RectorAddress addr = new RectorAddress();

        public RectorAddress build() {
            return addr;
        }
    }

    public static RectorAddressBuilder aRectorAddress() {
        return new RectorAddressBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // PostalCode
    //---------------------------------------------------------------------------------------------------------------------------
    public class PostalCodeBuilder {
        private Codigo_Postal__c postalCode = new Codigo_Postal__c();

        public PostalCodeBuilder() {
            this.postalCode.Name = '961864';
            this.postalCode.Codigo__c = '1428';
            this.postalCode.Localidad__c = '1|50426';
        }

        public PostalCodeBuilder clearMockData() {
            this.postalCode.clear();
            return this;
        }

        public PostalCodeBuilder withName(String name) {
            this.postalCode.Name = name;
            return this;
        }

        public PostalCodeBuilder withCodigo(String codigo) {
            this.postalCode.Codigo__c = codigo;
            return this;
        }

        public PostalCodeBuilder withLocalidad(String provinciaPipeLocalidad) {
            this.postalCode.Localidad__c = provinciaPipeLocalidad;
            return this;
        }

        public Codigo_Postal__c build() {
            return postalCode;
        }
    }

    public static PostalCodeBuilder aPostalCode() {
        return new PostalCodeBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Region
    //---------------------------------------------------------------------------------------------------------------------------
    public class RegionBuilder {
        RegionBuilder() {
            region.Name = '123|456';
            region.Codigo__c = '456';
            region.Descripcion__c = 'mi localidad';
            region.Provincia__c = '123';
        }

        public RegionBuilder forPostalCode(Codigo_Postal__c c) {
            region.Name = c.Localidad__c;
            Integer posDiv = c.Localidad__c.indexOf('|');
            Integer len = c.Localidad__c.length();
            region.Provincia__c = c.Localidad__c.left(posDiv);
            region.Codigo__c = c.Localidad__c.left(len - posDiv - 1);
            return this;
        }

        Localidad__c region = new Localidad__c();

        public Localidad__c build() {
            return region;
        }
    }

    public static RegionBuilder aRegion() {
        return new RegionBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Province
    //---------------------------------------------------------------------------------------------------------------------------
    public class ProvinceBuilder {
        ProvinceBuilder() {
            province.Name = '1';
            province.Codigo__c = '1';
            province.Descripcion__c = 'mi provincia';
            province.Codigo_SSN__c = '08';
            province.Codigo_Ibero__c = '08';
            province.Pais__c = '80';
        }

        public ProvinceBuilder forPostalCode(Codigo_Postal__c c) {
            Integer posDiv = c.Localidad__c.indexOf('|');
            province.Name = c.Localidad__c.left(posDiv);
            province.Codigo__c = c.Localidad__c.left(posDiv);
            return this;
        }

        Provincia__c province = new Provincia__c();

        public Provincia__c build() {
            return province;
        }
    }

    public static ProvinceBuilder aProvince() {
        return new ProvinceBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Provinca Rector
    //---------------------------------------------------------------------------------------------------------------------------
    public class ProvinceRectorBuilder {
        ProvinceRectorBuilder() {
            province.Name = '1';
            province.Codigo__c = '1';
            province.Descripcion__c = 'mi provincia';
            province.Codigo_SSN__c = '08';
            province.Codigo_Ibero__c = '08';
            province.Pais__c = '80';
        }

        public ProvinceRectorBuilder forPostalCode(Codigo_Postal__c c) {
            Integer posDiv = c.Localidad__c.indexOf('|');
            province.Name = c.Localidad__c.left(posDiv);
            province.Codigo__c = c.Localidad__c.left(posDiv);
            return this;
        }

        Provincia_Rector__c province = new Provincia_Rector__c();

        public Provincia_Rector__c build() {
            return province;
        }
    }

    public static ProvinceRectorBuilder aProvinceRector() {
        return new ProvinceRectorBuilder();
    }

    /*------------------------------------------------------------------------
				ProvinciaRectorBuilderStart
	------------------------------------------------------------------------*/
    public class ProvinciaRectorBuilder {
        private Provincia_Rector__c obj = new Provincia_Rector__c();

        public ProvinciaRectorBuilder withOwnerId(Group value) {
            obj.OwnerId = value.Id;
            return this;
        }

        public ProvinciaRectorBuilder withOwnerId(User value) {
            obj.OwnerId = value.Id;
            return this;
        }

        public ProvinciaRectorBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public ProvinciaRectorBuilder withCodigoIbero(String value) {
            obj.Codigo_Ibero__c = value;
            return this;
        }

        public ProvinciaRectorBuilder withCodigoSSN(String value) {
            obj.Codigo_SSN__c = value;
            return this;
        }

        public ProvinciaRectorBuilder withCodigo(String value) {
            obj.Codigo__c = value;
            return this;
        }

        public ProvinciaRectorBuilder withDescripcion(String value) {
            obj.Descripcion__c = value;
            return this;
        }

        public ProvinciaRectorBuilder withPais(String value) {
            obj.Pais__c = value;
            return this;
        }

        public ProvinciaRectorBuilder withidbhseg(String value) {
            obj.id_bhseg__c = value;
            return this;
        }

        public Provincia_Rector__c build() {
            return obj;
        }
    }

    public static ProvinciaRectorBuilder aProvinciaRector() {
        return new ProvinciaRectorBuilder();
    }

    /*------------------------------------------------------------------------
	             ProvinciaRectorBuilderEnd
	------------------------------------------------------------------------*/

    //---------------------------------------------------------------------------------------------------------------------------
    // Country
    //---------------------------------------------------------------------------------------------------------------------------
    public class CountryBuilder {
        CountryBuilder() {
            country.Name = '80';
            country.Codigo__c = '80';
            country.Descripcion__c = 'ARGENTINA';
        }

        Pais__c country = new Pais__c();

        public Pais__c build() {
            return country;
        }
    }

    public static CountryBuilder aCountry() {
        return new CountryBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RectorCertificate
    //---------------------------------------------------------------------------------------------------------------------------
    public class RectorCertificateBuilder {
        RectorCertificateBuilder() {
            certif.sucursal = '1';
            certif.ramo = '19';
            certif.ramoDes = 'VIDA';
            certif.producto = '007';
            certif.productoDes = 'TARJETAS DE CREDITO';
            certif.poliza = '19|16';
            certif.certificado = '19|16|331390';
            certif.estado = '331390';
            certif.idAsegurado = '183262';
            certif.idNegocio = '190071-404657602';
            certif.fechaDesde = '2010-09-30';
            certif.fechaHasta = '2011-01-27';
            certif.fechaAnulacion = '2014-09-30';
            certif.codigoMedio = '0';
            certif.codigoOrigen = '2';
            certif.consecutivoCuenta = '4';
            certif.consecutivoDomicilio = '6';
            certif.codigoPlanPago = '8';
        }

        public RectorCertificateBuilder forClient(Account c) {
            certif.idAsegurado = c.Id_Cliente_BHSeg__c;
            return this;
        }

        public RectorCertificateBuilder withSucursal(String value) {
            certif.sucursal = value;
            return this;
        }

        public RectorCertificateBuilder withRamo(String value) {
            certif.ramo = value;
            return this;
        }

        public RectorCertificateBuilder withProducto(String value) {
            certif.producto = value;
            return this;
        }

        public RectorCertificateBuilder withPoliza(String value) {
            certif.poliza = value;
            return this;
        }

        public RectorCertificateBuilder withCertificado(String value) {
            certif.certificado = value;
            return this;
        }

        public RectorCertificateBuilder withEstado(String value) {
            certif.estado = value;
            return this;
        }

        public RectorCertificateBuilder withIdAsegurado(String value) {
            certif.idAsegurado = value;
            return this;
        }

        public RectorCertificateBuilder withIdNegocio(String value) {
            certif.idNegocio = value;
            return this;
        }

        public RectorCertificateBuilder withFechaDesde(String value) {
            certif.fechaDesde = value;
            return this;
        }

        public RectorCertificateBuilder withFechaHasta(String value) {
            certif.fechaHasta = value;
            return this;
        }

        public RectorCertificateBuilder withFechaAnulacion(String value) {
            certif.fechaAnulacion = value;
            return this;
        }

        public RectorCertificateBuilder withCodigoMedio(String value) {
            certif.codigoMedio = value;
            return this;
        }

        public RectorCertificateBuilder withCodigoOrigen(String value) {
            certif.codigoOrigen = value;
            return this;
        }

        public RectorCertificateBuilder withConsecutivoCuenta(String value) {
            certif.consecutivoCuenta = value;
            return this;
        }

        public RectorCertificateBuilder withConsecutivoDomicilio(String value) {
            certif.consecutivoDomicilio = value;
            return this;
        }

        public RectorCertificateBuilder withCodigoPlanPago(String value) {
            certif.codigoPlanPago = value;
            return this;
        }

        RectorCertificate certif = new RectorCertificate();

        public RectorCertificate build() {
            return certif;
        }
    }

    public static RectorCertificateBuilder aRectorCertificate() {
        return new RectorCertificateBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RectorPolicy
    //---------------------------------------------------------------------------------------------------------------------------
    public class RectorPolicyBuilder {
        RectorPolicyBuilder() {
            pol.id = '19|16';
            pol.codigoProducto = '007';
            pol.numeroPoliza = '16';
            pol.productor = '414';
            pol.cliente = '3';
            pol.medioPago = '1|0';
            pol.tipoVigencia = 'P';
            pol.tipoVigenciaContrato = 'PP';
            pol.planPago = '10';
            pol.fechaDesde = '2007-07-20';
            pol.fechaHasta = '2011-07-21';
            pol.fechaDesdeContrato = '2007-07-21';
            pol.fechaHastaContrato = '2011-07-22';
            pol.fechaEmision = '2007-08-01';
            pol.fechaAnulacion = '2107-08-01';
            pol.hashCombo = '19007001';
            pol.estado = 'Vigente';
            pol.numeroAnterior = '01';
            pol.numeroSiguiente = '02';
            pol.ultimoEndoso = '03';
            pol.domicilioEnvio = '04';
        }

        public RectorPolicyBuilder withId(String value) {
            pol.id = value;
            return this;
        }

        public RectorPolicyBuilder withCodigoProducto(String value) {
            pol.codigoProducto = value;
            return this;
        }

        public RectorPolicyBuilder withNumeroPoliza(String value) {
            pol.numeroPoliza = value;
            return this;
        }

        public RectorPolicyBuilder withProductor(String value) {
            pol.productor = value;
            return this;
        }

        public RectorPolicyBuilder withCliente(String value) {
            pol.cliente = value;
            return this;
        }

        public RectorPolicyBuilder withMedioPago(String value) {
            pol.medioPago = value;
            return this;
        }

        public RectorPolicyBuilder withTipoVigencia(String value) {
            pol.tipoVigencia = value;
            return this;
        }

        public RectorPolicyBuilder withTipoVigenciaContrato(String value) {
            pol.tipoVigenciaContrato = value;
            return this;
        }

        public RectorPolicyBuilder withPlanPago(String value) {
            pol.planPago = value;
            return this;
        }

        public RectorPolicyBuilder withFechaDesde(String value) {
            pol.fechaDesde = value;
            return this;
        }

        public RectorPolicyBuilder withFechaHasta(String value) {
            pol.fechaHasta = value;
            return this;
        }

        public RectorPolicyBuilder withFechaDesdeContrato(String value) {
            pol.fechaDesdeContrato = value;
            return this;
        }

        public RectorPolicyBuilder withFechaHastaContrato(String value) {
            pol.fechaHastaContrato = value;
            return this;
        }

        public RectorPolicyBuilder withFechaEmision(String value) {
            pol.fechaEmision = value;
            return this;
        }

        public RectorPolicyBuilder withFechaAnulacion(String value) {
            pol.fechaAnulacion = value;
            return this;
        }

        public RectorPolicyBuilder withHashCombo(String value) {
            pol.hashCombo = value;
            return this;
        }

        public RectorPolicyBuilder withEstado(String value) {
            pol.estado = value;
            return this;
        }

        public RectorPolicyBuilder withNumeroAnterior(String value) {
            pol.numeroAnterior = value;
            return this;
        }

        public RectorPolicyBuilder withNumeroSiguiente(String value) {
            pol.numeroSiguiente = value;
            return this;
        }

        public RectorPolicyBuilder withUltimoEndoso(String value) {
            pol.ultimoEndoso = value;
            return this;
        }

        public RectorPolicyBuilder withDomicilioEnvio(String value) {
            pol.domicilioEnvio = value;
            return this;
        }

        RectorPolicy pol = new RectorPolicy();

        public RectorPolicy build() {
            return pol;
        }
    }

    public static RectorPolicyBuilder aRectorPolicy() {
        return new RectorPolicyBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ClientProductDataRetrieverMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClientProductDataRetrieverMockBuilder {
        public ClientProductDataRetrieverMockBuilder withRectorCertificateBrief(RectorCertificateBrief cert) {
            briefs.add(cert);
            return this;
        }

        public ClientProductDataRetrieverMockBuilder withRectorCertificateDetail(RectorCertificateDetail detail) {
            String url = detail.nroPoliza + '_' + detail.codRamo + '_' + detail.nroCertificado + '_' + detail.nroEndoso;
            details.put(url, detail);
            return this;
        }

        public ClientProductDataRetrieverMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        public ClientProductDataRetrieverMockBuilder withClient(Account c) {
            clients.add(c);
            return this;
        }

        List<Account> clients = new List<Account>();
        List<RectorCertificateBrief> briefs = new List<RectorCertificateBrief>();
        Map<String, RectorCertificateDetail> details = new Map<String, RectorCertificateDetail>();
        Boolean syntaxisError = false;

        public ClientProductDataRetrieverMock build() {
            ClientProductDataRetrieverMock mock = new ClientProductDataRetrieverMock(
                briefs,
                details,
                syntaxisError,
                clients
            );

            return mock;
        }
    }

    public static ClientProductDataRetrieverMockBuilder aClientProductDataRetrieverMock() {
        return new ClientProductDataRetrieverMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ClientFinderMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClientFinderMockBuilder {
        public ClientFinderMockBuilder withClient(Account c) {
            clients.add(c);
            return this;
        }

        public ClientFinderMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        public ClientFinderMockBuilder withRectorCertificate(RectorCertificate cert) {
            certificate = cert;
            return this;
        }

        RectorCertificate certificate;
        List<Account> clients = new List<Account>();
        Boolean syntaxisError = false;

        public ClientFinderMock build() {
            ClientFinderMock mock = new ClientFinderMock(clients, certificate, syntaxisError);

            return mock;
        }
    }

    public static ClientFinderMockBuilder aClientFinderMock() {
        return new ClientFinderMockBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Policy
    //---------------------------------------------------------------------------------------------------------------------------
    public class PolicyBuilder {
        public PolicyBuilder() {
            policy.Ramo_IdBHSeg__c = '111';
            policy.Poliza__c = 222;
            policy.Certificado__c = 333;
            policy.Id_bhseg__c = policy.Certificado_Id_BHSeg__c = '111|222|333';
            policy.Endoso__c = 444;
            policy.Estado__c = 'Vigente';
        }

        public PolicyBuilder withMedioDePago(String value) {
            this.policy.Medio_de_Pago__c = value;
            return this;
        }

        public PolicyBuilder cleanMockData() {
            this.policy.clear();
            return this;
        }

        public PolicyBuilder withHasta(Date hasta) {
            // Jira 1603
            this.policy.Hasta__c = hasta;
            return this;
        }

        public PolicyBuilder withDesde(Date desde) {
            // Jira 1603
            this.policy.Desde__c = desde;
            return this;
        }

        public PolicyBuilder withNumeroPoliza(Integer value) {
            this.policy.Poliza__c = value;
            return this;
        }

        public PolicyBuilder withBriefDataFrom(RectorCertificateBrief brief) {
            policy.Id_bhseg__c = policy.Certificado_Id_BHSeg__c = brief.cramo + '|' + brief.poliza + '|' + brief.certif;
            policy.Ramo_IdBHSeg__c = brief.cramo;
            policy.Certificado__c = Decimal.valueOf(brief.certif);
            policy.Endoso__c = Decimal.valueOf(brief.endoso);
            policy.Poliza__c = Decimal.valueOf(brief.poliza);
            policy.Plan__c = brief.dplan;
            policy.Plan_IdBHSeg__c = brief.PLAN;

            policy.Certificado__c = Decimal.valueOf(brief.certif);
            policy.Emision__c = Date.parse(brief.fe_emision);
            policy.Endoso__c = Decimal.valueOf(brief.endoso);
            policy.Desde__c = Date.parse(brief.fe_vdesde);
            policy.Hasta__c = Date.parse(brief.fe_vhasta);
            policy.Estado__c = brief.estado;
            policy.Motivo_Endoso__c = brief.dmotiv;
            policy.Poliza_Anterior__c = Decimal.valueOf(brief.pol_ant);
            policy.Producto__c = brief.dprod;
            policy.Producto_IdBHSeg__c = brief.cprod;
            policy.Ramo__c = brief.dramo;
            policy.Ramo_IdBHSeg__c = brief.cramo;
            policy.Premio__c = Decimal.valueOf(brief.premio);
            policy.Suma_Asegurada__c = Decimal.valueOf(brief.suma_aseg);

            policy.Medio_de_Pago__c = brief.mdpDescription;
            policy.Medio_de_Pago_IdBHSeg__c = brief.mdpCode;
            policy.Origen_de_Pago__c = brief.odpDescription;
            policy.Origen_de_Pago_IdBHSeg__c = brief.odpCode;
            policy.Cuenta_Pago__c = brief.numeroCuenta;

            if (brief.obligatorio == 'SI') {
                policy.Optativa__c = false;
            } else {
                policy.Optativa__c = true;
            }

            return this;
        }

        public PolicyBuilder withDetailDataFrom(RectorCertificateDetail detail) {
            policy.Id_bhseg__c = policy.Certificado_Id_BHSeg__c =
                detail.codRamo +
                '|' +
                detail.nroPoliza +
                '|' +
                detail.nroCertificado;

            policy.Baja__c = Date.parse(detail.fecBaja);
            policy.Canal_1__c = detail.descCanalNivel1;
            policy.Canal_1_IdBHSeg__c = detail.codCanalNivel1;
            policy.Canal_2__c = detail.descCanalNivel2;
            policy.Canal_2_IdBHSeg__c = detail.codCanalNivel2;
            policy.Canal_4__c = detail.descCanalNivel4;
            policy.Canal_4_IdBHSeg__c = detail.codCanalNivel4;
            policy.Cuenta_Pago__c = detail.nroCuentaPago;
            policy.Domicilio__c = detail.descDomicilio;
            policy.Endoso_Desde__c = Date.parse(detail.fecDesdeEndoso);
            policy.Endoso_Hasta__c = Date.parse(detail.fecHastaEndoso);
            policy.Estado_IdBHSeg__c = detail.codEstCertificado;
            policy.Medio_de_Pago__c = detail.descMedioPago;
            policy.Medio_de_Pago_IdBHSeg__c = detail.codMedioPago;
            policy.Motivo_Endoso_IdBHSeg__c = detail.codMotivoEndoso;
            policy.Numero_Producto_Financiero__c = detail.nroProdFinanciero;
            policy.Origen_de_Pago__c = detail.descOrigenPago;
            policy.Origen_de_Pago_IdBHSeg__c = detail.codOrigenPago;
            policy.Producto_Financiero__c = detail.codIdProdFinanciero;
            policy.Producto_Financiero_IdBHSeg__c = detail.codTipProdFinanciero;
            policy.Productor__c = detail.descProductor;
            policy.Productor_IdBHSeg__c = detail.codProductor;
            policy.Tipo_Endoso__c = detail.descTipEndoso;
            policy.Tipo_Endoso_IdBHSeg__c = detail.codTipEndoso;
            policy.Ultimo_endoso__c = Decimal.valueOf(detail.nroUltimoEndoso);

            return this;
        }

        public PolicyBuilder forClient(Account c) {
            policy.Cuenta__c = c.id;
            return this;
        }

        public PolicyBuilder withPremio(Integer value) {
            policy.Premio__c = value;
            return this;
        }

        public PolicyBuilder withExpirationDate(Date value) {
            policy.Hasta__c = value;
            return this;
        }

        public PolicyBuilder withStatus(String value) {
            policy.Estado__c = value;
            return this;
        }

        public PolicyBuilder withTrade(String value) {
            policy.Ramo__c = value;
            return this;
        }

        public PolicyBuilder withTradeNumber(String value) {
            policy.Ramo_IdBHSeg__c = value;
            return this;
        }

        public PolicyBuilder withPlanIdBhSeg(String value) {
            //Jira 1205
            policy.Plan_IdBHSeg__c = value;
            return this;
        }

        public PolicyBuilder withProductor(String value) {
            //Jira 1205
            policy.Productor__c = value;
            return this;
        }

        public PolicyBuilder withProductorIdBhSeg(String value) {
            policy.Productor_IdBHSeg__c = value;
            return this;
        }

        public PolicyBuilder withPlan(String value) {
            //Jira 1205
            policy.Plan__c = value;
            return this;
        }

        public PolicyBuilder withFromDate(Date fromDate) {
            policy.Desde__c = fromDate;
            return this;
        }

        public PolicyBuilder optional(Boolean value) {
            policy.Optativa__c = value;
            return this;
        }

        public PolicyBuilder withPoliza(Integer value) {
            policy.Poliza__c = value;
            return this;
        }

        public PolicyBuilder withCertificado(Integer value) {
            policy.Certificado__c = value;
            return this;
        }

        public PolicyBuilder withCertificadoIdBhseg(String value) {
            policy.Certificado_Id_BHSeg__c = value;
            return this;
        }

        public PolicyBuilder withProducto(String value) {
            //Jira 1205
            policy.Producto__c = value;
            return this;
        }

        public PolicyBuilder withProductoIdBhSeg(String value) {
            //Jira 1205
            policy.Producto_IdBHSeg__c = value;
            return this;
        }

        public PolicyBuilder withIncluyeCamara(Boolean value) {
            //Jira 1205
            policy.Incluye_Camara__c = value;
            return this;
        }

        public PolicyBuilder withTipoEndosoIdBhseg(String value) {
            policy.Tipo_Endoso_IdBHSeg__c = value;
            return this;
        }

        public PolicyBuilder withOrigenDePago(String value) {
            policy.Origen_de_Pago__c = value;
            return this;
        }
        public PolicyBuilder withCuentaPago(String value) {
            policy.Cuenta_Pago__c = value;
            return this;
        }
        public PolicyBuilder withCertificado(Double value) {
            policy.Certificado__c = value;
            return this;
        }

        public PolicyBuilder withDescripcionProducto(String descripcion) {
            this.policy.Descripcion_Producto__c = descripcion;
            return this;
        }

        public PolicyBuilder withEndoso(Integer endoso) {
            this.policy.Endoso__c = endoso;
            return this;
        }

        public PolicyBuilder withEmision(Date emision) {
            this.policy.Emision__c = emision;
            return this;
        }

        public PolicyBuilder withCanal1(String canal) {
            this.policy.Canal_1__c = canal;
            return this;
        }

        public PolicyBuilder withCanal2(String canal) {
            this.policy.Canal_2__c = canal;
            return this;
        }

        public PolicyBuilder withPolizaAnterior(Decimal value) {
            this.policy.Poliza_anterior__c = value;
            return this;
        }

        public PolicyBuilder withCuenta(Account value) {
            this.policy.Cuenta__c = value.Id;
            return this;
        }

        public PolicyBuilder withIdBhseg(String value) {
            this.policy.Id_bhseg__c = value;
            return this;
        }

        public PolicyBuilder withVigente(Boolean value) {
            this.policy.Vigente__c = value;
            return this;
        }

        public PolicyBuilder withAsistencias(String value) {
            this.policy.Asistencias_Extras__c = value;
            return this;
        }

        public PolicyBuilder withAlertaDesignacionBeneficiarios(Boolean value) {
            this.policy.Alerta_Designacion_de_Beneficiarios__c = value;
            return this;
        }

        public PolicyBuilder withMarcaModelo(String value) {
            this.policy.Marca_Modelo__c = value;
            return this;
        }

        public PolicyBuilder withTipoDeBien(String value) {
            this.policy.Tipo_Bien__c = value;
            return this;
        }

        public PolicyBuilder withNumeroDeSerie(String value) {
            this.policy.Numero_Serie__c = value;
            return this;
        }

        Poliza__c policy = new Poliza__c();

        public Poliza__c build() {
            return policy;
        }
    }

    public static PolicyBuilder aPolicy() {
        return new PolicyBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Request
    //---------------------------------------------------------------------------------------------------------------------------
    public class RequestBuilder {
        public RequestBuilder(String recordTypeName) {
            RecordType rt = [
                SELECT Id, DeveloperName
                FROM RecordType
                WHERE /*SObjectType = 'Gestion__c' AND */ DeveloperName = :recordTypeName AND IsActive = TRUE
            ];

            req = new Gestion__c(recordtypeId = rt.Id);

            completeBuildData(recordTypeName);
        }

        public RequestBuilder() {
            req = new Gestion__c();

            completeBuildData('');
        }

        public void completeBuildData(String recordTypeName) {
            // Basicos
            req.Numero__c = 12564148;
            req.Estado__c = 'FINALIZADO';
            req.Estado_IdBHSeg__c = 'F';
            req.Observaciones__c = 'Envio de carta para la transformacion automatica';
            req.Ramo__c = 'VIDA';
            req.Ramo_IdBHSeg__c = '19';
            req.Producto_IdBHSeg__c = '611';
            req.Resultado__c = 'Envio de Carta de Transformacion';
            req.Resultado_IdBHSeg__c = '124';
            req.Tramite__c = 'ENVIO CARTA TRANSFORMACION';
            req.Tramite_IdBHSeg__c = '66';
            req.Novedad__c = 'Baja';
            req.Novedad_IdBHSeg__c = 'BAJ';
            req.Notificante__c = 'NOTIFICANTE= S/D RELACION= S/D TELEFONO= S/D DOMICILIO= S/D';
            req.Detalle_Endoso__c = 'ACEPTADO';
            req.Creado_en_Rector__c = true;
            req.Iniciada_por__c = 'B12345';

            req.Poliza__c = policy.id;
            req.Cuenta__c = policy.Cuenta__c;

            if (recordTypeName == 'Baja') {
                req.Motivo_Baja__c = 'Falta de pago';
                req.Motivo_Baja_IdBHSeg__c = '1';
                req.Numero_Fax__c = '1234568';
                req.Fecha_Registro_Fax__c = Date.parse('01/01/2014');
                req.Reintegro__c = true;
            }

            if (recordTypeName == 'Actualizacion_Nombre_Apellido') {
                req.Nombre_Original__c = 'Juan';
                req.Nombre_Modificado__c = 'Pedro';
                req.Apellido_Original__c = 'Perez';
                req.Apellido_Modificado__c = 'Peres';
            }

            if (recordTypeName == 'Reintegro_Extraordinario') {
                req.Medio_de_Pago__c = 'DEBITO DIRECTO';
                req.Origen_de_Pago__c = 'CBU';
                req.Cuenta_de_Pago__c = '2850590940090418135201';
                req.Monto_Reintegro__c = 100;
                req.Fecha_Reintegro__c = system.today();
            }

            if (recordTypeName == 'Declaracion_Siniestro') {
                req.Tipo_de_Siniestro__c = '5';
                req.Fecha_y_Hora_de_Ocurrencia__c = Datetime.now();
                req.Localidad_de_Ocurrencia__c = 'LOTE MAIZ NEGRO';
                req.Provincia_de_Ocurrencia__c = 'JUJUY';
                req.Causa_Siniestro__c = '9-9300';
                req.Codigo_de_Riesgo__c = 'RCA';
                req.Lugar_de_Ocurrencia__c = 'lugar';
                req.Descripcion__c = 'adsfasd';
                req.Detalle__c = 'direccion del cajero';
                req.Importe__c = 1000;
                req.Tipo_de_Documento_Notificante__c = 'D.N.I.';
                req.Numero_de_Documento_Notificante__c = '10489567';
                req.Nombre_Notificante__c = 'Pedro Paz';
                req.Relacion_Notificante__c = 'relacion';
                req.Telefono_Notificante__c = '15-4945-1235';
                req.Domicilio_Notificante__c = 'direccion notif.';
            }

            if (recordTypeName == 'Cambio_Medio_Pago') {
                req.Medio_de_Pago__c = 'DEBITO DIRECTO';
                req.Origen_de_Pago__c = 'CBU';
                req.Cuenta_de_Pago__c = '2850590940090418135201';
            }

            if (recordTypeName == 'Cambio_Plan') {
                req.Plan_Original__c = '012';
                req.Nuevo_Plan__c = '055';
            }

            if (recordTypeName == 'Retencion') {
                req.Plan_Original__c = '012';
                req.Nuevo_Plan__c = '012';
                req.Premio_Plan_Nuevo__c = 123;
            }

            if (recordTypeName == 'Cambio_de_Domicilio' || recordTypeName == 'Cambio_de_Domicilio_Bien_Asegurado') {
                req.Calle__c = 'La calle';
                req.Altura__c = '11235';
                req.Provincia__c = 'La provincia';
                req.Localidad__c = 'La localidad';
                req.Piso__c = '813';
                req.Departamento__c = 'TOA';
                req.Codigo_Postal__c = '5589';
            }
        }

        public RequestBuilder forClient(Account c) {
            req.Cuenta__c = c.Id;
            return this;
        }

        public RequestBuilder forCase(Case c) {
            req.Caso__c = c.Id;
            return this;
        }

        public RequestBuilder forPolicy(Poliza__c p) {
            policy = p;
            req.Poliza__c = policy.id;
            req.Cuenta__c = policy.Cuenta__c;
            return this;
        }

        public RequestBuilder clearMockData() {
            this.req.clear();
            return this;
        }

        public RequestBuilder withMotivoDeBaja(String motivo) {
            this.req.Motivo_Baja__c = motivo;
            return this;
        }

        public RequestBuilder withResultado(String resultado) {
            this.req.Resultado__c = resultado;
            return this;
        }

        public RequestBuilder withIntentosDeEnvioFallidos(Integer value) {
            this.req.Intentos_de_Envio_Fallidos__c = value;
            return this;
        }

        public RequestBuilder withoutObservations() {
            req.Observaciones__c = null;
            return this;
        }

        public RequestBuilder notCreatedInRector() {
            req.Creado_en_Rector__c = false;
            return this;
        }

        public RequestBuilder withRectorStatus(String status) {
            req.Estado_Comunicacion_Rector__c = status;
            return this;
        }

        public RequestBuilder withOccurrenceProvince(String prov) {
            req.Provincia_de_Ocurrencia__c = prov;
            return this;
        }

        public RequestBuilder withOccurrenceRegione(String reg) {
            req.Localidad_de_Ocurrencia__c = reg;
            return this;
        }

        public RequestBuilder withOccurrenceDateTime(DateTime datetim) {
            req.Fecha_y_Hora_de_Ocurrencia__c = datetim;
            return this;
        }

        public RequestBuilder withNumber(String num) {
            req.Numero__c = Decimal.valueOf(num);
            return this;
        }

        public RequestBuilder withoutRequestNumber() {
            req.Numero__c = null;
            return this;
        }

        public RequestBuilder withStatus(String sta) {
            req.Estado__c = sta;
            return this;
        }

        public RequestBuilder withRamo(String branchDescription) {
            req.Ramo__c = branchDescription;
            return this;
        }

        public RequestBuilder withRamoIdBhseg(String branchCode) {
            req.Ramo_idbhseg__c = branchCode;
            return this;
        }

        public RequestBuilder withProductoIdBhseg(String productCode) {
            req.Producto_IdBHSeg__c = productCode;
            return this;
        }

        public RequestBuilder withtipo(String tipo) {
            req.Tipo_de_Siniestro__c = tipo;
            return this;
        }

        public RequestBuilder withStatusId(String staId) {
            req.Estado_IdBHSeg__c = staId;
            return this;
        }

        public RequestBuilder withEndorsement(String endor) {
            req.Detalle_Endoso__c = endor;
            return this;
        }

        public RequestBuilder appliesToAllPolicies(Boolean val) {
            req.Aplicar_a_todas_las_polizas__c = val;
            return this;
        }

        public RequestBuilder withObservaciones(String observations) {
            this.req.Observaciones__c = observations;
            return this;
        }

        public RequestBuilder withRecordType(String recordTypeDeveloperName) {
            RecordType recordtype = [
                SELECT Id
                FROM RecordType
                WHERE SObjectType = 'Gestion__c' AND DeveloperName = :recordTypeDeveloperName AND IsActive = TRUE
            ];
            this.req.RecordType = recordtype;
            this.req.RecordTypeId = recordtype.Id;
            return this;
        }

        public RequestBuilder withTramite(String tramite) {
            this.req.Tramite__c = tramite;
            return this;
        }

        public RequestBuilder withTramiteIdBhSeg(String code) {
            this.req.Tramite_idbhseg__c = code;
            return this;
        }

        public RequestBuilder withFecha(Datetime requestDate) {
            this.req.Fecha__c = requestDate;
            return this;
        }

        Poliza__c policy = new Poliza__c();
        Gestion__c req;

        public Gestion__c build() {
            return req;
        }
    }

    public static RequestBuilder aRequest() {
        return new RequestBuilder();
    }
    public static RequestBuilder aRequest(String recordTypeName) {
        return new RequestBuilder(recordTypeName);
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ClientRequestDataRetrieverMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClientRequestDataRetrieverMockBuilder {
        public ClientRequestDataRetrieverMockBuilder withRequest(Gestion__c r) {
            request = r;
            return this;
        }

        public ClientRequestDataRetrieverMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        public ClientRequestDataRetrieverMockBuilder forPolicy(Poliza__c p) {
            certId = p.Poliza__c + ' / ' + p.Certificado__c;
            return this;
        }

        String certId;
        Gestion__c request = new Gestion__c();
        Boolean syntaxisError = false;

        public ClientRequestDataRetrieverMock build() {
            ClientRequestDataRetrieverMock mock = new ClientRequestDataRetrieverMock(request, certId, syntaxisError);

            return mock;
        }
    }

    public static ClientRequestDataRetrieverMockBuilder aClientRequestDataRetrieverMock() {
        return new ClientRequestDataRetrieverMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RectorCertificateDetail
    //---------------------------------------------------------------------------------------------------------------------------
    public class RectorCertificateDetailBuilder {
        RectorCertificateDetailBuilder() {
            certDetail.codRamo = '19';
            certDetail.codProducto = '100';
            certDetail.descRamo = 'VIDA';
            certDetail.descProducto = 'VIDA 24';
            certDetail.nroPoliza = '23';
            certDetail.nroCertificado = '21389';
            certDetail.nroEndoso = '7960';
            certDetail.nroUltimoEndoso = '7960';
            certDetail.nroPolizaAnterior = '20';
            certDetail.codProductor = '414';
            certDetail.descProductor = 'BANCO HIPOTECARIO';
            certDetail.fecEmision = '09/04/2013';
            certDetail.fecDesdeCertificado = '01/01/2015';
            certDetail.fecHastaCertificado = '30/06/2015';
            certDetail.fecDesdeEndoso = '01/01/2015';
            certDetail.fecHastaEndoso = '30/06/2015';
            certDetail.codEstCertificado = '11';
            certDetail.descEstCertificado = 'ANULADO';
            certDetail.fecBaja = '31/03/2008';
            certDetail.codMoneda = '80';
            certDetail.codTipEndoso = 'A';
            certDetail.descTipEndoso = 'ANULACION';
            certDetail.codMotivoEndoso = '5';
            certDetail.descMotivoEndoso = 'MORA';
            certDetail.codMedioPago = '2';
            certDetail.descMedioPago = 'TARJETA DE CREDITO';
            certDetail.codOrigenPago = '05';
            certDetail.descOrigenPago = 'VISA';
            certDetail.nroCuentaPago = '4304960004731964';
            certDetail.codTipProdFinanciero = '203';
            certDetail.codIdProdFinanciero = 'SMART OPEN';
            certDetail.nroProdFinanciero = '0160330935';
            certDetail.codCanalNivel1 = '2';
            certDetail.descCanalNivel1 = 'TELEMARKETING';
            certDetail.codCanalNivel2 = '1102';
            certDetail.descCanalNivel2 = 'CALL CENTER BH';
            certDetail.codCanalNivel4 = '2570';
            certDetail.descCanalNivel4 = 'CAAMA?O , JUAN MANUEL';
            certDetail.codProvRiesgo = '1';
            certDetail.descProvRiesgo = 'CAPITAL FEDERAL';
            certDetail.premio = '20';
            certDetail.sello = '0';
            certDetail.descDomicilio = 'JUAN XXIII 460   - GODOY CRUZ - MENDOZA (5501)';
            certDetail.imei = '123456';
            certDetail.ddjj = 'S';
        }

        public RectorCertificateDetailBuilder forBrief(RectorCertificateBrief brief) {
            certDetail.codRamo = brief.cramo;
            certDetail.codProducto = brief.cprod;
            certDetail.nroPoliza = brief.poliza;
            certDetail.nroCertificado = brief.certif;
            certDetail.nroEndoso = brief.endoso;
            return this;
        }

        RectorCertificateDetail certDetail = new RectorCertificateDetail();

        public RectorCertificateDetail build() {
            return certDetail;
        }
    }

    public static RectorCertificateDetailBuilder aRectorCertificateDetail() {
        return new RectorCertificateDetailBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RectorCertificateBrief
    //---------------------------------------------------------------------------------------------------------------------------
    public class RectorCertificateBriefBuilder {
        RectorCertificateBriefBuilder() {
            certBrief.dempresa = 'BHN VIDA';
            certBrief.csucu = '1';
            certBrief.dprod = 'VIDA 24';
            certBrief.cprod = '100';
            certBrief.PLAN = '002';
            certBrief.dplan = 'OPCION A';
            certBrief.poliza = '23';
            certBrief.pol_ant = '20';
            certBrief.tipoPoliza = 'I';
            certBrief.certif = '21389';
            certBrief.endoso = '7960';
            certBrief.dmotiv = 'MORA';
            certBrief.tomador = '414';
            certBrief.fe_emision = '13/02/2008';
            certBrief.fe_vdesde = '05/02/2008';
            certBrief.fe_vhasta = '31/12/2008';
            certBrief.estado = 'VIGENTE';
            certBrief.cramo = '19';
            certBrief.dramo = 'VIDA';
            certBrief.premio = '20';
            certBrief.obligatorio = 'SI';
            certBrief.suma_aseg = '200.5';
            certBrief.esAutogestion = 'S';
            certBrief.mdpCode = '2';
            certBrief.mdpDescription = 'TARJETA DE CREDITO';
            certBrief.odpCode = '05';
            certBrief.odpDescription = 'VISA';
            certBrief.numeroCuenta = '4304960004731964';
        }

        public RectorCertificateBriefBuilder withExpireDate(String expireDate) {
            certBrief.fe_vhasta = expireDate;

            return this;
        }

        RectorCertificateBrief certBrief = new RectorCertificateBrief();

        public RectorCertificateBrief build() {
            return certBrief;
        }
    }

    public static RectorCertificateBriefBuilder aRectorCertificateBrief() {
        return new RectorCertificateBriefBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RectorClaim
    //---------------------------------------------------------------------------------------------------------------------------
    public class RectorClaimBuilder {
        public RectorClaimBuilder() {
            claim.nro_siniestro = '74';
            claim.fec_declaracion = '08/04/2008';
            claim.fec_ocurrencia = '27/02/2008';
            claim.cod_riesgo = 'MM4';
            claim.desc_riesgo = 'MUERTE PERSONALES MUT. LA RIOJA-SDO DEU.';
            claim.cod_causal = '100';
            claim.desc_causal = 'MUERTE';
            claim.descripcion =
                'Siniestro de Vida RESOLUCION FAVORABLE, se procede a la cancelación de la deuda informada ' +
                'por el Banco Hipotecario S.A. a fecha de siniestro. En caso de que desee realizar una ' +
                'consulta respecto al estado del producto financiero, se deberá contactar con el Banco  ' +
                'al teléfono 0810-222-2472 o bien presentándose en forma personal en una sucursal del BH.';
            claim.estado_siniestro = 'CERRADO CON PAGO';
            claim.fe_estado_siniestro = '08/07/2008';
        }

        RectorClaim claim = new RectorClaim();

        public RectorClaim build() {
            return claim;
        }
    }

    public static RectorClaimBuilder aRectorClaim() {
        return new RectorClaimBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RectorClaimNote
    //---------------------------------------------------------------------------------------------------------------------------
    public class RectorClaimNoteBuilder {
        public RectorClaimNoteBuilder() {
            claimNote.nu_nota = '9';
            claimNote.tipo_nota = 'Observaci?n';
            claimNote.fe_nota = '14/04/2008';
            claimNote.de_nota =
                'Siniestro de Vida RESOLUCION FAVORABLE, se procede a la cancelaci?n de la deuda informada ' +
                'por el Banco Hipotecario S.A. a fecha de siniestro. En caso de que desee realizar una ' +
                'consulta respecto al estado del producto financiero, se deber? contactar con el Banco  ' +
                'al tel?fono 0810-222-2472 o bien present?ndose en forma personal en una sucursal del BH.';
        }

        public RectorClaimNoteBuilder withDate(String noteDate) {
            claimNote.fe_nota = noteDate;
            return this;
        }

        public RectorClaimNoteBuilder withDescription(String noteDesc) {
            claimNote.de_nota = noteDesc;
            return this;
        }

        public RectorClaimNoteBuilder withNumber(String noteNum) {
            claimNote.nu_nota = noteNum;
            return this;
        }

        public RectorClaimNoteBuilder withType(String noteType) {
            claimNote.tipo_nota = noteType;
            return this;
        }

        RectorClaimNote claimNote = new RectorClaimNote();

        public RectorClaimNote build() {
            return claimNote;
        }
    }

    public static RectorClaimNoteBuilder aRectorClaimNote() {
        return new RectorClaimNoteBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ProductClaimDataRetrieverMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class ProductClaimDataRetrieverMockBuilder {
        public ProductClaimDataRetrieverMockBuilder withClaim(RectorClaim c) {
            claim = c;
            return this;
        }

        public ProductClaimDataRetrieverMockBuilder withClaimNote(RectorClaimNote n) {
            claimNotes.add(n);
            return this;
        }

        public ProductClaimDataRetrieverMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        RectorClaim claim;
        List<RectorClaimNote> claimNotes = new List<RectorClaimNote>();
        Boolean syntaxisError = false;

        public ProductClaimDataRetrieverMock build() {
            ProductClaimDataRetrieverMock mock = new ProductClaimDataRetrieverMock(claim, claimNotes, syntaxisError);

            return mock;
        }
    }

    public static ProductClaimDataRetrieverMockBuilder aProductClaimDataRetrieverMock() {
        return new ProductClaimDataRetrieverMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Claim
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClaimBuilder {
        public ClaimBuilder() {
            claim.Numero__c = 74;
        }

        public ClaimBuilder withDataFrom(RectorClaim c) {
            Map<String, String> estados = new Map<String, String>{
                '1' => 'Creado', 
                '2' => 'Pendiente', 
                '3' => 'Análisis', 
                '4' => 'Perito',
                '5' => 'Plazos Suspendidos',
                '6' => 'Liquidación',
                '7' => 'Rechazado',
                '8' => 'Baja',
                '9' => 'Cerrado con Pago'
            };
            claim.Numero__c = Decimal.valueOf(c.nro_siniestro);
            claim.Declaracion__c = Date.parse(c.fec_declaracion);
            claim.Ocurrencia__c = Date.parse(c.fec_ocurrencia);
            claim.Riesgo_IdBHSeg__c = c.cod_riesgo;
            claim.Riesgo__c = c.desc_riesgo;
            claim.Causal_IdBHSeg__c = c.cod_causal;
            claim.Causal__c = c.desc_causal;
            claim.Descripcion__c = c.descripcion;
            claim.Estado__c = estados.get(c.estado_siniestro);
            claim.Fecha_Cambio_de_Estado__c = Date.parse(c.fe_estado_siniestro);

            return this;
        }

        public ClaimBuilder forClient(Account c) {
            claim.Cuenta__c = c.Id;

            return this;
        }

        public ClaimBuilder forPolicy(Poliza__c p) {
            claim.Poliza__c = p.Id;

            return this;
        }

        public ClaimBuilder withOnlyBasicData() {
            fillData = false;

            return this;
        }

        public ClaimBuilder withIdDataFrom(SimplicidadClaim simpClaim) {
            claim.Numero__c = Decimal.valueOf(simpClaim.nroSiniestro);
            claim.Numero_Anio__c = simpClaim.nroAnnio;
            claim.Ramo_IdBHSeg__c = simpClaim.codRamo;

            return this;
        }

        Siniestro__c claim = new Siniestro__c();
        Boolean fillData = true;

        public Siniestro__c build() {
            if (fillData) {
                claim.Declaracion__c = Date.parse('08/04/2008');
                claim.Ocurrencia__c = Date.parse('27/02/2008');
                claim.Riesgo_IdBHSeg__c = 'MM4';
                claim.Riesgo__c = 'MUERTE PERSONALES MUT. LA RIOJA-SDO DEU.';
                claim.Causal_IdBHSeg__c = '100';
                claim.Causal__c = 'MUERTE';
                claim.Descripcion__c =
                    'Siniestro de Vida RESOLUCION FAVORABLE, se procede a la cancelaci?n de la informada ' +
                    'por el Banco Hipotecario S.A. a fecha de siniestro. En caso de que desee realizar una ' +
                    'consulta respecto al estado del producto financiero, se deber? contactar con el Banco  ' +
                    'al tel?fono 0810-222-2472 o bien present?ndose en forma personal en una sucursal del BH.';
                claim.Estado__c = 'Baja';
                claim.Fecha_Cambio_de_Estado__c = Date.parse('08/07/2008');
            }

            return claim;
        }
    }

    public static ClaimBuilder aClaim() {
        return new ClaimBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ClaimNote
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClaimNoteBuilder {
        public ClaimNoteBuilder() {
            claimNote.Numero__c = 9;
            claimNote.Tipo__c = 'Observaci?n';
            claimNote.Fecha__c = Date.parse('30/04/2008');
            claimNote.Descripcion__c =
                'Siniestro de Vida RESOLUCION FAVORABLE, se procede a la  de la deuda informada ' +
                'por el Banco Hipotecario S.A. a fecha de siniestro. En caso de que desee realizar una ' +
                'consulta respecto al estado del producto financiero, se deber? con el Banco Hipotecario ' +
                'al tel?fono 0810-222-2472 o bien present?ndose en forma personal en una sucursal del BH.';
        }

        public ClaimNoteBuilder withDataFrom(RectorClaimNote n) {
            claimNote.Numero__c = Decimal.valueOf(n.nu_nota);
            claimNote.Tipo__c = n.tipo_nota;
            claimNote.Descripcion__c = n.de_nota;
            claimNote.Fecha__c = Date.parse(n.fe_nota);

            return this;
        }

        public ClaimNoteBuilder forClient(Account c) {
            claimNote.Cuenta__c = c.Id;

            return this;
        }

        public ClaimNoteBuilder forClaim(Siniestro__c s) {
            claimNote.Siniestro__c = s.Id;

            return this;
        }

        Nota__c claimNote = new Nota__c();

        public Nota__c build() {
            return claimNote;
        }
    }

    public static ClaimNoteBuilder aClaimNote() {
        return new ClaimNoteBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // ClaimDocument
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClaimDocumentBuilder {
        Documentacion_Siniestro__c claimDocument = new Documentacion_Siniestro__c();

        public ClaimDocumentBuilder() {        }

        public ClaimDocumentBuilder forClaim(Siniestro__c c) {
            claimDocument.Siniestro__c = c.Id;
            return this;
        }

        public ClaimDocumentBuilder withCodTipoDocumento(Integer value) {
            claimDocument.Cod_Tipo_Documento__c = value;
            return this;
        }

        public ClaimDocumentBuilder withDetalleTipoDocumento(String value) {
            claimDocument.Detalle_Tipo_Documento__c = value;
            return this;
        }
        public ClaimDocumentBuilder withFechaMesaEntrada(Date valueDate) {
            claimDocument.Fecha_Mesa_Entrada__c  = valueDate;
            return this;
        }

        public ClaimDocumentBuilder withCodRamo(Integer value) {
            claimDocument.Cod_Ramo__c = value;
            return this;
        }

        public ClaimDocumentBuilder withNumeroSiniestro(Integer value) {
            claimDocument.Numero_Siniestro__c = value;
            return this;
        }

        public ClaimDocumentBuilder withFechaRecepcion(Date valueDate) {
            claimDocument.Fecha_Recepcion__c = valueDate;
            return this;
        }

        public Documentacion_Siniestro__c build() {
            return this.claimDocument;
        }
    }

    public static ClaimDocumentBuilder aClaimDocument() {
        return new ClaimDocumentBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // RequestSenderMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class RequestSenderMockBuilder {
        public RequestSenderMockBuilder withRequest(Request r) {
            request = r;
            return this;
        }

        Request request;

        public RequestSenderMock build() {
            RequestSenderMock mock = new RequestSenderMock(request);

            return mock;
        }
    }

    public static RequestSenderMockBuilder aRequestSenderMock() {
        return new RequestSenderMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // CancellationRequest
    //---------------------------------------------------------------------------------------------------------------------------
    public class CancellationRequestBuilder {
        public CancellationRequestBuilder() {
            request.clienteCuit = '20238204454';
            request.ramo = '09';
            request.poliza = '25';
            request.certificado = '439';
            request.estado = 'D';
            request.observaciones = 'observaciones';
            request.tipoTramite = '49';
            request.tipoNovedad = 'BAJ';
            request.canal1 = '1007';
            request.canal2 = '0';
            request.canal4 = '12321';
            request.resultado = '112';
            request.bajcodigoMotivoBaja = '1';
            request.bajreintegro = '0';
            request.bajnumfax = '1234568';
            request.bajfechaRegitroFax = '01/01/2014';
        }

        CancellationRequest request = new CancellationRequest();

        public CancellationRequest build() {
            return request;
        }
    }

    public static CancellationRequestBuilder aCancellationRequest() {
        return new CancellationRequestBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Beneficiary
    //---------------------------------------------------------------------------------------------------------------------------
    public class BeneficiaryBuilder {
        public BeneficiaryBuilder() {
            beneficiary.Fecha_de_Inclusion__c = Date.parse('27/02/2008');
            beneficiary.Fecha_de_Nacimiento__c = Date.parse('08/04/2008');
            beneficiary.Nombre_Completo__c = 'Pepito Peres';
            beneficiary.Numero_de_Documento__c = '12.345.678';
            beneficiary.Observaciones__c = 'Observaciones';
            beneficiary.Parentesco__c = 'PADRE';
            beneficiary.Porcentaje__c = 100;
            beneficiary.Tipo_de_Documento__c = 'D.N.I.';
        }

        public BeneficiaryBuilder withCompleteName(String name) {
            beneficiary.Nombre_Completo__c = name;

            return this;
        }

        public BeneficiaryBuilder withPercentage(Decimal per) {
            beneficiary.Porcentaje__c = per;

            return this;
        }

        public BeneficiaryBuilder forPolicy(Poliza__c p) {
            beneficiary.Poliza__c = p.Id;

            return this;
        }

        public BeneficiaryBuilder forRequest(Gestion__c req) {
            beneficiary.Gestion__c = req.Id;

            return this;
        }

        public BeneficiaryBuilder withRelationship(Parentesco__c rel) {
            beneficiary.Parentesco__c = rel.Descripcion__c;

            return this;
        }

        Beneficiario__c beneficiary = new Beneficiario__c();

        public Beneficiario__c build() {
            return beneficiary;
        }
    }

    public static BeneficiaryBuilder aBeneficiary() {
        return new BeneficiaryBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RequestBeneficiary
    //---------------------------------------------------------------------------------------------------------------------------
    public class RequestBeneficiaryBuilder {
        public RequestBeneficiaryBuilder() {
            beneficiary.Fecha_de_Inclusion__c = Date.parse('27/02/2008');
            beneficiary.Fecha_de_Nacimiento__c = Date.parse('08/04/2008');
            beneficiary.Nombre_Completo__c = 'Pepito Peres';
            beneficiary.Numero_de_Documento__c = '12.345.678';
            beneficiary.Observaciones__c = 'Observaciones';
            beneficiary.Parentesco__c = 'PADRE';
            beneficiary.Porcentaje__c = 100;
            beneficiary.Tipo_de_Documento__c = 'D.N.I.';
        }

        public RequestBeneficiaryBuilder withCompleteName(String name) {
            beneficiary.Nombre_Completo__c = name;

            return this;
        }

        public RequestBeneficiaryBuilder withPercentage(Decimal per) {
            beneficiary.Porcentaje__c = per;

            return this;
        }

        public RequestBeneficiaryBuilder forPolicy(Poliza__c p) {
            beneficiary.Poliza__c = p.Id;

            return this;
        }

        public RequestBeneficiaryBuilder forRequest(Gestion__c req) {
            beneficiary.Gestion__c = req.Id;

            return this;
        }

        public RequestBeneficiaryBuilder withRelationship(Parentesco__c rel) {
            beneficiary.Parentesco__c = rel.Descripcion__c;

            return this;
        }

        Beneficiario_de_Gestion__c beneficiary = new Beneficiario_de_Gestion__c();

        public Beneficiario_de_Gestion__c build() {
            return beneficiary;
        }
    }

    public static RequestBeneficiaryBuilder aRequestBeneficiary() {
        return new RequestBeneficiaryBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // BeneficiaryChangeRequest
    //---------------------------------------------------------------------------------------------------------------------------
    public class BeneficiaryChangeRequestBuilder {
        public BeneficiaryChangeRequestBuilder() {
            request.clienteCuit = '20238204454';
            request.ramo = '09';
            request.poliza = '25';
            request.certificado = '439';
            request.estado = 'P';
            request.observaciones = 'observaciones';
            request.tipoTramite = '54';
            request.tipoNovedad = 'BEN';
            request.canal1 = '1007';
            request.canal2 = '0';
            request.canal4 = '12321';
            request.resultado = '112';
        }

        public BeneficiaryChangeRequestBuilder withBeneficiary(Beneficiario_de_Gestion__c ben) {
            BeneficiaryChangeData benData = new BeneficiaryChangeData();
            benData.benTipoDocBeneficiario = XMLDataConversion.docTypeToXml(ben.Tipo_de_Documento__c);
            benData.benNumDocBeneficiario = ben.Numero_de_Documento__c;
            benData.benNomBeneficiario = ben.Nombre_Completo__c;
            benData.benParentescoBeneficiario = XMLDataConversion.relationshipToXml(ben.Parentesco__c);
            benData.benPorcParticipacionBeneficiario = ben.Porcentaje__c.toPlainString();
            benData.benFecNacBeneficiario = ben.Fecha_de_Nacimiento__c.format();
            benData.benObservacionesBeneficiario = ben.Observaciones__c;
            benData.benFechaInclusionBeneficiario = ben.Fecha_de_Inclusion__c.format();
            request.beneficiaries.add(benData);

            return this;
        }

        BeneficiaryChangeRequest request = new BeneficiaryChangeRequest();

        public BeneficiaryChangeRequest build() {
            return request;
        }
    }

    public static BeneficiaryChangeRequestBuilder aBeneficiaryChangeRequest() {
        return new BeneficiaryChangeRequestBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // BeneficiaryUpdateRequest
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClientNameUpdateRequestBuilder {
        public ClientNameUpdateRequestBuilder() {
            request.clienteCuit = '20238204454';
            request.ramo = '09';
            request.poliza = '25';
            request.certificado = '439';
            request.estado = 'P';
            request.observaciones = '38';
            request.tipoTramite = '38';
            request.tipoNovedad = 'NOM';
            request.canal1 = '1007';
            request.canal2 = '0';
            request.canal4 = '12321';
            request.resultado = '62';
            request.nomNombreOrigen = 'RUBEN EDUARDO';
            request.nomApellidoOrigen = 'DONNET';
            request.nomNombreDestino = 'RUBEN EDUARDO';
            request.nomApellidoDestino = 'DONNETrrrr';
        }

        ClientNameUpdateRequest request = new ClientNameUpdateRequest();

        public ClientNameUpdateRequest build() {
            return request;
        }
    }

    public static ClientNameUpdateRequestBuilder aClientNameUpdateRequest() {
        return new ClientNameUpdateRequestBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // PlanChangeRequest
    //---------------------------------------------------------------------------------------------------------------------------
    public class PlanChangeRequestBuilder {
        public PlanChangeRequestBuilder() {
            request.clienteCuit = '20238204454';
            request.ramo = '09';
            request.poliza = '25';
            request.certificado = '439';
            request.estado = 'P';
            request.observaciones = 'observaciones';
            request.tipoTramite = '51';
            request.tipoNovedad = 'PLN';
            request.canal1 = '1007';
            request.canal2 = '0';
            request.canal4 = '12321';
            request.resultado = '62';
            request.comComboOrigen = '013';
            request.comComboDestino = '003';
        }

        PlanChangeRequest request = new PlanChangeRequest();

        public PlanChangeRequest build() {
            return request;
        }
    }

    public static PlanChangeRequestBuilder aPlanChangeRequest() {
        return new PlanChangeRequestBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ProfesionChangeRequest
    //---------------------------------------------------------------------------------------------------------------------------
    public class ProfesionChangeRequestBuilder {
        public ProfesionChangeRequestBuilder() {
            request.clienteCuit = '20238204454';
            request.ramo = '09';
            request.poliza = '25';
            request.certificado = '439';
            request.estado = 'P';
            request.observaciones = 'observaciones';
            request.tipoTramite = '58';
            request.tipoNovedad = 'PRF';
            request.canal1 = '1007';
            request.canal2 = '0';
            request.canal4 = '12321';
            request.resultado = '116';
            request.profCodigoProfesion = '30701';
            request.profCodigoRelacionLaboral = '3';
        }

        ProfesionChangeRequest request = new ProfesionChangeRequest();

        public ProfesionChangeRequest build() {
            return request;
        }
    }

    public static ProfesionChangeRequestBuilder aProfesionChangeRequest() {
        return new ProfesionChangeRequestBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // EnquiryRequest
    //---------------------------------------------------------------------------------------------------------------------------
    public class EnquiryRequestBuilder {
        public EnquiryRequestBuilder() {
            request.clienteCuit = '20238204454';
            request.ramo = '09';
            request.poliza = '25';
            request.certificado = '439';
            request.estado = 'P';
            request.observaciones = 'observaciones';
            request.tipoTramite = '50';
            request.tipoNovedad = 'CNS';
            request.canal1 = '1007';
            request.canal2 = '0';
            request.canal4 = '12321';
            request.resultado = '108';
            request.tipoConsultaId = '29';
            request.tipoConsultaDescripcion = 'descripcion';
        }

        EnquiryRequest request = new EnquiryRequest();

        public EnquiryRequest build() {
            return request;
        }
    }

    public static EnquiryRequestBuilder anEnquiryRequest() {
        return new EnquiryRequestBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ClaimRequest
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClaimRequestBuilder {
        public ClaimRequestBuilder() {
            request.clienteCuit = '20238204454';
            request.ramo = '09';
            request.poliza = '25';
            request.certificado = '439';
            request.estado = 'P';
            request.observaciones = 'observaciones';
            request.tipoTramite = '58';
            request.tipoNovedad = 'PRF';
            request.canal1 = '1007';
            request.canal2 = '0';
            request.canal4 = '12321';
            request.resultado = '116';
            request.sinTipoSiniestro = '5';
            request.sinFechaOcurrencia = '05/11/2014';
            request.sinHoraOcurrencia = '16:99';
            request.sinLocalidadOcurrencia = '14431';
            request.sinProvinciaOcurrencia = '1';
            request.sinCausa = '9-9300';
            request.sinCodigoRiesgo = 'RCA';
            request.sinLugar = 'lugar';
            request.sinDescripcion = 'asdfasd';
            request.sinDetalle = 'direccion del cajero';
            request.sinImporte = '1000';
            request.sinTipoDocumentoDocNotificante = '01';
            request.sinNumeroDocumentoDocumentoNotificante = '20114415';
            request.sinNombreNotificante = 'nombre Notif';
            request.sinRelacionNotificante = 'relacion';
            request.sinTelefonoNotificante = '0';
            request.sinDomicilioNotificante = '0';
            request.sinNumDoc = '3';
        }

        ClaimRequest request = new ClaimRequest();

        public ClaimRequest build() {
            return request;
        }
    }

    public static ClaimRequestBuilder aClaimRequest() {
        return new ClaimRequestBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RequestGeneratorMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class RequestGeneratorMockBuilder {
        public RequestGeneratorMockBuilder withField(String fieldName, String fieldId) {
            customFields.put(fieldName, fieldId);

            return this;
        }

        Map<String, String> customFields = new Map<String, String>();

        public RequestGeneratorMock build() {
            RequestGeneratorMock mock = new RequestGeneratorMock(customFields);

            return mock;
        }
    }

    public static RequestGeneratorMockBuilder aRequestGeneratorMock() {
        return new RequestGeneratorMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RecordType
    //---------------------------------------------------------------------------------------------------------------------------
    public class RecordTypeBuilder {
        public RecordTypeBuilder() {
            recordType.Name = 'Nuevo RT';
        }

        public RecordTypeBuilder withName(String name) {
            recordType.Name = name;
            return this;
        }

        RecordType recordType = new RecordType();

        public RecordType build() {
            return recordType;
        }
    }

    public static RecordTypeBuilder aRecordType() {
        return new RecordTypeBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // EMailUpdateRequest
    //---------------------------------------------------------------------------------------------------------------------------
    public class EMailUpdateRequestBuilder {
        public EMailUpdateRequestBuilder() {
            request.clienteCuit = '20238204454';
            request.ramo = '0';
            request.poliza = '0';
            request.certificado = '0';
            request.estado = 'P';
            request.observaciones = '';
            request.tipoTramite = '70';
            request.tipoNovedad = 'EMA';
            request.canal1 = '1007';
            request.canal2 = '0';
            request.canal4 = '12321';
            request.resultado = '127';
            request.mailCodMailPrincipal = '14';
            request.mailMailPrincipal = 'mail1@mail.com';
            request.mailCodMailAlternatico = '13';
            request.mailMailAlternativo = 'mail2@mail.com';
        }

        public EMailUpdateRequestBuilder withEmail(String mail) {
            request.mailMailPrincipal = mail;
            return this;
        }

        public EMailUpdateRequestBuilder withAltEmail(String mail) {
            request.mailMailAlternativo = mail;
            return this;
        }

        EMailUpdateRequest request = new EMailUpdateRequest();

        public EMailUpdateRequest build() {
            return request;
        }
    }

    public static EMailUpdateRequestBuilder anEMailUpdateRequest() {
        return new EMailUpdateRequestBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // SendRequestToRectorBatchMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class SendRequestToRectorBatchMockBuilder {
        public SendRequestToRectorBatchMockBuilder withResult(Boolean r) {
            result = r;
            return this;
        }

        Boolean result;

        public SendRequestToRectorBatchMock build() {
            SendRequestToRectorBatchMock mock = new SendRequestToRectorBatchMock(result);

            return mock;
        }
    }

    public static SendRequestToRectorBatchMockBuilder aSendRequestToRectorBatchMock() {
        return new SendRequestToRectorBatchMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // PhoneUpdateRequest
    //---------------------------------------------------------------------------------------------------------------------------
    public class PhoneUpdateRequestBuilder {
        public PhoneUpdateRequestBuilder() {
            request.clienteCuit = '20238204454';
            request.ramo = '0';
            request.poliza = '0';
            request.certificado = '0';
            request.estado = 'P';
            request.observaciones = '';
            request.tipoTramite = '71';
            request.tipoNovedad = 'TEL';
            request.canal1 = '1007';
            request.canal2 = '0';
            request.canal4 = '12321';
            request.resultado = '126';
            // Tel particular
            request.telefonoParticularPais = '54';
            request.telefonoParticularArea = '11';
            request.telefonoParticularPrefijo = '';
            request.telefonoParticularCaracterista = '1234';
            request.telefonoParticularNumero = '5678';
            request.telefonoParticularInterno = '111';
            request.telefonoParticularHorario = '';
            // Tel alternativo
            request.telefonoAlternativoPais = '54';
            request.telefonoAlternativoArea = '11';
            request.telefonoAlternativoPrefijo = '';
            request.telefonoAlternativoCaracterista = '4321';
            request.telefonoAlternativoNumero = '8765';
            request.telefonoAlternativoInterno = '222';
            request.telefonoAlternativoHorario = '';
            // Tel celular
            request.telefonoCelularPais = '54';
            request.telefonoCelularArea = '11';
            request.telefonoCelularPrefijo = '15';
            request.telefonoCelularCaracterista = '1111';
            request.telefonoCelularNumero = '2222';
            request.telefonoCelularInterno = '';
            request.telefonoCelularHorario = '';
        }

        PhoneUpdateRequest request = new PhoneUpdateRequest();

        public PhoneUpdateRequest build() {
            return request;
        }
    }

    public static PhoneUpdateRequestBuilder aPhoneUpdateRequest() {
        return new PhoneUpdateRequestBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Relationship
    //---------------------------------------------------------------------------------------------------------------------------
    public class RelationshipBuilder {
        RelationshipBuilder() {
            relationship.Name = '1';
            relationship.Descripcion__c = 'PADRE';
        }

        Parentesco__c relationship = new Parentesco__c();

        public RelationshipBuilder withDesc(String descrip) {
            relationship.Descripcion__c = descrip;
            return this;
        }

        public RelationshipBuilder withCode(String code) {
            relationship.Name = code;
            return this;
        }

        public Parentesco__c build() {
            return relationship;
        }
    }

    public static RelationshipBuilder aRelationship() {
        return new RelationshipBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RectorComponent
    //---------------------------------------------------------------------------------------------------------------------------
    public class RectorComponentBuilder {
        RectorComponentBuilder() {
            component.cod_concepto = 'SUM         ';
            component.desc_concepto = 'SUMA ASEGURADA                          ';
            component.fecha = '02/10/2014';
            component.importe = '87.39';
            component.orden = '0';
        }

        RectorComponent component = new RectorComponent();

        public RectorComponent build() {
            return component;
        }
    }

    public static RectorComponentBuilder aRectorComponent() {
        return new RectorComponentBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ProductComponentDataRetrieverMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class ProductComponentDataRetrieverMockBuilder {
        private List<RectorComponent> components = new List<RectorComponent>();
        private Boolean syntaxisError = false;
        private Boolean emptyBody = false;

        public ProductComponentDataRetrieverMockBuilder withSyntaxisError() {
            this.syntaxisError = true;
            return this;
        }

        public ProductComponentDataRetrieverMockBuilder withEmptyBody() {
            this.emptyBody = true;
            return this;
        }

        public ProductComponentDataRetrieverMockBuilder withRectorComponent(RectorComponent comp) {
            this.components.add(comp);
            return this;
        }

        public ProductComponentDataRetrieverMock build() {
            ProductComponentDataRetrieverMock mock = new ProductComponentDataRetrieverMock(
                this.components,
                this.syntaxisError
            );
            mock.emptyBody = this.emptyBody;
            return mock;
        }
    }

    public static ProductComponentDataRetrieverMockBuilder aProductComponentDataRetrieverMock() {
        return new ProductComponentDataRetrieverMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RectorCoverage
    //---------------------------------------------------------------------------------------------------------------------------
    public class RectorCoverageBuilder {
        RectorCoverageBuilder() {
            coverage.cod_cobertura = '001';
            coverage.desc_cobertura = 'MUERTE';
            coverage.imp_asegurado = '86702';
            coverage.imp_deducible = '0';
        }

        RectorCoverage coverage = new RectorCoverage();

        public RectorCoverage build() {
            return coverage;
        }
    }

    public static RectorCoverageBuilder aRectorCoverage() {
        return new RectorCoverageBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ProductCoverageDataRetrieverMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class ProductCoverageDataRetrieverMockBuilder {
        public ProductCoverageDataRetrieverMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        public ProductCoverageDataRetrieverMockBuilder withRectorCoverage(RectorCoverage cover) {
            coverages.add(cover);
            return this;
        }

        List<RectorCoverage> coverages = new List<RectorCoverage>();
        Boolean syntaxisError = false;

        public ProductCoverageDataRetrieverMock build() {
            return new ProductCoverageDataRetrieverMock(coverages, syntaxisError);
        }
    }

    public static ProductCoverageDataRetrieverMockBuilder aProductCoverageDataRetrieverMock() {
        return new ProductCoverageDataRetrieverMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RectorBenefit
    //---------------------------------------------------------------------------------------------------------------------------
    public class RectorBenefitBuilder {
        RectorBenefitBuilder() {
            benefit.de_beneficio = 'SEGUNDA OPINION MEDICA';
            benefit.fe_alta = '01/07/2012';
            benefit.fe_baja = '';
        }

        public RectorBenefitBuilder forRequest(Gestion__c req) {
            benefit.cd_gestion = req.Numero__c.format();
            return this;
        }

        RectorBenefit benefit = new RectorBenefit();

        public RectorBenefit build() {
            return benefit;
        }
    }

    public static RectorBenefitBuilder aRectorBenefit() {
        return new RectorBenefitBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ProductBenefitDataRetrieverMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class ProductBenefitDataRetrieverMockBuilder {
        public ProductBenefitDataRetrieverMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        public ProductBenefitDataRetrieverMockBuilder withRectorBenefit(RectorBenefit ben) {
            benefits.add(ben);
            return this;
        }

        List<RectorBenefit> benefits = new List<RectorBenefit>();
        Boolean syntaxisError = false;

        public ProductBenefitDataRetrieverMock build() {
            return new ProductBenefitDataRetrieverMock(benefits, syntaxisError);
        }
    }

    public static ProductBenefitDataRetrieverMockBuilder aProductBenefitDataRetrieverMock() {
        return new ProductBenefitDataRetrieverMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RectorFee
    //---------------------------------------------------------------------------------------------------------------------------
    public class RectorFeeBuilder {
        RectorFeeBuilder() {
            fee.nro_cuota = '1';
            fee.nro_recibo = '88075791';
            fee.fec_emision = '01/06/2012';
            fee.nro_factura = '15325038';
            fee.fec_1er_venc = '01/07/2012';
            fee.cod_moneda = '80';
            fee.imp_total_premio = '52';
            fee.imp_imputado = '52';
            fee.fec_pago = '22/06/2014';
            fee.fe_aplica = '03/07/2012';
            fee.cod_est_factura = '4';
            fee.desc_est_factura = 'COBRADA';
            fee.cod_medio_pago = '2';
            fee.desc_medio_pago = 'TARJETA DE CREDITO';
            fee.estado_puesta_cobro = 'rechazado';
            fee.de_rechazo = 'TARJETA NO OPERATIVA POR LA E';
            fee.mp_rechazo = '4001040004933906';
            fee.Origen_Cobranza = 'COBRADO';
        }

        public RectorFeeBuilder withoutPayDate() {
            fee.fec_pago = '';
            return this;
        }

        RectorFee fee = new RectorFee();

        public RectorFee build() {
            return fee;
        }
    }

    public static RectorFeeBuilder aRectorFee() {
        return new RectorFeeBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ProductFeeDataRetrieverMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class ProductFeeDataRetrieverMockBuilder {
        public ProductFeeDataRetrieverMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        public ProductFeeDataRetrieverMockBuilder withRectorFee(RectorFee fee) {
            fees.add(fee);
            return this;
        }

        List<RectorFee> fees = new List<RectorFee>();
        Boolean syntaxisError = false;

        public ProductFeeDataRetrieverMock build() {
            return new ProductFeeDataRetrieverMock(fees, syntaxisError);
        }
    }

    public static ProductFeeDataRetrieverMockBuilder aProductFeeDataRetrieverMock() {
        return new ProductFeeDataRetrieverMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RectorBeneficiary
    //---------------------------------------------------------------------------------------------------------------------------
    public class RectorBeneficiaryBuilder {
        RectorBeneficiaryBuilder() {
            beneficiary.tip_doc = 'D.N.I.';
            beneficiary.cd_tip_doc = '01';
            beneficiary.num_doc = '13733177';
            beneficiary.nombre = 'MIO PEDRO BERNABE,';
            beneficiary.cd_parentesco = '8';
            beneficiary.parentesco = 'REPRESENTANTE LEGAL';
            beneficiary.particip = '100';
            beneficiary.fec_alta = '02/10/2014';
            beneficiary.fec_baja = '02/10/2019';
        }

        public RectorBeneficiaryBuilder withRelationship(Parentesco__c rel) {
            beneficiary.parentesco = rel.Descripcion__c;
            beneficiary.cd_parentesco = rel.Name;

            return this;
        }

        RectorBeneficiary beneficiary = new RectorBeneficiary();

        public RectorBeneficiary build() {
            return beneficiary;
        }
    }

    public static RectorBeneficiaryBuilder aRectorBeneficiary() {
        return new RectorBeneficiaryBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ProductBeneficiaryDataRetrieverMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class ProductBeneficiaryDataRetrieverMockBuilder {
        public ProductBeneficiaryDataRetrieverMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        public ProductBeneficiaryDataRetrieverMockBuilder withRectorBeneficiary(RectorBeneficiary beneficiary) {
            beneficiaries.add(beneficiary);
            return this;
        }

        List<RectorBeneficiary> beneficiaries = new List<RectorBeneficiary>();
        Boolean syntaxisError = false;

        public ProductBeneficiaryDataRetrieverMock build() {
            return new ProductBeneficiaryDataRetrieverMock(beneficiaries, syntaxisError);
        }
    }

    public static ProductBeneficiaryDataRetrieverMockBuilder aProductBeneficiaryDataRetrieverMock() {
        return new ProductBeneficiaryDataRetrieverMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RectorInsGood
    //---------------------------------------------------------------------------------------------------------------------------
    public class RectorInsGoodBuilder {
        private RectorInsGood insGood = new RectorInsGood();

        private RectorInsGoodBuilder() {
            this.insGood.bien = 'VIVIENDA';
            this.insGood.calle = 'TACUARI';
            this.insGood.numero = '1878';
            this.insGood.piso = '3';
            this.insGood.depto = '1';
            this.insGood.provincia = 'BUENOS AIRES';
            this.insGood.localidad = 'LANUS';
            this.insGood.cod_postal = '1824';
            this.insGood.id_postal = '714';
        }

        public RectorInsGoodBuilder clearMockData() {
            this.insGood.bien = '';
            this.insGood.calle = '';
            this.insGood.numero = '';
            this.insGood.piso = '';
            this.insGood.depto = '';
            this.insGood.provincia = '';
            this.insGood.localidad = '';
            this.insGood.cod_postal = '';
            this.insGood.id_postal = '';
            return this;
        }

        public RectorInsGoodBuilder withBien(String value) {
            this.insGood.bien = value;
            return this;
        }

        public RectorInsGoodBuilder withCalle(String value) {
            this.insGood.calle = value;
            return this;
        }

        public RectorInsGoodBuilder withNumero(String value) {
            this.insGood.numero = value;
            return this;
        }

        public RectorInsGoodBuilder withPiso(String value) {
            this.insGood.piso = value;
            return this;
        }

        public RectorInsGoodBuilder withDepto(String value) {
            this.insGood.depto = value;
            return this;
        }

        public RectorInsGoodBuilder withProvincia(String value) {
            this.insGood.provincia = value;
            return this;
        }

        public RectorInsGoodBuilder withLocalidad(String value) {
            this.insGood.localidad = value;
            return this;
        }

        public RectorInsGoodBuilder withCod_postal(String value) {
            this.insGood.cod_postal = value;
            return this;
        }

        public RectorInsGoodBuilder withId_postal(String value) {
            this.insGood.id_postal = value;
            return this;
        }

        public RectorInsGood build() {
            return this.insGood;
        }
    }

    public static RectorInsGoodBuilder aRectorInsGood() {
        return new RectorInsGoodBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ProductInsGoodDataRetrieverMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class ProductInsGoodDataRetrieverMockBuilder {
        public ProductInsGoodDataRetrieverMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        public ProductInsGoodDataRetrieverMockBuilder withRectorInsGood(RectorInsGood insGood) {
            insGoods.add(insGood);
            return this;
        }

        List<RectorInsGood> insGoods = new List<RectorInsGood>();
        Boolean syntaxisError = false;

        public ProductInsGoodDataRetrieverMock build() {
            return new ProductInsGoodDataRetrieverMock(insGoods, syntaxisError);
        }
    }

    public static ProductInsGoodDataRetrieverMockBuilder aProductInsGoodDataRetrieverMock() {
        return new ProductInsGoodDataRetrieverMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // PaymentMeanBuilder
    //---------------------------------------------------------------------------------------------------------------------------
    public class PaymentMeanBuilder {
        PaymentMeanBuilder() {
            mean.Name = 'MED';
            mean.Codigo__c = 'MED';
            mean.Descripcion__c = 'Medio Desc';
        }

        public PaymentMeanBuilder withCode(String code) {
            mean.Name = code;
            mean.Codigo__c = code;
            return this;
        }

        public PaymentMeanBuilder withDescription(String descrip) {
            mean.Descripcion__c = descrip;
            return this;
        }

        Medio_de_Pago__c mean = new Medio_de_Pago__c();

        public Medio_de_Pago__c build() {
            return mean;
        }
    }

    public static PaymentMeanBuilder aPaymentMean() {
        return new PaymentMeanBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // PaymentOriginBuilder
    //---------------------------------------------------------------------------------------------------------------------------
    public class PaymentOriginBuilder {
        PaymentOriginBuilder() {
            origin.Id__c = 'ORI';
            origin.Codigo__c = 'ORI';
            origin.Medio_de_Pago__c = 'MED';
            origin.Name = origin.Medio_de_Pago__c + '|' + origin.Codigo__c;
            origin.Descripcion__c = 'Origen Desc';
        }

        public PaymentOriginBuilder withName(String value) {
            origin.name = value;
            return this;
        }

        public PaymentOriginBuilder forMean(Medio_de_Pago__c mean) {
            origin.Medio_de_Pago__c = mean.Name;
            origin.Name = origin.Medio_de_Pago__c + '|' + origin.Codigo__c;
            return this;
        }

        public PaymentOriginBuilder withMeanCode(String code) {
            origin.Medio_de_Pago__c = code;
            return this;
        }

        public PaymentOriginBuilder withCode(String code) {
            origin.Id__c = code;
            origin.Codigo__c = code;
            origin.Name = origin.Medio_de_Pago__c + '|' + origin.Codigo__c;
            return this;
        }

        public PaymentOriginBuilder withDescription(String descrip) {
            origin.Descripcion__c = descrip;
            return this;
        }

        Origen_de_Pago__c origin = new Origen_de_Pago__c();

        public Origen_de_Pago__c build() {
            return origin;
        }
    }

    public static PaymentOriginBuilder aPaymentOrigin() {
        return new PaymentOriginBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // MeansOfPaymentUpdaterMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class MeansOfPaymentUpdaterMockBuilder {
        public MeansOfPaymentUpdaterMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        public MeansOfPaymentUpdaterMockBuilder withOrigin(Origen_de_Pago__c origin) {
            origins.add(origin);
            return this;
        }

        public MeansOfPaymentUpdaterMockBuilder withMean(Medio_de_Pago__c mean) {
            means.add(mean);
            return this;
        }

        List<Medio_de_Pago__c> means = new List<Medio_de_Pago__c>();
        List<Origen_de_Pago__c> origins = new List<Origen_de_Pago__c>();
        Boolean syntaxisError = false;

        public MeansOfPaymentUpdaterMock build() {
            return new MeansOfPaymentUpdaterMock(means, origins, syntaxisError);
        }
    }

    public static MeansOfPaymentUpdaterMockBuilder aMeansOfPaymentUpdaterMock() {
        return new MeansOfPaymentUpdaterMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // MeansOfPaymentUpdateRequestBuilder
    //---------------------------------------------------------------------------------------------------------------------------
    public class MeansOfPaymentUpdateRequestBuilder {
        public MeansOfPaymentUpdateRequestBuilder() {
            request.clienteCuit = '20238204454';
            request.ramo = '19';
            request.poliza = '101';
            request.certificado = '18279';
            request.estado = 'P';
            request.observaciones = '';
            request.tipoTramite = '52';
            request.tipoNovedad = 'PAG';
            request.canal1 = '1007';
            request.canal2 = '0';
            request.canal4 = '12321';
            request.resultado = '110';
            request.pagCodigoMedio = '8';
            request.pagCodigoOrigen = '01';
            request.pagCuentaDestino = '33232';
        }

        MeansOfPaymentUpdateRequest request = new MeansOfPaymentUpdateRequest();

        public MeansOfPaymentUpdateRequest build() {
            return request;
        }
    }

    public static MeansOfPaymentUpdateRequestBuilder aMeansOfPaymentUpdateRequest() {
        return new MeansOfPaymentUpdateRequestBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // PlanChangeControllerMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class PlanChangeControllerMockBuilder {
        public PlanChangeControllerMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        public PlanChangeControllerMockBuilder withPlan(PlanBrief plan) {
            plans.add(plan);
            return this;
        }

        public PlanChangeControllerMockBuilder withCoverage(PlanCoverage cover) {
            coverages.add(cover);
            return this;
        }

        List<PlanBrief> plans = new List<PlanBrief>();
        List<PlanCoverage> coverages = new List<PlanCoverage>();
        Boolean syntaxisError = false;

        public PlanChangeControllerMock build() {
            return new PlanChangeControllerMock(plans, coverages, syntaxisError);
        }
    }

    public static PlanChangeControllerMockBuilder aPlanChangeControllerMock() {
        return new PlanChangeControllerMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // PlanBriefBuilder
    //---------------------------------------------------------------------------------------------------------------------------
    public class PlanBriefBuilder {
        public PlanBriefBuilder() {
            plan.id = '003';
            plan.code = '003';
            plan.description = 'PLAN S/PLAN';
            plan.premium = 25.45;
        }

        PlanBrief plan = new PlanBrief();

        public PlanBrief build() {
            return plan;
        }
    }

    public static PlanBriefBuilder aPlanBrief() {
        return new PlanBriefBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // PlanCoverageBuilder
    //---------------------------------------------------------------------------------------------------------------------------
    public class PlanCoverageBuilder {
        public PlanCoverageBuilder() {
            cover.description = 'COBERTURA Z.R.';
            cover.insuredSum = 25.45;
            cover.deductible = 50.36;
        }

        PlanCoverage cover = new PlanCoverage();

        public PlanCoverage build() {
            return cover;
        }
    }

    public static PlanCoverageBuilder aPlanCoverage() {
        return new PlanCoverageBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // TaskBuilder
    //---------------------------------------------------------------------------------------------------------------------------
    public class TaskBuilder {
        Task task = new Task();

        public TaskBuilder() {
        }

        public TaskBuilder relatedTo(Case c) {
            task.WhatId = c.Id;
            return this;
        }

        public TaskBuilder withSubject(String sub) {
            task.Subject = sub;
            return this;
        }
        public TaskBuilder telephoneCallTask(Account client) {
            task.Type = 'Llamada';
            task.Status = 'Completada';
            task.Subject = 'Llamada';
            task.WhoId = client.PersonContactId;
            return this;
        }

        public TaskBuilder withMotivoDeLlamadoBO(String aMotivo) {
            this.task.Motivo_de_llamado_BO__c = aMotivo;
            return this;
        }

        public TaskBuilder withWhatCase(Case aCase) {
            this.task.WhatId = aCase.id;
            return this;
        }

        public TaskBuilder withIdPureCloud(String purecloudId) {
            this.task.Id_PureCloud__c = purecloudId;
            return this;
        }

        public TaskBuilder withCampania(String campaniaId) {
            this.task.Campania__c = campaniaId;
            return this;
        }

        public TaskBuilder withWhoId(Id value) {
            this.task.WhoId = value;
            return this;
        }

        public TaskBuilder withWhoId(Lead value) {
            this.task.WhoId = value.Id;
            return this;
        }

        public TaskBuilder withCallDisposition(String value) {
            this.task.CallDisposition = value;
            return this;
        }

        public TaskBuilder withCodigoDeCierre(String value) {
            this.task.Codigo_de_Cierre__c = value;
            return this;
        }

        public TaskBuilder withIdCandidato(String leadId) {
            this.task.Id_Candidato__c = leadId;
            return this;
        }

        public TaskBuilder withUsuarioGenesys(String genesysUser) {
            this.task.Usuario_Genesys__c = genesysUser;
            return this;
        }

        public Task build() {
            return task;
        }
    }

    public static TaskBuilder aTask() {
        return new TaskBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // UserBuilder
    //---------------------------------------------------------------------------------------------------------------------------
    public class UserBuilder {
        public UserBuilder() {
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' OR Name LIKE 'Usuario est%'];
            user = new User(
                Alias = 'standt',
                Email = 'testHipo@testHipo.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'testHipo',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = p.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = 'testHipo@testHipo.com'
            );
        }

        public UserBuilder(String profileName, Id accountId) {
            Profile p = [SELECT Id FROM Profile WHERE Name = :profileName];
            user = new User(
                Alias = 'standt',
                Email = 'testHipo@testHipo.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'testHipo',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = p.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = 'testHipo@testHipo.com',
                ContactId = accountId
            );
        }

        public UserBuilder(String profileName) {
            Profile p = [SELECT Id FROM Profile WHERE Name = :profileName];
            user = new User(
                Alias = 'standt',
                Email = 'testHipo@testHipo.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'testHipo',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = p.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = 'testHipo@testHipo.com'
            );
        }

        public UserBuilder withCallCenterArea(String area) {
            user.Area_Call_Center__c = area;
            return this;
        }

        public UserBuilder withArea(String area) {
            user.Area__c = area;
            return this;
        }

        public UserBuilder withSponsor(String spon) {
            user.Sponsor__c = spon;
            return this;
        }

        public UserBuilder withUserNotes(String notes) {
            user.Notas_Personales__c = notes;
            return this;
        }

        public UserBuilder withName(String name) {
            List<String> parts = name.split(' ');
            user.LastName = parts[0];
            if (parts.size() > 1) {
                user.FirstName = parts[1];
            }
            return this;
        }

        public UserBuilder withActiveDirectoryUser(String adUsr) {
            user.Active_Directory_Username__c = adUsr;
            return this;
        }

        public UserBuilder withLastName(String lastName) {
            user.LastName = lastName;
            return this;
        }

        public UserBuilder withAlias(String alias) {
            user.Alias = alias;
            return this;
        }

        public UserBuilder withUserName(String username) {
            user.Username = username;
            return this;
        }

        public UserBuilder withContact(String id) {
            user.ContactId = id;
            return this;
        }

        public UserBuilder withRole(UserRole aRole) {
            user.UserRoleId = aRole.id;
            return this;
        }

        public UserBuilder withProfile(Profile profile) {
            user.ProfileId = profile.id;
            return this;
        }

        public UserBuilder withEmail(String email) {
            user.Email = email;
            return this;
        }

        public UserBuilder withCanal1(String channel) {
            user.Canal1__c = channel;
            return this;
        }

        public UserBuilder withCanal2(String channel) {
            user.Canal2__c = channel;
            return this;
        }

        User user = new User();

        public User build() {
            return user;
        }
    }

    public static UserBuilder aUser() {
        return new UserBuilder();
    }
    public static UserBuilder aUser(String profileName) {
        return new UserBuilder(profileName);
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // CaseBuilder
    //---------------------------------------------------------------------------------------------------------------------------
    public class CaseBuilder {
        private Case theCase;

        public CaseBuilder() {
            this.theCase = new Case();
        }

        public CaseBuilder forClient(Account acc) {
            this.theCase.AccountId = acc.Id;
            return this;
        }

        public CaseBuilder withStatus(String sta) {
            this.theCase.Status = sta;
            return this;
        }

        public CaseBuilder withMotivo(String motivo) {
            this.theCase.reason = motivo;
            return this;
        }

        public CaseBuilder withResultado(String resultado) {
            this.theCase.resultado__c = resultado;
            return this;
        }

        public CaseBuilder withResultado2(String resultado) {
            this.theCase.resultado_2__c = resultado;
            return this;
        }

        public CaseBuilder withRecordTypeCasosMails() {
            RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Casos Mails'];
            this.theCase.RecordTypeId = rt.id;
            return this;
        }

        public CaseBuilder withCase(Case case1) {
            this.theCase.Caso_Asociado__c = case1.id;
            return this;
        }

        public CaseBuilder withOrigin(String origin) {
            this.theCase.origin = origin;
            return this;
        }

        public CaseBuilder withSuppliedEmail(String value) {
            this.theCase.SuppliedEmail = value;
            return this;
        }

        /** (2021-08-09 16:24:06) Valores disponibles:  'Nuevo', 'Pendiente', 'Finalizado', 'Spam', 'Ventas' */
        public CaseBuilder withEstadoMails(String value) {
            this.theCase.Estado_Mails__c = value;
            return this;
        }

        public CaseBuilder withType(String type1) {
            this.theCase.type = type1;
            return this;
        }

        public CaseBuilder withAsunto(String aSubject) {
            this.theCase.Subject = aSubject;
            return this;
        }

        public CaseBuilder withDescripcion(String aDescription) {
            this.theCase.Description = aDescription;
            return this;
        }

        public CaseBuilder withNumeroDeDocumento(String documentNumber) {
            this.theCase.Numero_de_Documento__c = documentNumber;
            return this;
        }

        public CaseBuilder withGestionConReintegroAAnalizar(Gestion__C aRequest) {
            this.theCase.Gestion_Con_Reintegro_A_Analizar__c = aRequest.Id;
            return this;
        }

        public CaseBuilder withSubject(String value) {
            this.theCase.Subject = value;
            return this;
        }

        public CaseBuilder withCamara(Camara__c camara) {
            this.theCase.Camara__c = camara.Id;
            return this;
        }

        public CaseBuilder withCommunityUserEmail(String value) {
            this.theCase.CommunityUserEmail__c = value;
            return this;
        }

        public Case build() {
            return this.theCase;
        }
    }

    public static CaseBuilder aCase() {
        return new CaseBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // CancellationMotiveBuilder
    //---------------------------------------------------------------------------------------------------------------------------
    public class CancellationMotiveBuilder {
        CancellationMotiveBuilder() {
            motive.Name = '2';
            motive.Codigo__c = '2';
            motive.Descripcion__c = 'CLIENTE DIO CONSENTIMIENTO';
        }

        public CancellationMotiveBuilder withCode(String code) {
            motive.Name = code;
            motive.Codigo__c = code;
            return this;
        }

        public CancellationMotiveBuilder withDescription(String descrip) {
            motive.Descripcion__c = descrip;
            return this;
        }

        Motivo_Baja__c motive = new Motivo_Baja__c();

        public Motivo_Baja__c build() {
            return motive;
        }
    }

    public static CancellationMotiveBuilder aCancellationMotive() {
        return new CancellationMotiveBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RequestResultBuilder
    //---------------------------------------------------------------------------------------------------------------------------
    public class RequestResultBuilder {
        RequestResultBuilder() {
            result.Name = '105';
            result.Codigo__c = '105';
            result.Descripcion__c = 'Venta No Retenida / Cliente conflictivo';
            result.Estado_de_la_gestion__c = 'D';
        }

        public RequestResultBuilder withCode(String code) {
            result.Name = code;
            result.Codigo__c = code;
            return this;
        }

        public RequestResultBuilder withDescription(String descrip) {
            result.Descripcion__c = descrip;
            return this;
        }

        Resultado_Gestion__c result = new Resultado_Gestion__c();

        public Resultado_Gestion__c build() {
            return result;
        }
    }

    public static RequestResultBuilder aRequestResult() {
        return new RequestResultBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ClaimTypeRiskCodeUpdaterMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClaimTypeRiskCodeUpdaterMockBuilder {
        public ClaimTypeRiskCodeUpdaterMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        public ClaimTypeRiskCodeUpdaterMockBuilder withType(String code, String descrip) {
            Tipo_Siniestro__c tipoSin = new Tipo_Siniestro__c();
            tipoSin.Codigo__c = code;
            tipoSin.Descripcion__c = descrip;
            listaTipo.add(tipoSin);
            return this;
        }

        public ClaimTypeRiskCodeUpdaterMockBuilder withCause(String code, String descrip) {
            Causa_Siniestro__c causaSin = new Causa_Siniestro__c();
            causaSin.Codigo__c = code;
            causaSin.Descripcion__c = descrip;
            listaCausa.add(causaSin);
            return this;
        }

        public ClaimTypeRiskCodeUpdaterMockBuilder withCode(String code, String descrip) {
            Codigo_Siniestro__c codSin = new Codigo_Siniestro__c();
            codSin.Codigo__c = code;
            codSin.Descripcion__c = descrip;
            listaCodigo.add(codSin);
            return this;
        }

        List<Tipo_Siniestro__c> listaTipo = new List<Tipo_Siniestro__c>();
        List<Causa_Siniestro__c> listaCausa = new List<Causa_Siniestro__c>();
        List<Codigo_Siniestro__c> listaCodigo = new List<Codigo_Siniestro__c>();
        Boolean syntaxisError = false;

        public ClaimTypeRiskCodeUpdaterMock build() {
            return new ClaimTypeRiskCodeUpdaterMock(listaTipo, listaCausa, listaCodigo, syntaxisError);
        }
    }

    public static ClaimTypeRiskCodeUpdaterMockBuilder aClaimTypeRiskCodeUpdaterMock() {
        return new ClaimTypeRiskCodeUpdaterMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ClaimType
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClaimType {
        ClaimType() {
            result.Name = '2';
            result.Codigo__c = '2';
            result.Descripcion__c = 'Incendio y/o Combinado Familiar (2)';
        }

        public ClaimType withCode(String code) {
            result.Name = code;
            result.Codigo__c = code;
            return this;
        }

        public ClaimType withDescription(String descrip) {
            result.Descripcion__c = descrip;
            return this;
        }

        Tipo_Siniestro__c result = new Tipo_Siniestro__c();

        public Tipo_Siniestro__c build() {
            return result;
        }
    }

    public static ClaimType aClaimType() {
        return new ClaimType();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ClaimCause
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClaimCause {
        ClaimCause() {
            result.Name = '2|2-100';
            result.Codigo__c = '2-100';
            result.Tipo_Siniestro__c = '2';
            result.Descripcion__c = '(HOGAR) - INCENDIO EDIFICIO (2, 2-100)';
        }

        public ClaimCause withCode(String code) {
            result.Name = code;
            result.Codigo__c = code;
            return this;
        }

        public ClaimCause withDescription(String descrip) {
            result.Descripcion__c = descrip;
            return this;
        }

        Causa_Siniestro__c result = new Causa_Siniestro__c();

        public Causa_Siniestro__c build() {
            return result;
        }
    }

    public static ClaimCause aClaimCause() {
        return new ClaimCause();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ClaimCode
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClaimCode {
        ClaimCode() {
            result.Name = '2|ICG';
            result.Codigo__c = 'ICG';
            result.Tipo_Siniestro__c = '2';
            result.Descripcion__c = 'INCENDIO CONTENIDO GENERAL (2, ICG)';
        }

        public ClaimCode withCode(String code) {
            result.Name = code;
            result.Codigo__c = code;
            return this;
        }

        public ClaimCode withDescription(String descrip) {
            result.Descripcion__c = descrip;
            return this;
        }

        Codigo_Siniestro__c result = new Codigo_Siniestro__c();

        public Codigo_Siniestro__c build() {
            return result;
        }
    }

    public static ClaimCode aClaimCode() {
        return new ClaimCode();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // DocumentTypeUpdaterMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class DocumentTypeUpdaterMockBuilder {
        public DocumentTypeUpdaterMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        public DocumentTypeUpdaterMockBuilder withDocType(
            String docId,
            String code,
            String descrip,
            String ssn,
            String ibero
        ) {
            Tipos_de_Documento__c docType = new Tipos_de_Documento__c();
            docType.Name = docId;
            docType.Codigo__c = code;
            docType.Descripcion__c = descrip;
            docType.Codigo_SSN__c = ssn;
            docType.Codigo_Ibero__c = ibero;
            listaDocs.add(docType);
            return this;
        }
        List<Tipos_de_Documento__c> listaDocs = new List<Tipos_de_Documento__c>();
        Boolean syntaxisError = false;

        public DocumentTypeUpdaterMock build() {
            return new DocumentTypeUpdaterMock(listaDocs, syntaxisError);
        }
    }

    public static DocumentTypeUpdaterMockBuilder aDocumentTypeUpdaterMock() {
        return new DocumentTypeUpdaterMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // DocType
    //---------------------------------------------------------------------------------------------------------------------------
    public class DocTypeBuilder {
        DocTypeBuilder() {
            docType.Name = '01';
            docType.Descripcion__c = 'D.N.I.';
        }

        Tipos_de_Documento__c docType = new Tipos_de_Documento__c();

        public DocTypeBuilder withDesc(String descrip) {
            docType.Descripcion__c = descrip;
            return this;
        }

        public DocTypeBuilder withCode(String code) {
            docType.Name = code;
            return this;
        }

        public Tipos_de_Documento__c build() {
            return docType;
        }
    }

    public static DocTypeBuilder aDocType() {
        return new DocTypeBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // UpdateRequestStatusFromRectorBatchMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class UpdateRequestStatusFromRectorBatchMockBuilder {
        public UpdateRequestStatusFromRectorBatchMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        public UpdateRequestStatusFromRectorBatchMockBuilder withNumber(Decimal n) {
            num = n.format();
            return this;
        }

        public UpdateRequestStatusFromRectorBatchMockBuilder withStatus(String e) {
            estado = e;
            return this;
        }

        public UpdateRequestStatusFromRectorBatchMockBuilder withStatusDescription(String ed) {
            estadoDes = ed;
            return this;
        }

        public UpdateRequestStatusFromRectorBatchMockBuilder withResult(String r) {
            result = r;
            return this;
        }

        public UpdateRequestStatusFromRectorBatchMockBuilder withResultDescription(String rd) {
            resultDes = rd;
            return this;
        }

        public UpdateRequestStatusFromRectorBatchMockBuilder withEndorsement(String endor) {
            endorsement = endor;
            return this;
        }

        Boolean syntaxisError = false;
        String num = '22148212';
        String estado = 'F';
        String estadoDes = 'FINALIZADO';
        String result = '124';
        String resultDes = 'Envio de Carta de Transformacion';
        String endorsement = '';

        public UpdateRequestStatusFromRectorBatchMock build() {
            return new UpdateRequestStatusFromRectorBatchMock(
                num,
                estado,
                estadoDes,
                result,
                resultDes,
                endorsement,
                syntaxisError
            );
        }
    }

    public static UpdateRequestStatusFromRectorBatchMockBuilder anUpdateRequestStatusFromRectorBatchMock() {
        return new UpdateRequestStatusFromRectorBatchMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Consultation
    //---------------------------------------------------------------------------------------------------------------------------
    public class ConsultationBuilder {
        ConsultationBuilder() {
            cons.Asunto__c = 'Asunto';
            cons.Cuerpo__c = 'Cuerpo';
        }

        Consulta__c cons = new Consulta__c();

        public Consulta__c build() {
            return cons;
        }
    }

    public static ConsultationBuilder aConsultation() {
        return new ConsultationBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Campaign
    //---------------------------------------------------------------------------------------------------------------------------
    public class CampaignBuilder {
        CampaignBuilder() {
            camp.Name = 'Test Campaign';
            camp.Sponsor__c = 'TS';
            camp.Producto__c = 'Producto TEST';
            camp.Producto_Principal__c = 'Producto Principal TEST';
            camp.Estimulo__c = 'Estimulo TEST';
            camp.Type = 'IN';
            camp.EndDate = Datetime.now().date().addDays(30);
        }

        /** (2020-11-27 11:36:56) Valores disponibles:  '001 - Seguro de Hogar', '150 - Seguro de Hogar', '170 - Seguro de Hogar', '153 - Seguro de Hogar', '103 - Vida 24 Max', '104 - Vida 24 Max', '175 - Seguro de Educación', '153 - Vida Max', '001 - Accidentes Personales', '150 - Accidentes Personales', '175 - Accidentes Personales', '153 - Accidentes Personales', '101 - Robo en Cajero', '003 - Protección Bienes Móviles', '150 - Protección Bienes Móviles', '170 - Protección Bienes Móviles', '153 - Protección Bienes Móviles', '02 - Compra Protegida', '150 - Compra Protegida', '153 - Compra Protegida', 'Coarseguros' */
        public CampaignBuilder withProducto(String value) {
            camp.Producto__c = value;
            return this;
        }

        public CampaignBuilder withName(String name) {
            camp.name = name;
            return this;
        }

        public CampaignBuilder withoutEndDate() {
            camp.EndDate = null;
            return this;
        }

        public CampaignBuilder withSponsor(String sponsor) {
            camp.Sponsor__c = sponsor;
            return this;
        }

        public CampaignBuilder withCampaignType(String cType) {
            camp.Tipos_de_Campa_a__c = cType;
            return this;
        }

        public CampaignBuilder withType(String cType) {
            camp.Type = cType;
            return this;
        }

        public CampaignBuilder withTotalOpportunityCount(Integer cOpp) {
            camp.Total_de_Oportunidades__c = cOpp;
            return this;
        }

        public CampaignBuilder withpurecloudPureCloudCampaignID(String value) {
            camp.purecloud__PureCloud_Campaign_ID__c = value;
            return this;
        }

        public CampaignBuilder withEquipo(String value) {
            // camp.equipo__c = value;
            return this;
        }

        public CampaignBuilder withpurecloudPureCloudContactListID(String value) {
            camp.purecloud__PureCloud_Contact_List_ID__c = value;
            return this;
        }

        public CampaignBuilder withProductoPrincipal(String value) {
            camp.Producto_Principal__c = value;
            return this;
        }

        Campaign camp = new Campaign();

        public Campaign build() {
            return camp;
        }
    }

    public static CampaignBuilder aCampaign() {
        return new CampaignBuilder();
    }

    /*------------------------------------------------------------------------
				CampaignMemberBuilderStart
	------------------------------------------------------------------------*/
    public class CampaignMemberBuilder {
        private CampaignMember obj = new CampaignMember();

        public CampaignMemberBuilder withCampaignId(Campaign value) {
            obj.CampaignId = value.Id;
            return this;
        }

        public CampaignMemberBuilder withContactId(Id value) {
            obj.ContactId = value;
            return this;
        }

        public CampaignMemberBuilder withLeadId(Lead value) {
            obj.LeadId = value.Id;
            return this;
        }

        public CampaignMemberBuilder withpurecloudSyncedtoPureCloud(Boolean value) {
            obj.purecloud__Synced_to_PureCloud__c = value;
            return this;
        }

        public CampaignMemberBuilder withobservaciones(String value) {
            obj.observaciones__c = value;
            return this;
        }

        public CampaignMemberBuilder withPolizasparaBaja(String value) {
            obj.Polizas_para_Baja__c = value;
            return this;
        }

        public CampaignMemberBuilder withDatetimeArrepentimientos(String value) {
            obj.Datetime_Arrepentimientos__c = value;
            return this;
        }

        public CampaignMember build() {
            return obj;
        }
    }

    /** It require following fields to can be inserted: CampaignId. */
    public static CampaignMemberBuilder aCampaignMember() {
        return new CampaignMemberBuilder();
    }

    /*------------------------------------------------------------------------
	             CampaignMemberBuilderEnd
	------------------------------------------------------------------------*/

    //---------------------------------------------------------------------------------------------------------------------------
    // EmailMessageBuilder
    //---------------------------------------------------------------------------------------------------------------------------
    public class EmailMessageBuilder {
        public EmailMessageBuilder() {
        }

        public EmailMessageBuilder relatedTo(Case c) {
            email.ParentId = c.Id;
            return this;
        }

        public EmailMessageBuilder isIncoming(Boolean inc) {
            email.Incoming = inc;
            return this;
        }

        EmailMessage email = new EmailMessage();

        public EmailMessage build() {
            return email;
        }
    }

    public static EmailMessageBuilder anEmailMessage() {
        return new EmailMessageBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Opportunity
    //---------------------------------------------------------------------------------------------------------------------------
    public class OpportunityBuilder {
        OpportunityBuilder() {
            opp.Name = 'Test Opportunity';
            opp.StageName = 'Aceptada';
            opp.CloseDate = Datetime.now().date().addDays(30);
            opp.Resultado_de_Telefono_1__c = 'No validado';
            opp.Telefono_1__c = '01511112222';
            opp.Resultado_de_Telefono_2__c = 'Ocupado No Contesta';
            opp.Telefono_2__c = '0034115333444';
            opp.Resultado_de_Telefono_3__c = 'No validado';
            opp.Telefono_3__c = '05556666';
            opp.Resultado_de_Telefono_4__c = 'Ocupado No Contesta';
            opp.Telefono_4__c = '002569998888';
            opp.CUIT__c = '20123456789';
            opp.Nombre_y_Apellido__c = 'App Nom';
        }

        public OpportunityBuilder forClient(Account acc) {
            opp.Account = acc;
            return this;
        }

        public OpportunityBuilder forCampaign(String camp) {
            opp.CampaignId = camp;
            return this;
        }

        Opportunity opp = new Opportunity();

        public Opportunity build() {
            return opp;
        }
    }

    public static OpportunityBuilder anOpportunity() {
        return new OpportunityBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Alta_de_Servicio__c
    //---------------------------------------------------------------------------------------------------------------------------
    public class ServiceActivationBuilder {
        ServiceActivationBuilder() {
            ads.Poliza__c = '987';
            ads.Nombre_y_Apellido__c = 'Pedro Perez';
            ads.Tipo_de_Documento__c = 'D';
            ads.Numero_de_Documento__c = '11222333';
            ads.Domicilio__c = 'Domicilio de prueba 654';
            ads.Codigo_Postal__c = '1234';
            ads.Localidad__c = 'CABA';
            ads.Codigo_de_Provincia__c = '18 - SANTIAGO DEL ESTERO';
            ads.Telefono__c = '44445555';
            ads.CD_Servicio__c = 8;
            ads.Vigencia_Desde__c = Datetime.now().date();
            ads.ST_Ibero__c = 'ING';
        }

        public ServiceActivationBuilder forOpportunity(String opp) {
            ads.Oportunidad__c = opp;
            return this;
        }

        public ServiceActivationBuilder withSpecialCharacters() {
            ads.Nombre_y_Apellido__c = 'NESTOR EDGARDO MARI??O';
            ads.Domicilio__c = 'ESPA?A 115';
            return this;
        }

        Alta_de_Servicio__c ads = new Alta_de_Servicio__c();

        public Alta_de_Servicio__c build() {
            return ads;
        }
    }

    public static ServiceActivationBuilder aServiceActivation() {
        return new ServiceActivationBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Localidad_Provincia
    //---------------------------------------------------------------------------------------------------------------------------
    public class Localidad_ProvinciaBuilder {
        private Localidad_Provincia__c localidad = new Localidad_Provincia__c();

        public Localidad_ProvinciaBuilder() {
            this.localidad.Name = 'Test Localidad_Provincia';
            this.localidad.Codigo__c = '1234';
            this.localidad.Id_BHSeg__c = '1256';
            this.localidad.Localidad__c = 'Localidad';
            this.localidad.Provincia__c = 'Provincia';
        }

        public Localidad_ProvinciaBuilder clearMockData() {
            this.localidad.clear();
            return this;
        }

        public Localidad_ProvinciaBuilder forPostalCode(Codigo_Postal__c cod) {
            this.localidad.Id_BHSeg__c = cod.localidad__c;
            return this;
        }

        public Localidad_ProvinciaBuilder withName(String name) {
            this.localidad.Name = name;
            return this;
        }

        public Localidad_ProvinciaBuilder withProvinciaIdBHSeg(String provinciaIdBHSeg) {
            this.localidad.Provincia_IdBHSeg__c = provinciaIdBHSeg;
            return this;
        }

        public Localidad_ProvinciaBuilder withCodigo(String codigo) {
            this.localidad.Codigo__c = codigo;
            return this;
        }

        public Localidad_ProvinciaBuilder withLocalidad(String nombreLocalidad) {
            this.localidad.Localidad__c = nombreLocalidad;
            return this;
        }

        public Localidad_ProvinciaBuilder withProvincia(String nombreProvincia) {
            this.localidad.Provincia__c = nombreProvincia;
            return this;
        }

        public Localidad_ProvinciaBuilder withCodigoPostal(String codigoPostal) {
            this.localidad.Codigo_Postal__c = codigoPostal;
            return this;
        }

        public Localidad_ProvinciaBuilder withIdBHSeg(String idBHSeg) {
            this.localidad.Id_BHSeg__c = idBHSeg;
            return this;
        }

        public Localidad_ProvinciaBuilder withIdBHSeguros(String idBHSeg) {
            this.localidad.Id_BH_Seguros__c = idBHSeg;
            return this;
        }

        public Localidad_Provincia__c build() {
            return this.localidad;
        }
    }

    public static Localidad_ProvinciaBuilder aLocalidad_Provincia() {
        return new Localidad_ProvinciaBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Producto
    //---------------------------------------------------------------------------------------------------------------------------
    public class ProductoBuilder {
        ProductoBuilder() {
            prod.Name = '2-153-023';
            prod.Combo__c = 'Robo de hogar';
            prod.Edad_Maxima__c = 0;
            prod.Edad_Minima__c = 0;
            prod.Plan_IdBHSeg__c = '023';
            prod.Producto_IdBHSeg__c = '153';
            prod.Ramo__c = 'Combinado Familiar';
            prod.Ramo_IdBHSeg__c = '2';
            prod.Sponsor__c = 'BH';
            prod.Premio__c = 50;
            prod.Suma_Asegurada__c = 1500000;
            prod.Medios_de_Pago_Aceptados__c = 'VISA';
        }

        public ProductoBuilder withCombo(String comboname) {
            this.prod.Combo__c = comboname;
            return this;
        }

        public ProductoBuilder withTrade(String tr) {
            prod.Ramo_IdBHSeg__c = tr;
            return this;
        }

        public ProductoBuilder withRamo(String value) {
            prod.Ramo__c = value;
            return this;
        }

        public ProductoBuilder withProductoIdBhseg(String value) {
            prod.Producto_IdBHSeg__c = value;
            return this;
        }

        public ProductoBuilder withName(String value) {
            prod.Name = value;
            return this;
        }

        public ProductoBuilder withPlanIdBhseg(String value) {
            prod.Plan_IdBHSeg__c = value;
            return this;
        }

        public ProductoBuilder withSponsor(String sp) {
            prod.Sponsor__c = sp;
            return this;
        }

        public ProductoBuilder withAuthorizePaymentMethod(String method) {
            prod.Medios_de_Pago_Aceptados__c = method;
            return this;
        }

        public ProductoBuilder withEdadMinima(Integer edadMinima) {
            prod.Edad_Minima__c = edadMinima;
            return this;
        }

        public ProductoBuilder withEdadMaxima(Integer edadMaxima) {
            prod.Edad_Maxima__c = edadMaxima;
            return this;
        }

        /** Valores: Femenino, Masculino, No especificado*/
        public ProductoBuilder withGenero(String genero) {
            prod.Genero__c = genero;
            return this;
        }

        public ProductoBuilder isActive(Boolean activo) {
            prod.Activo__c = activo;
            return this;
        }

        public ProductoBuilder needConyuge(Boolean conyuge) {
            prod.Conyuge__c = conyuge;
            return this;
        }

        Producto__c prod = new Producto__c();

        public Producto__c build() {
            return prod;
        }
    }

    public static ProductoBuilder aProduct() {
        return new ProductoBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // ProductWrapperList
    //---------------------------------------------------------------------------------------------------------------------------

    //---------------------------------------------------------------------------------------------------------------------------
    // OpportunityLoadOpperation
    //---------------------------------------------------------------------------------------------------------------------------
    public class OpportunityLoadOpperationBuilder {
        OpportunityLoadOpperationBuilder() {
        }

        public OpportunityLoadOpperationBuilder forCampign(String camp) {
            oper.Campa_a__c = camp;
            return this;
        }

        public OpportunityLoadOpperationBuilder withOpportunityCount(Decimal oppCount) {
            oper.Cantidad__c = oppCount;
            return this;
        }

        public OpportunityLoadOpperationBuilder withStartLine(Decimal sLine) {
            oper.Linea_de_Inicio__c = sLine;
            return this;
        }

        public OpportunityLoadOpperationBuilder withEndLine(Decimal eLine) {
            oper.Linea_de_Fin__c = eLine;
            return this;
        }

        public OpportunityLoadOpperationBuilder withResultStatus(Boolean result) {
            if (result) {
                oper.Completado_con_Exito__c = true;
                oper.Completado_con_Error__c = false;
            } else {
                oper.Completado_con_Exito__c = false;
                oper.Completado_con_Error__c = true;
            }
            return this;
        }

        Operacion_de_Carga__c oper = new Operacion_de_Carga__c();

        public Operacion_de_Carga__c build() {
            return oper;
        }
    }

    public static OpportunityLoadOpperationBuilder anOpportunityLoadOpperation() {
        return new OpportunityLoadOpperationBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Channel1
    //---------------------------------------------------------------------------------------------------------------------------
    public class Channel1Builder {
        Channel1Builder() {
            chn.Name = '1008';
            chn.Codigo__c = '1008';
            chn.Descripcion__c = '1008 - HML';
        }

        Canal1__c chn = new Canal1__c();

        public Canal1__c build() {
            return chn;
        }
    }

    public static Channel1Builder aChannel1() {
        return new Channel1Builder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Channel2
    //---------------------------------------------------------------------------------------------------------------------------
    public class Channel2Builder {
        Channel2Builder() {
            chn.Name = '9999';
            chn.Codigo__c = '9999';
            chn.Descripcion__c = '9999 - SUPERVISOR';
        }

        Canal2__c chn = new Canal2__c();

        public Canal2__c build() {
            return chn;
        }
    }

    public static Channel2Builder aChannel2() {
        return new Channel2Builder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ClientFinder Response
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClientFinderResponseBuilder {
        ClientFinderResponseBuilder() {
        }

        public ClientFinderResponseBuilder withDate(String d) {
            dateStr = d;
            return this;
        }

        String rs1 =
            '<?xml version="1.0" encoding="utf-8"?>' +
            '<string xmlns="http://tempuri.org/">' +
            '<findCliente>' +
            '<header>' +
            '<endTime>2016-10-2711:10:24</endTime>' +
            '<resultCode>0</resultCode>' +
            '<resultString>La transaccion ha sido exitosa</resultString>' +
            '<version>1.0.0</version>' +
            '</header>' +
            '<body>' +
            '<clientes>' +
            '<cliente>' +
            '<id>19035400</id>' +
            '<nombre>FABIAN VALENTIN</nombre>' +
            '<apellido>PESTCHANKER</apellido>' +
            '<sexo>M</sexo>' +
            '<fechaNacimiento>';
        String rs2 =
            '</fechaNacimiento>' +
            '<tipoDocumento>01</tipoDocumento>' +
            '<numeroDocumento>16037615</numeroDocumento>' +
            '<cuit>20160376156</cuit>' +
            '<ddjjPeps/>' +
            '<nacionalidad>80</nacionalidad>' +
            '<razonSocial>1</razonSocial>' +
            '<estadoCivil>C</estadoCivil>' +
            '<categoriaIVA></categoriaIVA>' +
            '<categoriaIB></categoriaIB>' +
            '<cobrador>false</cobrador>' +
            '<percepcionIVA>false</percepcionIVA>' +
            '<retencionIVA>false</retencionIVA>' +
            '<percepcionIB>false</percepcionIB>' +
            '<retencionIB>false</retencionIB>' +
            '<idCliente>18999875</idCliente>' +
            '<idProductor></idProductor>' +
            '<idClienteBH>311751</idClienteBH>' +
            '<fechaUltimaBH>2014-11-27</fechaUltimaBH>' +
            '<score>BLACK</score>' +
            '<domicilios>' +
            '<domicilio>' +
            '<idPersona>19035400</idPersona>' +
            '<numeroConsecutivo>2</numeroConsecutivo>' +
            '<idTipoDomicilio>6</idTipoDomicilio>' +
            '<idCodigoPostal>961006</idCodigoPostal>' +
            '<calle>GUAYAQUIL</calle>' +
            '<numero>165</numero>' +
            '<piso>3</piso>' +
            '<departamento>D</departamento>' +
            '<fechaUltimaBH>2009-03-02</fechaUltimaBH>' +
            '</domicilio>' +
            '<domicilio>' +
            '<idPersona>19035400</idPersona>' +
            '<numeroConsecutivo>129</numeroConsecutivo>' +
            '<idTipoDomicilio>1</idTipoDomicilio>' +
            '<idCodigoPostal>1271476</idCodigoPostal>' +
            '<calle>RECONQUISTA</calle>' +
            '<numero>151</numero>' +
            '<piso></piso>' +
            '<departamento>0</departamento>' +
            '<fechaUltimaBH>2014-11-27</fechaUltimaBH>' +
            '</domicilio>' +
            '</domicilios>' +
            '<telefonos>' +
            '<telefono>' +
            '<idPersona>19035400</idPersona>' +
            '<numeroConsecutivo>4</numeroConsecutivo>' +
            '<codigoContacto>18999875|4</codigoContacto>' +
            '<descripcion>(54-11)()4737-1077 INT</descripcion>' +
            '</telefono>' +
            '<telefono>' +
            '<idPersona>19035400</idPersona>' +
            '<numeroConsecutivo>2</numeroConsecutivo>' +
            '<codigoContacto>18999875|2</codigoContacto>' +
            '<descripcion>(054-011)(15)4419-1858 INT</descripcion>' +
            '</telefono>' +
            '</telefonos>' +
            '<emails>' +
            '<email>' +
            '<idPersona>19035400</idPersona>' +
            '<numeroConsecutivo>0</numeroConsecutivo>' +
            '<codigoContacto>13</codigoContacto>' +
            '<descripcion>fvpestchanker@hipotecarioseguros.com.ar</descripcion>' +
            '<estado>ACEPTADO</estado>' +
            '</email>' +
            '<email>' +
            '<idPersona>19035400</idPersona>' +
            '<numeroConsecutivo>0</numeroConsecutivo>' +
            '<codigoContacto>14</codigoContacto>' +
            '<descripcion>fpestchanker@ort.edu.ar</descripcion>' +
            '<estado>ACEPTADO</estado>' +
            '</email>' +
            '<email>' +
            '<idPersona>19035400</idPersona>' +
            '<numeroConsecutivo>0</numeroConsecutivo>' +
            '<codigoContacto>7</codigoContacto>' +
            '<descripcion>FVPESTCHANKER@HIPOTECARIOSEGUROS.COM.AR</descripcion>' +
            '<estado>ACEPTADO</estado>' +
            '</email>' +
            '</emails>';
        String rs3 = '</cliente>' + '</clientes>' + '</body>' + '</findCliente>' + '</string>';

        String dateStr = '';
        public List<Bonificacion_Cliente__c> bonificaciones = new List<Bonificacion_Cliente__c>();

        String bonificationResponse;

        public ClientFinderResponseBuilder withBonifications(List<Bonificacion_Cliente__c> bonificaciones) {
            this.bonificaciones = bonificaciones;
            return this;
        }

        HttpResponse resp = new HttpResponse();

        public HttpResponse build() {
            if (bonificaciones.size() > 0) {
                bonificationResponse = '<bonificaciones>';
                for (Bonificacion_Cliente__c bonificacion : bonificaciones) {
                    bonificationResponse +=
                        '<bonificacion>' +
                        '<nroGestion>' +
                        bonificacion.nroGestion__c +
                        '</nroGestion>' +
                        '<nroNota>' +
                        bonificacion.nroNota__c +
                        '</nroNota>' +
                        '<bonificacionDes>' +
                        bonificacion.Descripcion__c +
                        '</bonificacionDes>' +
                        '<fechaBonificacion>' +
                        bonificacion.Fecha__c.format() +
                        '</fechaBonificacion>' +
                        '<fechaAplicacion>' +
                        bonificacion.fechaAplicacion__c +
                        '</fechaAplicacion>' +
                        '<estadoGestion>' +
                        bonificacion.estadoGestion__c +
                        '</estadoGestion>' +
                        '<estadoNota>' +
                        bonificacion.estadoNota__c +
                        '</estadoNota>' +
                        '<cuotas>' +
                        bonificacion.cuotas__c +
                        '</cuotas>' +
                        '<porCuota>' +
                        bonificacion.porCuota__c +
                        '</porCuota>' +
                        '<importe>' +
                        bonificacion.importe__c +
                        '</importe>' +
                        '<importePremioReferencia>' +
                        bonificacion.importePremioReferencia__c +
                        '</importePremioReferencia>' +
                        '<importeBonificacionReferencia>' +
                        bonificacion.importeBonificacionReferencia__c +
                        '</importeBonificacionReferencia>' +
                        '<importePlicado>' +
                        bonificacion.importePlicado__c +
                        '</importePlicado>' +
                        '</bonificacion>';
                }
                bonificationResponse += '</bonificaciones>';
            }

            resp.setStatus('OK');
            resp.setStatusCode(200);
            resp.setBody(rs1 + dateStr + rs2 + rs3);
            if (bonificaciones.size() > 0) {
                resp.setBody(rs1 + dateStr + rs2 + bonificationResponse + rs3);
            }
            return resp;
        }
    }

    public static ClientFinderResponseBuilder aClientFinderResponse() {
        return new ClientFinderResponseBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Venta
    //---------------------------------------------------------------------------------------------------------------------------
    public class VentaBuilder {
        public VentaBuilder() {
            //recordType.Name = 'Nuevo RT';
        }

        public VentaBuilder withNumber(String value) {
            this.sell.Numero__c = value;
            return this;
        }

        public VentaBuilder withFirstName(String value) {
            this.sell.Nombre__c = value;
            return this;
        }

        public VentaBuilder withLocalidadProvincia(Localidad_Provincia__c value) {
            this.sell.Localidad_Provincia__c = value.id;
            return this;
        }

        public VentaBuilder withCaracteristicaTelefono(String value) {
            this.sell.caracteristica_telefono__c = value;
            return this;
        }

        public VentaBuilder withCaracteristicaCelular(String value) {
            this.sell.caracteristica_celular__c = value;
            return this;
        }

        public VentaBuilder withTipoDeDocumento(String value) {
            this.sell.Tipo_de_Documento__c = value;
            return this;
        }

        public VentaBuilder withTelefono(String value) {
            this.sell.Telefono__c = value;
            return this;
        }

        public VentaBuilder withProfesion(String value) {
            this.sell.Profesion__c = value;
            return this;
        }

        public VentaBuilder withPiso(String value) {
            this.sell.Piso__c = value;
            return this;
        }

        public VentaBuilder withCalle(String value) {
            this.sell.Calle__c = value;
            return this;
        }

        public VentaBuilder withCodigoPostal(String value) {
            this.sell.Codigo_Postal__c = value;
            return this;
        }

        public VentaBuilder withPaisDeNacimiento(String value) {
            this.sell.Pais_de_Nacimiento__c = value;
            return this;
        }

        public VentaBuilder withGenero(String value) {
            this.sell.Genero__c = value;
            return this;
        }

        public VentaBuilder withNumeroDeDocumento(String value) {
            this.sell.Numero_de_Documento__c = value;
            return this;
        }

        public VentaBuilder withNacionalidad(String value) {
            this.sell.Nacionalidad__c = value;
            return this;
        }

        public VentaBuilder withFechaDeNacimiento(Date value) {
            this.sell.Fecha_de_Nacimiento__c = value;
            return this;
        }

        public VentaBuilder withEmail(String value) {
            this.sell.Email__c = value;
            return this;
        }

        public VentaBuilder withEstadoCivil(String value) {
            this.sell.Estado_Civil__c = value;
            return this;
        }

        public VentaBuilder withDepartamento(String value) {
            this.sell.Departamento__c = value;
            return this;
        }

        public VentaBuilder withCelular(String value) {
            this.sell.Celular__c = value;
            return this;
        }

        public VentaBuilder withLastName(String value) {
            this.sell.Apellido__c = value;
            return this;
        }

        public VentaBuilder withCuitCuilPrefijo(String prefix) {
            this.sell.CUIL_CUIT_Prefijo__c = prefix;
            return this;
        }
        public VentaBuilder withCuitCuilNumero(String aNumber) {
            this.sell.CUIL_CUIT_Numero__c = aNumber;
            return this;
        }
        public VentaBuilder withCuitCuilNumeroVerificador(String verify) {
            this.sell.CUIL_CUIT_Digito_Verificador__c = verify;
            return this;
        }

        public VentaBuilder withAdjuntosEnviados(Boolean value) {
            this.sell.Adjuntos_Enviados__c = value;
            return this;
        }

        Venta__c sell = new Venta__c();

        public Venta__c build() {
            return this.sell;
        }
    }

    public static VentaBuilder aSell() {
        return new VentaBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ProductoVendido
    //---------------------------------------------------------------------------------------------------------------------------
    public class ProductoVendidoBuilder {
        private Producto_Vendido__c soldProduct = new Producto_Vendido__c();

        public ProductoVendidoBuilder() {
            //recordType.Name = 'Nuevo RT';
        }

        public ProductoVendidoBuilder withSource(String value) {
            this.soldProduct.Source__c = value;
            return this;
        }

        public ProductoVendidoBuilder withDescripcionMotivoNoVenta(String value) {
            this.soldProduct.Descripcion_Motivo_No_Venta__c = value;
            return this;
        }

        public ProductoVendidoBuilder withMotivoNoVenta(String value) {
            this.soldProduct.Motivo_No_Venta__c = value;
            return this;
        }

        public ProductoVendidoBuilder withCandidato(String value) {
            this.soldProduct.Candidato__c = value;
            return this;
        }

        public ProductoVendidoBuilder withComoNosConocio(String value) {
            this.soldProduct.Como_nos_conocio__c = value;
            return this;
        }

        public ProductoVendidoBuilder withPremioOrigen(Decimal value) {
            this.soldProduct.premioOrigen__c = value;
            return this;
        }

        public ProductoVendidoBuilder withPremioDestino(Decimal value) {
            this.soldProduct.premioDestino__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg01(String value) {
            this.soldProduct.sumaAseg01__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg02(String value) {
            this.soldProduct.sumaAseg02__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg03(String value) {
            this.soldProduct.sumaAseg03__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg04(String value) {
            this.soldProduct.sumaAseg04__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg05(String value) {
            this.soldProduct.sumaAseg05__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg06(String value) {
            this.soldProduct.sumaAseg06__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg07(String value) {
            this.soldProduct.sumaAseg07__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg08(String value) {
            this.soldProduct.sumaAseg08__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg09(String value) {
            this.soldProduct.sumaAseg09__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg10(String value) {
            this.soldProduct.sumaAseg10__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg11(String value) {
            this.soldProduct.sumaAseg11__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg12(String value) {
            this.soldProduct.sumaAseg12__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg13(String value) {
            this.soldProduct.sumaAseg13__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg14(String value) {
            this.soldProduct.sumaAseg14__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg15(String value) {
            this.soldProduct.sumaAseg15__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg16(String value) {
            this.soldProduct.sumaAseg16__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg17(String value) {
            this.soldProduct.sumaAseg17__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg18(String value) {
            this.soldProduct.sumaAseg18__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg19(String value) {
            this.soldProduct.sumaAseg19__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSumaAseg20(String value) {
            this.soldProduct.sumaAseg20__c = value;
            return this;
        }

        public ProductoVendidoBuilder withPromocion(String value) {
            this.soldProduct.promocion__c = value;
            return this;
        }

        public ProductoVendidoBuilder withPregunta1(String value) {
            this.soldProduct.pregunta1__c = value;
            return this;
        }

        public ProductoVendidoBuilder withPregunta2(String value) {
            this.soldProduct.pregunta2__c = value;
            return this;
        }

        public ProductoVendidoBuilder withPregunta3(String value) {
            this.soldProduct.pregunta3__c = value;
            return this;
        }

        public ProductoVendidoBuilder withCantidadObjetos(String value) {
            this.soldProduct.cantidadObjetos__c = value;
            return this;
        }

        public ProductoVendidoBuilder withParedesMaterial(String value) {
            this.soldProduct.paredesMaterial__c = value;
            return this;
        }

        public ProductoVendidoBuilder withViviendaPermanente(String value) {
            this.soldProduct.viviendaPermanente__c = value;
            return this;
        }

        public ProductoVendidoBuilder withTipoVivienda(String value) {
            this.soldProduct.tipoVivienda__c = value;
            return this;
        }

        public ProductoVendidoBuilder withMetrosCuadrados(String value) {
            this.soldProduct.metrosCuadrados__c = value;
            return this;
        }

        public ProductoVendidoBuilder withActividadesComerciales(String value) {
            this.soldProduct.actividadesComerciales__c = value;
            return this;
        }

        public ProductoVendidoBuilder withCombinatoria(String value) {
            this.soldProduct.combinatoria__c = value;
            return this;
        }

        public ProductoVendidoBuilder withRecordType(RecordType value) {
            this.soldProduct.RecordTypeId = value.id;
            return this;
        }

        public ProductoVendidoBuilder withSponsor(String value) {
            this.soldProduct.Sponsor__c = value;
            return this;
        }

        public ProductoVendidoBuilder withRamo(String value) {
            this.soldProduct.Ramo__c = value;
            return this;
        }

        public ProductoVendidoBuilder withPlan(String value) {
            this.soldProduct.Plan__c = value;
            return this;
        }

        public ProductoVendidoBuilder withPisoDomicilioPostal(String value) {
            this.soldProduct.Piso_Domicilio_Postal__c = value;
            return this;
        }

        public ProductoVendidoBuilder withPisoBienAsegurado(String value) {
            this.soldProduct.Piso_Bien_Asegurado__c = value;
            return this;
        }

        public ProductoVendidoBuilder withNumeroDomicilioPostal(String value) {
            this.soldProduct.Numero_Domicilio_Postal__c = value;
            return this;
        }

        public ProductoVendidoBuilder withNumeroBienAsegurado(String value) {
            this.soldProduct.Numero_Bien_Asegurado__c = value;
            return this;
        }

        public ProductoVendidoBuilder withLocalidadYProvinciaBienAsegurado(Localidad_Provincia__c value) {
            this.soldProduct.Localidad_y_Provincia_Bien_Asegurado__c = value.id;
            return this;
        }

        public ProductoVendidoBuilder withLocalidadYProvinciaDomicilioPostal(Localidad_Provincia__c value) {
            this.soldProduct.Localidad_y_Provincia_Domicilio_Postal__c = value.id;
            return this;
        }

        public ProductoVendidoBuilder withCodigoPostalBienAsegurado(String value) {
            this.soldProduct.Codigo_Postal_Bien_Asegurado__c = value;
            return this;
        }

        public ProductoVendidoBuilder withCodigoPostalDomicilioPostal(String value) {
            this.soldProduct.Codigo_Postal_Domicilio_Postal__c = value;
            return this;
        }

        public ProductoVendidoBuilder withIdInsercion(String value) {
            this.soldProduct.Id_de_insercion__c = value;
            return this;
        }

        public ProductoVendidoBuilder withFechaVencimientoTC(Date value) {
            this.soldProduct.Fecha_Vencimiento_TC__c = value;
            return this;
        }

        public ProductoVendidoBuilder withDepartamentoBienAsegurado(String value) {
            this.soldProduct.Departamento_Bien_Asegurado__c = value;
            return this;
        }

        public ProductoVendidoBuilder withDepartamentoDomicilioPostal(String value) {
            this.soldProduct.Departamento_Domicilio_Postal__c = value;
            return this;
        }

        public ProductoVendidoBuilder withCalleDomicilioPostal(String value) {
            this.soldProduct.Calle_Domicilio_Postal__c = value;
            return this;
        }

        public ProductoVendidoBuilder withCalleBienAsegurado(String value) {
            this.soldProduct.Calle_Bien_Asegurado__c = value;
            return this;
        }

        public ProductoVendidoBuilder withNombreTitularTC(String value) {
            this.soldProduct.Nombre_Titular_TC__c = value;
            return this;
        }

        public ProductoVendidoBuilder withApellidoTitularTC(String value) {
            this.soldProduct.Apellido_Titular_TC__c = value;
            return this;
        }

        public ProductoVendidoBuilder withSell(Venta__c venta) {
            this.soldProduct.Venta__c = venta.id;
            return this;
        }

        public ProductoVendidoBuilder forClient(Account client) {
            this.soldProduct.Cuenta__c = client.Id;
            return this;
        }

        public ProductoVendidoBuilder withCreditCardNumber(String value) {
            this.soldProduct.Numero_TC__c = value;
            return this;
        }

        public ProductoVendidoBuilder withPaymentOrigin(String value) {
            this.soldProduct.Origen_de_Pago__c = value;
            return this;
        }

        public ProductoVendidoBuilder withPaymentMethod(String value) {
            this.soldProduct.Medio_de_Pago__c = value;
            return this;
        }

        public ProductoVendidoBuilder withNumber(Decimal value) {
            this.soldProduct.Numero__c = value;
            return this;
        }

        public ProductoVendidoBuilder withTipoNovedad(String tipoNovedad) {
            this.soldProduct.tipoNovedad__c = tipoNovedad;
            return this;
        }

        public ProductoVendidoBuilder withEstadoComunicacionRector(String estado) {
            this.soldProduct.Estado_Comunicacion_Rector__c = estado;
            return this;
        }

        public ProductoVendidoBuilder withCameraSerialNumber(String value) {
            this.soldProduct.Numero_de_Serie_Camara__c = value;
            return this;
        }

        public ProductoVendidoBuilder withRamoIdBhSeg(String value) {
            this.soldProduct.Ramo_IdBHSeg__c = value;
            return this;
        }

        public ProductoVendidoBuilder withProductoIdBhSeg(String value) {
            this.soldProduct.Producto_IdBHSeg__c = value;
            return this;
        }

        public ProductoVendidoBuilder withPlanIdBhSeg(String value) {
            this.soldProduct.Plan_IdBHSeg__c = value;
            return this;
        }

        public ProductoVendidoBuilder withObservacion(String value) {
            this.soldProduct.Observacion__c = value;
            return this;
        }

        public ProductoVendidoBuilder withMecanismoEncriptacion(String value) {
            this.soldProduct.Mecanismo_Encriptacion__c = value;
            return this;
        }
    
        public ProductoVendidoBuilder withPorcentajeDevolucion(Double value) {
            this.soldProduct.Porcentaje_Devolucion__c = value;
            return this;
        }
    
        public ProductoVendidoBuilder withPatente(String value) {
            this.soldProduct.Patente__c = value;
            return this;
        }
    
        public ProductoVendidoBuilder withMarca(String value) {
            this.soldProduct.Marca__c = value;
            return this;
        }
    
        public ProductoVendidoBuilder withModelo(String value) {
            this.soldProduct.Modelo__c = value;
            return this;
        }
    
        public ProductoVendidoBuilder withIntentosDeEnvioFallidos(Integer value) {
            this.soldProduct.Intentos_de_Envio_Fallidos__c = value;
            return this;
        }
    
        public ProductoVendidoBuilder withIntentosDeEnvio(Integer value) {
            this.soldProduct.Intentos_de_Envio__c = value;
            return this;
        }
    
        public ProductoVendidoBuilder withDeclaracionJurada(String value) {
            this.soldProduct.Declaracion_Jurada__c = value;
            return this;
        }
    
        public ProductoVendidoBuilder withRespuestasDeclaracionJurada(String value) {
            this.soldProduct.Respuestas_Declaracion_Jurada__c = value;
            return this;
        }
        
        public Producto_Vendido__c build() {
            return this.soldProduct;
        }
    }

    public static ProductoVendidoBuilder aSoldProduct() {
        return new ProductoVendidoBuilder();
    }

    public static ProductoVendidoBuilder aProductoVendidoNoVenta() {
        ProductoVendidoBuilder val = new ProductoVendidoBuilder();
        val.soldProduct.RecordTypeId = XappiaHelper.getRecordType('Producto_Vendido__c', 'No_Venta').Id;
        return val;
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // ClientFinderExtMockFixed
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClientFinderExtMockFixedBuilder {
        public ClientFinderExtMockFixedBuilder withClient(Account c) {
            clients.add(c);
            return this;
        }

        public ClientFinderExtMockFixedBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        public ClientFinderExtMockFixedBuilder withRectorCertificate(RectorCertificate cert) {
            certificate = cert;
            return this;
        }

        public ClientFinderExtMockFixedBuilder withRequestsList(List<Gestion__c> reqs) {
            requests = reqs;
            return this;
        }

        public ClientFinderExtMockFixedBuilder withCertificateId(String cer) {
            certificateId = cer;
            return this;
        }

        public ClientFinderExtMockFixedBuilder withRectorCertificateBrief(List<RectorCertificateBrief> rectList) {
            certificateBriefList = rectList;
            return this;
        }

        RectorCertificate certificate;
        List<Account> clients = new List<Account>();
        List<Gestion__c> requests = new List<Gestion__c>();
        List<RectorCertificateBrief> certificateBriefList = new List<RectorCertificateBrief>();
        Boolean syntaxisError = false;
        String certificateId = '';

        public ClientFinderExtMockFixed build() {
            ClientFinderExtMockFixed mock = new ClientFinderExtMockFixed(
                clients,
                certificate,
                requests,
                certificateId,
                certificateBriefList,
                syntaxisError
            );

            return mock;
        }
    }

    public static ClientFinderExtMockFixedBuilder aClientFinderExtMockFixed() {
        return new ClientFinderExtMockFixedBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // ClientFinderExtMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class ClientFinderExtMockBuilder {
        public ClientFinderExtMockBuilder withClient(Account c) {
            clients.add(c);
            return this;
        }

        public ClientFinderExtMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        public ClientFinderExtMockBuilder withRectorCertificate(RectorCertificate cert) {
            certificate = cert;
            return this;
        }

        public ClientFinderExtMockBuilder withRequestsList(List<Gestion__c> reqs) {
            requests = reqs;
            return this;
        }

        public ClientFinderExtMockBuilder withCertificateId(String cer) {
            certificateId = cer;
            return this;
        }

        public ClientFinderExtMockBuilder withRectorCertificateBrief(List<RectorCertificateBrief> rectList) {
            certificateBriefList = rectList;
            return this;
        }

        RectorCertificate certificate;
        List<Account> clients = new List<Account>();
        List<Gestion__c> requests = new List<Gestion__c>();
        List<RectorCertificateBrief> certificateBriefList = new List<RectorCertificateBrief>();
        Boolean syntaxisError = false;
        String certificateId = '';

        public ClientFinderExtMock build() {
            ClientFinderExtMock mock = new ClientFinderExtMock(
                clients,
                certificate,
                requests,
                certificateId,
                certificateBriefList,
                syntaxisError
            );

            return mock;
        }
    }

    public static ClientFinderExtMockBuilder aClientFinderExtMock() {
        return new ClientFinderExtMockBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // FormRunnerControllerMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class FormRunnerControllerMockBuilder {
        public FormRunnerControllerMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        Boolean syntaxisError = false;

        public FormRunnerControllerMock build() {
            FormRunnerControllerMock mock = new FormRunnerControllerMock(syntaxisError);

            return mock;
        }
    }

    public static FormRunnerControllerMockBuilder aFormRunnerControllerMock() {
        return new FormRunnerControllerMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Cobertura
    //---------------------------------------------------------------------------------------------------------------------------
    public class CoverageBuilder {
        CoverageBuilder() {
            cover.Descripcion__c = 'Descript cover';
            cover.Importe_Asegurado__c = 15000.00;
            cover.Importe_Deducible__c = 1500.00;
            cover.Codigo__c = 'ABCDE';
        }

        public CoverageBuilder forPolicy(Poliza__c p) {
            cover.Poliza__c = p.Id;
            return this;
        }

        Cobertura__c cover = new Cobertura__c();

        public Cobertura__c build() {
            return cover;
        }
    }

    public static CoverageBuilder aCoverage() {
        return new CoverageBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Siniestro Simplicidad
    //---------------------------------------------------------------------------------------------------------------------------
    public class SimplicidadClaimBuilder {
        SimplicidadClaimBuilder() {
            claim.nroAnnio = '1';
            claim.codRamo = '2';
            claim.nroSiniestro = '17758';
            claim.descRamo = 'COMBINADO FAMILIAR';
            claim.nroSucursal = '1';
            claim.nroNotificacion = '';
            claim.fechaDecl = '2015-11-10 15:35:04.0';
            claim.fechaOcurr = '10/11/2015';
            claim.horaOcurr = '2015-11-10 15:35:00.0';
            claim.codNacionalidad = 'M';
            claim.codRif = '18999875';
            claim.descNombre = 'FABIAN VALENTIN PESTCHANKER';
            claim.codCausaSin = '200';
            claim.descSin = 'ROBO / HURTO CONTENIDO GENERAL';
            claim.codPlan = '038';
            claim.codOpFinanc = 'AHO400000002430766';
            claim.codCobert = 'codCobert';
            claim.codRiesgo = 'RCG';
            claim.descRiesgo = 'COMBINADO FAMILIAR';
            claim.lugarOcurr = 'Catamarca';
            claim.codPostal = '4723';
            claim.codCiudad = '13201';
            claim.descCiudad = 'LOS ESTANTES';
            claim.descProv = 'CATAMARCA';
            claim.formaOcurr = 'Algo';
            claim.codEjecutivo = 'X9999';
            claim.descEjecutivo = 'ROMEO ROXANA';
            claim.codSucDenuncia = '1';
            claim.descSucDenuncia = 'SUCURSAL BUENOS AIRES';
            claim.codJuzgado = 'codJuzgado';
            claim.codComisaria = 'codComisaria';
            claim.codActa = 'codActa';
            claim.cobTec = 'S';
            claim.cobFinanc = 'N';
        }

        public SimplicidadClaimBuilder forPolicy(Poliza__c p) {
            claim.nroPoliza = p.Poliza__c.format();
            claim.nroCerti = p.Certificado__c.format();
            claim.nroEndoso = p.Endoso__c.format();
            return this;
        }

        public SimplicidadClaimBuilder forClient(Account acc) {
            claim.nombreCliente = acc.FirstName;
            claim.apellidoCliente = acc.LastName;
            claim.tipoDocCliente = acc.Tipo_de_Documento__c;
            claim.numeroDocCliente = acc.Numero_de_Documento__c;
            return this;
        }

        public SimplicidadClaimBuilder withCoverage(RectorCoverage cov) {
            claim.affectedCoverages.add(cov);
            return this;
        }

        SimplicidadClaim claim = new SimplicidadClaim();

        public SimplicidadClaim build() {
            return claim;
        }
    }

    public static SimplicidadClaimBuilder aSimplicidadClaim() {
        return new SimplicidadClaimBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // EditSiniestroExtensionMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class EditSiniestroExtensionMockBuilder {
        public EditSiniestroExtensionMockBuilder withSimplicidadClaim(SimplicidadClaim c) {
            claim = c;
            return this;
        }

        public EditSiniestroExtensionMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        SimplicidadClaim claim = new SimplicidadClaim();
        Boolean syntaxisError = false;

        public EditSiniestroExtensionMock build() {
            EditSiniestroExtensionMock mock = new EditSiniestroExtensionMock(claim, syntaxisError);
            return mock;
        }
    }

    public static EditSiniestroExtensionMockBuilder aEditSiniestroExtensionMock() {
        return new EditSiniestroExtensionMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Telefono Buho Senal
    //---------------------------------------------------------------------------------------------------------------------------
    public class BuhoPhoneBuilder {
        public BuhoPhoneBuilder withName(String n) {
            name = n;
            return this;
        }

        public BuhoPhoneBuilder withPhone(String p) {
            phone = p;
            return this;
        }

        String name = 'test';
        String phone = '1234';

        public Telefonos_Buho_Senal__c build() {
            Telefonos_Buho_Senal__c buhoPhone = new Telefonos_Buho_Senal__c();
            buhoPhone.Name = name;
            buhoPhone.Telefono__c = phone;

            return buhoPhone;
        }
    }

    public static BuhoPhoneBuilder aBuhoPhone() {
        return new BuhoPhoneBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Codigo Pantalla Protegida
    //---------------------------------------------------------------------------------------------------------------------------
    public class PantallaProtegidaCodeBuilder {
        public PantallaProtegidaCodeBuilder withCode(String c) {
            name = c;
            return this;
        }

        String name = 'test';
        String phone = '1234';

        public Pantalla_Protegida__c build() {
            Pantalla_Protegida__c PantallaProtegidaCode = new Pantalla_Protegida__c();
            PantallaProtegidaCode.Name = name;

            return PantallaProtegidaCode;
        }
    }

    public static PantallaProtegidaCodeBuilder aPantallaProtegidaCode() {
        return new PantallaProtegidaCodeBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    public with sharing class IosPushNotificationMockBuilder {
        IosPushNotificationWebServiceMock m = new IosPushNotificationWebServiceMock();

        public IosPushNotificationMockBuilder withReturnOk(boolean value) {
            m.returnOk = value;
            return this;
        }

        public IosPushNotificationMockBuilder withStatusCode(integer value) {
            m.statusCode = value;
            return this;
        }

        public IosPushNotificationWebServiceMock build() {
            return m;
        }
    }

    public static IosPushNotificationMockBuilder anIosPushNotificationWebServiceMock() {
        return new IosPushNotificationMockBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Forms
    //---------------------------------------------------------------------------------------------------------------------------
    public class FormBuilder {
        public FormBuilder withName(String name) {
            form.Name = name;
            return this;
        }

        public FormBuilder withFirstQuestion(Nodo__c node) {
            form.Primer_Nodo__c = node.Id;
            return this;
        }

        Formulario__c form = new Formulario__c();

        public Formulario__c build() {
            return form;
        }
    }

    public static FormBuilder aForm() {
        return new FormBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Nodes
    //---------------------------------------------------------------------------------------------------------------------------
    public class NodeBuilder {
        public NodeBuilder withName(String name) {
            node.Name = name;
            return this;
        }

        public NodeBuilder withNextQuestion(Nodo__c next) {
            node.Proxima_Pregunta__c = next.Id;
            return this;
        }

        public NodeBuilder isEndNode() {
            node.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Fin'][0].Id;
            return this;
        }

        public NodeBuilder withType(String typeOfQuestion) {
            node.Tipo_de_pregunta__c = typeOfQuestion;
            return this;
        }

        Nodo__c node = new Nodo__c();

        public NodeBuilder withQuestion(String question) {
            node.Pregunta__c = question;
            return this;
        }

        public Nodo__c build() {
            return node;
        }
    }

    public static NodeBuilder aNode() {
        return new NodeBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Answers
    //---------------------------------------------------------------------------------------------------------------------------
    public class AnswerBuilder {
        public AnswerBuilder withName(String name) {
            answer.Name = name;
            return this;
        }

        public AnswerBuilder withNode(Nodo__c thisNode) {
            answer.Pregunta__c = thisNode.Id;
            return this;
        }

        public AnswerBuilder withAssociatedField(String field) {
            answer.Campo_Relacionado__c = field;
            return this;
        }

        public AnswerBuilder withType(String typeOfQuestion) {
            answer.Tipo_de_Dato__c = typeOfQuestion;
            return this;
        }

        Respuesta__c answer = new Respuesta__c();

        public Respuesta__c build() {
            return answer;
        }
    }

    public static AnswerBuilder anAnswer() {
        return new AnswerBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Lote
    //---------------------------------------------------------------------------------------------------------------------------
    public class LotBuilder {
        public LotBuilder withRectorId(String param) {
            lot.Lote_IdBHSeg__c = param;
            return this;
        }

        public LotBuilder withCantidadPiezasElectronicas(Integer param) {
            lot.Cantidad_Piezas_Electronicas__c = param;
            return this;
        }

        public LotBuilder withCantidadPiezasFisicas(Integer param) {
            lot.cantidad_piezas_fisicas__c = param;
            return this;
        }

        public LotBuilder withElectronicPieces(Boolean param) {
            lot.Contiene_Piezas_Electronicas__c = param;
            return this;
        }

        public LotBuilder withPhysicalPieces(Boolean param) {
            lot.Contiene_Piezas_Fisicas__c = param;
            return this;
        }

        public LotBuilder withElectronicStatus(String param) {
            lot.Estado_Electronico__c = param;
            return this;
        }

        public LotBuilder withPhysicalStatus(String param) {
            lot.Estado_Fisico__c = param;
            return this;
        }

        public LotBuilder withSupplies(String param) {
            lot.Insumos__c = param;
            return this;
        }

        public LotBuilder withResume(String param) {
            lot.Sumario__c = param;
            return this;
        }

        public LotBuilder withExcecutionDatetime(Datetime param) {
            lot.Fecha_de_Ejecucion__c = param;
            return this;
        }

        public LotBuilder piecesLoaded() {
            lot.Piezas_Cargadas__c = true;
            return this;
        }

        Lote__c lot = new Lote__c();

        public LotBuilder() {
            lot.Fecha_de_Creacion_Rector__c = Datetime.now();
            lot.Fecha_de_Ejecucion__c = Datetime.now();
        }

        public Lote__c build() {
            return lot;
        }
    }

    public static LotBuilder aLot() {
        return new LotBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // CheckForNewLotsMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class CheckForNewLotsMockBuilder {
        public CheckForNewLotsMockBuilder addLot(Lote__c l) {
            lots.add(l);
            return this;
        }

        public CheckForNewLotsMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        List<Lote__c> lots = new List<Lote__c>();
        Boolean syntaxisError = false;

        public CheckForNewLotsMock build() {
            CheckForNewLotsMock mock = new CheckForNewLotsMock(lots, syntaxisError);
            return mock;
        }
    }

    public static CheckForNewLotsMockBuilder aCheckForNewLotsMock() {
        return new CheckForNewLotsMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // DeliveryMailSetting
    //---------------------------------------------------------------------------------------------------------------------------
    public class DeliveryMailSettingBuilder {
        public DeliveryMailSettingBuilder withName(String param) {
            mailSetting.Name = param;
            return this;
        }

        public DeliveryMailSettingBuilder withSubject(String param) {
            mailSetting.Asunto__c = param;
            return this;
        }

        public DeliveryMailSettingBuilder withMail(String param) {
            mailSetting.Mail__c = param;
            return this;
        }

        public DeliveryMailSettingBuilder withMailCC(String param) {
            mailSetting.Con_Copia__c = param;
            return this;
        }

        Delivery_Direccion_Mail__c mailSetting = new Delivery_Direccion_Mail__c();

        public Delivery_Direccion_Mail__c build() {
            return mailSetting;
        }
    }

    public static DeliveryMailSettingBuilder aDeliveryMailSetting() {
        return new DeliveryMailSettingBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Pieza
    //---------------------------------------------------------------------------------------------------------------------------
    public class PieceBuilder {
        public PieceBuilder withRectorId(String param) {
            piece.Pieza_IdBHSeg__c = param;
            return this;
        }

        public PieceBuilder isPhysical(Boolean param) {
            piece.Pieza_Fisica__c = param;
            return this;
        }

        public PieceBuilder withTransaction(String param) {
            piece.Transaccion__c = param;
            return this;
        }

        public PieceBuilder withCuil(String param) {
            piece.CUIL__c = param;
            return this;
        }

        public PieceBuilder withNombre(String param) {
            piece.Nombre__c = param;
            return this;
        }

        public PieceBuilder withApellido(String param) {
            piece.Apellido__c = param;
            return this;
        }

        public PieceBuilder withFechaDeEnvio(Date param) {
            piece.Fecha_De_Envio__c = param;
            return this;
        }

        public PieceBuilder withDNI(String param) {
            piece.DNI__c = param;
            return this;
        }

        public PieceBuilder withEmail(String param) {
            piece.Email__c = param;
            return this;
        }

        public PieceBuilder withIdClienteBhSeg(String param) {
            piece.Id_Cliente_BHSeg__c = param;
            return this;
        }

        public PieceBuilder withIdBhSeg(String param) {
            piece.IdBHSeg__c = param;
            return this;
        }

        public PieceBuilder withBirthDate(Date param) {
            piece.Fecha_de_Nacimiento__c = param;
            return this;
        }

        public PieceBuilder withEstado(String param) {
            piece.Estado__c = param;
            return this;
        }

        public PieceBuilder withRamoIdBHSeg(String ramo) {
            piece.Ramo_IdBHSeg__c = ramo;
            return this;
        }

        public PieceBuilder procesarPorbatch() {
            piece.Procesar_Por_Batch__c = true;
            return this;
        }

        public PieceBuilder forLot(Lote__c lot) {
            piece.Lote__c = lot.Id;
            return this;
        }

        public PieceBuilder forPolizy(Poliza__c policy) {
            piece.Poliza__c = policy.Id;
            return this;
        }

        public PieceBuilder withPromocion(String value) {
            this.piece.Promocion__c = value;
            return this;
        }

        public PieceBuilder withOwnerId(Group value) {
            piece.OwnerId = value.Id;
            return this;
        }
        public PieceBuilder withOwnerId(User value) {
            piece.OwnerId = value.Id;
            return this;
        }

        public PieceBuilder withCalle(String value) {
            piece.Calle__c = value;
            return this;
        }

        public PieceBuilder withCodigoPostal(String value) {
            piece.Codigo_Postal__c = value;
            return this;
        }

        public PieceBuilder withDepartamento(String value) {
            piece.Departamento__c = value;
            return this;
        }

        public PieceBuilder withEndoso(String value) {
            piece.Endoso__c = value;
            return this;
        }

        public PieceBuilder withLocalidad(String value) {
            piece.Localidad__c = value;
            return this;
        }

        public PieceBuilder withNumero(String value) {
            piece.Numero__c = value;
            return this;
        }

        public PieceBuilder withNumerodeCertificado(String value) {
            piece.Numero_de_Certificado__c = value;
            return this;
        }

        public PieceBuilder withNumerodePoliza(String value) {
            piece.Numero_de_Poliza__c = value;
            return this;
        }

        public PieceBuilder withPiezaIdMandrill(String value) {
            piece.Pieza_IdMandrill__c = value;
            return this;
        }

        public PieceBuilder withPiso(String value) {
            piece.Piso__c = value;
            return this;
        }

        public PieceBuilder withPlan(String value) {
            piece.Plan__c = value;
            return this;
        }

        public PieceBuilder withProductoIdBHSeg(String value) {
            piece.Producto_IdBHSeg__c = value;
            return this;
        }

        public PieceBuilder withProducto(String value) {
            piece.Producto__c = value;
            return this;
        }

        public PieceBuilder withProvincia(String value) {
            piece.Provincia__c = value;
            return this;
        }

        public PieceBuilder withRamo(String value) {
            piece.Ramo__c = value;
            return this;
        }

        /** (2021-08-19 16:24:48) Valores disponibles:  'SUB ESTADO 1', 'SUB ESTADO 2', 'SUB ESTADO 3', 'Abierta' */
        public PieceBuilder withSubEstado(String value) {
            piece.Sub_Estado__c = value;
            return this;
        }

        public PieceBuilder withTomador(String value) {
            piece.Tomador__c = value;
            return this;
        }

        public PieceBuilder withPiezaMarcada(Pieza_Marcada__c value) {
            piece.Pieza_Marcada__c = value.Id;
            return this;
        }

        public PieceBuilder withInformada(Boolean value) {
            piece.Informada__c = value;
            return this;
        }

        public PieceBuilder withFechadeCreacionRector(Date value) {
            piece.Fecha_de_Creacion_Rector__c = value;
            return this;
        }

        public PieceBuilder withFechadeModificacionRector(Date value) {
            piece.Fecha_de_Modificacion_Rector__c = value;
            return this;
        }

        public PieceBuilder withCuenta(Account value) {
            piece.Cuenta__c = value.Id;
            return this;
        }

        Pieza__c piece = new Pieza__c();

        public Pieza__c build() {
            return piece;
        }
    }

    public static PieceBuilder aPiece() {
        return new PieceBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // LotPostFileAttachent
    //---------------------------------------------------------------------------------------------------------------------------
    public class LotPostFileAttachentBuilder {
        Attachment attach = new Attachment();

        public LotPostFileAttachentBuilder withName(String param) {
            this.attach.Name = param;
            return this;
        }

        public LotPostFileAttachentBuilder withBody(String param) {
            this.attach.Body = Blob.valueOf(param);
            return this;
        }

        public LotPostFileAttachentBuilder forLot(Lote__c lot) {
            this.attach.ParentId = lot.Id;
            return this;
        }

        public Attachment build() {
            this.attach.Body = Blob.valueOf('cuerpo del attachment');
            return attach;
        }
    }

    public static LotPostFileAttachentBuilder aLotPostFileAttachment() {
        return new LotPostFileAttachentBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // RetrievePiecesMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class RetrievePiecesMockBuilder {
        public RetrievePiecesMockBuilder addPiece(Pieza__c p) {
            pieces.add(p);
            return this;
        }

        public RetrievePiecesMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }

        List<Pieza__c> pieces = new List<Pieza__c>();
        Boolean syntaxisError = false;

        public RetrievePiecesMock build() {
            RetrievePiecesMock mock = new RetrievePiecesMock(pieces, syntaxisError);
            return mock;
        }
    }

    public static RetrievePiecesMockBuilder aRetrievePiecesMock() {
        return new RetrievePiecesMockBuilder();
    }
    //---------------------------------------------------------------------------------------------------------------------------

    //---------------------------------------------------------------------------------------------------------------------------
    // FindDetalleLoteMock
    //---------------------------------------------------------------------------------------------------------------------------
    public class FindDetalleLoteMockBuilder {
        public FindDetalleLoteMockBuilder withSyntaxisError() {
            syntaxisError = true;
            return this;
        }
        Boolean syntaxisError = false;

        public FindDetalleLoteMock build() {
            FindDetalleLoteMock mock = new FindDetalleLoteMock(syntaxisError);
            return mock;
        }
    }

    public static FindDetalleLoteMockBuilder aFindDetalleLoteMock() {
        return new FindDetalleLoteMockBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Reenvio de poliza
    //---------------------------------------------------------------------------------------------------------------------------
    public class ReenvioDePolizaBuilder {
        private Reenvio_de_Poliza__c aReenvioDePoliza;

        private ReenvioDePolizaBuilder() {
            this.aReenvioDePoliza = new Reenvio_de_Poliza__c();
        }

        public ReenvioDePolizaBuilder withNumber(String aNumber) {
            this.aReenvioDePoliza.Numero__c = aNumber;
            return this;
        }

        public ReenvioDePolizaBuilder withActiveDirectoryUsername(String activeDirectory) {
            this.aReenvioDePoliza.Active_Directory_Username__c = activeDirectory;
            return this;
        }

        public ReenvioDePolizaBuilder withCase(Case aCase) {
            this.aReenvioDePoliza.Caso__c = aCase.id;
            return this;
        }

        public ReenvioDePolizaBuilder withCertificado(String certificado) {
            this.aReenvioDePoliza.Certificado__c = certificado;
            return this;
        }

        public ReenvioDePolizaBuilder withCUIT(String cuit) {
            this.aReenvioDePoliza.CUIT__c = cuit;
            return this;
        }

        public ReenvioDePolizaBuilder withEndoso(String endoso) {
            this.aReenvioDePoliza.Endoso__c = endoso;
            return this;
        }

        public ReenvioDePolizaBuilder withPhysycal(Boolean physical) {
            this.aReenvioDePoliza.Physical__c = physical;
            return this;
        }

        public ReenvioDePolizaBuilder withPoliza(Poliza__c poliza) {
            this.aReenvioDePoliza.Poliza__c = poliza.id;
            return this;
        }

        public ReenvioDePolizaBuilder withProducto(String producto) {
            this.aReenvioDePoliza.Producto__c = producto;
            return this;
        }

        public Reenvio_de_Poliza__c build() {
            return this.aReenvioDePoliza;
        }
    }

    public static ReenvioDePolizaBuilder aReenvioDePoliza() {
        return new ReenvioDePolizaBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Camara
    //---------------------------------------------------------------------------------------------------------------------------
    public class CamaraBuilder {
        private Camara__c camara = new Camara__c();

        public CamaraBuilder withCodigoDeSerie(String serial) {
            this.camara.Codigo_de_Serie__c = serial;
            return this;
        }

        public CamaraBuilder withEstado(String estado) {
            this.camara.Estado__c = estado;
            return this;
        }

        public CamaraBuilder withApellido(String apellido) {
            this.camara.Apellido__c = apellido;
            return this;
        }

        public CamaraBuilder withNombre(String nombre) {
            this.camara.Nombre__c = nombre;
            return this;
        }

        public CamaraBuilder withNumeroDeDocumento(Integer dni) {
            this.camara.Numero_de_Documento__c = dni;
            return this;
        }

        public CamaraBuilder withCuenta(Account cuenta) {
            this.camara.Cuenta__c = cuenta.id;
            return this;
        }

        public CamaraBuilder withVendedor(String vendedor) {
            this.camara.Vendedor__c = vendedor;
            return this;
        }

        public CamaraBuilder withDeposito(String deposito) {
            this.camara.Deposito__c = deposito;
            return this;
        }

        public CamaraBuilder withCanalUno(String canal1) {
            this.camara.Canal_1__c = canal1;
            return this;
        }

        public CamaraBuilder withCanalUnoDescripcion(String canal1descripcion) {
            this.camara.Canal_1_Descripcion__c = canal1descripcion;
            return this;
        }

        public CamaraBuilder withCanalDos(String canal2) {
            this.camara.Canal_2__c = canal2;
            return this;
        }

        public CamaraBuilder withCanalDosDescripcion(String canal2descripcion) {
            this.camara.Canal_2_Descripcion__c = canal2descripcion;
            return this;
        }

        public CamaraBuilder withCanalCuatro(String canal4) {
            this.camara.Canal_4__c = canal4;
            return this;
        }

        public CamaraBuilder withCanalCuatroDescripcion(String canal4descripcion) {
            this.camara.Canal_4_Descripcion__c = canal4descripcion;
            return this;
        }

        public Camara__c build() {
            return this.camara;
        }
    }

    public static CamaraBuilder aCamara() {
        return new CamaraBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Contacto
    //---------------------------------------------------------------------------------------------------------------------------
    public class ContactBuilder {
        private Contact aContact = new Contact();

        public ContactBuilder withFirstName(String firstname) {
            this.aContact.FirstName = firstname;
            return this;
        }

        public ContactBuilder withLastName(String lastname) {
            this.aContact.LastName = lastname;
            return this;
        }

        public ContactBuilder withAccountId(Account value) {
            this.aContact.AccountId = value.Id;
            return this;
        }

        public Contact build() {
            return this.aContact;
        }
    }

    public static ContactBuilder aContact() {
        return new ContactBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Temporary Access Token Configuracion Personalizada
    //---------------------------------------------------------------------------------------------------------------------------
    public class TemporaryAccessTokenSettingBuilder {
        private Temporary_Access_Token__c aTemporaryAccessToken;

        private TemporaryAccessTokenSettingBuilder() {
            this.aTemporaryAccessToken = new Temporary_Access_Token__c();
        }

        public TemporaryAccessTokenSettingBuilder withName(String name) {
            this.aTemporaryAccessToken.Name = name;
            return this;
        }

        public TemporaryAccessTokenSettingBuilder withAccessToken(String accessToken) {
            this.aTemporaryAccessToken.Access_Token__c = accessToken;
            return this;
        }

        public TemporaryAccessTokenSettingBuilder withExpireDate(Datetime expireDate) {
            this.aTemporaryAccessToken.Expire_Date__c = expireDate;
            return this;
        }

        public TemporaryAccessTokenSettingBuilder withTokenType(String type) {
            this.aTemporaryAccessToken.Token_Type__c = type;
            return this;
        }

        public Temporary_Access_Token__c build() {
            return this.aTemporaryAccessToken;
        }
    }

    public static TemporaryAccessTokenSettingBuilder aTemporaryAccessToken() {
        return new TemporaryAccessTokenSettingBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Limites de Cobertura
    //---------------------------------------------------------------------------------------------------------------------------
    public class LimiteDeCoberturaBuilder {
        private Limite_de_cobertura__c coverageLimit;

        private LimiteDeCoberturaBuilder() {
            this.coverageLimit = new Limite_de_cobertura__c();
        }

        public LimiteDeCoberturaBuilder withIdLimiteDeCobertura(String code) {
            this.coverageLimit.Id_Limite_Cobertura__c = code;
            return this;
        }

        public LimiteDeCoberturaBuilder withCodigoCobertura(String code) {
            this.coverageLimit.Codigo_Cobertura__c = code;
            return this;
        }

        public LimiteDeCoberturaBuilder withIdCoberturaDeProducto(String code) {
            this.coverageLimit.Id_Cobertura_De_Producto__c = code;
            return this;
        }

        public LimiteDeCoberturaBuilder withIdIdentificadorLimite(String code) {
            this.coverageLimit.Id_Identificador_Limite__c = code;
            return this;
        }

        public LimiteDeCoberturaBuilder forIdentificadorLimite(Identificador_de_Limite__c identifier) {
            this.coverageLimit.Identificador_de_Limite__c = identifier.id;
            return this;
        }

        public LimiteDeCoberturaBuilder withTasaCobertura(Decimal fee) {
            this.coverageLimit.Tasa_Cobertura__c = fee;
            return this;
        }

        public LimiteDeCoberturaBuilder withPorcentajeDeSumaAsegurada(Decimal percentage) {
            this.coverageLimit.Porcentaje_Suma_Asegurada__c = percentage;
            return this;
        }

        public LimiteDeCoberturaBuilder withLimiteMinimo(Decimal amount) {
            this.coverageLimit.Limite_Min__c = amount;
            return this;
        }

        public LimiteDeCoberturaBuilder withLimiteMaximo(Decimal amount) {
            this.coverageLimit.Limite_Max__c = amount;
            return this;
        }

        public Limite_de_Cobertura__c build() {
            return this.coverageLimit;
        }
    }

    public static LimiteDeCoberturaBuilder aLimiteDeCobertura() {
        return new LimiteDeCoberturaBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Producto Base
    //---------------------------------------------------------------------------------------------------------------------------
    public class ProductoBaseBuilder {
        private Producto_Base__c baseProduct;

        private ProductoBaseBuilder() {
            this.baseProduct = new Producto_Base__c();
        }

        public ProductoBaseBuilder withIdProductoBase(String code) {
            this.baseProduct.Id_Producto_Base__c = code;
            return this;
        }

        public ProductoBaseBuilder withDescripcionProducto(String productDescription) {
            this.baseProduct.Descripcion_Producto__c = productDescription;
            return this;
        }

        public ProductoBaseBuilder withDescripcionRamo(String branchDescription) {
            this.baseProduct.Descripcion_Ramo__c = branchDescription;
            return this;
        }

        public ProductoBaseBuilder withEdadMaxima(Integer age) {
            this.baseProduct.Edad_Max__c = age;
            return this;
        }

        public ProductoBaseBuilder withEdadMinima(Integer age) {
            this.baseProduct.Edad_Min__c = age;
            return this;
        }

        public ProductoBaseBuilder withProductoIdBhSeg(String productCode) {
            this.baseProduct.Producto_IdBHSeg__c = productCode;
            return this;
        }

        public ProductoBaseBuilder withRamoIdBhSeg(String branchCode) {
            this.baseProduct.Ramo_IdBHSeg__c = branchCode;
            return this;
        }

        public ProductoBaseBuilder inactive() {
            this.baseProduct.activo__c = false;
            return this;
        }

        public ProductoBaseBuilder active() {
            this.baseProduct.activo__c = true;
            return this;
        }

        public Producto_Base__c build() {
            return this.baseProduct;
        }
    }

    public static ProductoBaseBuilder aProductoBase() {
        return new ProductoBaseBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Cobertura de Producto
    //---------------------------------------------------------------------------------------------------------------------------
    public class CoberturaDeProductoBuilder {
        private Cobertura_De_Producto__c coverage;

        private CoberturaDeProductoBuilder() {
            this.coverage = new Cobertura_De_Producto__c();
        }

        public CoberturaDeProductoBuilder forProductoBase(String id) {
            this.coverage.Producto_Base__c = id;
            return this;
        }

        public CoberturaDeProductoBuilder withIdProductoBase(String code) {
            this.coverage.Id_Producto_Base__c = code;
            return this;
        }

        public CoberturaDeProductoBuilder withCodigoCobertura(String code) {
            this.coverage.Codigo_Cobertura__c = code;
            return this;
        }

        public CoberturaDeProductoBuilder withDescripcionLarga(String longDescription) {
            this.coverage.Descripcion_Larga__c = longDescription;
            return this;
        }

        public CoberturaDeProductoBuilder withDescripcionCorta(String shortDescription) {
            this.coverage.Descripcion_Corta__c = shortDescription;
            return this;
        }

        public CoberturaDeProductoBuilder withIdCoberturaDeProducto(String coverageIdentifier) {
            this.coverage.Id_Cobertura_De_Producto__c = coverageIdentifier;
            return this;
        }

        public CoberturaDeProductoBuilder withPorcentajeDeAumento(Decimal percentage) {
            this.coverage.Porcentaje_de_Aumento__c = percentage;
            return this;
        }

        public CoberturaDeProductoBuilder withPorcentajeDeDisminucion(Decimal percentage) {
            this.coverage.Porcentaje_de_Disminucion__c = percentage;
            return this;
        }

        public CoberturaDeProductoBuilder withAddon(Boolean value) {
            this.coverage.Add_On__c = value;
            return this;
        }

        public Cobertura_De_Producto__c build() {
            return this.coverage;
        }
    }

    public static CoberturaDeProductoBuilder aCoberturaDeProducto() {
        return new CoberturaDeProductoBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Gasto
    //---------------------------------------------------------------------------------------------------------------------------
    public class GastoBuilder {
        private Gasto__c gasto;

        private GastoBuilder() {
            this.gasto = new Gasto__c();
        }

        public GastoBuilder withNombre(String name) {
            this.gasto.Name = name;
            return this;
        }

        public GastoBuilder withDescripcion(String description) {
            this.gasto.Descripcion_Gasto__c = description;
            return this;
        }

        public GastoBuilder withIdIdentificadorLimite(String code) {
            this.gasto.Id_Identificador_Limite__c = code;
            return this;
        }

        public GastoBuilder forIdentificadorLimite(String id) {
            this.gasto.Identificador_de_Limite__c = id;
            return this;
        }

        public GastoBuilder withPorcentajeGasto(Decimal percentage) {
            this.gasto.Porcentaje_Gasto__c = percentage;
            return this;
        }

        public Gasto__c build() {
            return this.gasto;
        }
    }

    public static GastoBuilder aGasto() {
        return new GastoBuilder();
    }

    //---------------------------------------------------------------------------------------------------------------------------
    // Numeracion Enacom
    //---------------------------------------------------------------------------------------------------------------------------
    public class NumeracionEnacomBuilder {
        private Numeracion_Enacom__c enacomNumeration;

        private NumeracionEnacomBuilder() {
            this.enacomNumeration = new Numeracion_Enacom__c();
        }

        public NumeracionEnacomBuilder withName(String name) {
            this.enacomNumeration.Name = name;
            return this;
        }

        public NumeracionEnacomBuilder withCodigoIdentificador(String code) {
            this.enacomNumeration.Codigo_Identificador__c = code;
            return this;
        }

        public NumeracionEnacomBuilder withIndicativo(Integer indicative) {
            this.enacomNumeration.INDICATIVO__c = indicative;
            return this;
        }

        public NumeracionEnacomBuilder withBloque(Integer block) {
            this.enacomNumeration.BLOQUE__c = block;
            return this;
        }

        public NumeracionEnacomBuilder withLocalidad(String localityName) {
            this.enacomNumeration.LOCALIDAD__c = localityName;
            return this;
        }

        public NumeracionEnacomBuilder withModalidad(String mode) {
            this.enacomNumeration.MODALIDAD__c = mode;
            return this;
        }

        public NumeracionEnacomBuilder withOperador(String operator) {
            this.enacomNumeration.OPERADOR__c = operator;
            return this;
        }

        public NumeracionEnacomBuilder withServicio(String service) {
            this.enacomNumeration.SERVICIO__c = service;
            return this;
        }

        public Numeracion_Enacom__c build() {
            return this.enacomNumeration;
        }
    }

    public static NumeracionEnacomBuilder aNumeracionEnacom() {
        return new NumeracionEnacomBuilder();
    }

    /*------------------------------------------------------------------------
	             AccountBuilderStart
	------------------------------------------------------------------------*/
    public class AccountBuilder {
        private Account obj = new Account(LastName = 'STRING');

        public AccountBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public AccountBuilder withLastName(String value) {
            obj.LastName = value;
            return this;
        }

        public AccountBuilder withFirstName(String value) {
            obj.FirstName = value;
            return this;
        }

        public AccountBuilder withAGUser(Boolean value) {
            obj.AGUser__c = value;
            return this;
        }

        public AccountBuilder withAniversarioAG(Date value) {
            obj.Aniversario_AG__c = value;
            return this;
        }

        public AccountBuilder withApellidoAG(String value) {
            obj.Apellido_AG__c = value;
            return this;
        }

        public AccountBuilder withNombreAG(String value) {
            obj.Nombre_AG__c = value;
            return this;
        }

        public AccountBuilder withEmailAG(String value) {
            obj.Email_AG__c = value;
            return this;
        }

        public AccountBuilder withSolicituddeBajaActiva(Boolean value) {
            obj.Solicitud_de_Baja_Activa__c = value;
            return this;
        }

        public AccountBuilder withSolicituddeArrepentimientoActiva(Boolean value) {
            obj.Solicitud_de_Arrepentimiento_Activa__c = value;
            return this;
        }

        public AccountBuilder withNumerodeDocumento(String value) {
            obj.Numero_de_Documento__c = value;
            return this;
        }

        public AccountBuilder withPersonBirthdate(Date value) {
            obj.PersonBirthdate = value;
            return this;
        }

        public AccountBuilder withCUIT(String value) {
            obj.CUIT__c = value;
            return this;
        }

        /** (2021-03-29 14:07:44) Valores disponibles:  'Femenino', 'Masculino' */
        public AccountBuilder withGenero(String value) {
            obj.Genero__c = value;
            return this;
        }

        public AccountBuilder withIdClienteBHSeg(String value) {
            obj.Id_Cliente_BHSeg__c = value;
            return this;
        }

        public AccountBuilder isAPIUpdate(boolean IsAPIUpdate) {
            obj.Is_API_Update__c = IsAPIUpdate;
            return this;
        }

        public Account build() {
            return obj;
        }
    }

    public static AccountBuilder anAccount() {
        return new AccountBuilder();
    }

    public static AccountBuilder anAccountPersonAccount() {
        AccountBuilder val = new AccountBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Account', 'PersonAccount').Id;
        return val;
    }

    public static AccountBuilder anAccountBusinessAccount() {
        AccountBuilder val = new AccountBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Account', 'Business_Account').Id;
        return val;
    }

    /*------------------------------------------------------------------------
	             AccountBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             ProductorBuilderStart
	------------------------------------------------------------------------*/
    public class ProductorBuilder {
        private Productor__c obj = new Productor__c(Codigo_Productor__c = 'STRING', Id_Productor__c = 'STRING');

        public ProductorBuilder withOwnerId(Group value) {
            obj.OwnerId = value.Id;
            return this;
        }
        public ProductorBuilder withOwnerId(User value) {
            obj.OwnerId = value.Id;
            return this;
        }

        public ProductorBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public ProductorBuilder withCodigoProductor(String value) {
            obj.Codigo_Productor__c = value;
            return this;
        }

        public ProductorBuilder withDescripcionProductor(String value) {
            obj.Descripcion_Productor__c = value;
            return this;
        }

        public ProductorBuilder withIdProductor(String value) {
            obj.Id_Productor__c = value;
            return this;
        }

        public Productor__c build() {
            return obj;
        }
    }

    public static ProductorBuilder aProductor() {
        return new ProductorBuilder();
    }

    /*------------------------------------------------------------------------
	             ProductorBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             GestionBuilderStart
	------------------------------------------------------------------------*/
    public class GestionBuilder {
        private Gestion__c obj = new Gestion__c();

        public GestionBuilder withCuenta(Account value) {
            obj.Cuenta__c = value.Id;
            return this;
        }

        public GestionBuilder withCaso(Case value) {
            obj.Caso__c = value.Id;
            return this;
        }

        public GestionBuilder withPoliza(Poliza__c value) {
            obj.Poliza__c = value.Id;
            return this;
        }

        public GestionBuilder withMotivoBajaIdBHSeg(String value) {
            obj.Motivo_Baja_IdBHSeg__c = value;
            return this;
        }

        /** (2020-12-30 12:24:02) Valores disponibles:  'A PEDIDO DEL ASEGURADO', 'CLIENTE NO DIO EL CONSENTIMIENTO', 'DISCONFORME CON EL SERVICIO' */
        public GestionBuilder withMotivoBaja(String value) {
            obj.Motivo_Baja__c = value;
            return this;
        }

        public GestionBuilder withResultadoIdBHSeg(String value) {
            obj.Resultado_IdBHSeg__c = value;
            return this;
        }

        /** (2020-12-30 12:24:02) Valores disponibles:  'Aplicada', 'Cambio de Combo por Transformacion', 'Cambio de mail', 'Consulta Resuelta', 'CorrecciÃÂ³n de beneficiarios', 'Envio de Carta de Transformacion', 'Finalizada', 'Modificacion efectuada', 'Notificación de siniestro', 'Ocupado/no contesta', 'Rechazada', 'Reclamo Derivado', 'Venta Retenida / Mantiene Combo', 'Venta Retenida / Modifica Combo', 'Volver a llamar', 'Venta No Retenida / Cliente conflictivo', 'Venta No Retenida / No Interesado / Sin Nota', 'Venta No Retenida / No Interesado / Con Nota' */
        public GestionBuilder withResultado(String value) {
            obj.Resultado__c = value;
            return this;
        }

        public GestionBuilder withEstado(String value) {
            obj.Estado__c = value;
            return this;
        }

        public GestionBuilder withDetalleEndoso(String value) {
            obj.Detalle_Endoso__c = value;
            return this;
        }

        public GestionBuilder withDescripcion(String value) {
            obj.Descripcion__c = value;
            return this;
        }

        public GestionBuilder withObservaciones(String value) {
            obj.Observaciones__c = value;
            return this;
        }

        public GestionBuilder withPremioPlanNuevo(Decimal value) {
            obj.Premio_Plan_Nuevo__c = value;
            return this;
        }

        public GestionBuilder withIsAPIUpdate(Boolean value) {
            obj.Is_API_Update__c = value;
            return this;
        }

        /** (2021-04-13 23:51:21) Valores disponibles:  'Pendiente', 'Para Enviar', 'Enviada', 'Fallida', 'Creada en Rector', 'Cancelada' */
        public GestionBuilder withEstadoComunicacionRector(String value) {
            obj.Estado_Comunicacion_Rector__c = value;
            return this;
        }

        public Gestion__c build() {
            return obj;
        }
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static GestionBuilder aGestion() {
        return new GestionBuilder();
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static GestionBuilder aGestionMegaservicio() {
        GestionBuilder val = new GestionBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Gestion__c', 'Megaservicio').Id;
        return val;
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static GestionBuilder aGestionMultiAsistencia() {
        GestionBuilder val = new GestionBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Gestion__c', 'Multi_Asistencia').Id;
        return val;
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static GestionBuilder aGestionActualizacionNombreApellido() {
        GestionBuilder val = new GestionBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Gestion__c', 'Actualizacion_Nombre_Apellido').Id;
        return val;
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static GestionBuilder aGestionBaja() {
        GestionBuilder val = new GestionBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Gestion__c', 'Baja').Id;
        return val;
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static GestionBuilder aGestionBasica() {
        GestionBuilder val = new GestionBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Gestion__c', 'Basica').Id;
        return val;
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static GestionBuilder aGestionCambioBeneficiarios() {
        GestionBuilder val = new GestionBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Gestion__c', 'Cambio_Beneficiarios').Id;
        return val;
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static GestionBuilder aGestionCambioEmails() {
        GestionBuilder val = new GestionBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Gestion__c', 'Cambio_Emails').Id;
        return val;
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static GestionBuilder aGestionCambioMedioPago() {
        GestionBuilder val = new GestionBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Gestion__c', 'Cambio_Medio_Pago').Id;
        return val;
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static GestionBuilder aGestionCambioPlan() {
        GestionBuilder val = new GestionBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Gestion__c', 'Cambio_Plan').Id;
        return val;
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static GestionBuilder aGestionCambioTelefonos() {
        GestionBuilder val = new GestionBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Gestion__c', 'Cambio_Telefonos').Id;
        return val;
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static GestionBuilder aGestionDeclaracionSiniestro() {
        GestionBuilder val = new GestionBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Gestion__c', 'Declaracion_Siniestro').Id;
        return val;
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static GestionBuilder aGestionCambiodeDomicilio() {
        GestionBuilder val = new GestionBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Gestion__c', 'Cambio_de_Domicilio').Id;
        return val;
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static GestionBuilder aGestionCambiodeDomicilioBienAsegurado() {
        GestionBuilder val = new GestionBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Gestion__c', 'Cambio_de_Domicilio_Bien_Asegurado').Id;
        return val;
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static GestionBuilder aGestionRetencion() {
        GestionBuilder val = new GestionBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Gestion__c', 'Retencion').Id;
        return val;
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static GestionBuilder aGestionRechazaTransformacion() {
        GestionBuilder val = new GestionBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Gestion__c', 'Rechaza_Transformacion').Id;
        return val;
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static GestionBuilder aGestionReintegroExtraordinario() {
        GestionBuilder val = new GestionBuilder();
        val.obj.RecordTypeId = XappiaHelper.getRecordType('Gestion__c', 'Reintegro_Extraordinario').Id;
        return val;
    }

    /*------------------------------------------------------------------------
				GestionBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
				MotivoBajaBuilderStart
	------------------------------------------------------------------------*/
    public class MotivoBajaBuilder {
        private Motivo_Baja__c obj = new Motivo_Baja__c(Name = 'STRING');

        public MotivoBajaBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public MotivoBajaBuilder withCodigo(String value) {
            obj.Codigo__c = value;
            return this;
        }

        public MotivoBajaBuilder withDescripcion(String value) {
            obj.Descripcion__c = value;
            return this;
        }

        public Motivo_Baja__c build() {
            return obj;
        }
    }

    public static MotivoBajaBuilder aMotivoBaja() {
        return new MotivoBajaBuilder();
    }

    /*------------------------------------------------------------------------
				MotivoBajaBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
				ResultadoGestionBuilderStart
	------------------------------------------------------------------------*/
    public class ResultadoGestionBuilder {
        private Resultado_Gestion__c obj = new Resultado_Gestion__c(Name = 'STRING');

        public ResultadoGestionBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public ResultadoGestionBuilder withCodigo(String value) {
            obj.Codigo__c = value;
            return this;
        }

        public ResultadoGestionBuilder withDescripcion(String value) {
            obj.Descripcion__c = value;
            return this;
        }

        public ResultadoGestionBuilder withEstadodelagestion(String value) {
            obj.Estado_de_la_gestion__c = value;
            return this;
        }

        public Resultado_Gestion__c build() {
            return obj;
        }
    }

    public static ResultadoGestionBuilder aResultadoGestion() {
        return new ResultadoGestionBuilder();
    }

    /*------------------------------------------------------------------------
				ResultadoGestionBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             IdentificadordeLimiteBuilderStart
	------------------------------------------------------------------------*/
    public class IdentificadordeLimiteBuilder {
        private Identificador_de_Limite__c obj = new Identificador_de_Limite__c(
            Id_Identificador_Limite__c = 'STRING',
            Id_Producto_Base__c = 'STRING'
        );

        public IdentificadordeLimiteBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public IdentificadordeLimiteBuilder withProductoBase(Producto_Base__c value) {
            obj.Producto_Base__c = value.Id;
            return this;
        }

        public IdentificadordeLimiteBuilder withCanal(Canal__c value) {
            obj.Canal__c = value.Id;
            return this;
        }

        public IdentificadordeLimiteBuilder withDescripcionCanal(String value) {
            obj.Descripcion_Canal__c = value;
            return this;
        }

        public IdentificadordeLimiteBuilder withDescripcionProducto(String value) {
            obj.Descripcion_Producto__c = value;
            return this;
        }

        public IdentificadordeLimiteBuilder withDescripcionProductor(String value) {
            obj.Descripcion_Productor__c = value;
            return this;
        }

        public IdentificadordeLimiteBuilder withIdCanal(String value) {
            obj.Id_Canal__c = value;
            return this;
        }

        public IdentificadordeLimiteBuilder withIdIdentificadorLimite(String value) {
            obj.Id_Identificador_Limite__c = value;
            return this;
        }

        public IdentificadordeLimiteBuilder withIdProductoBase(String value) {
            obj.Id_Producto_Base__c = value;
            return this;
        }

        public IdentificadordeLimiteBuilder withIdProductor(String value) {
            obj.Id_Productor__c = value;
            return this;
        }

        public IdentificadordeLimiteBuilder withProductor(Productor__c value) {
            obj.Productor__c = value.Id;
            return this;
        }

        /** (2021-01-19 22:36:06) Valores disponibles:  'Retencion', 'Venta', 'Retencion/Venta' */
        public IdentificadordeLimiteBuilder withTipodeUso(String value) {
            obj.Tipo_de_Uso__c = value;
            return this;
        }

        public Identificador_de_Limite__c build() {
            return obj;
        }
    }

    /** It require following fields to can be inserted: Producto_Base__c. */
    public static IdentificadordeLimiteBuilder anIdentificadordeLimite() {
        return new IdentificadordeLimiteBuilder();
    }

    /*------------------------------------------------------------------------
	             IdentificadordeLimiteBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             IdentificadordeEnlatadoBuilderStart
	------------------------------------------------------------------------*/
    public class IdentificadordeEnlatadoBuilder {
        private Identificador_de_Enlatado__c obj = new Identificador_de_Enlatado__c(
            Id_Identificador_Enlatado__c = 'STRING'
        );

        public IdentificadordeEnlatadoBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public IdentificadordeEnlatadoBuilder withCanal(Canal__c value) {
            obj.Canal__c = value.Id;
            return this;
        }

        public IdentificadordeEnlatadoBuilder withProductor(Productor__c value) {
            obj.Productor__c = value.Id;
            return this;
        }

        public IdentificadordeEnlatadoBuilder withProductoBase(Producto_Base__c value) {
            obj.Producto_Base__c = value.Id;
            return this;
        }

        public IdentificadordeEnlatadoBuilder withDescripcionCanal(String value) {
            obj.Descripcion_Canal__c = value;
            return this;
        }

        public IdentificadordeEnlatadoBuilder withDescripcionProducto(String value) {
            obj.Descripcion_Producto__c = value;
            return this;
        }

        public IdentificadordeEnlatadoBuilder withDescripcionProductor(String value) {
            obj.Descripcion_Productor__c = value;
            return this;
        }

        public IdentificadordeEnlatadoBuilder withIdCanal(String value) {
            obj.Id_Canal__c = value;
            return this;
        }

        public IdentificadordeEnlatadoBuilder withIdIdentificadorEnlatado(String value) {
            obj.Id_Identificador_Enlatado__c = value;
            return this;
        }

        public IdentificadordeEnlatadoBuilder withIdProductoBase(String value) {
            obj.Id_Producto_Base__c = value;
            return this;
        }

        public IdentificadordeEnlatadoBuilder withIdProductor(String value) {
            obj.Id_Productor__c = value;
            return this;
        }

        public Identificador_de_Enlatado__c build() {
            return obj;
        }
    }

    /** It require following fields to can be inserted: Producto_Base__c. */
    public static IdentificadordeEnlatadoBuilder anIdentificadordeEnlatado() {
        return new IdentificadordeEnlatadoBuilder();
    }

    /*------------------------------------------------------------------------
	             IdentificadordeEnlatadoBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             EnlatadoBuilderStart
	------------------------------------------------------------------------*/
    public class EnlatadoBuilder {
        private Enlatado__c obj = new Enlatado__c(
            Id_Enlatado__c = 'STRING',
            Codigo_Enlatado__c = 'STRING',
            Id_Identificador_Enlatado__c = 'STRING'
        );

        public EnlatadoBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public EnlatadoBuilder withIdEnlatado(String value) {
            obj.Id_Enlatado__c = value;
            return this;
        }

        public EnlatadoBuilder withCodigoEnlatado(String value) {
            obj.Codigo_Enlatado__c = value;
            return this;
        }

        public EnlatadoBuilder withIdIdentificadorEnlatado(String value) {
            obj.Id_Identificador_Enlatado__c = value;
            return this;
        }

        public EnlatadoBuilder withAmbiente(String value) {
            obj.Ambiente__c = value;
            return this;
        }

        public EnlatadoBuilder withIdentificadordeEnlatado(Identificador_de_Enlatado__c value) {
            obj.Identificador_de_Enlatado__c = value.Id;
            return this;
        }

        public EnlatadoBuilder withEstado(String value) {
            obj.Estado__c = value;
            return this;
        }

        public EnlatadoBuilder withCombo(String value) {
            obj.Combo__c = value;
            return this;
        }

        public EnlatadoBuilder withPremio(Double value) {
            obj.Premio__c = value;
            return this;
        }

        public EnlatadoBuilder withAsistencia(String value) {
            obj.Asistencia__c = value;
            return this;
        }

        public EnlatadoBuilder withTipoDeUso(String value) {
            obj.Tipo_De_Uso__c = value;
            return this;
        }

        public Enlatado__c build() {
            return obj;
        }
    }

    /** It require following fields to can be inserted: Identificador_de_Enlatado__c. */
    public static EnlatadoBuilder anEnlatado() {
        return new EnlatadoBuilder();
    }

    /*------------------------------------------------------------------------
	             EnlatadoBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             CoberturaEnlatadoBuilderStart
	------------------------------------------------------------------------*/
    public class CoberturaEnlatadoBuilder {
        private Cobertura_Enlatado__c obj = new Cobertura_Enlatado__c(
            Id_Enlatado__c = 'STRING',
            Id_Cobertura_Enlatado__c = 'STRING'
        );

        public CoberturaEnlatadoBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public CoberturaEnlatadoBuilder withMontoCobertura(Decimal value) {
            obj.Monto_Cobertura__c = value;
            return this;
        }

        public CoberturaEnlatadoBuilder withEnlatado(Enlatado__c value) {
            obj.Enlatado__c = value.Id;
            return this;
        }

        public CoberturaEnlatadoBuilder withIdEnlatado(String value) {
            obj.Id_Enlatado__c = value;
            return this;
        }

        public CoberturaEnlatadoBuilder withIdCoberturaEnlatado(String value) {
            obj.Id_Cobertura_Enlatado__c = value;
            return this;
        }

        public CoberturaEnlatadoBuilder withCoberturaEditable(Boolean value) {
            obj.Cobertura_Editable__c = value;
            return this;
        }

        public CoberturaEnlatadoBuilder withPremiosOpcionesdeSumas(String value) {
            obj.Premios_Opciones_de_Sumas__c = value;
            return this;
        }

        public CoberturaEnlatadoBuilder withOpcionesdeSuma(String value) {
            obj.Opciones_de_Suma__c = value;
            return this;
        }

        public Cobertura_Enlatado__c build() {
            return obj;
        }
    }

    /** It require following fields to can be inserted: Enlatado__c. */
    public static CoberturaEnlatadoBuilder aCoberturaEnlatado() {
        return new CoberturaEnlatadoBuilder();
    }

    /*------------------------------------------------------------------------
	             CoberturaEnlatadoBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             NombredeCampaniaAbandonosBuilderStart
	------------------------------------------------------------------------*/
    public class NombredeCampaniaAbandonosBuilder {
        private Nombre_de_Campania_Abandonos__c obj = new Nombre_de_Campania_Abandonos__c(Name = 'STRING');

        public NombredeCampaniaAbandonosBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public NombredeCampaniaAbandonosBuilder withSetupOwnerId(Organization value) {
            obj.SetupOwnerId = value.Id;
            return this;
        }

        public NombredeCampaniaAbandonosBuilder withSetupOwnerId(Profile value) {
            obj.SetupOwnerId = value.Id;
            return this;
        }

        public NombredeCampaniaAbandonosBuilder withSetupOwnerId(User value) {
            obj.SetupOwnerId = value.Id;
            return this;
        }

        public NombredeCampaniaAbandonosBuilder withNombredeCampania(String value) {
            obj.Nombre_de_Campania__c = value;
            return this;
        }

        public NombredeCampaniaAbandonosBuilder withCodigoRamo(Double value) {
            obj.Codigo_Ramo__c = value;
            return this;
        }

        public NombredeCampaniaAbandonosBuilder withCodigoProducto(Double value) {
            obj.Codigo_Producto__c = value;
            return this;
        }

        public Nombre_de_Campania_Abandonos__c build() {
            return obj;
        }
    }

    public static NombredeCampaniaAbandonosBuilder aNombredeCampaniaAbandonos() {
        return new NombredeCampaniaAbandonosBuilder();
    }

    /*------------------------------------------------------------------------
	             NombredeCampaniaAbandonosBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             DomicilioBuilderStart
	------------------------------------------------------------------------*/
    public class DomicilioBuilder {
        private Domicilio__c obj = new Domicilio__c(Calle__c = 'STRING', Codigo_Postal__c = 'STRING', Numero__c = 1.5);

        public DomicilioBuilder withCuenta(Account value) {
            obj.Cuenta__c = value.Id;
            return this;
        }

        public DomicilioBuilder withCalle(String value) {
            obj.Calle__c = value;
            return this;
        }

        /** (2021-02-18 23:29:39) Valores disponibles:  '23 DE AGOSTO', 'ABRA DE HINOJO', 'ABRA DE PIVES', 'ABRALAITE', 'ABRA PAMPA', 'AGUA CALIENTE', 'AGUADA DE LAS TEJAS', 'AGUADA DEL PITO', 'AGUA PALOMAR', 'AGUAS BLANCAS', 'AGUSTINA', 'ALEGRIA', 'ALFREDO DEMARCHI', 'ALGARROBAL', 'ALTO CALILEGUA', 'ALTO COMEDERO', 'ALTO QUIRQUINCHO', 'ALTO RIO MAYO', 'ALTO RIO SENGUER', 'ALTO VERDE', 'ANTIGUO', 'ANTIGUYOS', 'ARROYO GATO', 'ARROYO PERCY', 'ATALAYA', 'BAJO BARTOLO', 'BALNEARIO MAR CHIQUITA', 'BARRANCAS', 'BARRIO 9 DE JULIO', 'BARRIO ALBERDI', 'BARRIO ALTO LA VIÑA', 'BARRIO ASTRA', 'BARRIO BAJO LA VIÑA', 'BARRIO CHIJRA', 'BARRIO CIUDADELA', 'BARRIO CUYAYA', 'BARRIO GENERAL SAN MARTIN', 'BARRIO LUJAN', 'BARRIO PARQUE 19 DE ABRIL', 'BARRIO SANTA RITA', 'BARRIO TIRO FEDERAL', 'BELLA VISTA', 'BOCA DE LA ZANJA', 'BOCA ZANJA SUD', 'BOLETERIA', 'CAIMANCITO', 'CAJAS', 'CAJON DE GINEBRA CHICO', 'CAJON DE GINEBRA GRANDE', 'CALETA CORDOVA', 'CALILEGUA', 'CAMPO LA TUNA', 'CAMPO OCULTO', 'CAÑADON CHILENO', 'CAÑADON FERRAIS', 'CAÑADON GRANDE', 'CAÑADON PEDRO EX VALLE HERMOSO', 'CAÑAS', 'CANCHUELA', 'CANGREJILLOS', 'CARAHUNCO', 'CARCEL', 'CARHUE NIYEO', 'CASAYOCK', 'CASILLAS', 'CASTILLA', 'CATAMONTAÑA', 'CAUCHARI', 'CERRO CONDOR', 'CERRO NEGRO', 'CERROS ZAPLA', 'CHACAY ESTE', 'CHACAY OESTE', 'CHAÑARCITO', 'CHAÑI CHICO', 'CHASICO', 'CHOROJRA', 'CHORRILLOS', 'CIENAGA', 'CIENEGO GRANDE', 'COLHUE HUAPI', 'COLONIA ALBERDI', 'COLONIA EL FISCAL', 'COLONIA HIPOLITO YRIGOYEN', 'COLONIA JUAN JOSE CASTELLI', 'COLONIA JUAN LAVALLE', 'COLONIA LA FLORIDA GRANDE', 'COLONIA LOS GANZOS', 'COLONIA LOTE 10', 'COLONIA MARIANO SARRATEA', 'COLONIA MIGUEL ESTEVERENA', 'COLONIA PALMIRA', 'COLONIA PUENTE PHILIPON', 'COLONIA RIO DE ORO', 'COLONIA RODRIGUEZ PEÑA', 'COLONIA SABINA', 'COLONIA SAN ANTONIO', 'CORBETT', 'CORONEL AVALOS', 'CORRALITO', 'CORRALITOS', 'COSTA BRAVA', 'COSTA CHUBUT', 'COSTA DEL LEPA', 'COSTA INE', 'CURVA DE NOVOA', 'DOCTOR RICARDO ROJAS', 'DOLAVON', 'DOÑA PAULA', 'DOS HERMANOS', 'EBENECER', 'EL AGUILAR', 'EL ALAMO', 'EL BAÑADO', 'EL CHACAY DPTO GASTRE', 'EL CHALET', 'EL CHERQUE', 'EL CURUNDU', 'EL ESCORIAL', 'EL ESPINILLO', 'EL HOYO', 'EL JAGUEL', 'EL OLVIDO', 'EL PAJARITO', 'EL PALMAR TRES ISLETAS', 'EL PARAISO', 'EL PIQUETE', 'EL PONGO', 'EL PORONGAL', 'EL SALITRAL', 'EL SAUZAL', 'EL SAUZALITO', 'EL SHAMAN', 'EL SOMBRERO', 'EL TOBA', 'EL TRAGADERO', 'EL TRIANA', 'EL TUPI KILOMETRO 474', 'EL VERANO', 'ENCINA', 'ENCRUCIJADA', 'ERIZE', 'ESCAYA', 'ESTACION PERICO', 'ESTACION PROVINCIAL', 'ESTANCIA CHAPAR', 'ESTANCIA LAS GAMAS', 'EX FORTIN ZELAVA', 'FALDA DEL QUEBRACHAL', 'FALDA MONTOSA', 'FINCA AGUA SALADA', 'FINCA AGUA TAPADA', 'FINCA LA LUCRECIA', 'FINCA LA REALIDAD', 'FITIRHUIN', 'FLORADORA', 'FOTOCAHUEL', 'FRAILE PINTADO', 'FRANKLIN', 'FRONTERA DE RIO PICO', 'GALETA', 'GANCEDO', 'GENERAL MANUEL SAVIO', 'GOBERNADOR TELLO', 'GRAL MANUEL SAVIO', 'GRANADAS', 'GUAYACAN', 'GUAYATAYOC', 'GUEMES', 'HARAS NACIONAL', 'HIGUERITAS', 'HITO 43', 'HUACALERA', 'HUALLATAYOC', 'HUMAHUACA', 'INCA HUASI', 'INDIA MUERTA', 'ING BRUNO J THOMAE', 'INGENIO LA ESPERANZA', 'INGENIO LEDESMA', 'ISLA CHICA', 'ITIN', 'JARAMILLO', 'JUELLA', 'JULIO ARDITI', 'KILOMETRO 11', 'KILOMETRO 1369', 'KILOMETRO 1397', 'KILOMETRO 191', 'KILOMETRO 352', 'LA ADELA', 'LA ALMONA', 'LA BAJADA', 'LA CHINACA', 'LA CRUZ', 'LA DELFINA', 'LA ESPERANZA', 'LA GARITA', 'LAGO BLANCO', 'LAGO LEZAMA', 'LAGO RIVADAVIA', 'LAGUNA ALSINA', 'LAGUNA BELIGAY', 'LAGUNA DE VACAS', 'LAGUNA LIMPIA', 'LAGUNA VERDE', 'LAGUNILLAS', 'LA MENDIETA', 'LANGUIÑEO', 'LANUS', 'LA OLLADA', 'LAPACHAL LEDESMA', 'LA PRIMAVERA', 'LA PUERTA', 'LA QUIACA', 'LA RAQUEL', 'LAS BLANCAS', 'LAS CHAPAS', 'LAS ESCALERAS', 'LAS GARCITAS', 'LAS HACHERAS', 'LAS HIGUERILLAS', 'LAS MORERAS', 'LAS PAMPAS', 'LAS VERTIENTES', 'LA TOMA', 'LA UNION', 'LEDESMA', 'LIB GRAL SAN MARTIN', 'LIVA', 'LLULLUCHAYOC', 'LOMA BLANCA', 'LORETO', 'LOS ALISOS', 'LOS ALTARES', 'LOS ANGELES', 'LOS CORRALITOS', 'LOS GUALCOS', 'LOS MATOS', 'LOS ORTIZ', 'LOS PORONGOS', 'LOS POZOS', 'LOS QUEBRACHITOS', 'LOTE 1', 'LOTE 12', 'LOTE 15 LA SABANA', 'LOTE 24', 'LOTE 43 ESCUELA 250', 'LOTE 4 COLONIA PASTORIL', 'LOTE EL PUESTO', 'LOTE MAIZ NEGRO', 'LOZANO', 'LUMARA', 'LUMB', 'MAIMARA', 'MALLIN BLANCO', 'MARIANO ROLDAN', 'MAYILTE', 'MERCO', 'MINA PULPERA', 'MINA SAN FRANCISCO', 'MINA SOL DE MAYO', 'MIRAFLORES DE LA CANDELARIA', 'MIYUYOC', 'MONTE CASEROS', 'MONTERRICO', 'MORALITO', 'MORENO CHICO', 'NAHUEL PAN ESTACION FCGR', 'NAHUEL RUCA', 'NAPALPI', 'NARANJITO', 'NIRIGUAO', 'NOGAL', 'ÑORQUINCO SUD', 'NUEVA HERMOSURA', 'NUEVA UNION', 'OCUMAZO', 'OLACAPATO', 'OVARA', 'PAINALUF', 'PALO BLANCO', 'PALO MARCADO', 'PALPALA', 'PAMPA ALMIRON', 'PAMPA ALSINA', 'PAMPA BLANCA', 'PAMPA BOLSA', 'PAMPA CEJAS', 'PAMPA EL FOSFORITO', 'PAMPA IPORA GUAZU', 'PAMPA LARGA', 'PAMPA LOCA', 'PAMPA SOMMER', 'PAMPA VERDE', 'PARQUE CARILO', 'PARQUE NACIONAL LOS ALERCES', 'PERICO', 'PERICO DEL CARMEN', 'PIEDRA SHOTEL', 'PIRRE MAHUIDA', 'PLANCUNTRE', 'PORVENIR', 'POZO VERDE', 'PREDILIANA', 'PUEBLO LEDESMA', 'PUERTA VIEJA', 'PUERTO EVA PERON', 'PUERTO LOBOS', 'PUESTO', 'PUESTO DEL MARQUEZ', 'PUESTO VIEJO', 'PURMAMARCA', 'PUTRACHOIQUE', 'QUEBRALEÑA', 'QUEÑOAL', 'QUERA', 'QUETA', 'QUICHAGUA', 'RANQUIL HUAO', 'REDONDA', 'RINCONADA', 'RIO BLANCO', 'RIO COLORADO', 'RIO GRANDE', 'RIVERITO', 'ROCHA', 'RODERO', 'RUMI CRUZ', 'RUTA 3 KILOMETRO 1646', 'SACANANA', 'SAN ANDRES', 'SAN ANTONIO', 'SAN CARLOS', 'SAN FRANCISCO DE ALFARCITO', 'SAN JORGE', 'SAN JOSE DE LA RINCONADA', 'SAN JOSE DEL BORDO', 'SAN JOSE DEL CHAÑI', 'SAN JUANCITO', 'SAN LEON', 'SAN LORENZO', 'SAN LUCAS', 'SAN RAFAEL', 'SAN ROQUE', 'SANTA AGUEDA', 'SANTA ROSA TUMBAYA', 'SANTA ROSA VALLE GRANDE', 'SANTIAGO GARBARINI', 'SANTIAGO LARRE', 'SANTO TOMAS CHICO', 'SANTUYOC', 'SAUZALITO', 'SELVAS DEL RIO DE ORO', 'SEPRUCAL', 'SIEMPRE VIVA', 'SIERRA CHATA', 'SIERRA DE TECKA', 'SIERRA NEVADA PASO DE INDIOS', 'SIERRA OVERA CHICAS Y GRANDES', 'SIERRA ROSADA', 'SOLEDAD', 'SORCUYO', 'TABLADITAS', 'TABLON', 'TAQUETREN', 'TARTAGAL', 'TECKA', 'TERMAS DE REYES', 'TIO MAYO', 'TIRAXI', 'TOBA', 'TREORKI', 'TRES NACIONES', 'TURILARI', 'TUSAQUILLAS', 'UZCUDUN', 'VALLE DEL RIO CHUBUT', 'VALLE LOS MARTIRES', 'VICENTINI', 'VIGELENCIA', 'VILLA ALTA', 'VILLA BARBERAN', 'VILLA EL PALMAR', 'VILLAFAÑE', 'VILLA JUAN DE GARAY', 'VILLA RIO BERMEJITO', 'VILLARS', 'VISCACHANI', 'WICHI', 'YATAY', 'ZONA DELTA TIGRE', 'ZUBERBUHLER' */
        public DomicilioBuilder withCiudad(String value) {
            obj.Ciudad__c = value;
            return this;
        }

        public DomicilioBuilder withCodigoPostal(String value) {
            obj.Codigo_Postal__c = value;
            return this;
        }

        public DomicilioBuilder withCoordenadasLatitudes(Double value) {
            obj.Coordenadas__Latitude__s = value;
            return this;
        }

        public DomicilioBuilder withCoordenadasLongitudes(Double value) {
            obj.Coordenadas__Longitude__s = value;
            return this;
        }

        public DomicilioBuilder withDepto(String value) {
            obj.Depto__c = value;
            return this;
        }

        public DomicilioBuilder withIdCodigoPostalBHSeg(String value) {
            obj.Id_Codigo_Postal_BHSeg__c = value;
            return this;
        }

        public DomicilioBuilder withNumeroConsecutivoBHSeg(Double value) {
            obj.Numero_Consecutivo_BHSeg__c = value;
            return this;
        }

        public DomicilioBuilder withNumero(Double value) {
            obj.Numero__c = value;
            return this;
        }

        public DomicilioBuilder withPiso(String value) {
            obj.Piso__c = value;
            return this;
        }

        /** (2021-02-18 23:29:39) Valores disponibles:  'BUENOS AIRES', 'CAPITAL FEDERAL', 'CATAMARCA', 'CHACO', 'CHUBUT', 'CORDOBA', 'CORRIENTES', 'ENTRE RIOS', 'FORMOSA', 'JUJUY', 'LA PAMPA', 'LA RIOJA', 'MENDOZA', 'MISIONES', 'NEUQUEN', 'RIO NEGRO', 'SALTA', 'SAN JUAN', 'SAN LUIS', 'SANTA CRUZ', 'SANTA FE', 'SANTIAGO DEL ESTERO', 'TIERRA DEL FUEGO', 'TUCUMAN' */
        public DomicilioBuilder withProvincia(String value) {
            obj.Provincia__c = value;
            return this;
        }

        public DomicilioBuilder withTipoBHSeg(String value) {
            obj.Tipo_BHSeg__c = value;
            return this;
        }

        /** (2021-02-18 23:29:39) Valores disponibles:  'Domicilio Postal', 'Legal' */
        public DomicilioBuilder withTipo(String value) {
            obj.Tipo__c = value;
            return this;
        }

        public DomicilioBuilder withDomicilioPreferente(Boolean value) {
            obj.Domicilio_Preferente__c = value;
            return this;
        }

        public DomicilioBuilder withIdClienteBHSeg(String value) {
            obj.Id_Cliente_BHSeg__c = value;
            return this;
        }

        public Domicilio__c build() {
            return obj;
        }
    }

    /** It require following fields to can be inserted: Cuenta__c. */
    public static DomicilioBuilder aDomicilio() {
        return new DomicilioBuilder();
    }

    /*------------------------------------------------------------------------
	             DomicilioBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             TipodeTramiteBuilderStart
	------------------------------------------------------------------------*/
    public class TipodeTramiteBuilder {
        private Tipo_de_Tramite__c obj = new Tipo_de_Tramite__c(Name = 'STRING');

        public TipodeTramiteBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public TipodeTramiteBuilder withDescripcion(String value) {
            obj.Descripcion__c = value;
            return this;
        }

        public Tipo_de_Tramite__c build() {
            return obj;
        }
    }

    public static TipodeTramiteBuilder aTipodeTramite() {
        return new TipodeTramiteBuilder();
    }

    /*------------------------------------------------------------------------
	             TipodeTramiteBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             AlertaBuilderStart
	------------------------------------------------------------------------*/
    public class AlertaBuilder {
        private Alerta__c obj = new Alerta__c();

        public AlertaBuilder withOwnerId(Group value) {
            obj.OwnerId = value.Id;
            return this;
        }
        public AlertaBuilder withOwnerId(User value) {
            obj.OwnerId = value.Id;
            return this;
        }

        public AlertaBuilder withContenido(String value) {
            obj.Contenido__c = value;
            return this;
        }

        public AlertaBuilder withCuenta(Account value) {
            obj.Cuenta__c = value.Id;
            return this;
        }

        public AlertaBuilder withEliminable(Boolean value) {
            obj.Eliminable__c = value;
            return this;
        }

        /** (2021-04-26 14:01:32) Valores disponibles:  'Comentario', 'Informacion', 'Exclamacion', 'Alerta'*/
        public AlertaBuilder withTipodeAlerta(String value) {
            obj.Tipo_de_Alerta__c = value;
            return this;
        }

        public AlertaBuilder withTitulo(String value) {
            obj.Titulo__c = value;
            return this;
        }

        public AlertaBuilder withOportunidad(Opportunity value) {
            obj.Oportunidad__c = value.Id;
            return this;
        }

        public AlertaBuilder withDefiniciondeAlerta(Definicion_de_Alerta__c value) {
            obj.Definicion_de_Alerta__c = value.Id;
            return this;
        }

        public AlertaBuilder withIdentificadorAdicional(String value) {
            obj.Identificador_Adicional__c = value;
            return this;
        }

        public Alerta__c build() {
            return obj;
        }
    }

    public static AlertaBuilder anAlerta() {
        return new AlertaBuilder();
    }

    /*------------------------------------------------------------------------
	             AlertaBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             CotizacionEnviadaBuilderStart
	------------------------------------------------------------------------*/
    public class CotizacionEnviadaBuilder {
        private Cotizacion_Enviada__c obj = new Cotizacion_Enviada__c();

        public CotizacionEnviadaBuilder withOwnerId(Group value) {
            obj.OwnerId = value.Id;
            return this;
        }
        public CotizacionEnviadaBuilder withOwnerId(User value) {
            obj.OwnerId = value.Id;
            return this;
        }

        public CotizacionEnviadaBuilder withAsunto(String value) {
            obj.Asunto__c = value;
            return this;
        }

        public CotizacionEnviadaBuilder withNumerodeDocumento(String value) {
            obj.Numero_de_Documento__c = value;
            return this;
        }

        public CotizacionEnviadaBuilder withProductoVendido(Producto_Vendido__c value) {
            obj.Producto_Vendido__c = value.Id;
            return this;
        }

        public CotizacionEnviadaBuilder withEmail(String value) {
            obj.Email__c = value;
            return this;
        }

        public CotizacionEnviadaBuilder withCEProductoIdBHSeg(String value) {
            obj.CE_Producto_IdBHSeg__c = value;
            return this;
        }

        public CotizacionEnviadaBuilder withCERamoIdBHSeg(String value) {
            obj.CE_Ramo_IdBHSeg__c = value;
            return this;
        }

        public CotizacionEnviadaBuilder withCERamo(String value) {
            obj.CE_Ramo__c = value;
            return this;
        }

        public CotizacionEnviadaBuilder withAccountCUIT(String value) {
            obj.AccountCUIT__c = value;
            return this;
        }

        public CotizacionEnviadaBuilder withAccountIdClienteBHSeg(String value) {
            obj.AccountIdClienteBHSeg__c = value;
            return this;
        }

        public Cotizacion_Enviada__c build() {
            return obj;
        }
    }

    public static CotizacionEnviadaBuilder aCotizacionEnviada() {
        return new CotizacionEnviadaBuilder();
    }

    /*------------------------------------------------------------------------
	             CotizacionEnviadaBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             LocalidadProvinciaRectorBuilderStart
	------------------------------------------------------------------------*/
    public class LocalidadProvinciaRectorBuilder {
        private Localidad_Provincia_Rector__c obj = new Localidad_Provincia_Rector__c();

        public LocalidadProvinciaRectorBuilder withOwnerId(Group value) {
            obj.OwnerId = value.Id;
            return this;
        }
        public LocalidadProvinciaRectorBuilder withOwnerId(User value) {
            obj.OwnerId = value.Id;
            return this;
        }

        public LocalidadProvinciaRectorBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public LocalidadProvinciaRectorBuilder withCodigoPostal(String value) {
            obj.Codigo_Postal__c = value;
            return this;
        }

        public LocalidadProvinciaRectorBuilder withCodigo(String value) {
            obj.Codigo__c = value;
            return this;
        }

        public LocalidadProvinciaRectorBuilder withIdBHSeg(String value) {
            obj.Id_BHSeg__c = value;
            return this;
        }

        public LocalidadProvinciaRectorBuilder withLocalidad(String value) {
            obj.Localidad__c = value;
            return this;
        }

        public LocalidadProvinciaRectorBuilder withProvinciaIdBHSeg(String value) {
            obj.Provincia_IdBHSeg__c = value;
            return this;
        }

        public LocalidadProvinciaRectorBuilder withProvincia(String value) {
            obj.Provincia__c = value;
            return this;
        }

        public LocalidadProvinciaRectorBuilder withIdBHSeguros(String idBHSeg) {
            obj.Id_BH_Seguros__c = idBHSeg;
            return this;
        }

        public Localidad_Provincia_Rector__c build() {
            return obj;
        }
    }

    public static LocalidadProvinciaRectorBuilder aLocalidadProvinciaRector() {
        return new LocalidadProvinciaRectorBuilder();
    }

    /*------------------------------------------------------------------------
	             LocalidadProvinciaRectorBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             GenesysCallbacksQueueBuilderStart
	------------------------------------------------------------------------*/
    public class GenesysCallbacksQueueBuilder {
        private Genesys_Callbacks_Queue__c obj = new Genesys_Callbacks_Queue__c();

        public GenesysCallbacksQueueBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public GenesysCallbacksQueueBuilder withQueuedId(String value) {
            obj.QueuedId__c = value;
            return this;
        }

        public GenesysCallbacksQueueBuilder withScriptId(String value) {
            obj.ScriptId__c = value;
            return this;
        }

        public GenesysCallbacksQueueBuilder withRamoIdBhSeg(String value) {
            obj.Ramo_IdBHSeg__c = value;
            return this;
        }

        public GenesysCallbacksQueueBuilder withProductoIdBhSeg(String value) {
            obj.Producto_IdBHSeg__c = value;
            return this;
        }

        public GenesysCallbacksQueueBuilder withSponsor(String value) {
            obj.Sponsor__c = value;
            return this;
        }

        public GenesysCallbacksQueueBuilder withOrigen(String value) {
            obj.Origen__c = value;
            return this;
        }

        public GenesysCallbacksQueueBuilder withRoutingDataQueueId(String value) {
            obj.RoutingDataQueueId__c = value;
            return this;
        }

        public Genesys_Callbacks_Queue__c build() {
            return obj;
        }
    }

    public static GenesysCallbacksQueueBuilder aGenesysCallbacksQueue() {
        return new GenesysCallbacksQueueBuilder();
    }

    /*------------------------------------------------------------------------
	                GenesysCallbacksQueueBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
                            BeneficioBuilderStart
    ------------------------------------------------------------------------*/
    public class BeneficioBuilder {
        private Beneficio__c obj = new Beneficio__c();


        public BeneficioBuilder withPoliza(Poliza__c value) {
            obj.Poliza__c = value.Id;
            return this;
        }

        public BeneficioBuilder withAlta(Date value) {
            obj.Alta__c = value;
            return this;
        }

        public BeneficioBuilder withDescripcion(String value) {
            obj.Descripcion__c = value;
            return this;
        }

        public Beneficio__c build() {
            return obj;
        }
    }

    public static BeneficioBuilder aBeneficio() {
        return new BeneficioBuilder();
    }
    /*------------------------------------------------------------------------
                            BeneficioBuilderEnd
    ------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
                            MatrizAsistenciaBuilderStart
    ------------------------------------------------------------------------*/
    public class MatrizAsistenciaBuilder {
        private Matriz_Asistencia__c matrizAsistencia = new Matriz_Asistencia__c();


        public MatrizAsistenciaBuilder withName(String value) {
            this.matrizAsistencia.name = value;
            return this;
        }

        public MatrizAsistenciaBuilder withActivo(Boolean value) {
            this.matrizAsistencia.Activo__c = value;
            return this;
        }

        public MatrizAsistenciaBuilder withCodigoAsistenciaAplicable(Decimal value) {
            this.matrizAsistencia.Codigo_Asistencia_Aplicable__c = value;
            return this;
        }

        public MatrizAsistenciaBuilder withDescripcionAsistenciaAplicable(String value) {
            this.matrizAsistencia.Descripcion_Asistencia_Aplicable__c = value;
            return this;
        }

        public MatrizAsistenciaBuilder withCodigoAsistenciaActual(Decimal value) {
            this.matrizAsistencia.Codigo_Asistencia_Actual__c = value;
            return this;
        }

        public MatrizAsistenciaBuilder withDescripcionAsistenciaActual(String value) {
            this.matrizAsistencia.Descripcion_Asistencia_Actual__c = value;
            return this;
        }

        public MatrizAsistenciaBuilder withPorcentajePremioMinimo(Decimal value) {
            this.matrizAsistencia.Porcentaje_Premio_Minimo__c = value;
            return this;
        }

        public MatrizAsistenciaBuilder withPorcentajePremioMaximo(Decimal value) {
            this.matrizAsistencia.Porcentaje_Premio_Maximo__c = value;
            return this;
        }

        public MatrizAsistenciaBuilder withCodigoRamo(String value) {
            this.matrizAsistencia.Codigo_Ramo__c = value;
            return this;
        }

        public MatrizAsistenciaBuilder withCodigoProducto(String value) {
            this.matrizAsistencia.Codigo_Producto__c = value;
            return this;
        }

        public MatrizAsistenciaBuilder withIdentificadorSponsor(String value) {
            this.matrizAsistencia.Identificador_Sponsor__c = value;
            return this;
        }

        public MatrizAsistenciaBuilder withIdentificadorAsistenciaActual(String value) {
            this.matrizAsistencia.Identificador_Asistencia_Actual__c = value;
            return this;
        }

        public MatrizAsistenciaBuilder withIdentificadorAsistenciaAplicable(String value) {
            this.matrizAsistencia.Identificador_Asistencia_Aplicable__c = value;
            return this;
        }

        public MatrizAsistenciaBuilder withCodigoSponsor(String value) {
            this.matrizAsistencia.Codigo_Sponsor__c = value;
            return this;
        }

        public Matriz_Asistencia__c build() {
            return this.matrizAsistencia;
        }

    }

    public static MatrizAsistenciaBuilder aMatrizAsistencia() {
        return new MatrizAsistenciaBuilder();
    }
    /*------------------------------------------------------------------------
                            MatrizAsistenciaBuilderEnd
    ------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             ServicioBuilderStart
	------------------------------------------------------------------------*/
    public class ServicioBuilder {
        private Servicio__c obj = new Servicio__c();

        public ServicioBuilder withOwnerId(Group value) {
            obj.OwnerId = value.Id;
            return this;
        }
        public ServicioBuilder withOwnerId(User value) {
            obj.OwnerId = value.Id;
            return this;
        }

        public ServicioBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public ServicioBuilder withCodigoClienteBeneficio(String value) {
            obj.Codigo_Cliente_Beneficio__c = value;
            return this;
        }

        public ServicioBuilder withCodigo(String value) {
            obj.Codigo__c = value;
            return this;
        }

        public ServicioBuilder withCuenta(Account value) {
            obj.Cuenta__c = value.Id;
            return this;
        }

        public ServicioBuilder withDescripcion(String value) {
            obj.Descripcion__c = value;
            return this;
        }

        public ServicioBuilder withFechaAlta(Date value) {
            obj.Fecha_Alta__c = value;
            return this;
        }

        public ServicioBuilder withFechaBaja(Date value) {
            obj.Fecha_Baja__c = value;
            return this;
        }

        public ServicioBuilder withFechaAceptado(Date value) {
            obj.Fecha_Aceptado__c = value;
            return this;
        }

        public Servicio__c build() {
            return obj;
        }
    }

    public static ServicioBuilder aServicio() {
        return new ServicioBuilder();
    }

    /*------------------------------------------------------------------------
	             ServicioBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             NotificacionBuilderStart
	------------------------------------------------------------------------*/
    public class NotificacionBuilder {
        private Notificacion__c notification = new Notificacion__c();

        public NotificacionBuilder withPolicy(Id value) {
            this.notification.Poliza__c = value;
            return this;
        }

        public NotificacionBuilder withIdClienteBHSeg(String value) {
            this.notification.Id_Cliente_BHSeg__c = value;
            return this;
        }

        public NotificacionBuilder withRamoIdBHSeg(String value) {
            this.notification.Ramo_IdBHSeg__c = value;
            return this;
        }

        public NotificacionBuilder withNumeroPoliza(Double value) {
            this.notification.Numero_Poliza__c = value;
            return this;
        }

        public NotificacionBuilder withNombre(String value) {
            this.notification.Nombre__c = value;
            return this;
        }

        public NotificacionBuilder withApellido(String value) {
            this.notification.Apellido__c = value;
            return this;
        }

        public NotificacionBuilder withPorcentajeDevolucion(Decimal value) {
            this.notification.Porcentaje_Devolucion__c = value;
            return this;
        }

        public NotificacionBuilder withAvisoDias(Double value) {
            this.notification.Aviso_Dias__c = value;
            return this;
        }

        public NotificacionBuilder withCertificado(Double value) {
            this.notification.Certificado__c = value;
            return this;
        }

        public NotificacionBuilder withURL(String value) {
            this.notification.URL__c = value;
            return this;
        }

        public NotificacionBuilder forclient(Account value) {
            this.notification.Cuenta__c = value.Id;
            return this;
        }

        public Notificacion__c build() {
            return this.notification;
        }
    }

    public static NotificacionBuilder aNotificacion() {
        return new NotificacionBuilder();
    }

    /*------------------------------------------------------------------------
	             NotificacionBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             ActivePlanBuilderStart
	------------------------------------------------------------------------*/
    public class ActivePlanBuilder {
        private Active_Plan__c obj = new Active_Plan__c();

        public ActivePlanBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public ActivePlanBuilder withTradeCode(String value) {
            obj.Trade_Code__c = value;
            return this;
        }

        public ActivePlanBuilder withProductCode(String value) {
            obj.Product_Code__c = value;
            return this;
        }

        public ActivePlanBuilder withPlanCode(String value) {
            obj.Plan_Code__c = value;
            return this;
        }

        public Active_Plan__c build() {
            return obj;
        }
    }

    public static ActivePlanBuilder anActivePlan() {
        return new ActivePlanBuilder();
    }

    /*------------------------------------------------------------------------
	             ActivePlanBuilderEnd
	------------------------------------------------------------------------*/
}