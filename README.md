# orkestra-docker-build
A Dockerfile to run builds with sbt that have docker tools installed to allow us to push to a registry

`docker build -t orkestra-docker-build .`

`docker tag orkestra-docker-build:0.1.0-SNAPSHOT gcr.io/$PROJECT/orkestra-docker-build:0.1.0`

`docker push gcr.io/$PROJECT/orkestra-docker-build:0.1.0`
