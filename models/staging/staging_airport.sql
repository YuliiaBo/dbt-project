{{ config(materialized='table') }}
WITH airports AS (
    SELECT * 
    FROM {{source('staging_flights', 'airports')}}
)
SELECT * FROM airports
