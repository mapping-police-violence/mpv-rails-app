[![Build Status](https://travis-ci.org/mapping-police-violence/mpv-rails-app.svg?branch=master)](https://travis-ci.org/mapping-police-violence/mpv-rails-app)

### Dependencies
* git
* homebrew

### Configuration
git clone git@github.com:mapping-police-violence/mpv-rails-app.git
cd mpv-rails-app/
brew install rbenv ruby-build postgres
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
rbenv install 2.2.4
rbenv rehash
which ruby (verify that it returns a path that references .rbenv shims)
gem install bundler
rbenv rehash
bundle

### Database initialization
Start postgres (brew info postgres will have info about how to do this on your system)
rake db:create
rake db:migrate
rake db:seed
rake db:test:prepare
rake (runs the tests)
