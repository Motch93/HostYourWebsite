# Project Description

This Project aims to easily create one or more nginx-webserver for your Domain(s). All Tools used within this project are free and open-source.

It includes a Nginx Proxy Configuration, an Amplify Agent to monitor your webserver and a CiCd Pipeline Configuration.

With the CiCd Pipeline the Deployment of changes, the SSL Certificate generation and all Updates
within Docker and other Software Components are completely automated.

# Requirements
 - Host Machine: For installing the software and deploying the Code (In my case I am using a AWS EC2 instance with ubuntu installed)
 - Amplify Account: Nginx Amplify is free and open-source. Just create a Account and save your API-KEY
 - GitHub Account: Create a free Account to run your CiCd-Pipelines
 - Docker: Installed on host, every webserver/proxy runs within Docker Containers on your host machine

# Project Organization
    - .github: Workflows for Github CiCd Pipelines
    - infrastructure: Files containing the Docker Image and Container Configuration and Nginx-Proxy Configuration
    - Domain-Directory (e.g MyWebsite):
        - toplevel:
            - build: The Build files, which the webserver uses to serve and show at the Frontend.
            - infrastructure: nginx logs and configuration
            - javascript/html/css... files
        - subdomain (same structure as toplevel)
    ... More Domain-Directories

# Prerequisites
    - On your host ensure docker, curl is installed and ufw22, ufw 80 and ufw 443 is enabled

Only if using Github CICD Pipelines:

    - In my case, I using vite for create the "build" Files from javascript or similiar files. If you are using npm or other build tools
    adjust the build command in the github workflow corresponding to your build environment. It's only necessary to create the "build" directory
    with the static files to serve.
    - To use Github CiCd to deploy on your Host, add following values to your github Secrets:
          host: ${{ secrets.AWS_HOST }}
          username: ${{ secrets.AWS_USERNAME }}
          port: ${{ secrets.AWS_SSH_PORT }}
          key: ${{ secrets.AWS_SSH_KEY }}
          amplify_key=${{ secrets.AMPLIFY_KEY }}
    Set the values accordingly to your environment
    - Change the Paths in /.github/workflows/deploy_and_build_docker_image.yml, deploy_proxy.yml, deploy_and_gen_ssl.yml 
    at the top of the files to your environment configuration

## Add a Domain to your Project
 - Create the A-Record for your Domain at your Domain Provider, showing to the Ip-Address of your host.
 - Create new Directory under your Project Toplevel Folder. 

 It contains your Frontend-Environment and creates the "build" directory containing your static Files (html,css) within this folder.

 It also must have a "infrastructure" directory. At first you can copy both from the existing default Website in this Project.

 - Add a new docker service to your docker-compose File located in /infrastructure: define the expose port and add the containername
    to the proxy service dependencies.
 - Add a new github CiCd-Pipeline to /.github/workflows by copying the default_website.yml.

Change the Paths at the top of the file corresponding to your Environment
 - Add the domain-name to /infrastructure/entrypoint_generate_ssl.sh
 - Change the server name and location path in the nginx configuration in your directory's infrastructure folder to your specification
 - Add your domain to the nginx Proxy configuration located at /infrastructure/nginx/nginx_proxy.conf by changing/copying
 the default config to your domain name. Change the Proxypass to your hostname and port specified in the docker compose File
 - Add your domain to the nginx Proxy configuration without ssl encryption at /infrastructure/nginx/nginx_proxy_no_ssl.conf
 - Add Path of logs to your Cloudwatch Config if exist
### Fire it up manually
 - First copy the /infrastructure directory to your host, change to this directory and build the Dockerimage with following command:

    docker build -t nginx_amplify:latest --build-arg amplify_key=${YOUR_AMPLIFY_KEY} .
 - Generate SSL certificates with following command:
    docker compose -f docker-compose_gen_ssl.yml up generate_ssl_prod
 
    For Testing the SSL Generation there is a TestContainer: docker compose -f docker-compose_gen_ssl.yml up generate_ssl_demo
 - Stop the SSL Container and start the Proxy and also your webserver container. You need the infrastructure and build
    directory of your Website(s) on your host machine. Be sure the Paths in the docker compose File are correct:

    docker compose down

    docker compose up


# Watch your Website
Go to your Domain Url in the Browser and check if everything is shown correctly and is ssl encrypted

Login to amplify and watch the monitoring of your Websites and System stats: https://amplify.nginx.com/login

Add more domains or subdomains by only following the steps in section "Add a Domain to your Project"
