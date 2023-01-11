<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : Fiche_Infirmière.xsl
    Created on : 9 novembre 2022, 09:49
    Author     : Seynabou
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:cab="http://www.ujf-grenoble.fr/l3miage/medical"
                xmlns:act="http://www.ujf-grenoble.fr/l3miage/actes"
                xmlns:xh="http://www.w3.org/1999/xhtml">
    <xsl:output method="html"/>

    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
   
    
    <!-- paramètre contenant l'id de l'infirmier destiné -->
    <xsl:param name="destinedId" select="001"/>
    
    <!-- variable contenant les visites du jour -->
    <xsl:variable name="VisitesDuJour" select="//cab:patients/cab:patient/cab:visite[@intervenant=$destinedId]"/> 

    <!-- variable contenant le fichier actes -->
    <xsl:variable name="actes" select="document('actes.xml', /)/act:ngap"/> 
    
    <!-- variable contenant l'id d'un acte d'un patient de l'infirmier destiné -->
    <xsl:variable name="acte-id" select="$VisitesDuJour/cab:acte/@id"/> 
    
    <!-- variable contenant le soin correspondant à l'acte d'un patient -->
    <xsl:variable name="soin" select="$actes/act:actes/act:acte[@id=$acte-id]/text()"/> 


    <!--Template principale-->   
    <xsl:template match="/">
        <html>
            <head>
                <title>Fiche infirmier</title>
                
                <!-- le lien du fichier css -->
                <link rel="stylesheet" type="text/css" href="../css/InfirmierPage.css"/>
                
                <!-- le script js pour le bouton facture -->
                <script type="text/javascript" src="../js/facture.js"></script>
                
                <!-- la fonction du bouton qui affiche la facture d'un patient -->
                <script type="text/javascript"> 
                    
                        function openFacture(prenom, nom, actes) {
                            var width  = 500;
                            var height = 300;
                            if(window.innerWidth) {
                                var left = (window.innerWidth-width)/2;
                                var top = (window.innerHeight-height)/2;
                            }
                            else {
                            var left = (document.body.clientWidth-width)/2;
                            var top = (document.body.clientHeight-height)/2;
                            }
                            var factureWindow = window.open(",'facture','menubar=yes, scrollbars=yes, top='+top+', left='+left+', width='+width+', height='+height+");
                            <!-- variable qui utilise la fonction défine dansnle fichier facture.js -->
                            <!--var factureText = afficherFacture(prenom, nom, actes); -->
                            var factureText = "Facture pour : " + prenom + " " + nom;
                            factureWindow.document.write(factureText);

                        }        
                   
                </script>
           
            </head>
            
            <body>
                
                <!--Appelle de la template infirmier avec en paramettre l'identifiant de l'infirmière -->
                <xsl:call-template name="cab:infirmier">
                    <xsl:with-param name="destinedId"/>
                </xsl:call-template>                                     
            </body>
        </html>
    </xsl:template>
    
    <!--Création de la template infirmier qui va permettre d'affiche les information d'une infirmière -->
    <xsl:template name="cab:infirmier">
        <h1> Page d'accueil </h1>
        <div class="page">
            <div class="infirmier">
                <div class="image">
                   <!-- <img src="image/{cab:cabinet/cab:infirmiers/cab:infirmier[@id=$destinedId]/cab:photo}" alt="Smiley face" width="100" height="150"/> -->
                    <img src="../css/photos/sarahh.jpg" alt="Smiley face" width="120" height="120"/>
                </div>
                <div class="imagecabinet">
                    <img src="../css/photos/logo_infirmier.png" alt="Smiley face" width="180" height="100"/>
                </div>
                <div class="presentation">
                    Bonjour <strong><xsl:value-of select="//cab:infirmiers/cab:infirmier[@id=$destinedId]/cab:prénom/text()" /></strong>,
                    <br/>
                    <br/>
                    Aujourd'hui vous avez <xsl:value-of select="count($VisitesDuJour/../cab:nom)"  /> patients.
                </div>         
            </div> 
            <div class="patient">  
                <h2> Informations de vos patients</h2>  
            </div>    
            
            <!--Création d'un tableau qui contient les informations des patients d'une infirmière -->
            <table>
                <thead>
                    <tr>
                        <th>Nom</th>
                        <th>Adresse</th>
                        <th>Date</th>
                        <th>Soins</th>
                        <th>Facture</th>
                       
                    </tr>
                </thead>
                <tbody>
                <!--Appelle de template pour récupérer les information des patients d'une infirmière -->
                <xsl:apply-templates select="//cab:patients/cab:patient[cab:visite/@intervenant=$destinedId]">
                    <xsl:sort select="./cab:visite/@date" order="ascending" />
                </xsl:apply-templates>

                </tbody>
            </table>
        </div>        
    </xsl:template>
    
    <!--Template pour récupérer les informations des patients d'une infirmière-->
        <xsl:template match="cab:patient">
        
            <tr>
                <td>
                    <span>
                        <xsl:value-of select="./cab:nom" /> 
                    </span>
                </td>
                <td> 
                    <xsl:value-of select="./cab:adresse/cab:étage/text()" />
                    <xsl:if test="cab:adresse/cab:étage/text()">
                        ième Etage
                    </xsl:if>
                    <br/>
                    <br/>
                    <span >
                        <xsl:value-of select="./cab:adresse/cab:numéro" />  
                    </span>
                    <span>
                        <xsl:value-of select="./cab:adresse/cab:rue"/>
                    </span>  
                    <br/>
                    <span>
                        <xsl:value-of select="./cab:adresse/cab:codePostal"/>
                    </span> 
                    <span>
                        <xsl:value-of select="./cab:adresse/cab:ville"/> 
                    </span>
                </td> 
                <td>
                    <!-- Appel de la template qui récupère les dates des visites d'un infirmier -->
                    <xsl:apply-templates select="./cab:visite"/>
                </td>      
                <td>
                    <!--Piocher les différents soins d'un patient à travers variable 
                    $actes contenant les noeuds ngap du document actes.xml--> 
                    <xsl:apply-templates select="cab:visite/cab:acte"/>
                    
                </td>
                <td>
                    <!--Création d'un element de type button dont la propriété onclick prend la fonction openFacture-->         
                    <button>
                        <xsl:attribute name="onclick">
                        openFacture('<xsl:value-of select="./cab:prénom/text()"/>',
                                    '<xsl:value-of select="./cab:nom/text()"/>',
                                    '<xsl:value-of select="./cab:visite/cab:actes"/>')
                        </xsl:attribute>
                        Facture
                    </button> 
             
                    <br/>     
                </td>
            </tr> 
               
    </xsl:template> 
    
    <!-- template qui definit les soins du patient --> 
    <xsl:template match="cab:acte">
        <xsl:variable name="idact" select="@id"/>
        <xsl:value-of select="($actes/act:actes/act:acte[@id=$idact]/text())"/> 
        <br/>       
    </xsl:template>  
    
    <!--Template qui récupère la date d'une visite --> 
    <xsl:template match="cab:visite">
        <xsl:value-of select="./@date"/><br/>
    </xsl:template> 

</xsl:stylesheet>
