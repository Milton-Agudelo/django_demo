# Imagen base (o padre), desde la cual se construirá la imagen en el docker.
FROM python:3.12.2-alpine3.19
# El responsable de mantener la imagen o archivo docker.     
LABEL maintainer="SIESTech.com"

# Define una variable de ambiente que garantiza que python actua sin buferear, salida inmediata.
ENV PYTHONUNBUFFERED 1

# Copia de archivo desde la máquina host a tmp en el contenedor docker.
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# Copia el directorio de la aplicación al contenedor docker.
COPY ./app /app
# Define el directorio de trabajo para las instrucciones subsequentes.
WORKDIR /app
# Puerto de escucha durante la ejecución
EXPOSE 8000
# Define el argumento DEV y o preestablece en 'false'
ARG DEV=false

# Crea el ambiente virtual
RUN python -m venv /py && \
    # Actualizar la herramienta de gestión de paquetes 'pip'
    /py/bin/pip install --upgrade pip && \
    # Instala las dependencias de Python listadas en requirements.txt usando el interprete de Python
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    # Elimina el directorio /tmp y su contenido
    rm -rf /tmp && \
    # Agrega un usuario al contenedor. Las opciones proporcionadas crean uun usuario llamado 'django-user'
    # sin password y sin directorio 'home'.
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Define la variable de ambiente en PATH para incluir el directorio /py/bin,
# garantizando que los binarios de Python son accesibles en el entorno virtual.
ENV PATH="/py/bin:$PATH"

# Define el usuario con el cual el contenedor debe ejecutar los comandos
USER django-user