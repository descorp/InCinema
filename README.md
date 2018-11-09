
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
![Scroll preview](https://user-images.githubusercontent.com/2648655/48274261-3ea8ed00-e443-11e8-991d-0fea668749fb.gif) | ![Details preview](https://user-images.githubusercontent.com/2648655/48274222-1faa5b00-e443-11e8-9e4b-e8913588bf09.gif) | ![Search preview](https://user-images.githubusercontent.com/2648655/48274124-f25dad00-e442-11e8-90a2-7ee6bb9f7f5b.gif)

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

