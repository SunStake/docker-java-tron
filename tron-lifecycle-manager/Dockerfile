FROM python:3.10
RUN apt-get update && apt-get -y install cron vim
RUN pip install pymongo
WORKDIR /app
COPY crontab /etc/cron.d/crontab
COPY cleanup.py /app/cleanup.py
RUN chmod 0644 /etc/cron.d/crontab
RUN /usr/bin/crontab /etc/cron.d/crontab

# run crond as main process of container
CMD ["cron", "-f"]


