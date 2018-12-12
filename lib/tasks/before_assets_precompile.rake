task :before_assets_precompile do
  system('rails g routes')
end

Rake::Task['assets:precompile'].enhance ['before_assets_precompile']

