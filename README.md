# docker-php-fpm

## Installation

    git clone https://github.com/shomatan/docker-php-fpm.git
    cd docker-php-fpm
    ansible-galaxy install -p roles/ -r requirements.yml

## Build image

    cd centos7

### PHP 7.1

    ansible-playbook site.yml

### PHP 7.0

    ansible-playbook site.yml -e php_version=7.0
