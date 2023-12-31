USE [DataWarehouseCovid]
GO
/****** Object:  Schema [general]    Script Date: 6/11/2023 4:48:58 PM ******/
CREATE SCHEMA [general]
GO
/****** Object:  Schema [mexico]    Script Date: 6/11/2023 4:48:58 PM ******/
CREATE SCHEMA [mexico]
GO
/****** Object:  Schema [world]    Script Date: 6/11/2023 4:48:58 PM ******/
CREATE SCHEMA [world]
GO
/****** Object:  UserDefinedFunction [world].[fn_CaculaPorcentajeEfectividadUsoVacunas]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Mario Estrada
-- Create date: 11/06/2023
-- Description:	Calcula porcentaje de efectividad de uso de vacunas en el mundo
-- =============================================
CREATE FUNCTION [world].[fn_CaculaPorcentajeEfectividadUsoVacunas]
(
  @TotalVacunas AS BIGINT,
  @TotalVacunados AS BIGINT
)
RETURNS DECIMAL(20,2)

AS

BEGIN

	DECLARE @Porcentaje DECIMAL(20,2) = 0

    SET @Porcentaje = CASE WHEN @TotalVacunas = 0 THEN 0 ELSE (CAST(@TotalVacunados AS decimal(20,2))/CAST(@TotalVacunas AS decimal(20,2)))*100 END

	RETURN @Porcentaje
		
END
GO
/****** Object:  Table [mexico].[FACT_CovidTotals]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [mexico].[FACT_CovidTotals](
	[idCovidTotals] [int] IDENTITY(1,1) NOT NULL,
	[idState] [int] NOT NULL,
	[idSector] [int] NOT NULL,
	[idGender] [int] NOT NULL,
	[idPatienType] [int] NOT NULL,
	[idResult] [int] NOT NULL,
	[dateSymptoms] [date] NOT NULL,
	[intubated] [int] NOT NULL,
	[pneumonia] [int] NOT NULL,
	[diabetes] [int] NOT NULL,
	[asma] [int] NOT NULL,
	[inmusupr] [int] NOT NULL,
	[Hypertension] [int] NOT NULL,
	[obecity] [int] NOT NULL,
	[cardio] [int] NOT NULL,
	[tabaquismo] [int] NOT NULL,
 CONSTRAINT [PK_FACT_CovidTotals] PRIMARY KEY CLUSTERED 
(
	[idCovidTotals] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [mexico].[DIM_Gender]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [mexico].[DIM_Gender](
	[idGender] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](20) NOT NULL,
 CONSTRAINT [PK_DIM_Gender] PRIMARY KEY CLUSTERED 
(
	[idGender] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [mexico].[DIM_PatienType]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [mexico].[DIM_PatienType](
	[idPatienType] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](100) NOT NULL,
 CONSTRAINT [PK_DIM_PatienType] PRIMARY KEY CLUSTERED 
(
	[idPatienType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [mexico].[DIM_Result]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [mexico].[DIM_Result](
	[idResult] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](200) NOT NULL,
 CONSTRAINT [PK_DIM_Result] PRIMARY KEY CLUSTERED 
(
	[idResult] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [mexico].[DIM_Sector]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [mexico].[DIM_Sector](
	[idSector] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Sector] PRIMARY KEY CLUSTERED 
(
	[idSector] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [mexico].[DIM_State]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [mexico].[DIM_State](
	[idState] [int] IDENTITY(1,1) NOT NULL,
	[code] [varchar](20) NOT NULL,
	[name] [varchar](150) NOT NULL,
 CONSTRAINT [PK_DIM_State] PRIMARY KEY CLUSTERED 
(
	[idState] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [mexico].[VW_Covid_Totals_Mexico_Data]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [mexico].[VW_Covid_Totals_Mexico_Data]
 AS
SELECT 
 CONVERT(VARCHAR, ctm.dateSymptoms, 6) AS 'Fecha'
 ,st.[name] AS 'EntidadFederativa'
 ,se.[name] AS 'Sector'
 ,ge.[name] AS 'Genero'
 ,pt.[description] AS 'TipoPaciente'
 ,ctm.intubated AS 'Entubados'
 ,ctm.pneumonia AS 'Neumonia'
 ,ctm.diabetes AS 'Diabetes'
 ,ctm.asma AS 'Asma'
 ,ctm.inmusupr 'Inmuno'
 ,ctm.Hypertension 'Impertencion'
 ,ctm.obecity 'Obesidad'
 ,ctm.cardio 'Cardio'
 ,ctm.tabaquismo 'Tabaquismo'
 ,r.[description] AS 'Resultado'
 FROM 
 mexico.FACT_CovidTotals ctm
 INNER JOIN
 mexico.DIM_State st ON st.idState = ctm.idState
 INNER JOIN
 mexico.DIM_Sector se ON se.idSector = ctm.idSector
 INNER JOIN
 mexico.DIM_Gender ge ON ge.idGender = ctm.idGender
 INNER JOIN
 mexico.DIM_PatienType pt ON pt.idPatienType = ctm.idPatienType
 INNER JOIN
 mexico.DIM_Result r ON r.idResult = ctm.idResult
GO
/****** Object:  Table [world].[DIM_Country]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [world].[DIM_Country](
	[idCountry] [int] IDENTITY(1,1) NOT NULL,
	[idRegion] [int] NOT NULL,
	[isoCode] [varchar](20) NULL,
	[name] [varchar](100) NOT NULL,
	[latitude] [decimal](10, 8) NULL,
	[longitude] [decimal](10, 8) NULL,
 CONSTRAINT [PK_DIM_Country] PRIMARY KEY CLUSTERED 
(
	[idCountry] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [world].[FACT_CovidCompleteTotals]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [world].[FACT_CovidCompleteTotals](
	[idCovidCompleteTotals] [int] IDENTITY(1,1) NOT NULL,
	[idCountry] [int] NOT NULL,
	[date] [date] NOT NULL,
	[Confirmed] [int] NOT NULL,
	[Deaths] [int] NOT NULL,
	[Recovered] [int] NOT NULL,
	[Active] [int] NOT NULL,
 CONSTRAINT [PK_FACT_CovidCompleteTotals] PRIMARY KEY CLUSTERED 
(
	[idCovidCompleteTotals] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [world].[DIM_Region]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [world].[DIM_Region](
	[idRegion] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_DIM_Region] PRIMARY KEY CLUSTERED 
(
	[idRegion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [world].[VW_Covid_Totals_Mundo_Data]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [world].[VW_Covid_Totals_Mundo_Data]
 AS
SELECT
  CONVERT(VARCHAR, cct.date, 11) AS 'Fecha'
 ,cpr.Region
 ,cpr.Pais
 ,cct.Confirmed AS 'Confirmados'
 ,cct.Deaths AS 'Muertes'
 ,cct.Recovered AS 'Recuperados'
 ,cct.Active AS 'Activos'
 FROM
 world.FACT_CovidCompleteTotals AS cct
 CROSS APPLY
 (
	SELECT 
	c.[name] AS 'Pais'
	,re.[name] AS 'Region'
	FROM
	world.DIM_Country AS c 
	INNER JOIN
	world.DIM_Region AS re ON re.idRegion = c.idRegion
	WHERE
	c.idCountry = cct.idCountry
 ) cpr
GO
/****** Object:  Table [world].[FACT_SymptomsTotals]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [world].[FACT_SymptomsTotals](
	[idSymptomsTotals] [int] IDENTITY(1,1) NOT NULL,
	[idCountry] [int] NOT NULL,
	[idGender] [int] NOT NULL,
	[Fever] [int] NOT NULL,
	[Tiredness] [int] NOT NULL,
	[DryCought] [int] NOT NULL,
	[DificultudBreath] [int] NOT NULL,
	[SoreThroat] [int] NOT NULL,
	[Pains] [int] NOT NULL,
	[NasalCongestion] [int] NOT NULL,
	[RunnyNose] [int] NOT NULL,
	[Diarrhea] [int] NOT NULL,
	[noneSymptoms] [int] NOT NULL,
 CONSTRAINT [PK_FACT_SymptomsTotals] PRIMARY KEY CLUSTERED 
(
	[idSymptomsTotals] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [world].[VW_Covid_Symptoms_Totals_Mundo_Data]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [world].[VW_Covid_Symptoms_Totals_Mundo_Data]
 AS
SELECT  
  cpr.Region
 ,cpr.Pais
 ,(
	SELECT
	gd.[name]
	FROM
	mexico.DIM_Gender AS gd 
	WHERE
	gd.idGender = st.idGender
 ) AS 'Genero'
 ,st.Fever AS 'Fiebre'
 ,st.Tiredness AS 'Fatiga'
 ,st.DryCought AS 'TosSeca'
 ,st.DificultudBreath 'DificultadRespirar'
 ,st.SoreThroat 'DolorGarganta'
 ,st.Pains 'Dolores'
 ,st.NasalCongestion 'CongestionNasal'
 ,st.RunnyNose 'GoteoNasal'
 ,st.Diarrhea 'Diarrea'
 ,st.noneSymptoms 'SinSintomas'
 FROM
 world.FACT_SymptomsTotals st
 CROSS APPLY
 (
	SELECT 
	c.[name] AS 'Pais'
	,re.[name] AS 'Region'
	FROM
	world.DIM_Country AS c 
	INNER JOIN
	world.DIM_Region AS re ON re.idRegion = c.idRegion
	WHERE
	c.idCountry = st.idCountry
 ) cpr
GO
/****** Object:  Table [world].[DIM_Source]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [world].[DIM_Source](
	[idSource] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](150) NOT NULL,
	[webSite] [varchar](150) NULL,
 CONSTRAINT [PK_DIM_Source] PRIMARY KEY CLUSTERED 
(
	[idSource] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [world].[DIM_Vaccine]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [world].[DIM_Vaccine](
	[idVaccine] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](150) NOT NULL,
 CONSTRAINT [PK_DIM_Vaccine] PRIMARY KEY CLUSTERED 
(
	[idVaccine] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [world].[FACT_VaccinationsTotals]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [world].[FACT_VaccinationsTotals](
	[idVaccinationsTotals] [int] IDENTITY(1,1) NOT NULL,
	[idCountry] [int] NOT NULL,
	[idVaccine] [int] NOT NULL,
	[idSource] [int] NOT NULL,
	[date] [date] NOT NULL,
	[totalVaccination] [bigint] NOT NULL,
	[totalPeopleVaccinated] [bigint] NOT NULL,
 CONSTRAINT [PK_FACT_VaccinationsTotals] PRIMARY KEY CLUSTERED 
(
	[idVaccinationsTotals] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [world].[VW_Covid_Vaccines_Totals_Mundo_Data]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [world].[VW_Covid_Vaccines_Totals_Mundo_Data]
 AS
SELECT
CONVERT(VARCHAR, vt.[date], 6) AS 'Fecha'
,cpr.Region
,cpr.Pais
,va.[name] AS 'Vacunas'
,so.[name] AS 'Fuente'
,vt.totalVaccination AS 'TotalVacunas'
,vt.totalPeopleVaccinated AS 'TotalVacunados'
FROM
world.FACT_VaccinationsTotals vt WITH(NOLOCK)
INNER JOIN
world.DIM_Vaccine va WITH(NOLOCK) ON va.idVaccine = vt.idVaccine
INNER JOIN
world.DIM_Source so WITH(NOLOCK) ON so.idSource = vt.idSource
CROSS APPLY
 (
	SELECT 
	c.[name] AS 'Pais'
	,re.[name] AS 'Region'
	FROM
	world.DIM_Country AS c WITH(NOLOCK)
	INNER JOIN
	world.DIM_Region AS re WITH(NOLOCK) ON re.idRegion = c.idRegion
	WHERE
	c.idCountry = vt.idCountry
 ) cpr
GO
/****** Object:  Table [general].[DIM_Date]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [general].[DIM_Date](
	[idDate] [int] IDENTITY(1,1) NOT NULL,
	[normalFormatDate] [varchar](100) NOT NULL,
	[largeDate] [varchar](100) NOT NULL,
	[monthDayDate] [varchar](2) NOT NULL,
	[monthNumberDate] [varchar](2) NOT NULL,
	[yearDate] [varchar](5) NOT NULL,
 CONSTRAINT [PK_DIM_Date] PRIMARY KEY CLUSTERED 
(
	[idDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [idx_GenderCovid]    Script Date: 6/11/2023 4:48:58 PM ******/
