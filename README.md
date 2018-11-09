
[![codebeat badge](https://codebeat.co/badges/fc671989-7aeb-4b3b-a5fb-9d918fcd0e54)](https://codebeat.co/projects/github-com-descorp-incinema-develop)
[![CI Status](http://img.shields.io/travis/descorp/InCinema.svg?style=flat)](https://travis-ci.org/descorp/InCinema)
[![codecov](https://codecov.io/gh/descorp/InCinema/branch/master/graph/badge.svg)](https://codecov.io/gh/descorp/InCinema)

# InCinema
<img src="https://www.themoviedb.org/assets/1/v4/logos/408x161-powered-by-rectangle-green-bb4301c10ddc749b4e79463811a68afebeae66ef43d17bcfd8ff0e60ded7ce99.png" alt="Powered by The MovieDB" width="150">

Application to show a list of movies currently in cinema.

## Structure

Solution spited into 2 projects:

### MDBProvider

Extendable HTTPs client. SSL certificates to MovieDB pinned. 90% test coverage

### InCinema iOS app 

MVVM-C architecture with dependency injection. Shows info based on devices local and language. Images cached.

#### Overview

 Scroll      | Details       | Search 
------------ | ------------- | ------------
![Search preview](https://user-images.githubusercontent.com/2648655/47792431-50401580-dd1c-11e8-9a24-7bca9bca9395.gif) | ![Details preview](https://user-images.githubusercontent.com/2648655/47792461-6221b880-dd1c-11e8-8e44-65866122c933.gif) | ![Search preview](https://user-images.githubusercontent.com/2648655/47792464-651ca900-dd1c-11e8-9a56-08dce2e6afb9.gif)

## How to run

* clone solution
* replace {API_KEY} in config.info with your API Key
* Run the app

## Todo

1. Convert MDBProvider to universal library
2. Convert MDBProvider to pod
3. Cover InCinema with tests
4. Improve scrolling
5. Implement Error Handling

