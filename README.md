# TFG-ElasticStack
Repositorio con todos los archivos y datos utilizados para mi proyecto TFG

#### Herramientas necesarias y utilizadas
  - Sistema operativo Centos7
  - docker
  - docker-compose
  - Elastic Stack (Filebeat, Logstash, Elasticsearch, Kibana)
  - Bash Script

#### Organización del repositorio
En el repositorio encontramos por un lado la carpeta **_docker-elk_**. Esta carpeta contiene todo lo necesario para arrrancar con docker un entorno con Elasticsearch, Logstash, Filebeat y Kibana.

Por otro lado, podemos encontrar una carpeta denominada **_dashboads y templates_**. Esta carpeta se subdivide a su vez en tres y separa los ficheros necesarios para la configuración, así como los datos usados y visualizaciones de Kibana.

```bash
  ├── .git
  ├── README.md
  ├── docker-elk
  ├   ├── .git ...
  ├   ├── .env
  ├   ├── .github ...
  ├   ├── .gitattributes
  ├   ├── .dockerignore
  ├   ├── LICENSE
  ├   ├── README.md
  ├   ├── docker-stack.yml
  ├   ├── docker-compose.yml
  ├── bash_script
  ├   ├── script.sh
  ├── filebeat
  ├   ├── Dockerfile
  ├   └── filebeat.yml
  ├── logstash
  ├   ├── Dockerfile
  ├   ├── config
  ├   ├   ├── jvm.options
  ├   ├   └── logstash.yml
  ├   └── pipeline
  ├       ├── pipelines.yml
  ├       ├── cancer_pipeline.conf
  ├       ├── covid_pipeline.conf
  ├       ├── hospitales_pipeline.conf
  ├       ├── hospitales_merge_pipeline.conf
  ├       └── data
  ├           ├── CANCER
  ├           ├   ├── clinical.tsv
  ├           ├   ├── exposure.tsv
  ├           ├   └── family_hitory.tsv
  ├           ├── COVID
  ├           └── HOSPITALES
  ├               ├── centros_C1.csv
  ├               ├── centros_E.csv
  ├               └── CNH-2020.csv
  ├── elasticsearch
  ├   ├── Dockerfile
  ├   └── config
  ├       └── elasticsearch.yml
  ├── kibana
  ├   ├── Dockerfile
  ├   └── config
  ├       └── kibana.yml
  └── dashboards y templates
      ├── pipelines.yml
      ├── Cancer
      ├   ├── dashboards y visualizaciones
      ├   ├   └── dashboard_cancer.json
      ├   └── templates
      ├       ├── pacientes_caracteristicas_template.json
      ├       ├── pacientes_diagnostico_template.json
      ├       └── pacientes_historial_familiar_template.json
      ├── Covid19
      ├   ├── dashboards y visualizaciones
      ├   ├   └── dashboard_covid.json
      ├   ├── datos
      ├   ├   └── EXPLICACION.txt
      ├   └── templates
      ├       ├── covid19_fallecidos_template.json
      ├       └── covid19_vacunacion_template.json
      └── Centros y Hospitales
          ├── dashboards y visualizaciones
          ├   └── dashboard_hospitales.json
          └── templates e ilm
              ├── centros_template.json
              ├── hospitales_template.json
              └── politica_ilm.json
```

#### Instalación y despliegue inicial
El 
