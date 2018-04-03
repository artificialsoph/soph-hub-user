FROM jupyter/tensorflow-notebook:8d9388cac562

LABEL maintainer="Sophie Searcy <s@soph.info>"

RUN conda install --yes \
    'yapf' \
    'autopep8' \
    'ipywidgets' \
    'jupyter_contrib_nbextensions' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR

RUN jupyter contrib nbextension install --user
RUN jupyter nbextension enable --py widgetsnbextension
RUN jupyter nbextension enable python-markdown/main
RUN jupyter nbextension enable code_prettify/code_prettify
RUN jupyter nbextension enable varInspector/main
RUN jupyter nbextension enable execute_time/ExecuteTime
RUN jupyter nbextension enable toggle_all_line_numbers/main

# Make sure the contents of our repo are in ${HOME}

USER root
COPY . /srv/app/src
COPY . ${HOME}
RUN chown -R ${NB_UID} /srv/app/src
RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}
