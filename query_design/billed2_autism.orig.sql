-- Optimizations applied: Switch Groupers to Temp Tables, Remove Dimension Tables, Filter to Where Exists, Query Consolidation, Use Optimized DMCs
SET TRANSACTION ISOLATION LEVEL SNAPSHOT

DROP TABLE IF EXISTS #GrouperTableparam0009

SELECT
GrouperSubquery3.* INTO #GrouperTableparam0009
FROM
 ( 
    SELECT
     DISTINCT table0.DiagnosisKey AS basekey, table0.NameAndCode AS grouper_id_1, table0.NameAndCode AS grouper_name_1
    FROM
     dbo.DiagnosisTerminologyDim AS table0
    WHERE
      (  ( table0.[Type]=N'ICD-10-CM' ) 
        AND  ( table0.NameAndCode IS NOT NULL )  )  )  AS GrouperSubquery3
LEFT OUTER JOIN Epic.CciForBatchMode ON 0 = 1
WHERE
 (   (  GrouperSubquery3.grouper_id_1 = 'Autistic disorder( ICD-10-CM: F84.0 )'  )  OR  (  GrouperSubquery3.grouper_id_1 = 'Other childhood disintegrative disorder( ICD-10-CM: F84.3 )'  )  OR  (  GrouperSubquery3.grouper_id_1 = 'Asperger''s syndrome( ICD-10-CM: F84.5 )'  )  OR  (  GrouperSubquery3.grouper_id_1 = 'Other pervasive developmental disorders( ICD-10-CM: F84.8 )'  )  OR  (  GrouperSubquery3.grouper_id_1 = 'Pervasive developmental disorder, unspecified( ICD-10-CM: F84.9 )'  )   ) 


DROP TABLE IF EXISTS #resultSet;

