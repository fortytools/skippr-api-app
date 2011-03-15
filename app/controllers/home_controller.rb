class HomeController < ApplicationController

  def show
    @bar = 'http://fortytools.skippr.local:3000'

    auth = SkipprApi::AuthFactory.for_user('kgd','b9428b783714167915812688853c1008', 'd58d2a1f')
    api = SkipprApi::ApiFactory.create_api(auth)

    @foo =  api::Invoice.find(6165).inspect

  end
end
