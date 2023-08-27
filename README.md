# README
    Welcome to a rails api app that handles a reserveration test case.

## Specifications
    1.  The app has a single endpoint that will allow multiple different uploaders to connect.
    2.  Each uploader is assumed to be non-distinguishable. i.e. no headers or parameter dependencies are made. 
    3.  Our Reservation data is saved to a Reservation model that belongs to a Guest model.
    4.  Uniqueness will be applied to the reservation_code and guest_email fields.
    5.  The endpoint will allow reservation information to be upserted. No limits are applied for the moment.
    6.  Code must be readable and maintainable. Convention will be explained for clarity but should be intuitive to understand.
    7.  Code is easy to scale, handling 20+ additional payloads.
    8.  Use standard practices.
    9.  Properly handle errors.
    10. Ensure code is tested but strike a balance to avoid over coupled tests. 
    
## App dependencies
    As I have packaged the app with docker the dependencies are reduced but not zero.
    To proceed you will need to ensure you follow the Pre App dependencies section below. 

### Pre App dependencies -  Must install prior to running Docker App Setup
    1. Install docker desktop for your OS [Linux](https://docs.docker.com/desktop/install/linux-install/), [Mac](https://docs.docker.com/desktop/install/mac-install/), [Windows](https://docs.docker.com/desktop/install/windows-install/)
    Notes: 
    During the installation process you will be guided to uninstall docker-desktop and reinstall the latest version. 
    The reason for this is so you install the latest Go CLI called "docker compose" instead of using the (old) "docker-compose" Python variant. 
    My instructions below are written for "docker compose" Go CLI (docker compose v2.20.2). 
    2. 
    3. Ensure port 5432 is free. Otherwise kill any postgres processes so that the dockerised postgres process can attach to the OS port 5432. 

### App dependencies covered by docker
    Ruby 3.2.2
    Rails 7.0.7.2
    Postgres 15.4

## Docker App Setup
    We will use the contained docker file to setup the development environment. 
    
    To setup the app:
    1. Save the project locally.
    `git clone https://github.com/andrejvidic/reservation_api.git`
    2. load .env file into your current terminal shell
    `cd resrvation_api && source ./.env`
    3. Build the docker images.
    `docker compose build --build-arg USER=$USER --build-arg USER_ID=$USER_ID --build-arg GROUP_ID=$GROUP_ID --build-arg GROUP_NAME=$GROUP_NAME`
    4. Run the docker containers and let docker compose handle container orchestration.
    `docker compose up -d`
    5. Ensure both the reservations_db and reservations_api docker containers are running 
    `docker ps -a`
    6. If there are no running containers, check the error logs (Should not need this step)
    `docker logs <name_of_container>`
    7. Drop into the docker container shell 
    `docker compose exec reservations_api bash`
    8. Create the postgres reservations_api_development and test databases 
    `bin/rails db:drop db:create db:schema:load`

## Testing
    From the Docker App Setup section you should be in the docker bash shell. If not, re-enter:
    `docker compose exec reservations_api bash`

    Then run the tests as normal
    `rspec spec`
## Code convention
    
