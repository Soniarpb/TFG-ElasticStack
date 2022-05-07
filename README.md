# TFG-ElasticStack
Repositorio con todos los archivos y datos utilizados para el proyecto TFG **__Explotación de datos biomédicos a través de la herramienta Elastic Stack__**
Este despliegue se ha realizado modificando un git ya existente que podeis encontrar en https://github.com/deviantony/docker-elk.git. Este git ha sido adaptado y modificado en varios puntos para adaptarlo a nuestras necesidades, simulando un cluster completo de 3 nodos de Elasticsearch.
Así mismo, los datos utilizados para la explotación provienen a su vez de:
  - Datos hospitales y centros sanitarios: https://www.mscbs.gob.es/estadEstudios/estadisticas/sisInfSanSNS/ofertaRecursos.htm
  - Datos Covid19: https://github.com/owid/covid-19-data
  - Datos Cancer: https://portal.gdc.cancer.gov/repository


#### Herramientas necesarias y utilizadas
  - Sistema operativo basado en Linux (En nuestro caso Centos7)
  - docker
  - docker-compose
  - Elastic Stack (Filebeat, Logstash, Elasticsearch, Kibana)
  - Bash Script

#### Organización del repositorio
En el repositorio encontramos por un lado la carpeta **_docker-elk_**. Esta carpeta contiene todo lo necesario para arrrancar con docker un entorno con Elasticsearch, Logstash, Filebeat y Kibana.

Por otro lado, podemos encontrar una carpeta denominada **_dashboads y templates_**. Esta carpeta contine por un lado ficheros json de los dashboards y las visualizaciones así como los templates o políticas de ilm utilizadas.

```bash
  ├── .git
  ├── README.md
  ├── docker-elk
  ├   ├── .git ...
  ├   ├── .github ...
  ├   ├── .env
  ├   ├── .gitattributes
  ├   ├── .dockerignore
  ├   ├── filebeat
  ├   ├   ├── Dockerfile
  ├   ├   └── filebeat.yml
  ├   ├── logstash
  ├   ├   ├── Dockerfile
  ├   ├   ├── config
  ├   ├   ├   ├── jvm.options
  ├   ├   ├   └── logstash.yml
  ├   ├   └── pipeline
  ├   ├       ├── pipelines.yml
  ├   ├       ├── cancer_pipeline.conf
  ├   ├       ├── covid_pipeline.conf
  ├   ├       ├── hospitales_pipeline.conf
  ├   ├       └── data
  ├   ├           ├── CANCER
  ├   ├           ├   ├── clinical.tsv
  ├   ├           ├   ├── exposure.tsv
  ├   ├           ├   └── family_hitory.tsv
  ├   ├           ├── COVID
  ├   ├           ├   └── covid-data-2022-03-09.csv
  ├   ├           └── HOSPITALES
  ├   ├               ├── centros_C1.csv
  ├   ├               ├── centros_E.csv
  ├   ├               └── CNH-2020.csv
  ├   ├── elasticsearch
  ├   ├   ├── Dockerfile
  ├   ├   └── config
  ├   ├       └── elasticsearch.yml
  ├   ├── kibana
  ├   ├   ├── Dockerfile
  ├   ├   └── config
  ├   ├       └── kibana.yml
  ├   ├── LICENSE
  ├   ├── README.md
  ├   ├── docker-stack.yml
  ├   └── docker-compose.yml
  └── dashboards y templates
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
En primer lugar, deberemos preparar el entorno instalando docker y docker compose en la máquina donde vayamos a desplegar nuestro entorno de prueba.
En el caso de que se trabaje con una VDI, será necesario ponerle al menos 8GB de memoria.
Es importante recalcar, que pese a que en esta prueba se lanza todo como servicios dockerizados sobre una misma máquina, en un entorno real esto se haría sobre distintas.

Para instalar docker lanzaremos el siguientes comando (sobre Centos7):
```bash
yum install docker
```

Para instalar docker-compose usaremos curl, por lo que lo instalaremos previamente. Después descargámos el binario, le asignamos permisos de ejecución y finalmente generamos un enlace simbólico.
```bash
yum install curl
curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

