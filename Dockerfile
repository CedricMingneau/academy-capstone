FROM public.ecr.aws/dataminded/spark-k8s-glue:v3.1.2-hadoop-3.3.1
WORKDIR ~/wetl
COPY ./requirements.txt .
RUN pip install -r ./requirements.txt -h
COPY ./src .
CMD ["/bin/bash", "python", "src/wetl_code.py"]
