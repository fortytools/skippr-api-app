Skippr API Example App
======================

This is a rails project to give you a starting point when you want to use
the REST-API for the http://skippr.com application


To be able to talk to the skippr API you have to configure your rails app with the credentials of your skippr-app.
This is done here: /config/skippr_api.yml

If you just want to copy the important bits to your rails application, these are the important bits:
- config/initalizers: skippr.rb & activeresource.rb
- lib/skippr_api.rb
- onfig/skippr_api.yml

Since it's REST we don't have any sessions or the like. Instead every request is authenticated with a temporary token.
But generation and usage of the authentication should be completely transparent to the user of the provided library.