Tras esto tendremos instalado docker y docker-compose. Podemos comprobarlo con los siguentes comandos:
```bash
docker --version
docker-compose --version
```
Una vez finalizados estos requerimientos previos, pasaremos a descargarnos el repositorio git, con el que desplegaremos nuestro entorno completo.
```bash
git clone https://github.com/Soniarpb/TFG-ElasticStack.git
```

Dado que el git que se adjunta tiene todos los ficheros guardados en su lugar solo habrá que lanzarlo para desplegarlo.
```bash
cd TFG-ElasticStack/docker-elk
docker-compose up
```
Sin embargo, debemos parar el contenedor de Logstash para cargar los templates y políticas de rotado antes de la indexación.
```bash
docker stop docker-elk_logstash_1
```

Es posible que tengamos que modificar uno de los parámetros que vienen por defecto en elasticsearch, si obtenemos un mensaje de error relacionado con la memoria y te pide que aumente el vm.max_map_count, ejecuta la siguiente línea
```bash
sudo sysctl -w vm.max_map_count=262144
```

Pasado un tiempo, Elasticsearch y Kibana habran arrancado. Podemos comprobar que todo está bien desde uno de los nodos de Elasticsearh http://localhost:9200/ 
  - Nombre de usuario: elastic
  - Contraseña: changeme

Tras esto accederemos a Kibana en el http://localhost:5601/ con las mismas credenciales y pasaremos a cargar los templates y políticas de rotado desde el Dev Tools, copiando los ficheros json y dándoles al play.
En este punto también es posible crear espacios y usuarios. Si no, por defecto con el usuario elastic (admin), tendremos acceso a todo.

![Dev Tools](https://github.com/Soniarpb/TFG-ElasticStack/blob/main/Imagenes-readme/DevTools.png)

Por último levantamos el contenedor de logstash y se producirá la indexación.
```bash
docker start docker-elk_logstash_1
```

#### Cargar los dashboards y visualizaciones
Una vez se ha realizado el despliegue y los datos han sido indexados en Elasticsearch, es hora de cargar las visualizaciones y dashboards para ver los datos de forma visual.
Para ello, nos dirigiremos a Kibana y en el desplegable de la derecha pulsaremos sobre Stack Management.

![Stack Management](https://github.com/Soniarpb/TFG-ElasticStack/blob/main/Imagenes-readme/Stack%20Management.png)


Una vez dentro, iremos a Saved objets --> Import y arrastraremos los .json que se encuentran en las distintas carpetas de **dashboards y templates/APLICACION/dashboards y visualizaciones**.

![Saved Objects](https://github.com/Soniarpb/TFG-ElasticStack/blob/main/Imagenes-readme/Saved%20Objects.png)

Tras esto, apareceran todos los dashboards de explotación y podremos ver la información ya explotada de forma gráfica.

![Dashboards](https://github.com/Soniarpb/TFG-ElasticStack/blob/main/Imagenes-readme/Dashboards.png)

Las visualizaciones que tendremos serán similares a las siguientes:
###### CENTROS Y HOSPITALES DASHBOARDS
![Dashboard Centros](https://github.com/Soniarpb/TFG-ElasticStack/blob/main/Imagenes-readme/dashboard%20centros%20y%20hospitales.PNG)
![Dashboard Hospitales](https://github.com/Soniarpb/TFG-ElasticStack/blob/main/Imagenes-readme/dashboard%20hospitales.png)



###### COVID DASHBOARDS
![Dashboard Covid casos y fallecimientos](https://github.com/Soniarpb/TFG-ElasticStack/blob/main/Imagenes-readme/dashboard%20casos%20y%20fallecimientos.png)
![Dashboard Covid vacunacion](https://github.com/Soniarpb/TFG-ElasticStack/blob/main/Imagenes-readme/dashboard%20vacunaci%C3%B3n.png)



###### CANCER DASHBOARDS
![Dashboard Cancer general](https://github.com/Soniarpb/TFG-ElasticStack/blob/main/Imagenes-readme/dashboard%20cancer%20general.png)
![Dashboard Cancer concreto](https://github.com/Soniarpb/TFG-ElasticStack/blob/main/Imagenes-readme/dashboard%20cancer%20concreto.png)
