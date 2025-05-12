
DECLARE @version     AS nvarchar(MAX) = '20250510'


DECLARE @start_date AS nvarchar(MAX) = '20240101'
DECLARE @end_date   AS nvarchar(MAX) = '20250101'

DECLARE @age  AS integer = 8
DECLARE @age_plus1  AS integer = 9
DECLARE @age_name   AS nvarchar(MAX) =  '8'
DECLARE @birth_base_date  AS nvarchar(MAX) =  '2025-04-17'

DECLARE @INTERIM_YEARS  AS integer = 3

drop table #result_autism
drop table #result_patients

SELECT
* INTO #result_autism
FROM
 ( 

    SELECT
    @start_date as Date, Race, Sex, State, SVI,  COUNT_BIG ( DurableKey )  AS count0

    FROM
      ( 

        SELECT
         subq0.DurableKey,  subq0.Race,  subq0.Sex,  subq0.State, subq0.SVI
        FROM
          ( 
            SELECT
             DISTINCT RootTable0.DurableKey AS DurableKey,  RootTable0.FirstRace AS Race,  RootTable0.ReliableSex AS Sex, RootTable0.ValidatedStateOrProvince_X as State, 
              (CASE WHEN  ( RootTable0.SviOverallPctlRankByZip2020_X * 100    <     25 )  THEN 0
                    WHEN  (   (  RootTable0.SviOverallPctlRankByZip2020_X * 100  <  50  ) 
                        AND  (  RootTable0.SviOverallPctlRankByZip2020_X * 100  >=  25  )   )  THEN 1
                    WHEN  (   (  RootTable0.SviOverallPctlRankByZip2020_X * 100  <  75  ) 
                        AND  (  RootTable0.SviOverallPctlRankByZip2020_X * 100  >=  50  )   )  THEN 2
                    WHEN  (  RootTable0.SviOverallPctlRankByZip2020_X * 100  >=     75  )  THEN 3
		ELSE -1 END) AS SVI
		
            FROM
             PatientDim AS RootTable0
            INNER JOIN EncounterFact AS FilterTable1 ON RootTable0.DurableKey = FilterTable1.PatientDurableKey
            INNER JOIN dbo.DateDim AS table2 ON FilterTable1.DateKey = table2.DateKey
            INNER JOIN dbo.DateDim AS table3 ON  ( FilterTable1.EndDateKey = table3.DateKey ) 
            AND  (  (  (  (  ( FilterTable1.DateKey < @end_date ) 
                            AND NOT  ( FilterTable1.DateKey < 0 )  ) 
                        AND  (  ( FilterTable1.EndDateKey >= @start_date )  OR  ( FilterTable1.EndDateKey < 0 )  )  ) 
                    AND  (  ( table2.DateValue < DATEADD ( YEAR,@age_plus1,RootTable0.BirthDate )  ) 
                        AND  (  ( table3.DateValue IS NULL )  OR  ( table3.DateValue >= DATEADD ( YEAR,@age,RootTable0.BirthDate )  )  ) 
                        AND  ( RootTable0.DeathDate IS NULL OR RootTable0.DeathDate >= DATEADD ( YEAR,@age,RootTable0.BirthDate )  ) 
                        AND  ( RootTable0.BirthDate <= DATEADD ( YEAR,-@age,@birth_base_date )  )  ) 
                    AND  (  ( @start_date < DATEADD ( YEAR,@age_plus1,RootTable0.BirthDate )  ) 
                        AND  ( @end_date > DATEADD ( YEAR,@age,RootTable0.BirthDate )  ) 
                        AND  ( RootTable0.BirthDate <= DATEADD ( YEAR,-@age,@birth_base_date )  )  )  )  ) 
            INNER JOIN DiagnosisEventFact AS ConsolidatedTable4 ON  ( RootTable0.DurableKey = ConsolidatedTable4.PatientDurableKey ) 
            AND  (  ( ConsolidatedTable4.[Type] IN  ( N'Billing Admission Diagnosis',N'Billing Final Diagnosis',N'Billing Procedure Linked Diagnosis' )  )  ) 
            INNER JOIN dbo.DateDim AS ConsolidatedTable5 ON  ( ConsolidatedTable4.StartDateKey = ConsolidatedTable5.DateKey ) 
            AND  (  (  (  ( ConsolidatedTable5.DateValue < DATEADD ( YEAR,@age_plus1,RootTable0.BirthDate )  ) 
                        AND  ( RootTable0.BirthDate <= @birth_base_date )  ) 
                    AND  (  ( @start_date < DATEADD ( YEAR,@age_plus1,RootTable0.BirthDate )  ) 
                        AND  ( RootTable0.BirthDate <= @birth_base_date )  )  )  ) 
            INNER JOIN  ( 
                SELECT
                 FilterTable1.PatientDurableKey AS DurableKey, FilterTable1.StartDateKey AS startDate
                FROM
                 DiagnosisEventFact AS FilterTable1
                INNER JOIN #IcdAutism AS GrouperSubquery3 ON FilterTable1.DiagnosisKey = GrouperSubquery3.basekey
                WHERE
                  (   ( FilterTable1.[Type] IN  ( N'Billing Admission Diagnosis',N'Billing Final Diagnosis',N'Billing Procedure Linked Diagnosis' )  )   )  )  ConsolidatedTable6 ON  ( ConsolidatedTable4.PatientDurableKey = ConsolidatedTable6.DurableKey ) 
            AND  (  ( ConsolidatedTable6.DurableKey > 0 )  ) 
            AND  (  (  (  (  CASE
                            WHEN  ( CASE
                                WHEN ConsolidatedTable6.startDate > 0 THEN TRY_CONVERT ( DATE, TRY_CONVERT ( VARCHAR ( 8 ) , ConsolidatedTable6.startDate )  ) 
                                ELSE CONVERT ( DATE, '90001231' )  END )  < '99961231' THEN DATEADD ( YEAR, @INTERIM_YEARS,  ( CASE
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
                     #IcdAutism AS GrouperSubquery3
                    WHERE
                      (  (  (  ConsolidatedTable4.DiagnosisKey = GrouperSubquery3.basekey  )  )  )  )   )   )  subq0
 )  subq

    WHERE
    
subq.DurableKey > 0
GROUP BY  Race, Sex, State, SVI
 )  AS tempResultSet
OPTION  ( RECOMPILE, USE HINT  ( 'FORCE_DEFAULT_CARDINALITY_ESTIMATION', 'DISABLE_OPTIMIZER_ROWGOAL', 'ENABLE_PARALLEL_PLAN_PREFERENCE' ) , NO_PERFORMANCE_SPOOL ) 






SELECT
* INTO #result_patients
FROM
 ( 

    SELECT
      @start_date as Date, Race, Sex, State, SVI,  COUNT_BIG ( DurableKey )  AS count0

    FROM
      ( 

        SELECT
         subq0.DurableKey,  subq0.Race,  subq0.Sex,  subq0.State, subq0.SVI
        FROM
          ( 
            SELECT
             DISTINCT RootTable0.DurableKey AS DurableKey, RootTable0.FirstRace AS Race,  RootTable0.ReliableSex AS Sex, RootTable0.ValidatedStateOrProvince_X as State, 
              (CASE WHEN  ( RootTable0.SviOverallPctlRankByZip2020_X * 100    <     25 )  THEN 0
                    WHEN  (   (  RootTable0.SviOverallPctlRankByZip2020_X * 100  <  50  ) 
                        AND  (  RootTable0.SviOverallPctlRankByZip2020_X * 100  >=  25  )   )  THEN 1
                    WHEN  (   (  RootTable0.SviOverallPctlRankByZip2020_X * 100  <  75  ) 
                        AND  (  RootTable0.SviOverallPctlRankByZip2020_X * 100  >=  50  )   )  THEN 2
                    WHEN  (  RootTable0.SviOverallPctlRankByZip2020_X * 100  >=     75  )  THEN 3
		ELSE -1 END) AS SVI
		
            FROM
             PatientDim AS RootTable0
            INNER JOIN EncounterFact AS FilterTable1 ON RootTable0.DurableKey = FilterTable1.PatientDurableKey
            INNER JOIN dbo.DateDim AS table2 ON FilterTable1.DateKey = table2.DateKey
            INNER JOIN dbo.DateDim AS table3 ON  ( FilterTable1.EndDateKey = table3.DateKey ) 
            AND  (  (  (  (  ( FilterTable1.DateKey < @end_date ) 
                            AND NOT  ( FilterTable1.DateKey < 0 )  ) 
                        AND  (  ( FilterTable1.EndDateKey >= @start_date )  OR  ( FilterTable1.EndDateKey < 0 )  )  ) 
                    AND  (  ( table2.DateValue < DATEADD ( YEAR,@age_plus1,RootTable0.BirthDate )  ) 
                        AND  (  ( table3.DateValue IS NULL )  OR  ( table3.DateValue >= DATEADD ( YEAR,@age,RootTable0.BirthDate )  )  ) 
                        AND  ( RootTable0.DeathDate IS NULL OR RootTable0.DeathDate >= DATEADD ( YEAR,@age,RootTable0.BirthDate )  ) 
                        AND  ( RootTable0.BirthDate <= DATEADD ( YEAR,-@age,@birth_base_date )  )  ) 
                    AND  (  ( @start_date < DATEADD ( YEAR,@age_plus1,RootTable0.BirthDate )  ) 
                        AND  ( @end_date > DATEADD ( YEAR,@age,RootTable0.BirthDate )  ) 
                        AND  ( RootTable0.BirthDate <= DATEADD ( YEAR,-@age,@birth_base_date )  )  )  )  ) 
            WHERE
              (  (  ( RootTable0.IsValid = 1 ) 
                    AND  ( RootTable0.UseInCosmosAnalytics_X = 1 )  ) 
                AND  ( RootTable0.IsCurrent = 1 ) 
                AND  (  ( FilterTable1.Count = '1' )  )   )   )  subq0
 )  subq

    WHERE
    
subq.DurableKey > 0
GROUP BY  Race, Sex, State, SVI
 )  AS tempResultSet
OPTION  ( RECOMPILE, USE HINT  ( 'FORCE_DEFAULT_CARDINALITY_ESTIMATION', 'DISABLE_OPTIMIZER_ROWGOAL', 'ENABLE_PARALLEL_PLAN_PREFERENCE' ) , NO_PERFORMANCE_SPOOL ) 
