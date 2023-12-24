// General
String provincia = '21';
List<Localidad_Provincia__c> noNormalizadas = [
    SELECT
        Id,
        Id_BHSeg__c,
        Provincia_IdBHSeg__c,
        Codigo__c,
        Localidad__c,
        Codigo_Postal__c,
        Provincia__c,
        Id_BH_Seguros__c,
        Name
    FROM Localidad_Provincia__c
    WHERE Provincia_IdBHSeg__c = :provincia
        AND Id_BHSeg__c LIKE '%|%|%'
];

Map<String, Localidad_Provincia__c> localityProvincesToUpdateByKey = new Map<String, Localidad_Provincia__c>();
for (Localidad_Provincia__c localityProvince : noNormalizadas) {
    localityProvincesToUpdateByKey.put(localityProvince.Id_BHSeg__c, localityProvince);
}

List<Localidad_Provincia_Rector__c> normalizadas = [
        SELECT 
            Id,
            Name,
            Codigo_Postal__c,
            Codigo__c,
            Id_BHSeg__c,
            Localidad__c,
            Provincia_IdBHSeg__c,
            Provincia__c,
            Id_BH_Seguros__c
        FROM Localidad_Provincia_Rector__c
        WHERE Provincia_IdBHSeg__c = :provincia // AND Codigo_Postal__c IN :cp
];

String key;
Localidad_Provincia__c unnormalizedLocalityProvince;
for (Localidad_Provincia_Rector__c localityProvince : normalizadas) {
    key = localityProvince.Provincia_IdBHSeg__c + '|' + localityProvince.Codigo_Postal__c + '|' + localityProvince.Localidad__c.toLowerCase()
                                                                                                                                 .deleteWhitespace()
                                                                                                                                 .hashCode();
    if (localityProvincesToUpdateByKey.containsKey(key)) {
        System.debug('Quiero insertar el id bhseg de rector ' + localityProvince.Id_BHSeg__c)
        unnormalizedLocalityProvince = localityProvincesToUpdateByKey.get(key);
        unnormalizedLocalityProvince.Codigo__c = localityProvince.Codigo__c;
        unnormalizedLocalityProvince.Id_BHSeg__c = localityProvince.Id_BHSeg__c;
        unnormalizedLocalityProvince.Id_BH_Seguros__c = localityProvince.Id_BHSeg__c + '|' + localityProvince.Codigo_Postal__c;
    }
}

UPDATE unnormalizedLocalityProvince;

// Set<String> cp = new Set<String>();
// for (Localidad_Provincia__c provCP : tablaNoNormalizada) {
//     cp.add(provCP.Codigo_Postal__c);
// }


for (Localidad_Provincia__c nn : tablaNoNormalizada) {
    for(Localidad_Provincia_Rector__c pr : tablaNormalizadaRector) {
        if(nn.Codigo_Postal__c.equalsIgnoreCase(pr.Codigo_Postal__c)) {
            System.debug('Normalize la provincia ' + nn.Provincia__c + ' con el codigo ' + pr.Codigo__c);
            nn.Codigo__c = pr.Codigo__c;
            nn.Id_BHSeg__c = pr.Id_BHSeg__c;
            nn.Id_BH_Seguros__c = pr.Id_BHSeg__c + '|' + pr.Codigo_Postal__c;
        }
    }
}

UPDATE tablaNoNormalizada;