class WelcomeController < ActionController::Base
  def index
    endpoints = YAML.safe_load(File.read('config/app_constants.yml'))
    @merchant_endpoints = endpoints[:merchants]
    @item_endpoints = endpoints[:items]
    @analysis_endpoints = endpoints[:analysis]
  end
end
