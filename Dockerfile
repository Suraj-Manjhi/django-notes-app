FROM python:3.9

WORKDIR /app/backend

COPY requirements.txt /app/backend

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Install app dependencies
RUN pip install mysqlclient
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app/backend

EXPOSE 8000

CMD ["sh", "-c", "until mysqladmin ping -h $DB_HOST -u $DB_USER -p$DB_PASSWORD --silent; do echo Waiting for database...; sleep 5; done && python manage.py migrate --noinput && gunicorn notesapp.wsgi --bind 0.0.0.0:8000"]

