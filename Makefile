build:
	docker build --force-rm -t jupyterlab:1.0 .

run:
	docker run --rm -d -p 8888:8888 --name jupyterlab -v jupyterlab:/home/jupyteruser -d jupyterlab:1.0
