# My Site
# Version: 1.0

FROM python:3.5

# Install Python and Package Libraries
RUN apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get autoclean
RUN apt-get install -y apt-utils
RUN apt-get install -y \
    libffi-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev \
    net-tools \
    vim \
    apache2 \
    apache2-utils \
    libapache2-mod-wsgi-py3

## setup httpd

ADD ./data/apache/sites-available /etc/apache2/sites-available

RUN a2dissite 000-default.conf


# Project Files and Settings
ARG PROJECT_DIR
ARG PROJECT_NAME
RUN mkdir -p $PROJECT_DIR
WORKDIR $PROJECT_DIR
COPY data/django/$PROJECT_NAME/requirements.txt ./

RUN pip install -r requirements.txt
RUN pip install Django
#COPY Pipfile Pipfile.lock ./
#RUN pip install -U pipenv
# Server
EXPOSE 80 443
STOPSIGNAL SIGINT
#ENTRYPOINT ["python", "manage.py"]
#CMD ["runserver", "0.0.0.0:80"]
RUN a2ensite $PROJECT_NAME.conf
RUN apache2ctl configtest

CMD ["apache2ctl", "-D", "FOREGROUND"]
