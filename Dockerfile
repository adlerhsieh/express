FROM ruby:2.3.1
MAINTAINER Adler Hsieh

# Config
ENV python 2.7.10
ENV ruby 2.3.1
ENV app_home ~/projects/express

SHELL ["/bin/bash", "-c"]

# Install dependencies
RUN apt-get update
RUN apt-get -y install git curl build-essential sudo wget apt-utils
RUN apt-get -yq install --no-install-recommends --no-install-suggests cmake cron ssh

# Install vim distribution
RUN apt-get -y install vim silversearcher-ag
RUN apt-get -y upgrade
RUN git clone https://github.com/adlerhsieh/.vim.git ~/.vim
RUN cd ~/.vim ; git submodule init
RUN cd ~/.vim ; git submodule update --recursive
RUN cp ~/.vim/misc/.vimrc ~/.vimrc
RUN cp ~/.vim/misc/onedark.vim ~/.vim/bundle/vim-colorschemes/colors/onedark.vim

# Install Nodejs & Yarn
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - >/dev/null
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get -yq install --no-install-recommends --no-install-suggests nodejs

# MySQL
RUN debconf-set-selections <<< 'mysql-server mysql-server/root_password password 12345678'
RUN debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 12345678'
RUN apt-get -y install mysql-server
RUN service mysql start

# Install Python
RUN apt-get -y install make libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev xz-utils
RUN apt-get -y upgrade
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
RUN /root/.pyenv/bin/pyenv update
RUN /root/.pyenv/bin/pyenv install ${python}
RUN /root/.pyenv/bin/pyenv global ${python}
RUN /root/.pyenv/shims/pip install -U pip
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
RUN source ~/.bash_profile

# Install rbenv
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash ; exit 0
RUN /root/.rbenv/bin/rbenv install ${ruby}
RUN /root/.rbenv/bin/rbenv global ${ruby}
RUN echo 'export RBENV_ROOT="$HOME/.rbenv"' >> ~/.bash_profile
RUN echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> ~/.bash_profile
RUN source ~/.bash_profile

# Clone Project
RUN mkdir -p ~/projects
RUN git clone https://github.com/adlerhsieh/express.git ${app_home}

# Build
RUN cd ${app_home}
RUN mv config/database.docker.yml config/database.yml
RUN mv config/secrets.docker.yml config/secrets.yml
RUN gem install bundler
RUN bundle install
RUN bundle exec rake db:create
RUN bundle exec rake db:migrate

# ENTRYPOINT ["bundle", "exec"]