SELECT
* INTO #resultSet
FROM
 ( 

    SELECT
     COUNT_BIG ( DurableKey )  AS count0 , COUNT_BIG ( DurableKey )  AS count1

    FROM
      ( 

        SELECT
         subq0.DurableKey, NULL AS count0, NULL AS count1
        FROM
          ( 
            SELECT
             DISTINCT RootTable0.DurableKey AS DurableKey, NULL AS count0 , NULL AS count1
            FROM
             SlicerDicer.PatientDim_638808424802284327_uZtueeujnEejwrN88koRtQ AS RootTable0
            INNER JOIN SlicerDicer.EncounterFact_638808804566723264_7dumBqKLRki5zKCCYBrwAg AS FilterTable1 ON RootTable0.DurableKey = FilterTable1.PatientDurableKey
            INNER JOIN dbo.DateDim AS table2 ON FilterTable1.DateKey = table2.DateKey
            INNER JOIN dbo.DateDim AS table3 ON  ( FilterTable1.EndDateKey = table3.DateKey ) 
            AND  (  (  (  (  ( FilterTable1.DateKey < '20200101' ) 
                            AND NOT  ( FilterTable1.DateKey < 0 )  ) 
                        AND  (  ( FilterTable1.EndDateKey >= '20190101' )  OR  ( FilterTable1.EndDateKey < 0 )  )  ) 
                    AND  (  ( table2.DateValue < DATEADD ( YEAR,9,RootTable0.BirthDate )  ) 
                        AND  (  ( table3.DateValue IS NULL )  OR  ( table3.DateValue >= DATEADD ( YEAR,8,RootTable0.BirthDate )  )  ) 
                        AND  ( RootTable0.DeathDate IS NULL OR RootTable0.DeathDate >= DATEADD ( YEAR,8,RootTable0.BirthDate )  ) 
                        AND  ( RootTable0.BirthDate <= DATEADD ( YEAR,-8,'2025-04-17' )  )  ) 
                    AND  (  ( '20190101' < DATEADD ( YEAR,9,RootTable0.BirthDate )  ) 
                        AND  ( '20200101' > DATEADD ( YEAR,8,RootTable0.BirthDate )  ) 
                        AND  ( RootTable0.BirthDate <= DATEADD ( YEAR,-8,'2025-04-17' )  )  )  )  ) 
            INNER JOIN SlicerDicer.DiagnosisEventFact_638808804566723264_qJv3JCmhtUqGQnzpyhwgiw AS ConsolidatedTable4 ON  ( RootTable0.DurableKey = ConsolidatedTable4.PatientDurableKey ) 
            AND  (  ( ConsolidatedTable4.[Type] IN  ( N'Billing Admission Diagnosis',N'Billing Final Diagnosis',N'Billing Procedure Linked Diagnosis' )  )  ) 
            INNER JOIN dbo.DateDim AS ConsolidatedTable5 ON  ( ConsolidatedTable4.StartDateKey = ConsolidatedTable5.DateKey ) 
            AND  (  (  (  ( ConsolidatedTable5.DateValue < DATEADD ( YEAR,9,RootTable0.BirthDate )  ) 
                        AND  ( RootTable0.BirthDate <= '2025-04-17' )  ) 
                    AND  (  ( '20190101' < DATEADD ( YEAR,9,RootTable0.BirthDate )  ) 
                        AND  ( RootTable0.BirthDate <= '2025-04-17' )  )  )  ) 
            INNER JOIN  ( 
                SELECT
                 FilterTable1.PatientDurableKey AS DurableKey, FilterTable1.StartDateKey AS startDate
                FROM
                 SlicerDicer.DiagnosisEventFact_638808804566723264_qJv3JCmhtUqGQnzpyhwgiw AS FilterTable1
                INNER JOIN #GrouperTableparam0009 AS GrouperSubquery3 ON FilterTable1.DiagnosisKey = GrouperSubquery3.basekey
                WHERE
                  (   ( FilterTable1.[Type] IN  ( N'Billing Admission Diagnosis',N'Billing Final Diagnosis',N'Billing Procedure Linked Diagnosis' )  )   )  )  ConsolidatedTable6 ON  ( ConsolidatedTable4.PatientDurableKey = ConsolidatedTable6.DurableKey ) 
            AND  (  ( ConsolidatedTable6.DurableKey > 0 )  ) 
            AND  (  (  (  (  CASE
                            WHEN  ( CASE
                                WHEN ConsolidatedTable6.startDate > 0 THEN TRY_CONVERT ( DATE, TRY_CONVERT ( VARCHAR ( 8 ) , ConsolidatedTable6.startDate )  ) 
                                ELSE CONVERT ( DATE, '90001231' )  END )  < '99961231' THEN DATEADD ( YEAR, 3,  ( CASE
                                    WHEN ConsolidatedTable6.startDate > 0 THEN TRY_CONVERT ( DATE, TRY_CONVERT ( VARCHAR ( 8 ) , ConsolidatedTable6.startDate )  ) 
                                    ELSE CONVERT ( DATE, '90001231' )  END )  ) 
                            ELSE '17530101' END  )  >=  ( CASE
                            WHEN ConsolidatedTable4.StartDateKey > 0 THEN TRY_CONVERT ( DATE, TRY_CONVERT ( VARCHAR ( 8 ) , ConsolidatedTable4.StartDateKey )  ) 
                            ELSE CONVERT ( DATE, '90001231' )  END )  ) 
                    AND  (  ( CASE
                            WHEN ConsolidatedTable6.startDate > 0 THEN TRY_CONVERT ( DATE, TRY_CONVERT ( VARCHAR ( 8 ) , ConsolidatedTable6.startDate )  ) 
                            ELSE CONVERT ( DATE, '90001231' )  END )  <  ( CASE
                            WHEN ConsolidatedTable4.StartDateKey > 0 THEN TRY_CONVERT ( DATE, TRY_CONVERT ( VARCHAR ( 8 ) , ConsolidatedTable4.StartDateKey )  ) 
                            ELSE CONVERT ( DATE, '90001231' )  END )  )  )  ) 
            WHERE
              (  (  ( RootTable0.IsValid = 1 ) 
                    AND  ( RootTable0.UseInCosmosAnalytics_X = 1 )  ) 
                AND  ( RootTable0.IsCurrent = 1 ) 
                AND  (  ( FilterTable1.Count = '1' )  ) 
                AND EXISTS  ( 
                    SELECT
                     1
                    FROM
                     #GrouperTableparam0009 AS GrouperSubquery3
                    WHERE
                      (  (  (  ConsolidatedTable4.DiagnosisKey = GrouperSubquery3.basekey  )  )  )  )   )   )  subq0
 )  subq

    WHERE
    
subq.DurableKey > 0

 )  AS tempResultSet
