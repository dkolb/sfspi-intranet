JsRoutes.setup do |config|
  config.include = [ /^events_by_date$/ ]
  config.include << /^events_by_date_range$/
end
