@isTest
global with sharing class ClientFinderMock implements HttpCalloutMock {
    public ClientFinderMock() 
    {
    	clients = new List<Account>();
    	syntaxisError = false;
        returnNull = false;
    }
  
    
    public ClientFinderMock(List<Account> c, RectorCertificate certificate, Boolean se) 
    {
    	cert = certificate;
		clients = c;
    	syntaxisError = se;
        returnNull = false;
    }
    
	RectorCertificate cert;
	List<Account> clients;
    Boolean syntaxisError;
    public Boolean returnNull;
        
	global HTTPResponse respond(HTTPRequest req)
	{
		Dom.Document doc = new Dom.Document();
		doc.load(req.getBody());
		String method = doc.getRootElement().getName(); 
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
		String response = '<string xmlns="http://tempuri.org/">' +
		    '<' + method + '>' +
		    '<header>' +
				'<handle/>' +
				'<startTime/>' +
				'<endTime/>' +
				'<component/>' +
				'<version/>' +
				'<server/>' +
				'<resultCode/>' +
				'<resultString/>' +
				'<faultCode/>' +
				'<faultMessage/>' +
			'</header>';
        
       	if(returnNull){
			response += '<body><clientes>';
            response += '</clientes></body>';
        }
		else if ( method == 'findCertificado' ) {
			if (cert != null) {
				response += '<body><certificado>'+
								'<sucursal>' + cert.sucursal + '</sucursal>' +
								'<ramo>' + cert.ramo + '</ramo>' +
								'<ramoDes>' + cert.ramoDes + '</ramoDes>' +
								'<producto>' + cert.producto	 + '</producto>' +
								'<productoDes>' + cert.productoDes	 + '</productoDes>' +
								'<poliza>' + cert.poliza	 + '</poliza>' +
								'<certificado>' + cert.certificado	 + '</certificado>' +
								'<estado>' + cert.estado	 + '</estado>' +
								'<idAsegurado>' + cert.idAsegurado	 + '</idAsegurado>'+
								'<idNegocio>' + cert.idNegocio	 + '</idNegocio>'+
								'<fechaDesde>' + cert.fechaDesde	 + '</fechaDesde>'+
								'<fechaHasta>' + cert.fechaHasta	 + '</fechaHasta>'+
								'<fechaAnulacion>' + cert.fechaAnulacion	 + '</fechaAnulacion>'+
								'<codigoMedio>' + cert.codigoMedio	 + '</codigoMedio>'+
								'<codigoOrigen>' + cert.codigoOrigen	 + '</codigoOrigen>'+
								'<consecutivoCuenta>' + cert.consecutivoCuenta	 + '</consecutivoCuenta>'+
								'<consecutivoDomicilio>' + cert.consecutivoDomicilio	 + '</consecutivoDomicilio>'+
								'<codigoPlanPago>' + cert.codigoPlanPago	 + '</codigoPlanPago>';
				if (!syntaxisError) {
					response += '</certificado></body>';
				}
			}
		}
		/*
		else if ( url.contains('findClientePorSiniestro') ) {
			if (clients.size() > 0)
			{
				response += '<cliente>'+
								'<id>' + clients[0].IdBHSeg__c + '</id>' +
								'<nombre>' + clients[0].FirstName + '</nombre>' +
								'<apellido>' + clients[0].LastName + '</apellido>' +
								'<sexo>' + XMLDataConversion.genderToXml(clients[0].Genero__c) + '</sexo>' +
								'<fechaNacimiento>' + clients[0].PersonBirthdate + '</fechaNacimiento>' +
								'<tipoDocumento>' + XMLDataConversion.docTypeToXml(clients[0].Tipo_de_Documento__c) + '</tipoDocumento>' +
								'<numeroDocumento>' + clients[0].Numero_de_Documento__c + '</numeroDocumento>' +
								'<cuit>' + clients[0].CUIT__c + '</cuit>' +
								'<estadoCivil>' + XMLDataConversion.maritalStatusToXml(clients[0].Estado_Civil__c) + '</estadoCivil>' +
								'<idCliente>' + clients[0].Id_Cliente_BHSeg__c + '</idCliente>';
									
				if (!syntaxisError) {
					response += '</cliente>';
				}
			}
		}
		*/
		else if ( method ==  'findGestion' ) {
			response += '<body>';
			if (clients.size() > 0)
			{
				response += '<gestion>'+
			      '<ramo></ramo>' +
			      '<ramoDes></ramoDes>' +
			      '<id>20996032</id>' +
			      '<codigoGestion>0</codigoGestion>' +
			      '<codigoGestionPersona>0</codigoGestionPersona>' +
			      '<cliente>' + clients[0].Id_Cliente_BHSeg__c + '</cliente>' +
			      '<certificado></certificado>' +
			      '<codigoCanal1>123</codigoCanal1>' +
			      '<codigoCanal2>123</codigoCanal2>' +
			      '<codigoCanal4>123</codigoCanal4>' +
			      '<resultado>128</resultado>' +
			      '<resultadoDes>Rechazada</resultadoDes>' +
			      '<estado>G</estado>' +
			      '<estadoDes>COMISIONADAS</estadoDes>' +
			      '<errores>ACEPTADO</errores>' +
			      '<lista></lista>' +
			      '<tipoTramite>73</tipoTramite>' +
			      '<tipoTramiteDes>EMISION</tipoTramiteDes>' +
			      '<fechaActualizacion>2014-01-07</fechaActualizacion>' +
			      '<codigoUsuario>B30044</codigoUsuario>' +
			      '<numeroLote>469514</numeroLote>' +
			      '<numeroSecuencia>0</numeroSecuencia>' +
			      '<producto></producto>' +
			      '<codigoRes>128</codigoRes>' +
			      '<tipoConsulta></tipoConsulta>' +
			      '<fechaResolucion></fechaResolucion>' +
			      '<fechaComunicacion></fechaComunicacion>' +
			      '<motivoBaja></motivoBaja>' +
			      '<reintegro>false</reintegro>' +
			      '<fechaRegistroFax></fechaRegistroFax>' +
			      '<comboOrigen></comboOrigen>' +
			      '<comboDestino></comboDestino>' +
			      '<tipoMedioPagoOrigen></tipoMedioPagoOrigen>' +
			      '<tipoMedioPagoDestino></tipoMedioPagoDestino>' +
			      '<cantidadBeneficiarios>0</cantidadBeneficiarios>' +
			      '<tipoDocumentoOrigen></tipoDocumentoOrigen>' +
			      '<tipoDocumentoDestino></tipoDocumentoDestino>' +
			      '<fechaNacimientoOrigen></fechaNacimientoOrigen>' +
			      '<fechaNacimientoDestino></fechaNacimientoDestino>' +
			      '<codigoPostal></codigoPostal>' +
			      '<profesion></profesion>' +
			      '<relacionLaboral></relacionLaboral>' +
			      '<apellido>' + clients[0].LastName + '</apellido>' +
			      '<nombre>' + clients[0].FirstName + '</nombre>' +
			      '<tipoDoc>' + XMLDataConversion.docTypeToXml(clients[0].Tipo_de_Documento__c) + '</tipoDoc>' +
			      '<numDoc>' + clients[0].Numero_de_Documento__c + '</numDoc>' +
			      '<fechaNacimiento>' + clients[0].PersonBirthdate + '</fechaNacimiento>' +
			      '<sexo>' + XMLDataConversion.genderToXml(clients[0].Genero__c) + '</sexo>' +
			      '<estadoCivil>' + XMLDataConversion.maritalStatusToXml(clients[0].Estado_Civil__c) + '</estadoCivil>' +
			      '<codProfesion>12100</codProfesion>' +
			      '<paisNacimiento>80</paisNacimiento>' +
			      '<actividad>0</actividad>' +
			      '<drCalle>RECONQUISTA</drCalle>' +
			      '<drNumero>46</drNumero>' +
			      '<drPiso>8</drPiso>' +
			      '<drProv>1</drProv>' +
			      '<drLocalidad>195</drLocalidad>' +
			      '<drCcp>1003</drCcp>' +
			      '<tepais>80</tepais>' +
			      '<teArea>11</teArea>' +
			      '<teRef>0</teRef>' +
			      '<tecarac>4641</tecarac>' +
			      '<num>0</num>' +
			      '<celPais>0</celPais>' +
			      '<celArea>0</celArea>' +
			      '<celRef>0</celRef>' +
			      '<celCarac>0</celCarac>' +
			      '<celNum>0</celNum>' +
			      '<plan>001</plan>' +
			      '<canal1>0</canal1>' +
			      '<canal2>0</canal2>' +
			      '<canal4>0</canal4>' +
			      '<tipoTarjeta>05</tipoTarjeta>' +
			      '<numTarjeta>4304970007551111</numTarjeta>' +
			      '<nombreTitularTC>martin</nombreTitularTC>' +
			      '<apellidoTitularTC>nasca</apellidoTitularTC>' +
			      '<vencTC>2016-05-31</vencTC>' +
			      '<deCalle>RECONQUISTA</deCalle>' +
			      '<deNumero>46</deNumero>' +
			      '<dePiso>8</dePiso>' +
			      '<deProv>1</deProv>' +
			      '<deLocalidad>195</deLocalidad>' +
			      '<deCp>1003</deCp>' +
			      '<dbCalle>RECONQUISTA</dbCalle>' +
			      '<dbNumero>0</dbNumero>' +
			      '<dbProv>0</dbProv>' +
			      '<dbLocalidad>0</dbLocalidad>' +
			      '<dbCp>0</dbCp>' +
			      '<benNumDoc1>0</benNumDoc1>' +
			      '<benSexo1>0</benSexo1>' +
			      '<benIdRel1>0</benIdRel1>' +
			      '<benParticipacion1>0.0</benParticipacion1>' +
			      '<benNumDoc2>0</benNumDoc2>' +
			      '<benSexo2>0</benSexo2>' +
			      '<benRel2>0</benRel2>' +
			      '<benParticipacion2>0.0</benParticipacion2>' +
			      '<benNumDoc3>0</benNumDoc3>' +
			      '<benSexo3>0</benSexo3>' +
			      '<benIdRel3>0</benIdRel3>' +
			      '<benParticipacion3>0.0</benParticipacion3>' +
			      '<benNumdoc4>0</benNumdoc4>' +
			      '<benSexo4>0</benSexo4>' +
			      '<benIdRel4>0</benIdRel4>' +
			      '<benParticipacion4>0.0</benParticipacion4>' +
			      '<RFTIPO>0</RFTIPO>' +
			      '<RFDESTIPO>hml</RFDESTIPO>' +
			      '<RFIDPROD>hml</RFIDPROD>' +
			      '<siniestro></siniestro>' +
			      '<codMailPrincipal>0</codMailPrincipal>' +
			      '<codMailAlternatico>0</codMailAlternatico>' +
			      '<telefonoParticular></telefonoParticular>' +
			      '<telefonoAlternativo></telefonoAlternativo>' +
			      '<telefonoCelular></telefonoCelular>' +
			      '</gestion>';
			}
									
			if (!syntaxisError) {
				response += '</body>';
			}
		}
		else {			
			if (clients.size() > 0)
			{
				
				response += '<body><clientes>';
				for (Account client : clients) {
					response += '<cliente>'+
									'<id>' + client.IdBHSeg__c + '</id>' +
									'<nombre>' + client.FirstName + '</nombre>' +
									'<apellido>' + client.LastName + '</apellido>' +
									'<sexo>' + XMLDataConversion.genderToXml(client.Genero__c) + '</sexo>' +
									'<fechaNacimiento>' + client.PersonBirthdate + '</fechaNacimiento>' +
									'<tipoDocumento>' + XMLDataConversion.docTypeToXml(client.Tipo_de_Documento__c) + '</tipoDocumento>' +
									'<numeroDocumento>' + client.Numero_de_Documento__c + '</numeroDocumento>' +
									'<cuit>' + client.CUIT__c + '</cuit>' +
									'<estadoCivil>' + XMLDataConversion.maritalStatusToXml(client.Estado_Civil__c) + '</estadoCivil>' +
									'<idCliente>' + client.Id_Cliente_BHSeg__c + '</idCliente>' +
									'<ddjjPeps>';
					if(client.PEP__C != null && client.PEP__C){
						response += 'S';
					} else if(client.PEP__C != null && !client.PEP__C){
						response += 'N';
					} 
					response += '</ddjjPeps>';
									
					if (!syntaxisError) {
						response += '</cliente>';
					}
				}
				response += '</clientes></body>';
			}
		}
		response +=	'</' + method + '>' +
		'</string>';
		   
        res.setBody(response);
        res.setStatusCode(200);
        return res;				
	}
}