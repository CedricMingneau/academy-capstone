# FROM public.ecr.aws/dataminded/spark-k8s-glue:v3.1.2-hadoop-3.3.1
FROM ubuntu
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR ~/wetl
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk python3 python3-pip && \
    apt-get clean;
COPY ./requirements.txt .
USER root
RUN pip3 install -r ./requirements.txt
# USER 185
COPY ./src ./src
CMD ["python3",  "./src/wetl_code.py"]
