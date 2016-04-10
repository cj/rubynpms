Opal::Connect.setup do
  options[:plugins_path] = 'app/plugins'
  options[:plugins]      = [
    :server, :html, :dom, :events, :scope, :form
  ]

  if RACK_ENV == 'development'
    options[:hot_reload] = {
      host: SITE_URL,
      port: 8080,
    }
  end
end
