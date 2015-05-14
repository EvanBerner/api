jellyfish
=======

[![Code Climate](https://codeclimate.com/repos/551958df69568055c00020f8/badges/b227e3bde5577507002e/gpa.svg)](https://codeclimate.com/repos/551958df69568055c00020f8/feed)
[![Test Coverage](https://codeclimate.com/repos/551958df69568055c00020f8/badges/b227e3bde5577507002e/coverage.svg)](https://codeclimate.com/repos/551958df69568055c00020f8/feed)
[![Build Status](https://travis-ci.org/projectjellyfish/api.svg?branch=master)](https://travis-ci.org/projectjellyfish/api)

#### Overview

Project Jellyfish is a broker system.  It allows admins to create a product catalog of any type of service (IaaS,
TaaS, PaaS, or even Staff) and allows them to be assigned a cost, and then users can create projects and add those
services to a project.

#### Requirements

Jellyfish has the following requirements

* Ruby (Please check .ruby-version for the latest version to use, generally, this is the current version of Ruby)
* PostgreSQL 9.4+
* Red Hat Enterprise Linux / CentOS

#### Installation

Jellyfish is a Ruby on Rails app, and you can install it as such.  Please see the appropriate installation guide
for specifics for how to install.

INSTALL-OSX.md - Mac OS Installation (generally used for development)

INSTALL-RHEL.md - Red Hat Enterprise Linux / CentOS installation

#### Heroku Quick Install

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

#### API Documentation

To access docs on the API, please start rails server (make sure enviroment is either "test" or "development") and 
navigate to http://your.jellyfish.install.url/documentation

#### License

See LICENSE


Copyright 2015 Booz Allen Hamilton
