
--unique number of departures connections
--
--unique number of arrival connections
--
--how many flight were planned in total (departures & arrivals)
--
--how many flights were canceled in total (departures & arrivals)
--
--how many flights were diverted in total (departures & arrivals)
--
--how many flights actually occured in total (departures & arrivals)
--
--(optional) how many unique airplanes travelled on average
--
--(optional) how many unique airlines were in service on average
--
--add city, country and name of the airport


SELECT *
FROM prep_airports;
SELECT *
FROM prep_flights;

SELECT count(distinct origin) as count_dep
FROM prep_flights;

SELECT count(distinct dest) as count_arr
FROM prep_flights;

SELECT count(flight_number) as total_flihgts
FROM prep_flights;

SELECT count(cancelled) as total_cancelled
FROM prep_flights
where cancelled = 1;

SELECT count(diverted) as total_diverted
FROM prep_flights
where diverted = 1;

SELECT count(flight_number) as total_occured
FROM prep_flights
where diverted = 0 and cancelled = 0;

SELECT count(distinct tail_number) as un_airplanes
FROM prep_flights
where diverted = 0 and cancelled = 0;

SELECT count(distinct airline) as un_airline
FROM prep_flights
where diverted = 0 and cancelled = 0;



WITH CTE1 AS (
    SELECT pf.origin,
    pf.dest,
    pf.cancelled,
    pf.diverted,
    pf.flight_number,
    pf.tail_number,
    pf.airline,
    count(distinct origin) as count_dep,
    count(distinct dest) as count_arr,
    count(flight_number) as total_flihgts
FROM prep_flights as pf
group by pf.origin, pf.dest,
    pf.cancelled,
    pf.diverted,
    pf.flight_number,
    pf.tail_number,
    pf.airline
), CTE2 as (
select *,
    count(cancelled) as total_cancelled
from CTE1
where cancelled = 1
group by cte1.origin, cte1.dest,
    cte1.cancelled,
    cte1.diverted,
    cte1.flight_number,
    cte1.tail_number,
    cte1.airline,
    cte1.count_dep,
    cte1.count_arr,
    cte1.total_flihgts
), CTE3 as (
select *,
    count(diverted) as total_diverted
from CTE2
where diverted = 1
group by cte2.origin, cte2.dest,
    cte2.cancelled,
    cte2.diverted,
    cte2.flight_number,
    cte2.tail_number,
    cte2.airline,
    cte2.count_dep,
    cte2.count_arr,
    cte2.total_flihgts,
    cte2.total_cancelled   
),  CTE4 as (
select *,
    count(flight_number) as total_occured,
    count(distinct tail_number) as un_airplanes,
    count(distinct airline) as un_airline
FROM CTE3
where diverted = 0 and cancelled = 0
group by cte3.origin, cte3.dest,
    cte3.cancelled,
    cte3.diverted,
    cte3.flight_number,
    cte3.tail_number,
    cte3.airline,
    cte3.count_dep,
    cte3.count_arr,
    cte3.total_flihgts,
    cte3.total_cancelled,
    cte3.total_diverted
), CTE5 as (
select *,
    pa.faa,
    pa.name,
    pa.city,
    pa.country
from CTE4
join prep_airports as pa
   on pa.faa = CTE4.origin
)
select *
from CTE5;
    
    
