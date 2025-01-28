WITH flights AS (
    SELECT * 
    FROM {{source('staging_flights', 'filtered_flights_raw')}}
)
SELECT * FROM flights