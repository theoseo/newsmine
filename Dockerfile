# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/tensorflow-notebook

MAINTAINER Newsmine Project <manager@osslab.com>

USER root

#install KONLPY 
RUN \
  apt-get update && \
  apt-get install -y openjdk-8-jdk  automake libmecab2 libmecab-dev && \
  rm -rf /var/lib/apt/lists/*

USER $NB_USER
#RUN pip install JPype1-py3   # Python 3.x
RUN conda install --quiet --yes JPype1
#RUN pip2 install JPype1        # Python 2.x
#RUN conda install --quiet --yes -n python2 JPype1
RUN pip install konlpy       # Python 3.x
#RUN pip2 install konlpy        # Python 2.x

#install MeCab 
USER root

RUN cd /tmp && \
	wget --quiet https://bitbucket.org/eunjeon/mecab-ko/downloads/mecab-0.996-ko-0.9.2.tar.gz; tar zxfv mecab-0.996-ko-0.9.2.tar.gz; \
	cd mecab-0.996-ko-0.9.2; ./configure; make; make install; ldconfig

# Mecab-Ko-Dic
RUN cd /tmp && \
	wget --quiet https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-2.0.1-20150920.tar.gz; \
	tar zxfv mecab-ko-dic-2.0.1-20150920.tar.gz; \
	cd mecab-ko-dic-2.0.1-20150920; \
	./autogen.sh; \
	./configure; make; make install; ldconfig

# Mecab-Python
RUN cd /tmp && \
	git clone https://bitbucket.org/eunjeon/mecab-python-0.996.git; \
	cd mecab-python-0.996; python setup.py build; python setup.py install; python2 setup.py build; python2 setup.py install


USER $NB_USER
RUN conda install --quiet --yes gensim
RUN conda install --quiet --yes pytables
#RUN conda install --quiet --yes -n python2 gensim

