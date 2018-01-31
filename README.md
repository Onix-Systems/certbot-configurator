# certbot-configurator
[![Build Status](https://travis-ci.org/Onix-Systems/certbot-configurator.svg?branch=master)](https://travis-ci.org/Onix-Systems/certbot-configurator)

Script for automatic configuring your environment to use letsencrypt certificates without any 3rd party configuration changes
### Purpose

Configure environment to use letsencrypt certificates by using certbot and by providing command,
that can be used for applying new certificates in case when new certificate will be retrieved.

### Usage

```shell

$ ./install.sh --help
Usage: ./install.sh [OPTION]
Script for installing and configuring letsencrypt certificates usage.
Maintainer: devops@onix-systems.com
Options:
    -m, --mode <mode>         Set script's mode
                                * standalone - run certbot in standalone mode.
                                * webroot    - use prepared webroot for verification specified DN.
    -r, --root <folder>       Set webroot folder to use for DN verification. Should be prepared manually.
    -d, --domain-name [dn]    Comma-separated domain names for retrieving certificate for them.
    --email                   Set email for letsencrypt notifications.
    -h, --help                Show help.
    -c, --command <command>   Command that can be used for reload application to apply new certificates.

Examples:
    $ ./install.sh --mode standalone -d staging.test.com
    $ ./install.sh -m weboot -r /var/www/html --domain-name staging.test.com

```
