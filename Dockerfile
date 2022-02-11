FROM public.ecr.aws/dataminded/spark-k8s-glue:v3.1.2-hadoop-3.3.1
WORKDIR ~/wetl
COPY ./requirements.txt .
USER root
RUN pip install -r ./requirements.txt
USER 185
COPY ./src ./src
CMD ["python3",  "./src/wetl_code.py"]
