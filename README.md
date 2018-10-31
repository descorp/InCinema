
[![codebeat badge](https://codebeat.co/badges/fc671989-7aeb-4b3b-a5fb-9d918fcd0e54)](https://codebeat.co/projects/github-com-descorp-incinema-develop)

# InCinema

Application to show a list of movies currently in cinema.

## Structure

Solution spited into 2 projects:

### MDBProvider

Extendable HTTPs client. SSL certificates to MovieDB pinned. 90% test coverage

### InCinema iOS app 

MVVM-C architecture with dependency injection. Shows info based on devices local and language. Images cached.

## How to run

* clone solution
* replace {API_KEY} in config.info with your API Key
* Run the app

## Known bugs

1) detail page on iOS <11 do not have top padding

## Todo

1. Convert MDBProvider to universal library
2. Convert MDBProvider to pod
3. Cover InCinema with tests
4. Improve scrolling
5. Implement CI/CD to store Secret Key
6. Implement Error Handling

<img src="https://www.themoviedb.org/assets/1/v4/logos/408x161-powered-by-rectangle-green-bb4301c10ddc749b4e79463811a68afebeae66ef43d17bcfd8ff0e60ded7ce99.png" alt="Powered by The MovieDB" width="150">
