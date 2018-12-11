JsRoutes.setup do |config|
  config.include = [ /^events/ ]
  config.include << /^members/
  config.include << /^meetings/
end
