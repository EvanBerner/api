jellyfish-api
=======

[![Code Climate](https://codeclimate.com/repos/54d4fa64695680762a0024c5/badges/6d529333a903ef19c6c7/gpa.svg)](https://codeclimate.com/repos/54d4fa64695680762a0024c5/feed)
[![Test Coverage](https://codeclimate.com/repos/54d4fa64695680762a0024c5/badges/6d529333a903ef19c6c7/coverage.svg)](https://codeclimate.com/repos/54d4fa64695680762a0024c5/feed)
[![Build Status](https://travis-ci.org/projectjellyfish/api.svg)](https://travis-ci.org/projectjellyfish/api)

#### Overview

Project Jellyfish is a broker system.  It allows admins to create a product catalog of any type of service (IaaS,
TaaS, PaaS, or even Staff) and allows them to be assigned a cost, and then users can create projects and add those
services to a project.  Jellyfish current supports IaaS via [ManageIQ](http://manageiq.org).

Project Jellyfish has 3 main components: Jellyfish API, Jellyfish UX, and ManageIQ.  Jellyfish API is the API layer
of Jellyfish.  It provides a REST based API for Jellyfish-UX and for the Jellyfish Mobile application.

#### Requirements

Jellyfish API has the following requirements

* Ruby (Please check .ruby-version for the latest version to use, generally, this is the current version of Ruby)
* PostgreSQL 9.4.x
* ManageIQ (Anand)

#### Installation

Jellyfish API is a Ruby on Rails app, and you can install it as such.  Please see the appropriate installation guide
for specifics for how to install.

INSTALL-OSX.md - Mac OS Installation (generally used for development)

INSTALL-RHEL.md - Red Hat Enterprise Linux installation

#### Other Installation Guide

MANAGEIQ.md - How to setup ManageIQ to work with Jellyfish-API

#### License

See LICENSE


Copyright 2015 Booz Allen Hamilton
