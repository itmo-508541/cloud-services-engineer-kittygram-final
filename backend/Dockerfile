FROM python:3.10
#ENV PYTHONUNBUFFERED=1
WORKDIR /code
EXPOSE 8000

COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python","manage.py","runserver","0.0.0.0:8000"] 
