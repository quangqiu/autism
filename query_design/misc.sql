
select   @start_date AS StartDate, @end_date AS EndDate,
(SELECT   sum(count0)  FROM #result_patients ) as patients,
(SELECT   sum(count0)  FROM #result_autism  ) as autism,
CONVERT(numeric(10,2), 100.0 * (SELECT   sum(count0)  FROM #result_autism  ) / (SELECT   sum(count0)  FROM #result_patients ) ) AS pct





select A.State,  @start_date AS StartDate, @end_date AS EndDate,   patients, autism,  CONVERT(numeric(10,2), 100.0 * autism / patients) AS pct
FROM
(SELECT  State, sum(count0) as patients
FROM #result_patients  group by State ) AS A
LEFT JOIN
(SELECT State, sum(count0) as autism
FROM #result_autism group by State  ) AS B
ON A.state=B.State
WHERE  autism > 10



select A.State, A.Race,  @start_date AS StartDate, @end_date AS EndDate,   patients, autism,  CONVERT(numeric(10,2), 100.0 * autism / patients) AS pct
FROM
(SELECT  State, Race, sum(count0) as patients
FROM #result_patients  group by State, Race ) AS A
LEFT JOIN
(SELECT State, Race,  sum(count0) as autism
FROM #result_autism group by State, Race  ) AS B
ON A.state=B.State AND A.Race=B.Race
WHERE  autism > 10





select A.State, A.SVI,  @start_date AS StartDate, @end_date AS EndDate,   patients, autism,  CONVERT(numeric(10,2), 100.0 * autism / patients) AS pct
FROM
(SELECT  State, SVI, sum(count0) as patients
FROM #result_patients  group by State, SVI ) AS A
LEFT JOIN
(SELECT State, SVI,  sum(count0) as autism
FROM #result_autism group by State, SVI  ) AS B
ON A.state=B.State AND A.SVI=B.SVI
WHERE  autism > 10
