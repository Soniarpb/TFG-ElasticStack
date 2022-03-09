#!/bin/bash
url=https://covid.ourworldindata.org/data/owid-covid-data.csv
d=$(date +%Y-%m-%d)

wget -O covid-data-$d --directory-prefix=/root/TFG-ElasticStack/docker-elk-main/logstash/pipeline/data/COVID/ $url

mv /root/TFG-ElasticStack/docker-elk-main/logstash/pipeline/data/COVID/covid-data-$d /root/TFG-ElasticStack/docker-elk-main/logstash/pipeline/data/COVID/covid-data-$d.csv

