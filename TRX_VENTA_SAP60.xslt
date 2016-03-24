<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet exclude-result-prefixes="xsl ns1" version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ns1="http://www.analisis.cl/beans/ext/envioventaunit">
	<xsl:output indent="yes" encoding="ISO-8859-1"/>
	<xsl:template match="/">
		<xsl:variable name="site" select="string('TE')"/>
		<WPUBON01>
			<IDOC BEGIN="1">
				<EDI_DC40 SEGMENT="1">
					<DIRECT>2</DIRECT>
					<IDOCTYP>WPUBON01</IDOCTYP>
					<MESTYP>WPUBON</MESTYP>
					<STDMES>WPUBON</STDMES>
					<SNDPOR>
						<xsl:value-of select="concat($site,'8MQ400')"/>
					</SNDPOR>
					<SNDPRT>KU</SNDPRT>
					<SNDPRN>
						<xsl:variable name="local" select="concat('00',/ns1:ventaDiaria/ns1:control_data/ns1:local_id)"/>
						<xsl:variable name="local_format" select="substring($local,string-length($local)-1,2)"/>
						<xsl:choose>
							<xsl:when test="/ns1:ventaDiaria/ns1:control_data/ns1:pais_id  = '56'">
								<xsl:value-of select="concat('T0',$local_format)"/>
							</xsl:when>
							<xsl:when test="/ns1:ventaDiaria/ns1:control_data/ns1:pais_id  = '51'">
								<xsl:value-of select="concat('PE',$local_format)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="/ns1:ventaDiaria/ns1:control_data/ns1:local_id"/>
							</xsl:otherwise>
						</xsl:choose>
					</SNDPRN>
					<RCVPOR>
						<xsl:value-of select="concat('SAP',$site,'8')"/>
					</RCVPOR>
					<RCVPRT>LS</RCVPRT>
					<RCVPRN>
						<xsl:value-of select="concat($site,'8-400')"/>
					</RCVPRN>
					<CREDAT>
						<xsl:value-of select="concat(substring(//ns1:ts_registrocentral,1,4),substring(//ns1:ts_registrocentral,6,2),substring(//ns1:ts_registrocentral,9,2))"/>
					</CREDAT>
					<CRETIM>
						<xsl:value-of select="concat(substring(//ns1:ts_registrocentral,12,2),substring(//ns1:ts_registrocentral,15,2),substring(//ns1:ts_registrocentral,18,2))"/>
					</CRETIM>
				</EDI_DC40>
				<xsl:variable name="ctaceros" select="'00000000000'"/>
				<!-- CABECERA -->
				<E1WPB01 SEGMENT="1">
					<xsl:variable name="idcaja" select="concat($ctaceros,//ns1:caja)"/>
					<KASSID>
						<xsl:value-of select="substring($idcaja,string-length($idcaja)-2,3)"/>
					</KASSID>
					<VORGDATUM>
						<xsl:value-of select="concat(substring(//ns1:fecha,1,4),substring(//ns1:fecha,6,2),substring(//ns1:fecha,9,2))"/>
						<!--  <xsl:value-of select="concat(substring(//ns1:fechaMsg,1,4),substring(//ns1:fechaMsg,6,2),substring(//ns1:fechaMsg,9,2))"/> -->
					</VORGDATUM>
					<VORGZEIT>
						<xsl:value-of select="concat(substring(//ns1:fecha,12,2),substring(//ns1:fecha,15,2),substring(//ns1:fecha,18,2))"/>
					</VORGZEIT>
					<BONNUMMER>
						<xsl:variable name="cod">
							<xsl:if test="/ns1:ventaDiaria/ns1:control_data/ns1:pais_id  = '56'">
								<xsl:choose>
									<xsl:when test="//ns1:tipodoc  = 'B' and //ns1:implDocCod = '1' ">B</xsl:when>
									<xsl:when test="//ns1:tipodoc  = 'F' and //ns1:implDocCod = '1' ">F</xsl:when>
									<xsl:when test="//ns1:tipodoc  = 'C' and //ns1:implDocCod = '1' ">C</xsl:when>
									<xsl:when test="//ns1:tipodoc  = 'D' and //ns1:implDocCod = '1' ">D</xsl:when>
									<xsl:when test="//ns1:tipodoc  = 'B' and //ns1:implDocCod = '16' ">X</xsl:when>
									<xsl:when test="//ns1:tipodoc  = 'F' and //ns1:implDocCod = '16' ">Y</xsl:when>
									<xsl:when test="//ns1:tipodoc  = 'C' and //ns1:implDocCod = '16' ">Z</xsl:when>
									<xsl:when test="//ns1:tipodoc  = 'B' and //ns1:modo = 'M' ">M</xsl:when>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="/ns1:ventaDiaria/ns1:control_data/ns1:pais_id  = '51'">
								<xsl:choose>
									<!-- 
									SI tipodoc=B y modo=M ENVIA A SAP =M
                            		SI tipodoc=F y modo=M ENVIA A SAP =F
                            		SI tipodoc=C y modo=M ENVIA A SAP =C
 
                            		SI tipodoc=R y modo=C ENVIA A SAP =B                    
                            		SI tipodoc=T y modo=C ENVIA A SAP =T              
                            		SI tipodoc=C  y modo=C y implDocCod=17 ENVIA A SAP =Z
                            		SI tipodoc=F  y modo=C y implDocCod=17 ENVIA A SAP =Y
                            		SI tipodoc=B  y modo=C y implDocCod=17 ENVIA A SAP =X

									    SI tipodoc=B y modo=C y implDocCod=0 ENVIA A SAP =B                     
                            			SI tipodoc=T y modo=C y implDocCod=0 ENVIA A SAP =T                    
                            			SI tipodoc=C y modo=C y implDocCod=0  ENVIA A SAP =C            
                            			SI tipodoc=C  y modo=C y implDocCod=17 ENVIA A SAP =Z
                            			SI tipodoc=F  y modo=C y implDocCod=17 ENVIA A SAP =Y
                            			SI tipodoc=B  y modo=C y implDocCod=17 ENVIA A SAP =X
 
									
									-->
									<xsl:when test="//ns1:tipodoc  = 'B' and //ns1:modo = 'M' ">M</xsl:when>
									<xsl:when test="//ns1:tipodoc  = 'B' and //ns1:modo = 'C' and //ns1:implDocCod = '0'">B</xsl:when>
									<xsl:when test="//ns1:tipodoc  = 'F' and //ns1:modo = 'M' ">F</xsl:when>
									<xsl:when test="//ns1:tipodoc  = 'C' and //ns1:modo = 'M' ">C</xsl:when>
									<xsl:when test="//ns1:tipodoc  = 'C' and //ns1:modo = 'C' and //ns1:implDocCod = '0'">C</xsl:when>
									<xsl:when test="//ns1:tipodoc  = 'R' and //ns1:modo = 'C' ">B</xsl:when>
									<xsl:when test="//ns1:tipodoc  = 'T' and //ns1:modo = 'C' and //ns1:implDocCod = '0'">T</xsl:when>
									<xsl:when test="//ns1:tipodoc  = 'C' and //ns1:modo = 'C' and //ns1:implDocCod = '17' ">Z</xsl:when>
									<xsl:when test="//ns1:tipodoc  = 'F' and //ns1:modo = 'C' and //ns1:implDocCod = '17' ">Y</xsl:when>
									<xsl:when test="//ns1:tipodoc  = 'B' and //ns1:modo = 'C' and //ns1:implDocCod = '17' ">X</xsl:when>
								</xsl:choose>
							</xsl:if>
						</xsl:variable>
						<xsl:variable name="ndoc">
							<xsl:value-of select="concat('000000000',//ns1:numdoc)"/>
						</xsl:variable>
						<xsl:variable name="fndoc">
							<xsl:value-of select="substring($ndoc,string-length($ndoc)-7,8)"/>
						</xsl:variable>
						<!-- r.silva 20151232 -->
						<xsl:if test="//ns1:pais_id  = '56'">
							<xsl:value-of select="concat($cod,$fndoc)"/>
						</xsl:if>
						<xsl:if test="//ns1:pais_id  = '51' and //ns1:modo != 'M'">
							<xsl:value-of select="concat($cod,$fndoc)"/>
						</xsl:if>
						<xsl:if test="//ns1:pais_id  = '51' and //ns1:modo = 'M'">
							<xsl:value-of select="concat($cod,$fndoc,'-',//ns1:serie)"/>
						</xsl:if>
					</BONNUMMER>
					<KUNDNR>
						<xsl:if test="/ns1:ventaDiaria/ns1:control_data/ns1:pais_id  = '56'">
							<xsl:value-of select="concat(substring-before(//ns1:fac_rut,'-'),substring-after(//ns1:fac_rut,'-'))"/>
						</xsl:if>
						<xsl:if test="/ns1:ventaDiaria/ns1:control_data/ns1:pais_id  = '51'">
							<xsl:value-of select="//ns1:fac_cuenta_sap"/>
						</xsl:if>
					</KUNDNR>
					<KASSIERER>
						<xsl:value-of select="//ns1:vendedor"/>
					</KASSIERER>
					<BELEGWAERS>
						<xsl:value-of select="//ns1:erp_moneda"/>
					</BELEGWAERS>
					<!-- DETALLE VENTA -->
					<xsl:for-each select="//ns1:item_det_prod">
						<xsl:if test="//ns1:tipodoc != 'TR'">
							<E1WPB02 SEGMENT="1">
								<QUALARTNR>ARTN</QUALARTNR>
								<ARTNR>
									<xsl:value-of select="concat('0',./ns1:sku)"/>
								</ARTNR>
								<VORZEICHEN>
									<!-- revisar diferencia con Peru -->
									<xsl:choose>
										<xsl:when test="./ns1:cantidad &lt; 0">
											<xsl:choose>
												<xsl:when test="//ns1:tipodoc = 'C'">+</xsl:when>
												<xsl:otherwise>+</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="//ns1:tipodoc = 'C'">+</xsl:when>
												<xsl:otherwise>-</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</VORZEICHEN>
								<MENGE>
									<xsl:choose>
										<xsl:when test="./ns1:cantidad &lt; 0">
											<xsl:value-of select="./ns1:cantidad div -1"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="./ns1:cantidad div 1"/>
										</xsl:otherwise>
									</xsl:choose>
								</MENGE>
								<VERKAEUFER>
									<xsl:value-of select="//ns1:vendedor"/>
								</VERKAEUFER>
								<!-- Revisar LOGICA -->
								<xsl:if test="position() = 1">
									<xsl:if test="//ns1:tipodoc  = 'C'">
										<xsl:if test="/ns1:ventaDiaria/ns1:control_data/ns1:pais_id  = '56'">
											<xsl:variable name="ref" select="concat('0000000000000',//ns1:ref_notacredito)"/>
											<xsl:variable name="ref_for" select="substring($ref,string-length($ref)-12,13)"/>
											<REFBONNR>
												<xsl:value-of select="concat(//ns1:ref_tipo_notacredito,'-',$ref_for)"/>
											</REFBONNR>
										</xsl:if>
										<xsl:if test="/ns1:ventaDiaria/ns1:control_data/ns1:pais_id  = '51'">
											<!-- r.silva 20151202 -->
											<REFBONNR>
												<xsl:for-each select="//ns1:item_adic">
													<xsl:if test="ns1:concepto = 'TIPODOC_ORIG'">
														<xsl:variable name="torig">
															<xsl:value-of select="ns1:valor"/>
														</xsl:variable>
														<xsl:value-of select="concat($torig,'-')"/>
													</xsl:if>
												</xsl:for-each>
												<xsl:for-each select="//ns1:item_adic">
													<xsl:if test="ns1:concepto = 'SERIE_ORIG'">
														<xsl:variable name="sorig">
															<xsl:value-of select="ns1:valor"/>
														</xsl:variable>
														<xsl:value-of select="concat($sorig,'-')"/>
													</xsl:if>
												</xsl:for-each>
												<xsl:for-each select="//ns1:item_adic">
													<xsl:if test="ns1:concepto = 'NUMDOC_ORIG'">
														<xsl:variable name="norig">
															<xsl:value-of select="ns1:valor"/>
														</xsl:variable>
														<xsl:value-of select="$norig"/>
													</xsl:if>
												</xsl:for-each>
												<!-- <xsl:value-of select="concat(//ns1:ref_notacredito_tipodoc,'-',//ns1:ref_notacredito_serie,'-',//ns1:ref_notacredito)"/> -->
											</REFBONNR>
										</xsl:if>
									</xsl:if>
									<xsl:if test="//ns1:tipodoc  != 'C'">
										<xsl:if test="//ns1:pais_id  = '56'">
											<REFBONNR>
												<xsl:value-of select="string(' ')"/>
											</REFBONNR>
										</xsl:if>
										<xsl:if test="//ns1:pais_id  = '51'">
											<REFBONNR>
												<xsl:if test="//ns1:Detalle_mpago/ns1:item_mpago/ns1:clasif_mp = 'NCR'">
													<xsl:for-each select="//ns1:Detalle_mpago/ns1:item_mpago">
														<xsl:if test="./ns1:clasif_mp = 'NCR'">
															<xsl:if test="./ns1:serie != ''">
																<xsl:value-of select="concat('07-',./ns1:serie,'-',./ns1:nro_nc)"/>
															</xsl:if>
															<xsl:if test="./ns1:serie = ''">
																<xsl:value-of select="concat('07-',' ','-',./ns1:nro_nc)"/>
															</xsl:if>
														</xsl:if>
													</xsl:for-each>
												</xsl:if>
												<xsl:if test="not(//ns1:Detalle_mpago/ns1:item_mpago/ns1:clasif_mp = 'NCR')">
													<xsl:value-of select="string(' ')"/>
												</xsl:if>
											</REFBONNR>
										</xsl:if>
									</xsl:if>
								</xsl:if>
								<xsl:if test="./ns1:subtotal_item != 0">
									<E1WPB03 SEGMENT="1">
										<VORZEICHEN>
										</VORZEICHEN>
										<KONDITION>PN10</KONDITION>
										<KONDVALUE>
											<xsl:if test="//ns1:pais_id  = '56'">
												<xsl:choose>
													<xsl:when test="./ns1:subtotal_item &lt; 0">
														<xsl:value-of select="format-number((-1 * ./ns1:subtotal_item div 1),'#')"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="format-number((./ns1:subtotal_item div 1),'#')"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
											<xsl:if test="//ns1:pais_id  = '51'">
												<xsl:choose>
													<xsl:when test="./ns1:subtotal_item &lt; 0">
														<xsl:value-of select="format-number((-1 * ./ns1:subtotal_item div 1),'#.00')"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="format-number((./ns1:subtotal_item div 1),'#.00')"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
										</KONDVALUE>
									</E1WPB03>
								</xsl:if>
								<xsl:if test="./ns1:montodesc != 0 and ./ns1:montodesc != ''">
									<E1WPB03 SEGMENT="1">
										<VORZEICHEN>
										</VORZEICHEN>
										<KONDITION>
											<xsl:value-of select="./ns1:refcontabdesc_i"/>
										</KONDITION>
										<KONDVALUE>
											<xsl:if test="//ns1:pais_id  = '56'">
												<xsl:choose>
													<xsl:when test="./ns1:montodesc &lt; 0">
														<xsl:value-of select="format-number((-1 * ./ns1:montodesc div 1),'#')"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="format-number((./ns1:montodesc div 1),'#')"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
											<xsl:if test="//ns1:pais_id  = '51'">
												<xsl:choose>
													<xsl:when test="./ns1:montodesc &lt; 0">
														<xsl:value-of select="format-number((-1 * ./ns1:montodesc div 1),'#.00')"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="format-number((./ns1:montodesc div 1),'#.00')"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
										</KONDVALUE>
									</E1WPB03>
								</xsl:if>
								<xsl:if test="./ns1:descglob != 0 and ./ns1:descglob != ''">
									<E1WPB03 SEGMENT="1">
										<VORZEICHEN>
										</VORZEICHEN>
										<KONDITION>
											<xsl:value-of select="./ns1:refcontabdesc_g"/>
										</KONDITION>
										<KONDVALUE>
											<xsl:if test="//ns1:pais_id  = '56'">
												<xsl:choose>
													<xsl:when test="./ns1:descglob &lt; 0">
														<xsl:value-of select="format-number((-1 * ./ns1:descglob div 1),'#')"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="format-number((./ns1:descglob div 1),'#')"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
											<xsl:if test="//ns1:pais_id  = '51'">
												<xsl:choose>
													<xsl:when test="./ns1:descglob &lt; 0">
														<xsl:value-of select="format-number((-1 * ./ns1:descglob div 1),'#.00')"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="format-number((./ns1:descglob div 1),'#.00')"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
										</KONDVALUE>
									</E1WPB03>
								</xsl:if>
								<xsl:if test="/ns1:ventaDiaria/ns1:control_data/ns1:pais_id  = '51'">
									<xsl:if test="position() = 1">
										<E1WXX01 SEGMENT="1">
											<FLDNAME>POSEDCROS</FLDNAME>
											<xsl:if test="//ns1:tipodoc = 'C'">
												<FLDVAL>
													<!-- Cambio SERIE_EQUIPO por  FECHA_ORIG 2016-01-30 rsilva-->
													<xsl:for-each select="//ns1:Detalle_adic/ns1:item_adic">
														<xsl:if test="./ns1:concepto = 'FECHA_ORIG'">
															<xsl:value-of select="concat(substring(./ns1:valor,1,2),'.',substring(./ns1:valor,4,2),'.',substring(./ns1:valor,7,4))"/>
														</xsl:if>
													</xsl:for-each>
												</FLDVAL>
											</xsl:if>
											<xsl:if test="//ns1:tipodoc != 'C'">
												<FLDVAL>
													<xsl:value-of select="string(' ')"/>
												</FLDVAL>
											</xsl:if>
										</E1WXX01>
										<E1WXX01 SEGMENT="1">
											<FLDNAME>POSEDTRNR</FLDNAME>
											<FLDVAL>
												<xsl:value-of select="substring(//ns1:venta_id,5,10)"/>
											</FLDVAL>
										</E1WXX01>
									</xsl:if>
								</xsl:if>
							</E1WPB02>
						</xsl:if>
						<xsl:if test="/ns1:ventaDiaria/ns1:control_data/ns1:pais_id  = '51'">
							<xsl:if test="position() = 1">
								<E1WPB05 SEGMENT="1">
									<RABATTART>ZARP</RABATTART>
									<xsl:if test="//ns1:ajusteredondeo &lt; 0">
										<RABVALUE>
											<xsl:value-of select="number(//ns1:ajusteredondeo)*-1"/>
										</RABVALUE>
									</xsl:if>
									<xsl:if test="//ns1:ajusteredondeo &gt;= 0">
										<RABVALUE>
											<xsl:value-of select="number(//ns1:ajusteredondeo)*1"/>
										</RABVALUE>
									</xsl:if>
								</E1WPB05>
							</xsl:if>
						</xsl:if>
					</xsl:for-each>
					<!-- MEDIOS DE PAGOS -->
					<xsl:if test="//ns1:tipodoc = 'TR'">
						<E1WPB06 SEGMENT="1">
							<VORZEICHEN>+</VORZEICHEN>
							<ZAHLART>
								<xsl:value-of select="//ns1:refcontab1"/>
							</ZAHLART>
							<SUMME>
								<xsl:if test="//ns1:pais_id  = '56'">
									<xsl:value-of select="format-number((//ns1:subtotal div -1),'#')"/>
								</xsl:if>
								<xsl:if test="//ns1:pais_id  = '51'">
									<xsl:value-of select="format-number((//ns1:subtotal div -1),'#.00')"/>
								</xsl:if>
							</SUMME>
							<WAEHRUNG>
								<xsl:value-of select="//ns1:erp_moneda"/>
							</WAEHRUNG>
						</E1WPB06>
					</xsl:if>
					<xsl:if test="count(//ns1:Detalle_mpago/ns1:item_mpago) = 0 and //ns1:tipodoc = 'C'">
						<E1WPB06 SEGMENT="1">
							<VORZEICHEN>-</VORZEICHEN>
							<ZAHLART>
								<xsl:value-of select="string('ZINC')"/>
							</ZAHLART>
							<SUMME>
								<xsl:if test="//ns1:pais_id  = '56'">
									<xsl:value-of select="format-number((//ns1:subtotal div -1),'#')"/>
								</xsl:if>
								<xsl:if test="//ns1:pais_id  = '51'">
									<xsl:value-of select="format-number((//ns1:subtotal div -1),'#.00')"/>
								</xsl:if>
							</SUMME>
							<WAEHRUNG>
								<xsl:value-of select="//ns1:erp_moneda"/>
							</WAEHRUNG>
						</E1WPB06>
					</xsl:if>
					<!-- MEDIOS DE PAGOS -->
					<xsl:for-each select="//ns1:Detalle_mpago/ns1:item_mpago">
						<!-- CHILE -->
						<xsl:if test="//ns1:pais_id  = '56'">
							<E1WPB06 SEGMENT="1">
								<VORZEICHEN>
									<xsl:choose>
										<xsl:when test="./ns1:monto &lt; 0">
											<xsl:choose>
												<xsl:when test="//ns1:tipodoc = 'C'">-</xsl:when>
												<xsl:when test="//ns1:tipodoc = 'C' and TipodeSeleccion = '2'">-</xsl:when>
												<xsl:otherwise>-</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="//ns1:tipodoc = 'C'">-</xsl:when>
												<xsl:when test="//ns1:tipodoc = 'C' and TipodeSeleccion = '2'">-</xsl:when>
												<xsl:otherwise>+</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</VORZEICHEN>
								<ZAHLART>
									<xsl:value-of select="./ns1:refcontab1"/>
								</ZAHLART>
								<SUMME>
									<xsl:choose>
										<xsl:when test="./ns1:monto &lt; 0">
											<xsl:value-of select="format-number((./ns1:monto div -1),'#')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number((./ns1:monto div 1),'#')"/>
										</xsl:otherwise>
									</xsl:choose>
								</SUMME>
								<WAEHRUNG>
									<xsl:value-of select="//ns1:erp_moneda"/>
								</WAEHRUNG>
								<KARTENNR>
									<xsl:value-of select="./ns1:nro_operacion"/>
								</KARTENNR>
								<KARTENFNR>
									<xsl:value-of select="./ns1:fono"/>
								</KARTENFNR>
								<GUELTAB>
									<xsl:value-of select="./ns1:fechavenc"/>
								</GUELTAB>
								<GUELTBIS>
									<xsl:value-of select="./ns1:fechavenc"/>
								</GUELTBIS>
								<KONTOINH>
									<xsl:value-of select="./ns1:rut"/>
								</KONTOINH>
								<BANKLZ>
									<xsl:value-of select="concat(./ns1:codbanco,'-',./ns1:codplaza)"/>
								</BANKLZ>
								<KONTONR>
									<xsl:value-of select="./ns1:nro_cuenta"/>
								</KONTONR>
								<AUTORINR>
									<xsl:value-of select="./ns1:codautoriz"/>
								</AUTORINR>
								<TERMID>
									<xsl:value-of select="string(' ')"/>
								</TERMID>
								<REFERENZ1>
									<xsl:value-of select="./ns1:nrocuotas"/>
								</REFERENZ1>
								<REFERENZ2>
									<xsl:value-of select="//ns1:fecha"/>
								</REFERENZ2>
								<REFERENZ3>
									<xsl:value-of select="string(' ')"/>
								</REFERENZ3>
								<ZUONR>
									<xsl:value-of select="./ns1:codcomercio"/>
								</ZUONR>
							</E1WPB06>
						</xsl:if>
						<!-- PERU -->
						<xsl:if test="//ns1:pais_id  = '51' and //ns1:tipodoc = 'C'">
							<E1WPB06 SEGMENT="1">
								<VORZEICHEN>
									<xsl:choose>
										<xsl:when test="./ns1:monto &lt; 0">
											<xsl:choose>
												<xsl:when test="//ns1:tipodoc = 'C'">-</xsl:when>
												<xsl:when test="//ns1:tipodoc = 'C' and TipodeSeleccion = '2'">-</xsl:when>
												<xsl:otherwise>-</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="//ns1:tipodoc = 'C'">-</xsl:when>
												<xsl:when test="//ns1:tipodoc = 'C' and TipodeSeleccion = '2'">-</xsl:when>
												<xsl:otherwise>+</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</VORZEICHEN>
								<ZAHLART>
									<xsl:value-of select="./ns1:refcontab1"/>
								</ZAHLART>
								<SUMME>
									<xsl:if test="not(//ns1:tipodoc = 'C' and (./ns1:clasif_mp = 'TCR' or ./ns1:clasif_mp = 'TCO'))">
										<xsl:choose>
											<xsl:when test="./ns1:monto &lt; 0">
												<xsl:value-of select="format-number((./ns1:monto div -1),'#.00')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="format-number((./ns1:monto div 1),'#.00')"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
									<xsl:if test="//ns1:tipodoc = 'C' and (./ns1:clasif_mp = 'TCR' or ./ns1:clasif_mp = 'TCO')">
										<xsl:choose>
											<xsl:when test="./ns1:monto &lt; 0">
												<xsl:value-of select="format-number((./ns1:monto div 1),'#.00')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="format-number((./ns1:monto div 1),'#.00')"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</SUMME>
								<WAEHRUNG>
									<xsl:value-of select="//ns1:erp_moneda"/>
								</WAEHRUNG>
								<KARTENNR>
									<xsl:value-of select="./ns1:nro_operacion"/>
								</KARTENNR>
								<KARTENFNR>
									<xsl:value-of select="./ns1:fono"/>
								</KARTENFNR>
								<GUELTAB>
									<xsl:value-of select="./ns1:fechavenc"/>
								</GUELTAB>
								<GUELTBIS>
									<xsl:value-of select="./ns1:fechavenc"/>
								</GUELTBIS>
								<KONTOINH>
									<xsl:value-of select="./ns1:rut"/>
								</KONTOINH>
								<BANKLZ>
									<xsl:value-of select="concat(./ns1:codbanco,'-',./ns1:codplaza)"/>
								</BANKLZ>
								<KONTONR>
									<xsl:value-of select="./ns1:nro_cuenta"/>
								</KONTONR>
								<AUTORINR>
									<xsl:value-of select="./ns1:codautoriz"/>
								</AUTORINR>
								<TERMID>
									<xsl:value-of select="string(' ')"/>
								</TERMID>
								<REFERENZ1>
									<xsl:value-of select="./ns1:nrocuotas"/>
								</REFERENZ1>
								<REFERENZ2>
									<xsl:value-of select="//ns1:fecha"/>
								</REFERENZ2>
								<REFERENZ3>
									<xsl:value-of select="string(' ')"/>
								</REFERENZ3>
								<ZUONR>
									<xsl:value-of select="./ns1:codcomercio"/>
								</ZUONR>
							</E1WPB06>
						</xsl:if>

						<!-- r.silva 16-03-2016 -->

						<!-- //ns1:pais_id  = '51' and ./ns1:clasif_mp != 'NCR' and //ns1:tipodoc != 'C' -->
						<xsl:if test="//ns1:pais_id  = '51' and count(//ns1:Detalle_mpago_ref/ns1:item_mpago) != 0 and //ns1:tipodoc != 'C'">
							<xsl:if test="./ns1:clasif_mp != 'NCR'">
								<E1WPB06 SEGMENT="1">
									<VORZEICHEN>
										<xsl:choose>
											<xsl:when test="./ns1:monto &lt; 0">
												<xsl:choose>
													<xsl:when test="//ns1:tipodoc = 'C'">-</xsl:when>
													<xsl:when test="//ns1:tipodoc = 'C' and TipodeSeleccion = '2'">-</xsl:when>
													<xsl:otherwise>-</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<xsl:choose>
													<xsl:when test="//ns1:tipodoc = 'C'">-</xsl:when>
													<xsl:when test="//ns1:tipodoc = 'C' and TipodeSeleccion = '2'">-</xsl:when>
													<xsl:otherwise>+</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
									</VORZEICHEN>
									<ZAHLART>
										<xsl:value-of select="./ns1:refcontab1"/>
									</ZAHLART>
									<SUMME>
										<xsl:if test="not(//ns1:tipodoc = 'C' and (./ns1:clasif_mp = 'TCR' or ./ns1:clasif_mp = 'TCO'))">
											<xsl:choose>
												<xsl:when test="./ns1:monto &lt; 0">
													<xsl:value-of select="format-number((./ns1:monto div -1),'#.00')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="format-number((./ns1:monto div 1),'#.00')"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
										<xsl:if test="//ns1:tipodoc = 'C' and (./ns1:clasif_mp = 'TCR' or ./ns1:clasif_mp = 'TCO')">
											<xsl:choose>
												<xsl:when test="./ns1:monto &lt; 0">
													<xsl:value-of select="format-number((./ns1:monto div 1),'#.00')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="format-number((./ns1:monto div 1),'#.00')"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
									</SUMME>
									<WAEHRUNG>
										<xsl:value-of select="//ns1:erp_moneda"/>
									</WAEHRUNG>
									<KARTENNR>
										<xsl:value-of select="./ns1:nro_operacion"/>
									</KARTENNR>
									<KARTENFNR>
										<xsl:value-of select="./ns1:fono"/>
									</KARTENFNR>
									<GUELTAB>
										<xsl:value-of select="./ns1:fechavenc"/>
									</GUELTAB>
									<GUELTBIS>
										<xsl:value-of select="./ns1:fechavenc"/>
									</GUELTBIS>
									<KONTOINH>
										<xsl:value-of select="./ns1:rut"/>
									</KONTOINH>
									<BANKLZ>
										<xsl:value-of select="concat(./ns1:codbanco,'-',./ns1:codplaza)"/>
									</BANKLZ>
									<KONTONR>
										<xsl:value-of select="./ns1:nro_cuenta"/>
									</KONTONR>
									<AUTORINR>
										<xsl:value-of select="./ns1:codautoriz"/>
									</AUTORINR>
									<TERMID>
										<xsl:value-of select="string(' ')"/>
									</TERMID>
									<REFERENZ1>
										<xsl:value-of select="./ns1:nrocuotas"/>
									</REFERENZ1>
									<REFERENZ2>
										<xsl:value-of select="//ns1:fecha"/>
									</REFERENZ2>
									<REFERENZ3>
										<xsl:value-of select="string(' ')"/>
									</REFERENZ3>
									<ZUONR>
										<xsl:value-of select="./ns1:codcomercio"/>
									</ZUONR>
								</E1WPB06>
							</xsl:if>
						</xsl:if>


						<!-- ORIGINAL //ns1:pais_id  = '51' and ./ns1:clasif_mp != 'NCR' and //ns1:tipodoc != 'C' -->
						<xsl:if test="//ns1:pais_id  = '51' and count(//ns1:Detalle_mpago_ref/ns1:item_mpago) = 0 and //ns1:tipodoc != 'C'">
							<E1WPB06 SEGMENT="1">
								<VORZEICHEN>
									<xsl:choose>
										<xsl:when test="./ns1:monto &lt; 0">
											<xsl:choose>
												<xsl:when test="//ns1:tipodoc = 'C'">-</xsl:when>
												<xsl:when test="//ns1:tipodoc = 'C' and TipodeSeleccion = '2'">-</xsl:when>
												<xsl:otherwise>-</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="//ns1:tipodoc = 'C'">-</xsl:when>
												<xsl:when test="//ns1:tipodoc = 'C' and TipodeSeleccion = '2'">-</xsl:when>
												<xsl:otherwise>+</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</VORZEICHEN>
								<ZAHLART>
									<xsl:value-of select="./ns1:refcontab1"/>
								</ZAHLART>
								<SUMME>
									<xsl:if test="not(//ns1:tipodoc = 'C' and (./ns1:clasif_mp = 'TCR' or ./ns1:clasif_mp = 'TCO'))">
										<xsl:choose>
											<xsl:when test="./ns1:monto &lt; 0">
												<xsl:value-of select="format-number((./ns1:monto div -1),'#.00')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="format-number((./ns1:monto div 1),'#.00')"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
									<xsl:if test="//ns1:tipodoc = 'C' and (./ns1:clasif_mp = 'TCR' or ./ns1:clasif_mp = 'TCO')">
										<xsl:choose>
											<xsl:when test="./ns1:monto &lt; 0">
												<xsl:value-of select="format-number((./ns1:monto div 1),'#.00')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="format-number((./ns1:monto div 1),'#.00')"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</SUMME>
								<WAEHRUNG>
									<xsl:value-of select="//ns1:erp_moneda"/>
								</WAEHRUNG>
								<KARTENNR>
									<xsl:value-of select="./ns1:nro_operacion"/>
								</KARTENNR>
								<KARTENFNR>
									<xsl:value-of select="./ns1:fono"/>
								</KARTENFNR>
								<GUELTAB>
									<xsl:value-of select="./ns1:fechavenc"/>
								</GUELTAB>
								<GUELTBIS>
									<xsl:value-of select="./ns1:fechavenc"/>
								</GUELTBIS>
								<KONTOINH>
									<xsl:value-of select="./ns1:rut"/>
								</KONTOINH>
								<BANKLZ>
									<xsl:value-of select="concat(./ns1:codbanco,'-',./ns1:codplaza)"/>
								</BANKLZ>
								<KONTONR>
									<xsl:value-of select="./ns1:nro_cuenta"/>
								</KONTONR>
								<AUTORINR>
									<xsl:value-of select="./ns1:codautoriz"/>
								</AUTORINR>
								<TERMID>
									<xsl:value-of select="string(' ')"/>
								</TERMID>
								<REFERENZ1>
									<xsl:value-of select="./ns1:nrocuotas"/>
								</REFERENZ1>
								<REFERENZ2>
									<xsl:value-of select="//ns1:fecha"/>
								</REFERENZ2>
								<REFERENZ3>
									<xsl:value-of select="string(' ')"/>
								</REFERENZ3>
								<ZUONR>
									<xsl:value-of select="./ns1:codcomercio"/>
								</ZUONR>
							</E1WPB06>
						</xsl:if>
						<xsl:if test="./ns1:refcontab2 != '' and not(./ns1:clasif_mp = 'NCR' and //ns1:pais_id  = '51')">
							<E1WPB06 SEGMENT="1">
								<VORZEICHEN>
									<xsl:choose>
										<xsl:when test="./ns1:monto &lt; 0">
											<xsl:choose>
												<xsl:when test="//ns1:tipodoc = 'C'">-</xsl:when>
												<xsl:when test="//ns1:tipodoc = 'C' and TipodeSeleccion = '2'">-</xsl:when>
												<xsl:otherwise>-</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="//ns1:tipodoc = 'C'">-</xsl:when>
												<xsl:when test="//ns1:tipodoc = 'C' and TipodeSeleccion = '2'">-</xsl:when>
												<xsl:otherwise>+</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</VORZEICHEN>
								<ZAHLART>
									<xsl:value-of select="./ns1:refcontab2"/>
								</ZAHLART>
								<SUMME>
									<xsl:if test="//ns1:pais_id  = '56'">
										<xsl:choose>
											<xsl:when test="./ns1:monto &lt; 0">
												<xsl:value-of select="format-number((./ns1:monto div -1),'#')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="format-number((./ns1:monto div 1),'#')"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
									<xsl:if test="//ns1:pais_id  = '51'">
										<xsl:if test="//ns1:tipodoc != 'C'">
											<xsl:choose>
												<xsl:when test="./ns1:monto &lt; 0">
													<xsl:value-of select="format-number((./ns1:monto div -1),'#.00')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="format-number((./ns1:monto div 1),'#.00')"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
										<xsl:if test="//ns1:tipodoc = 'C'">
											<xsl:if test="./ns1:clasif_mp = 'TCR' or ./ns1:clasif_mp = 'TCO'">
												<xsl:choose>
													<xsl:when test="./ns1:monto &lt; 0">
														<xsl:value-of select="format-number((./ns1:monto div 1),'#.00')"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="format-number((./ns1:monto div 1),'#.00')"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
											<xsl:if test="not(./ns1:clasif_mp = 'TCR' or ./ns1:clasif_mp = 'TCO')">
												<xsl:choose>
													<xsl:when test="./ns1:monto &lt; 0">
														<xsl:value-of select="format-number((./ns1:monto div -1),'#.00')"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="format-number((./ns1:monto div 1),'#.00')"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
										</xsl:if>
									</xsl:if>
								</SUMME>
								<WAEHRUNG>
									<xsl:value-of select="//ns1:erp_moneda"/>
								</WAEHRUNG>
								<KARTENNR>
									<xsl:value-of select="./ns1:nro_operacion"/>
								</KARTENNR>
								<KARTENFNR>
									<xsl:value-of select="./ns1:fono"/>
								</KARTENFNR>
								<GUELTAB>
									<xsl:value-of select="./ns1:fechavenc"/>
								</GUELTAB>
								<GUELTBIS>
									<xsl:value-of select="./ns1:fechavenc"/>
								</GUELTBIS>
								<KONTOINH>
									<xsl:value-of select="./ns1:rut"/>
								</KONTOINH>
								<BANKLZ>
									<xsl:value-of select="concat(./ns1:codbanco,'-',./ns1:codplaza)"/>
								</BANKLZ>
								<KONTONR>
									<xsl:value-of select="./ns1:rut"/>
								</KONTONR>
								<AUTORINR>
									<xsl:value-of select="./ns1:codautoriz"/>
								</AUTORINR>
								<TERMID>
									<xsl:value-of select="string(' ')"/>
								</TERMID>
								<REFERENZ1>
									<xsl:value-of select="./ns1:nrocuotas"/>
								</REFERENZ1>
								<REFERENZ2>
									<xsl:value-of select="//ns1:fecha"/>
								</REFERENZ2>
								<REFERENZ3>
									<xsl:value-of select="string(' ')"/>
								</REFERENZ3>
								<ZUONR>
									<xsl:value-of select="./ns1:codcomercio"/>
								</ZUONR>
							</E1WPB06>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="//ns1:Detalle_mpago_ref/ns1:item_mpago">
						<!-- PERU mpag referencia -->
						<xsl:if test="//ns1:pais_id  = '51' and count(//ns1:Detalle_mpago_ref/ns1:item_mpago) != 0">
							<E1WPB06 SEGMENT="1">
								<VORZEICHEN>
									<xsl:value-of select="string('+')"/>
								</VORZEICHEN>
								<ZAHLART>
									<xsl:value-of select="./ns1:refcontab1"/>
								</ZAHLART>
								<SUMME>
									<xsl:choose>
										<xsl:when test="./ns1:monto &lt; 0">
											<xsl:value-of select="abs(format-number((./ns1:monto div 1),'#.00'))"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="abs(format-number((./ns1:monto div 1),'#.00'))"/>
										</xsl:otherwise>
									</xsl:choose>
								</SUMME>
								<WAEHRUNG>
									<xsl:value-of select="//ns1:erp_moneda"/>
								</WAEHRUNG>
								<KARTENNR>
									<xsl:value-of select="./ns1:nro_operacion"/>
								</KARTENNR>
								<KARTENFNR>
									<xsl:value-of select="./ns1:fono"/>
								</KARTENFNR>
								<GUELTAB>
									<xsl:value-of select="./ns1:fechavenc"/>
								</GUELTAB>
								<GUELTBIS>
									<xsl:value-of select="./ns1:fechavenc"/>
								</GUELTBIS>
								<KONTOINH>
									<xsl:value-of select="./ns1:rut"/>
								</KONTOINH>
								<BANKLZ>
									<xsl:value-of select="concat(./ns1:codbanco,'-',./ns1:codplaza)"/>
								</BANKLZ>
								<KONTONR>
									<xsl:value-of select="./ns1:nro_cuenta"/>
								</KONTONR>
								<AUTORINR>
									<xsl:value-of select="./ns1:codautoriz"/>
								</AUTORINR>
								<TERMID>
									<xsl:value-of select="string(' ')"/>
								</TERMID>
								<REFERENZ1>
									<xsl:value-of select="./ns1:nrocuotas"/>
								</REFERENZ1>
								<REFERENZ2>
									<xsl:value-of select="//ns1:fecha"/>
								</REFERENZ2>
								<REFERENZ3>
									<xsl:value-of select="string(' ')"/>
								</REFERENZ3>
								<ZUONR>
									<xsl:value-of select="./ns1:codcomercio"/>
								</ZUONR>
							</E1WPB06>
							<xsl:if test="./ns1:refcontab2 != ''">
								<E1WPB06 SEGMENT="1">
									<VORZEICHEN>
										<xsl:value-of select="string('+')"/>
									</VORZEICHEN>
									<ZAHLART>
										<xsl:value-of select="./ns1:refcontab2"/>
									</ZAHLART>
									<SUMME>
										<xsl:value-of select="abs(format-number((./ns1:monto div -1),'#.00'))"/>
									</SUMME>
									<WAEHRUNG>
										<xsl:value-of select="//ns1:erp_moneda"/>
									</WAEHRUNG>
									<KARTENNR>
										<xsl:value-of select="./ns1:nro_operacion"/>
									</KARTENNR>
									<KARTENFNR>
										<xsl:value-of select="./ns1:fono"/>
									</KARTENFNR>
									<GUELTAB>
										<xsl:value-of select="./ns1:fechavenc"/>
									</GUELTAB>
									<GUELTBIS>
										<xsl:value-of select="./ns1:fechavenc"/>
									</GUELTBIS>
									<KONTOINH>
										<xsl:value-of select="./ns1:rut"/>
									</KONTOINH>
									<BANKLZ>
										<xsl:value-of select="concat(./ns1:codbanco,'-',./ns1:codplaza)"/>
									</BANKLZ>
									<KONTONR>
										<xsl:value-of select="./ns1:rut"/>
									</KONTONR>
									<AUTORINR>
										<xsl:value-of select="./ns1:codautoriz"/>
									</AUTORINR>
									<TERMID>
										<xsl:value-of select="string(' ')"/>
									</TERMID>
									<REFERENZ1>
										<xsl:value-of select="./ns1:nrocuotas"/>
									</REFERENZ1>
									<REFERENZ2>
										<xsl:value-of select="//ns1:fecha"/>
									</REFERENZ2>
									<REFERENZ3>
										<xsl:value-of select="string(' ')"/>
									</REFERENZ3>
									<ZUONR>
										<xsl:value-of select="./ns1:codcomercio"/>
									</ZUONR>
								</E1WPB06>
							</xsl:if>
						</xsl:if>
					</xsl:for-each>
				</E1WPB01>
			</IDOC>
		</WPUBON01>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="error\V_51_05100102990814_190249_dT_20151228_1451336327454.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="yes" profilemode="0"
		          profiledepth="" profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no"
		          validator="internal" customvalidator="">
			<advancedProp name="sInitialMode" value=""/>
			<advancedProp name="bXsltOneIsOkay" value="true"/>
			<advancedProp name="bSchemaAware" value="true"/>
			<advancedProp name="bXml11" value="false"/>
			<advancedProp name="iValidation" value="0"/>
			<advancedProp name="bExtensions" value="true"/>
			<advancedProp name="iWhitespace" value="0"/>
			<advancedProp name="sInitialTemplate" value=""/>
			<advancedProp name="bTinyTree" value="true"/>
			<advancedProp name="bWarnings" value="true"/>
			<advancedProp name="bUseDTD" value="false"/>
			<advancedProp name="iErrorHandling" value="fatal"/>
		</scenario>
	</scenarios>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
		<MapperBlockPosition></MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->