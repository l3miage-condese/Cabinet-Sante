<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : patient_1.xsl
    Created on : 25 novembre 2022, 01:32
    Author     : Seynabou
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:cab="http://www.ujf-grenoble.fr/l3miage/medical"
                xmlns:act="http://www.ujf-grenoble.fr/l3miage/actes"
                xmlns:xh="http://www.w3.org/1999/xhtml">
    <xsl:output method="xml" indent="yes"/>

    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    
    <!-- paramètre contenant le nom du patient dont on doit extraire les informations -->
    <xsl:param name="destinedName" select="'Pien'"/>  
    
    <!-- variable contenant le fichier actes -->
    <xsl:variable name="actes" select="document('actes.xml', /)/act:ngap"/>
    
    <!-- variable contenant les id des infirmiers -->
    <xsl:variable name="id_infirmier" select="//cab:patients/cab:patient/cab:nom[text()=$destinedName]/../cab:visite/@intervenant"/>  
    
    <!-- variable contenant l'id d'un acte du patient concerné -->
    <xsl:variable name="idact" select="//cab:patients/cab:patient/cab:nom[text()=$destinedName]/../cab:visite/cab:acte/@id"/>
    
    <xsl:template match="/">
        
        <xsl:element name="patient">
            <!-- Appel de la template qui recupère le nom , prénom, sexe,naissance et numémoSS du patient concerné -->
            <xsl:apply-templates select="//cab:patients/cab:patient/cab:nom[text()=$destinedName]/.." />
            
            <xsl:element name="adresse">
                <!-- Appel de la template qui recupère l'adresse du patient concerné -->
                <xsl:apply-templates select="//cab:patients/cab:patient/cab:nom[text()=$destinedName]/../cab:adresse" />
            </xsl:element>
            
            <!-- Appel de la template qui recupère les visites, les informations des intervenants ainsi que les soins du patient concerné--> 
            <xsl:apply-templates select="//cab:infirmiers/cab:infirmier[@id=$id_infirmier]/cab:nom" />
        </xsl:element>
    </xsl:template>
    
    <!-- Création de la template pour récupérer le nom , prénom, sexe,naissance et numémoSS du patient concerné -->
    <xsl:template match="cab:patient">
        <xsl:element name="nom">
            <xsl:value-of select="./cab:nom/text()" />
        </xsl:element>
        <xsl:element name="prénom">
            <xsl:value-of select="./cab:prénom/text()" />
        </xsl:element>
        <xsl:element name="sexe">
            <xsl:value-of select="./cab:sexe/text()" />
        </xsl:element>
        <xsl:element name="naissance">
            <xsl:value-of select="./cab:naissance/text()" />
        </xsl:element>
        <xsl:element name="numéroSS">
            <xsl:value-of select="./cab:numéro/text()" />
        </xsl:element>
    </xsl:template>
    
    <!-- Création de la template qui récupère l'adresse du patient concerné -->
    <xsl:template match="cab:adresse">
        <!-- condition pour vérifier si l'adresse du patient a un numéro d'étage -->
            <xsl:if test="cab:adresse/cab:étage/text()">
                <xsl:element name="étage">
                    <xsl:value-of select="./cab:étage/text()" />
                </xsl:element>
            </xsl:if>
            <xsl:if test="cab:adresse/cab:numéro/text()">
                <xsl:element name="numéro">
                    <xsl:value-of select="./cab:numéro/text()" />
                </xsl:element>
            </xsl:if>
            <xsl:element name="rue">
                <xsl:value-of select="./cab:rue/text()" />
            </xsl:element>
            <xsl:element name="codePostal">
                <xsl:value-of select="./cab:codePostal/text()" />
            </xsl:element>
            <xsl:element name="ville">
                <xsl:value-of select="./cab:ville/text()" />
            </xsl:element>
    </xsl:template>
  
   <!-- Création de la template qui récupère les visites, les informations des intervenants et soins du patient concerné --> 
    <xsl:template match="cab:nom">
        <xsl:element name="visite">
            <xsl:attribute name="date">
                <xsl:value-of select="../../../cab:patients/cab:patient/cab:visite/@date" />
            </xsl:attribute>
            <xsl:element name="intervenant">
                <xsl:element name="nom">
                    <xsl:value-of select="./text()" />
                </xsl:element>
                <xsl:element name="prénom">
                    <xsl:value-of select="../cab:prénom/text()" />
                </xsl:element>
            </xsl:element>
            <!-- Appel de la template qui récupère les soins du patient concerné 
            <xsl:apply-templates select="../../../cab:patients/cab:patient[./cab:nom/text()=$destinedName]/cab:visite/cab:acte"/> -->
            
                <xsl:apply-templates select="../../../cab:patients/cab:patient[./cab:nom/text()=$destinedName]/cab:visite/cab:acte"/>
            
        </xsl:element>
    </xsl:template>
    
   <!-- template qui definit les soins du patient --> 
    <xsl:template match="cab:acte">
        <xsl:variable name="idact" select="@id"/>
            <xsl:element name="acte">
                <xsl:value-of select="($actes/act:actes/act:acte[@id=$idact]/text())"/> 
            </xsl:element>
    </xsl:template> 
    
   
    
     

</xsl:stylesheet>