OPTION  ( RECOMPILE, USE HINT  ( 'FORCE_DEFAULT_CARDINALITY_ESTIMATION', 'DISABLE_OPTIMIZER_ROWGOAL', 'ENABLE_PARALLEL_PLAN_PREFERENCE' ) , NO_PERFORMANCE_SPOOL ) 

SELECT
DISTINCT mainResultSet.count0 AS count0 , mainResultSet.count1 AS count1
FROM
#resultSet mainResultSet

DROP TABLE #resultSet

DROP TABLE IF EXISTS #GrouperTableparam0009





-- Optimizations applied: Remove Data Model Root, Switch Groupers to Temp Tables, Remove Dimension Tables, Filter to Where Exists, Query Consolidation, Use Optimized DMCs
SET TRANSACTION ISOLATION LEVEL SNAPSHOT

DECLARE @param0000 AS NUMERIC ( 28,10 )  = 25;

DECLARE @param0001 AS NUMERIC ( 28,10 )  = 50;

DECLARE @param0002 AS NUMERIC ( 28,10 )  = 75;

DROP TABLE IF EXISTS #GrouperTableparam0012

SELECT
GrouperSubquery3.* INTO #GrouperTableparam0012
FROM
 ( 
    SELECT
     DISTINCT table0.DiagnosisKey AS basekey, table0.NameAndCode AS grouper_id_1, table0.NameAndCode AS grouper_name_1
    FROM
     dbo.DiagnosisTerminologyDim AS table0
    WHERE
      (  ( table0.[Type]=N'ICD-10-CM' ) 
        AND  ( table0.NameAndCode IS NOT NULL )  )  )  AS GrouperSubquery3
LEFT OUTER JOIN Epic.CciForBatchMode ON 0 = 1
WHERE
 (   (  GrouperSubquery3.grouper_id_1 = 'Autistic disorder( ICD-10-CM: F84.0 )'  )  OR  (  GrouperSubquery3.grouper_id_1 = 'Other childhood disintegrative disorder( ICD-10-CM: F84.3 )'  )  OR  (  GrouperSubquery3.grouper_id_1 = 'Asperger''s syndrome( ICD-10-CM: F84.5 )'  )  OR  (  GrouperSubquery3.grouper_id_1 = 'Other pervasive developmental disorders( ICD-10-CM: F84.8 )'  )  OR  (  GrouperSubquery3.grouper_id_1 = 'Pervasive developmental disorder, unspecified( ICD-10-CM: F84.9 )'  )   ) 


DROP TABLE IF EXISTS #resultSet;

