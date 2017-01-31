<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output standalone="no"/>
	<!-- catch the default template -->
	<xsl:template match="*">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- match productionresulttag -->
	<xsl:template match="productionResult">
		<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE labels SYSTEM &quot;label.dtd&quot;&gt;</xsl:text>
		<!-- open the xml file containing the printer information -->
		<xsl:variable name="ini" select="document('ini.xml')"/> 
		<xsl:variable name="location" select="./location"/> 
		<!-- create a new tag called labels -->
		<xsl:element name="labels">
			<!-- add necessary attributes to labels -->
			<xsl:attribute name="_FORMAT">
				<xsl:value-of select="$ini/setup/location[id=$location]/format"/>
			</xsl:attribute>
			<xsl:attribute name="_QUANTITY">
				<xsl:value-of select="qty"/>
			</xsl:attribute>
			<xsl:attribute name="_PRINTERNAME">
				<xsl:value-of select="$ini/setup/location[id=$location]/printer"/>
			</xsl:attribute>
			<xsl:attribute name="_JOBNAME">
				<xsl:value-of select="./id"/>
			</xsl:attribute>
			
			<!-- add the label tag -->
			<xsl:element name="label">
				<!-- add a tag for the ip adres and portnumber of the printer -->
				<xsl:element name="variable">
					<xsl:attribute name="name">
						<xsl:text>printerAddress</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="$ini/setup/location[id=$location]/ip"/>
				</xsl:element>
				<xsl:element name="variable">
					<xsl:attribute name="name">
						<xsl:text>printerPort</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="$ini/setup/location[id=$location]/port"/>
				</xsl:element>
				<!-- apply the other templates -->
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<!-- match every tag under productionResulttag -->
	<xsl:template match="productionResult//*">
		<!-- create an element for each tag -->
		<xsl:element name="variable">
			<xsl:attribute name="name">
				<xsl:value-of select="local-name()"/>
			</xsl:attribute>
			<!-- apply the default template which will print our value as text -->
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>