CREATE NONCLUSTERED INDEX [idx_GenderCovid] ON [mexico].[FACT_CovidTotals]
(
	[idGender] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_PatienTypeCovid]    Script Date: 6/11/2023 4:48:58 PM ******/
CREATE NONCLUSTERED INDEX [idx_PatienTypeCovid] ON [mexico].[FACT_CovidTotals]
(
	[idPatienType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_ResultCovid]    Script Date: 6/11/2023 4:48:58 PM ******/
CREATE NONCLUSTERED INDEX [idx_ResultCovid] ON [mexico].[FACT_CovidTotals]
(
	[idResult] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_SectorCovid]    Script Date: 6/11/2023 4:48:58 PM ******/
CREATE NONCLUSTERED INDEX [idx_SectorCovid] ON [mexico].[FACT_CovidTotals]
(
	[idSector] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_StateCovid]    Script Date: 6/11/2023 4:48:58 PM ******/
CREATE NONCLUSTERED INDEX [idx_StateCovid] ON [mexico].[FACT_CovidTotals]
(
	[idState] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_CountryCovidCompleted]    Script Date: 6/11/2023 4:48:58 PM ******/
CREATE NONCLUSTERED INDEX [idx_CountryCovidCompleted] ON [world].[FACT_CovidCompleteTotals]
(
	[idCountry] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_countrySymptoms]    Script Date: 6/11/2023 4:48:58 PM ******/
CREATE NONCLUSTERED INDEX [idx_countrySymptoms] ON [world].[FACT_SymptomsTotals]
(
	[idCountry] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_genderSymptoms]    Script Date: 6/11/2023 4:48:58 PM ******/
CREATE NONCLUSTERED INDEX [idx_genderSymptoms] ON [world].[FACT_SymptomsTotals]
(
	[idGender] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_CountryVaccionation]    Script Date: 6/11/2023 4:48:58 PM ******/
CREATE NONCLUSTERED INDEX [idx_CountryVaccionation] ON [world].[FACT_VaccinationsTotals]
(
	[idCountry] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_SourceVaccionation]    Script Date: 6/11/2023 4:48:58 PM ******/
CREATE NONCLUSTERED INDEX [idx_SourceVaccionation] ON [world].[FACT_VaccinationsTotals]
(
	[idSource] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_VaccineVaccionation]    Script Date: 6/11/2023 4:48:58 PM ******/
CREATE NONCLUSTERED INDEX [idx_VaccineVaccionation] ON [world].[FACT_VaccinationsTotals]
(
	[idVaccine] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [mexico].[FACT_CovidTotals]  WITH CHECK ADD  CONSTRAINT [FK_FACT_CovidTotals_DIM_Gender] FOREIGN KEY([idGender])
REFERENCES [mexico].[DIM_Gender] ([idGender])
GO
ALTER TABLE [mexico].[FACT_CovidTotals] CHECK CONSTRAINT [FK_FACT_CovidTotals_DIM_Gender]
GO
ALTER TABLE [mexico].[FACT_CovidTotals]  WITH CHECK ADD  CONSTRAINT [FK_FACT_CovidTotals_DIM_PatienType] FOREIGN KEY([idPatienType])
REFERENCES [mexico].[DIM_PatienType] ([idPatienType])
GO
ALTER TABLE [mexico].[FACT_CovidTotals] CHECK CONSTRAINT [FK_FACT_CovidTotals_DIM_PatienType]
GO
ALTER TABLE [mexico].[FACT_CovidTotals]  WITH CHECK ADD  CONSTRAINT [FK_FACT_CovidTotals_DIM_Result] FOREIGN KEY([idResult])
REFERENCES [mexico].[DIM_Result] ([idResult])
GO
ALTER TABLE [mexico].[FACT_CovidTotals] CHECK CONSTRAINT [FK_FACT_CovidTotals_DIM_Result]
GO
ALTER TABLE [mexico].[FACT_CovidTotals]  WITH CHECK ADD  CONSTRAINT [FK_FACT_CovidTotals_DIM_Sector] FOREIGN KEY([idSector])
REFERENCES [mexico].[DIM_Sector] ([idSector])
GO
ALTER TABLE [mexico].[FACT_CovidTotals] CHECK CONSTRAINT [FK_FACT_CovidTotals_DIM_Sector]
GO
ALTER TABLE [mexico].[FACT_CovidTotals]  WITH CHECK ADD  CONSTRAINT [FK_FACT_CovidTotals_DIM_State] FOREIGN KEY([idState])
REFERENCES [mexico].[DIM_State] ([idState])
GO
ALTER TABLE [mexico].[FACT_CovidTotals] CHECK CONSTRAINT [FK_FACT_CovidTotals_DIM_State]
GO
ALTER TABLE [world].[DIM_Country]  WITH CHECK ADD  CONSTRAINT [FK_DIM_Country_DIM_Region] FOREIGN KEY([idRegion])
REFERENCES [world].[DIM_Region] ([idRegion])
GO
ALTER TABLE [world].[DIM_Country] CHECK CONSTRAINT [FK_DIM_Country_DIM_Region]
GO
ALTER TABLE [world].[FACT_CovidCompleteTotals]  WITH CHECK ADD  CONSTRAINT [FK_FACT_CovidCompleteTotals_DIM_Country] FOREIGN KEY([idCountry])
REFERENCES [world].[DIM_Country] ([idCountry])
GO
ALTER TABLE [world].[FACT_CovidCompleteTotals] CHECK CONSTRAINT [FK_FACT_CovidCompleteTotals_DIM_Country]
GO
ALTER TABLE [world].[FACT_SymptomsTotals]  WITH CHECK ADD  CONSTRAINT [FK_FACT_SymptomsTotals_DIM_Country] FOREIGN KEY([idCountry])
REFERENCES [world].[DIM_Country] ([idCountry])
GO
ALTER TABLE [world].[FACT_SymptomsTotals] CHECK CONSTRAINT [FK_FACT_SymptomsTotals_DIM_Country]
GO
ALTER TABLE [world].[FACT_SymptomsTotals]  WITH CHECK ADD  CONSTRAINT [FK_FACT_SymptomsTotals_DIM_Gender] FOREIGN KEY([idGender])
REFERENCES [mexico].[DIM_Gender] ([idGender])
GO
ALTER TABLE [world].[FACT_SymptomsTotals] CHECK CONSTRAINT [FK_FACT_SymptomsTotals_DIM_Gender]
GO
ALTER TABLE [world].[FACT_VaccinationsTotals]  WITH CHECK ADD  CONSTRAINT [FK_FACT_VaccinationsTotals_DIM_Country] FOREIGN KEY([idCountry])
REFERENCES [world].[DIM_Country] ([idCountry])
GO
ALTER TABLE [world].[FACT_VaccinationsTotals] CHECK CONSTRAINT [FK_FACT_VaccinationsTotals_DIM_Country]
GO
ALTER TABLE [world].[FACT_VaccinationsTotals]  WITH CHECK ADD  CONSTRAINT [FK_FACT_VaccinationsTotals_DIM_Source] FOREIGN KEY([idSource])
REFERENCES [world].[DIM_Source] ([idSource])
GO
ALTER TABLE [world].[FACT_VaccinationsTotals] CHECK CONSTRAINT [FK_FACT_VaccinationsTotals_DIM_Source]
GO
ALTER TABLE [world].[FACT_VaccinationsTotals]  WITH CHECK ADD  CONSTRAINT [FK_FACT_VaccinationsTotals_DIM_Vaccine] FOREIGN KEY([idVaccine])
REFERENCES [world].[DIM_Vaccine] ([idVaccine])
GO
ALTER TABLE [world].[FACT_VaccinationsTotals] CHECK CONSTRAINT [FK_FACT_VaccinationsTotals_DIM_Vaccine]
GO
/****** Object:  StoredProcedure [mexico].[stp_DatosInternosContraMundialesMexicoPorEntidadConsulta]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--	======================================================================================================================================================
--	Autor:		  Mario Estrada Ferreira
--	Creacion:	  11/06/2023
--	Descripción:  Consulta de informacion general de Mexico
--	======================================================================================================================================================
CREATE PROCEDURE [mexico].[stp_DatosInternosContraMundialesMexicoPorEntidadConsulta]
	@EntidadFederativa VARCHAR(150) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
	re.[name] AS 'RegionMundo'
	,vmt.Fecha AS 'Fecha'
	,vmt.EntidadFederativa
	,vmt.Sector
	,vmt.Entubados
	,vmt.Neumonia
	,vmt.Asma
	,vmt.Inmuno
	,vmt.Impertencion
	,vmt.Obesidad
	,vmt.Cardio
	,vmt.Tabaquismo
	,vt.totalVaccination
	,vt.totalPeopleVaccinated
	,(
		SELECT world.fn_CaculaPorcentajeEfectividadUsoVacunas(totalVaccination,totalPeopleVaccinated)
	) AS 'PorcentajeEfectividadUsoVacuna'
	FROM mexico.VW_Covid_Totals_Mexico_Data AS vmt
	INNER JOIN
	world.DIM_Country AS ct WITH(NOLOCK) ON ct.[name] = 'MEXICO'
	INNER JOIN
	world.FACT_VaccinationsTotals as vt  WITH(NOLOCK) ON vt.idCountry = ct.idCountry
	INNER JOIN
	world.DIM_Region AS re  WITH(NOLOCK) ON re.idRegion = ct.idRegion
	WHERE vmt.EntidadFederativa LIKE CASE WHEN @EntidadFederativa IS NULL THEN  vmt.EntidadFederativa ELSE @EntidadFederativa END

END
GO
/****** Object:  StoredProcedure [mexico].[stp_GeneroInserta]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--	======================================================================================================================================================
--	Autor:			Mario Estrada Ferreira
--	Creacion:		11/06/2023
--	Descripción:	Inserta un nuevo tipo de genero o actualiza
--	======================================================================================================================================================
CREATE PROCEDURE [mexico].[stp_GeneroInserta]
	@idGender INT = NULL
	, @name VARCHAR(150)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
	
	IF @idGender IS NOT NULL
	BEGIN
		UPDATE G
		SET [name] = @name
		FROM
		mexico.DIM_Gender G
		WHERE
		G.idGender = @idGender
	END
	ELSE
	BEGIN
		IF(SELECT COUNT(*) FROM mexico.DIM_Gender WHERE [name] = @name) = 0
		BEGIN
			INSERT INTO mexico.DIM_Gender ([name]) VALUES (@name)
		END
	END

	END TRY
	BEGIN CATCH

		DECLARE @Err NVARCHAR(1000)
		SET @Err = ' ( ' + CAST(ERROR_NUMBER() AS varchar(6)) + ' )' + CONVERT(varchar(500), ERROR_MESSAGE()) 

		RETURN @Err

	END CATCH
END
GO
/****** Object:  StoredProcedure [world].[stp_SymptomsTotalElimina]    Script Date: 6/11/2023 4:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--	======================================================================================================================================================
--	Autor:			Mario Estrada Ferreira
--	Creacion:		11/06/2023
--	Descripción:	Elimina un registro de la tabla FACT_SymptomsTotals
--	======================================================================================================================================================
CREATE PROCEDURE [world].[stp_SymptomsTotalElimina]
	@idSymptomsTotal INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY

	DELETE FROM world.FACT_SymptomsTotals WHERE idSymptomsTotals = @idSymptomsTotal

	END TRY
	BEGIN CATCH

		DECLARE @Err NVARCHAR(1000)
		SET @Err = ' ( ' + CAST(ERROR_NUMBER() AS varchar(6)) + ' )' + CONVERT(varchar(500), ERROR_MESSAGE()) 

		RETURN @Err

	END CATCH
END
GO
