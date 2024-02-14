SELECT * FROM (
SELECT
    EXTRACT(epoch from LEAD(date_created) OVER(PARTITION BY user_id ORDER BY date_created) - date_created) AS delta_seconds,
    date_created AS lesson_datetime,
    flt.lesson_id,
    LEAD(date_created) OVER(PARTITION BY user_id ORDER BY date_created) AS next_lesson_datetime,
    profession_name, 
    user_id
FROM finished_lesson_test flt
    LEFT JOIN lesson_index_test lit ON flt.lesson_id = lit.lesson_id
WHERE user_id IN (SELECT user_id FROM (
            SELECT 
                date_created AS lesson_datetime, 
                flt.lesson_id, 
                profession_name, 
                user_id,
                ROW_NUMBER() OVER(PARTITION BY user_id, profession_name order by date_created) as rn
            FROM finished_lesson_test flt
                LEFT JOIN lesson_index_test lit ON flt.lesson_id = lit.lesson_id
            ) t
        WHERE (lesson_datetime >= '2020-04-01 00:00:00.000000+00:00' AND lesson_datetime < '2020-05-01 00:00:00.000000+00:00')
        AND profession_name = 'data-analyst' 
        AND rn = 1)
) t2
WHERE delta_seconds <= 5
    AND profession_name = 'data-analyst' 