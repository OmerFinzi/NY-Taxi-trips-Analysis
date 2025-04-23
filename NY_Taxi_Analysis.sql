SELECT *
FROM bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022
LIMIT 10;

SELECT *
FROM ny-taxi-trips-analysis.NY_Taxi_Analysis_project.zone_lookup
LIMIT 10;

/* Checking the data Im dealing with*/
SELECT 
  column_name, data_type
FROM
  bigquery-public-data.new_york_taxi_trips.INFORMATION_SCHEMA.COLUMNS
WHERE
  table_name = 'tlc_yellow_trips_2022';

/* Data cleaning - 
1. Trips with negative fare
2. Pickup time AFTER dropoff time
3.Zero distance trips
4.Null locations IDs*/

CREATE OR REPLACE TABLE ny-taxi-trips-analysis.NY_Taxi_Analysis_project.cleaned_trips AS 
SELECT 
  pickup_datetime,
  dropoff_datetime,
  passenger_count,
  trip_distance,
  fare_amount,
  pickup_location_id,
  dropoff_location_id
FROM bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022
WHERE 
  fare_amount > 0
  AND trip_distance > 0
  AND pickup_datetime < dropoff_datetime
  AND pickup_location_id IS NOT NULL
  AND dropoff_location_id IS NOT NULL;



/* Validation */

SELECT
  MIN(fare_amount) AS min_fare,
  MAX (fare_amount) AS max_fare
FROM
  ny-taxi-trips-analysis.NY_Taxi_Analysis_project.cleaned_trips;

/*pickup before dropoff */
SELECT
  COUNT(*) AS bad_records
FROM
  ny-taxi-trips-analysis.NY_Taxi_Analysis_project.cleaned_trips
WHERE 
  pickup_datetime > dropoff_datetime;

/*no missing locations IDs */
SELECT 
  COUNT (*) AS missing_locations_ids
FROM
  ny-taxi-trips-analysis.NY_Taxi_Analysis_project.cleaned_trips
WHERE 
  pickup_location_id IS NULL 
  OR dropoff_location_id IS NULL; --if count is > 0 a specific seach is needed

/* Analysis */

SELECT 
  trips.pickup_datetime,
  trips.dropoff_datetime,
  pickup_zone.Zone AS pickup_zone_name,
  dropoff_zone.Zone AS dropoff_zone_name, 
  trips.passenger_count,
  trips.trip_distance,
  trips.fare_amount
FROM 
  ny-taxi-trips-analysis.NY_Taxi_Analysis_project.cleaned_trips AS trips
LEFT JOIN
  ny-taxi-trips-analysis.NY_Taxi_Analysis_project.zone_lookup AS pickup_zone
ON
  CAST (trips.pickup_location_id AS INT64) = CAST(pickup_zone.LocationID AS INT64)
LEFT JOIN
  ny-taxi-trips-analysis.NY_Taxi_Analysis_project.zone_lookup AS dropoff_zone
ON
  CAST (trips.dropoff_location_id AS INT64) = CAST(dropoff_zone.LocationID AS INT64)
LIMIT 1000;

SELECT
  passenger_count, 
  AVG(trip_distance) AS avg_distance
FROM (
  SELECT 
    passenger_count, 
    trip_distance
  FROM
    ny-taxi-trips-analysis.NY_Taxi_Analysis_project.cleaned_trips
  WHERE
    trip_distance < 100 --filter out extreme outliers
  )
GROUP BY
  passenger_count
ORDER BY
  passenger_count;

WITH pickup_counts AS (
  SELECT
    pickup_location_id,
    COUNT (*) AS pickup_count
  FROM 
    ny-taxi-trips-analysis.NY_Taxi_Analysis_project.cleaned_trips
  GROUP BY 
    pickup_location_id
)

SELECT
 zone.zone AS pickup_zone,
 pickup_counts.pickup_count,
 RANK () OVER (ORDER BY pickup_counts.pickup_count DESC) AS rank
FROM
  pickup_counts
JOIN
  ny-taxi-trips-analysis.NY_Taxi_Analysis_project.zone_lookup AS zone
ON
  CAST (pickup_counts.pickup_location_id AS INT64) = CAST (zone.locationID AS INT64)
WHERE
  pickup_count IS NOT NULL
ORDER BY
  rank
LIMIT 5;