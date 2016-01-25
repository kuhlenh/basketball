#!/bin/bash

psql basketball -f sos/standardized_results.sql

psql basketball -c "drop table if exists bbref._basic_factors;"
psql basketball -c "drop table if exists bbref._parameter_levels;"

psql basketball -c "vacuum analyze bbref.results;"

R --vanilla -f sos/lmer.R

psql basketball -c "vacuum full verbose analyze bbref._basic_factors;"
psql basketball -c "vacuum full verbose analyze bbref._parameter_levels;"

psql basketball -f sos/normalize_factors.sql

psql basketball -c "vacuum full verbose analyze bbref._factors;"

psql basketball -f sos/schedule_factors.sql

psql basketball -c "vacuum full verbose analyze bbref._schedule_factors;"

psql basketball -f sos/current_ranking.sql > sos/current_ranking.txt

psql basketball -f sos/predict_playoffs.sql > sos/predict_playoffs.txt

psql basketball -f sos/predict_daily.sql > sos/predict_daily.txt
cp /tmp/predict_daily.csv sos/predict_daily.csv

psql basketball -f sos/predict_weekly.sql > sos/predict_weekly.txt
cp /tmp/predict_weekly.csv sos/predict_weekly.csv
