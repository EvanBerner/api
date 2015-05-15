Architecture
============

Project Jellyfish is made up of numerous parts, working in concert to make it as easy to use as possible.
The two most prominent portions of Project Jellyfish are the Jellyfish API and Jellyfish UX.
Combined, they make up what we call the "Jellyfish Core".
Both the Jellyfish API and Jellyfish UX are built on the Ruby on Rails framework.



####Jellyfish API:

* The Jellyfish API is a Ruby on Rails application that contains the back-end and the UX, or front-end  the work horse of Project Jellyfish.
* It is a fully scalable REST server that powers the Jellyfish UX and Jellyfish Mobile.
* _Jellyfish API requires Ruby 2.2.x and PostgreSQL 9.4.x_



####Jellyfish UX:

* The Jellyfish UX is an Angular/HTML5 application using NodeJS.
* It provides an advanced interface for both end-users and admins.
* For end-users it acts as a marketplace and self-service portal.
* For admins, it allows the creation of a catalog of services that they would like to offer their end-users.



####Mobile App:

* The app will interface with the Jellyfish Core via the REST API providing basic functionality such as managing rights, accessing the catalog, and monitoring project status.
* While the app cannot do any provisioning of services, it is a great way to manage on the go!



####PostgreSQL Database:

* The PostgreSQL Database is where all the data from the API is stored.
* When any command is made by a user, the API makes a call to the database to return the data.



####Configuration Management:

* In order to help streamline the deployment and management of the data on the servers that Jellyfish runs on, we use configuration tools: Puppet and Chef.
* Instead of manually managing our infrastructure environment, Puppet and Chef automate that management and enable our team to focus on delivering Project Jellyfish.



####Monitoring:

* In order to ensure that Jellyfish is properly up and running, we use IT monitoring tools like Sensu and Nagios.
* They monitor the entire Jellyfish ecosystem, and provide us with details to minimize problems that may arise.
