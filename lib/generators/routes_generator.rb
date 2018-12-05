class RoutesGenerator < Rails::Generators::Base
  def create_initializer_file
    create_file 'app/webpacker/src/javascript/routes.js', JsRoutes.generate
  end
end
