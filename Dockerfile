# https://www.reddit.com/r/docker/comments/i64rnk/having_troubles_with_setting_usernamepassword_on/

FROM centos:latest

# CREATE USER
RUN useradd -m -d /home/jupyteruser jupyteruser
RUN usermod -aG jupyteruser jupyteruser && usermod -d /home/jupyteruser -u 1000 jupyteruser
RUN chown -R jupyteruser:jupyteruser /home/jupyteruser

WORKDIR /home/jupyteruser
RUN yum install -y \
	python3-devel \
	python3-pip \
	gcc-c++ \
	openssl-devel \
	bash epel-release openblas

# RUN yum install R R-devel R-core-devel

# INSTALL MICROSOFT SQL ODBC DRIVERS FOR PYTHON
RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo
RUN ACCEPT_EULA=Y yum install -y msodbcsql
RUN ACCEPT_EULA=Y yum install -y mssql-tools
RUN yum install -y unixODBC-devel
RUN mkdir /home/jupyteruser/.jupyter
COPY jupyter_notebook_config.py /home/jupyteruser/.jupyter/.

# INSTALL PYTHON REQUIREMENTS
COPY requirements.txt /root/.
RUN pip3 install -r /root/requirements.txt

# INSTALL R REQUIREMENTS
# RUN Rscript -e "install.packages(\"devtools\", repos = c(\"http://irkernel.github.io/\",\"http://cran.rstudio.com\"))"
# RUN Rscript -e "library(\"devtools\")" -e "install_github(\"IRkernel/repr\")" -e "install_github(\"IRkernel/IRdisplay\")"

USER jupyteruser
VOLUME juptyerlab
EXPOSE 8888

CMD jupyter lab --port=8888 --no-browser --ip=0.0.0.0 --allow-root
