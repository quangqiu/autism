drop table  #IcdAutism
SELECT
GrouperSubquery3.* INTO #IcdAutism
FROM
 ( 
    SELECT
     DISTINCT table0.DiagnosisKey AS basekey, table0.NameAndCode AS grouper_id_1, table0.NameAndCode AS grouper_name_1
    FROM
     dbo.DiagnosisTerminologyDim AS table0
    WHERE
      (  ( table0.[Type]=N'ICD-10-CM' ) 
        AND  ( table0.NameAndCode IS NOT NULL )  )  )  AS GrouperSubquery3
WHERE
 (   (  GrouperSubquery3.grouper_id_1 = 'Autistic disorder( ICD-10-CM: F84.0 )'  )  OR  (  GrouperSubquery3.grouper_id_1 = 'Other childhood disintegrative disorder( ICD-10-CM: F84.3 )'  )  OR  (  GrouperSubquery3.grouper_id_1 = 'Asperger''s syndrome( ICD-10-CM: F84.5 )'  )  OR  (  GrouperSubquery3.grouper_id_1 = 'Other pervasive developmental disorders( ICD-10-CM: F84.8 )'  )  OR  (  GrouperSubquery3.grouper_id_1 = 'Pervasive developmental disorder, unspecified( ICD-10-CM: F84.9 )'  )   ) 




drop table  #IcdAutism
SELECT
GrouperSubquery3.* INTO #IcdAutism
FROM
 ( 
    SELECT
     DISTINCT table0.DiagnosisKey AS basekey, table0.ValueSetEpicId AS grouper_id_0, CASE
    WHEN table0.DisplayName=N'*Unspecified' THEN table0.[Name]
    ELSE table0.DisplayName END AS grouper_name_0
    FROM
     dbo.DiagnosisSetDim AS table0
    WHERE
      (  ( table0.Trusted=1 ) 
        AND  ( table0.ValueSetEpicId IS NOT NULL )  )  )  AS GrouperSubquery3
WHERE
 (   (  GrouperSubquery3.grouper_id_0 = '89111809'  )   ) 
