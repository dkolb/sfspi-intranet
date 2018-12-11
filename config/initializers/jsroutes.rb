JsRoutes.setup do |config|
  config.include = [ /^events/ ]
  config.include << /^members$/
end