SELECT
* INTO #resultSet
FROM
 ( 

    SELECT
     slice0 , COUNT_BIG ( DurableKey )  AS count1 , COUNT_BIG ( DurableKey )  AS count2

    FROM
      ( 

        SELECT
         subq0.DurableKey, subq0.slice0 AS slice0 , NULL AS count1, NULL AS count2
        FROM
          ( 
            SELECT
             DISTINCT RootTable0.DurableKey AS DurableKey, NULL AS slice0MaxValue , NULL AS count1 , NULL AS count2 , ISNULL ( ConsolidatedTable4.slice0, 4 )  AS slice0
            FROM
             SlicerDicer.PatientDim_638808424802284327_uZtueeujnEejwrN88koRtQ AS RootTable0
            INNER JOIN SlicerDicer.EncounterFact_638808804566723264_7dumBqKLRki5zKCCYBrwAg AS FilterTable1 ON RootTable0.DurableKey = FilterTable1.PatientDurableKey
            INNER JOIN dbo.DateDim AS table2 ON FilterTable1.DateKey = table2.DateKey
            INNER JOIN dbo.DateDim AS table3 ON  ( FilterTable1.EndDateKey = table3.DateKey ) 
            AND  (  (  (  (  ( FilterTable1.DateKey < '20200101' ) 
                            AND NOT  ( FilterTable1.DateKey < 0 )  ) 
                        AND  (  ( FilterTable1.EndDateKey >= '20190101' )  OR  ( FilterTable1.EndDateKey < 0 )  )  ) 
                    AND  (  ( table2.DateValue < DATEADD ( YEAR,9,RootTable0.BirthDate )  ) 
                        AND  (  ( table3.DateValue IS NULL )  OR  ( table3.DateValue >= DATEADD ( YEAR,8,RootTable0.BirthDate )  )  ) 
                        AND  ( RootTable0.DeathDate IS NULL OR RootTable0.DeathDate >= DATEADD ( YEAR,8,RootTable0.BirthDate )  ) 
                        AND  ( RootTable0.BirthDate <= DATEADD ( YEAR,-8,'2025-04-17' )  )  ) 
                    AND  (  ( '20190101' < DATEADD ( YEAR,9,RootTable0.BirthDate )  ) 
                        AND  ( '20200101' > DATEADD ( YEAR,8,RootTable0.BirthDate )  ) 
                        AND  ( RootTable0.BirthDate <= DATEADD ( YEAR,-8,'2025-04-17' )  )  )  )  ) 
            LEFT OUTER JOIN  ( 
                SELECT
                 DISTINCT SlicerTable1.PatientDurableKey AS DurableKey,  ( CASE
                    WHEN  ( SlicerTable1.SVIStateSocioeconomicStatusPercentileRank*100 < @param0000 /* 25 */ )  THEN 0
                    WHEN  (   ( SlicerTable1.SVIStateSocioeconomicStatusPercentileRank*100 < @param0001 /* 50 */ ) 
                        AND  ( SlicerTable1.SVIStateSocioeconomicStatusPercentileRank*100 >= @param0000 /* 25 */ )   )  THEN 1
                    WHEN  (   ( SlicerTable1.SVIStateSocioeconomicStatusPercentileRank*100 < @param0002 /* 75 */ ) 
                        AND  ( SlicerTable1.SVIStateSocioeconomicStatusPercentileRank*100 >= @param0001 /* 50 */ )   )  THEN 2
                    WHEN  ( SlicerTable1.SVIStateSocioeconomicStatusPercentileRank*100 >= @param0002 /* 75 */ )  THEN 3
                    ELSE NULL END )  AS slice0
                FROM
                 dbo.PatientSviDimX AS SlicerTable1
                WHERE
                  (   ( SlicerTable1.SVIStateSocioeconomicStatusPercentileRank*100 IS NOT NULL ) 
                    AND  ( SlicerTable1.SurveyYear = '2020' )   )  )  ConsolidatedTable4 ON RootTable0.DurableKey = ConsolidatedTable4.DurableKey
            INNER JOIN SlicerDicer.DiagnosisEventFact_638808804566723264_qJv3JCmhtUqGQnzpyhwgiw AS ConsolidatedTable5 ON  ( RootTable0.DurableKey = ConsolidatedTable5.PatientDurableKey ) 
            AND  (  ( ConsolidatedTable5.[Type] IN  ( N'Billing Admission Diagnosis',N'Billing Final Diagnosis',N'Billing Procedure Linked Diagnosis' )  )  ) 
            INNER JOIN dbo.DateDim AS ConsolidatedTable6 ON  ( ConsolidatedTable5.StartDateKey = ConsolidatedTable6.DateKey ) 
            AND  (  (  (  ( ConsolidatedTable6.DateValue < DATEADD ( YEAR,9,RootTable0.BirthDate )  ) 
                        AND  ( RootTable0.BirthDate <= '2025-04-17' )  ) 
                    AND  (  ( '20190101' < DATEADD ( YEAR,9,RootTable0.BirthDate )  ) 
                        AND  ( RootTable0.BirthDate <= '2025-04-17' )  )  )  ) 
            INNER JOIN  ( 
                SELECT
                 FilterTable1.PatientDurableKey AS DurableKey, FilterTable1.StartDateKey AS startDate
                FROM
                 SlicerDicer.DiagnosisEventFact_638808804566723264_qJv3JCmhtUqGQnzpyhwgiw AS FilterTable1
                INNER JOIN #GrouperTableparam0012 AS GrouperSubquery3 ON FilterTable1.DiagnosisKey = GrouperSubquery3.basekey
                WHERE
                  (   ( FilterTable1.[Type] IN  ( N'Billing Admission Diagnosis',N'Billing Final Diagnosis',N'Billing Procedure Linked Diagnosis' )  )   )  )  ConsolidatedTable7 ON  ( ConsolidatedTable5.PatientDurableKey = ConsolidatedTable7.DurableKey ) 
            AND  (  ( ConsolidatedTable7.DurableKey > 0 )  ) 
            AND  (  (  (  (  CASE
                            WHEN  ( CASE
                                WHEN ConsolidatedTable7.startDate > 0 THEN TRY_CONVERT ( DATE, TRY_CONVERT ( VARCHAR ( 8 ) , ConsolidatedTable7.startDate )  ) 
                                ELSE CONVERT ( DATE, '90001231' )  END )  < '99961231' THEN DATEADD ( YEAR, 3,  ( CASE
                                    WHEN ConsolidatedTable7.startDate > 0 THEN TRY_CONVERT ( DATE, TRY_CONVERT ( VARCHAR ( 8 ) , ConsolidatedTable7.startDate )  ) 
                                    ELSE CONVERT ( DATE, '90001231' )  END )  ) 
                            ELSE '17530101' END  )  >=  ( CASE
                            WHEN ConsolidatedTable5.StartDateKey > 0 THEN TRY_CONVERT ( DATE, TRY_CONVERT ( VARCHAR ( 8 ) , ConsolidatedTable5.StartDateKey )  ) 
                            ELSE CONVERT ( DATE, '90001231' )  END )  ) 
                    AND  (  ( CASE
                            WHEN ConsolidatedTable7.startDate > 0 THEN TRY_CONVERT ( DATE, TRY_CONVERT ( VARCHAR ( 8 ) , ConsolidatedTable7.startDate )  ) 
                            ELSE CONVERT ( DATE, '90001231' )  END )  <  ( CASE
                            WHEN ConsolidatedTable5.StartDateKey > 0 THEN TRY_CONVERT ( DATE, TRY_CONVERT ( VARCHAR ( 8 ) , ConsolidatedTable5.StartDateKey )  ) 
                            ELSE CONVERT ( DATE, '90001231' )  END )  )  )  ) 
            WHERE
              (  (  ( RootTable0.IsValid = 1 ) 
                    AND  ( RootTable0.UseInCosmosAnalytics_X = 1 )  ) 
                AND  ( RootTable0.IsCurrent = 1 ) 
                AND  (  ( FilterTable1.Count = '1' )  ) 
                AND EXISTS  ( 
                    SELECT
                     1
                    FROM
                     #GrouperTableparam0012 AS GrouperSubquery3
                    WHERE
                      (  (  (  ConsolidatedTable5.DiagnosisKey = GrouperSubquery3.basekey  )  )  )  )   )   )  subq0
        WHERE
          (  (  (  ( subq0.slice0 <> '4' )  OR  ( subq0.slice0MaxValue IS NULL )  )  )  ) 
 )  subq

    WHERE
    
subq.DurableKey > 0

    GROUP BY slice0
 )  AS tempResultSet
OPTION  ( RECOMPILE, USE HINT  ( 'FORCE_DEFAULT_CARDINALITY_ESTIMATION', 'DISABLE_OPTIMIZER_ROWGOAL', 'ENABLE_PARALLEL_PLAN_PREFERENCE' ) , NO_PERFORMANCE_SPOOL ) 

SELECT
DISTINCT mainResultSet.slice0 , mainResultSet.count1 AS count1 , mainResultSet.count2 AS count2
FROM
#resultSet mainResultSet
WHERE
mainResultSet.slice0 IS NOT NULL

DROP TABLE #resultSet

DROP TABLE IF EXISTS #GrouperTableparam0012



https://www.reddit.com/r/science/comments/1ki656o/people_living_within_a_mile_of_a_golf_course_had/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
