<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : fiche_patient.xsl
    Created on : 27 novembre 2022, 14:48
    Author     : Seynabou
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:pa="http://www.ujf-grenoble.fr/l3miage/medical"  version="1.0">
    <xsl:output method="html"/>

    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    
    <!-- variable contenant les informations et visites du patient concerné -->
    <xsl:variable name="visites_patient" select="document('patient_html.xml', /)/patient"/> 
    
    <xsl:template match="/">
        <html>
            <head>
                <title>fiche_patient.xsl</title>
                
                <!-- le lien du fichier css -->
                <link rel="stylesheet" type="text/css" href="../css/pagePatient.css"/>
            </head>
            <body>
                
                <!--Appelle de la template patient qui permet d'afficher les informations du patient concerné -->
                <xsl:call-template name="pa:patient"/>
                    
                
            </body>
        </html>
    </xsl:template>
    
    <xsl:template name="pa:patient">
        <h1> Fiche patient </h1>
        <div class="page">
            <div class="patient">
                <div class="imagecabinet">
                    <img src="../css/photos/logo_cabinet.jpg" alt="Smiley face" width="120" height="110"/>
                </div>
                <div class="informations_personnelles">
                    <span>
                        <strong> Nom : </strong>  
                        <xsl:value-of select="pa:patient/pa:nom/text()" /> 
                    </span><br/>
                    <span>
                        <strong> Prénom : </strong>  
                        <xsl:value-of select="pa:patient/pa:prénom/text()" /> 
                    </span><br/>
                    <span>
                        <strong> Sexe : </strong>  
                        <xsl:value-of select="pa:patient/pa:sexe/text()" /> 
                    </span><br/>
                    <span>
                        <strong> Naissance : </strong>  
                        <xsl:value-of select="pa:patient/pa:naissance/text()" /> 
                    </span><br/>
                    <span>
                        <strong> Numéro de sécurité social : </strong>  
                        <xsl:value-of select="pa:patient/pa:numéroSS/text()" /> 
                    </span><br/>
                    <span>
                        <strong> Adresse : </strong>  
                        <xsl:value-of select="pa:patient/pa:adresse/pa:rue/text()" /> 
                    </span><br/>
                    <span>
                        <xsl:value-of select="pa:patient/pa:adresse/pa:codePostal/text()"/>&#160;&#160;
                        <xsl:value-of select="pa:patient/pa:adresse/pa:ville/text()"/>
                    </span>                    
                    
                </div>         
            </div> 
            <div class="visites">  
                <h2> Informations </h2>  
            </div>    
            
            <!-- Création d'un tableau qui contient les informations sur les visites du patient concerné -->
            <table>
                <thead>
                    <tr>
                        
                        <th>Date</th>
                        <th>Soins</th>
                        <th>Intervenant(e)</th>
                        
                    </tr>
                </thead>
                <tbody>
                <!-- Appelle de la template pour récupérer les informations des différentes visites du patient -->
                <xsl:apply-templates select="//pa:visite">
                    <xsl:sort select="./@date" order="ascending" />
                </xsl:apply-templates>

                </tbody>
            </table>
        </div>        
    </xsl:template>
    
    <!--Template pour récupérer les informations des différents visites du patient -->
        <xsl:template match="pa:visite">
        
            <tr>
                <td>
                    <span>
                        <xsl:value-of select="./@date" /> 
                    </span>
                </td>
                <td> 
                    <span >
                        <xsl:value-of select="./pa:acte/text()" />  
                    </span>
                </td> 
                <td>
                    <span>
                        <strong>Nom : </strong> 
                        <xsl:value-of select="./pa:intervenant/pa:nom/text()"/>
                    </span><br/>
                    <span>
                        <strong>Prénom : </strong> 
                        <xsl:value-of select="./pa:intervenant/pa:prénom/text()"/>
                    </span>
                </td>      
                
            </tr> 
               
    </xsl:template> 
    

</xsl:stylesheet>
