Skippr API Example App
======================

This is a rails project to give you a starting point when you want to use
the REST-API for the http://skippr.com application


To be able to talk to the skippr API you have to configure your rails app with the credentials of your skippr-app.
This is done here: /config/skippr_api.yml

If you just want to copy the important bits to your rails application, these are the important bits:

 * config/initalizers: skippr.rb & activeresource.rb
 * lib/skippr_api.rb
 * config/skippr_api.yml

Since it's REST we don't have any sessions or the like. Instead every request is authenticated with a temporary token.
But generation and usage of the authentication should be completely transparent to the user of the provided library.

Authentication & Authorization
==============================

To be able to request data your app must contain a valid signature *and* the user must have authorized your app to manage his data. For this he must have added your app to his 'apps in use'. A user can manage these as well under _http://YOURCLIENT.skippr.com/config/apps_. For a user to be able to use your app you must mark it as public in the edit view of your app. The details on how a correct signature is built are shown below. Generation of the signature itself is tken care of by the lib in this project, you just need to supply the necessary credentials

For successful authentication two 'datasets' must be known, to the app that wants to talk to the API:
 1. the 'app-credentials'
 1. the 'user-credentials'

The app credentials are managed in the skippr itself. If you visit _http://YOURCLIENT.skippr.com/config/apps_ you can edit your app. If you don't have one yet, you have to create a new one under _http://YOURCLIENT.skippr.com/config_/apps/new.
In the edit view *Identifikator* and *token* make up the app-credentials (app_key, and app_token).

Also under _http://YOURCLIENT.skippr.com/config/apps_ you see your own users user-credentials as 'Mein Schlüssel'.
They are simply key and secret concatenated with a colon, for easier copy&paste. *The user-credentials are not the credentials you use to login to skippr via the web form!!*

To authenticate usccessfully with the skippr API your request must contain the apps and the users key and a valid *signature*- and a *valid_until*-parameter.
Valid_until is the timestamp specifying until when the signature is valid. The signature is built as follows
`MD5_hash(user_secret + ":" + app_secret + ":" + valid_until)`
valid_until is a server time unix timestamp and must be in the future.

You can test successful authentication and authorization with a request to

`http://YOURCLIENT.skippr.com/api/v1/auth/valid?app=YOUR_APP_KEY&signature=THE_SIGNATURE&validuntil=VALIDUNTIL&user=USER_KEY` where you replace all uppercase words with matching values.



