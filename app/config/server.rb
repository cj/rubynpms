module RubyNpm
  class Server < Roda
    use Rack::Session::Cookie, :secret => '123456'

    plugin :environments

    # if production?
    #   require 'hirefire-resource'
    #   use HireFire::Middleware
    # end

    if development?
      # use BetterErrors::Middleware
      #
      # BetterErrors.application_root = Dir.pwd
      # BetterErrors::Middleware.allow_ip! "0.0.0.0/0"
    end

    headers = {
      'Cache-Control' => 'public, max-age=2592000, no-transform',
      'Connection' => 'keep-alive',
      'Age' => '25637',
      'Strict-Transport-Security' => 'max-age=315',
      'Vary' => 'Accept-Encoding'
    }

    unless development?
      plugin :assets,
        path: "#{Dir.pwd}",
        css_dir: '',
        js_dir: '',
        css: ['never_used_but_needed_by_roda.css'],
        js: ['never_used_but_needed_by_roda.js'],
        gzip: true,
        headers: headers,
        group_subdirs: false,
        compiled_name: 'main',
        compiled_path: "../public/assets",
        precompiled: './public/assets/precompiled.json'
    end

    plugin :static, ['/public'],
      root: "#{Dir.pwd}",
      header_rules: [ [:all, headers] ]

    plugin :not_found do
      # Components::Layout.scope(self).render :not_found
    end

    def pjax_request
      request.env['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest'
    end

    route do |r|
      r.assets if RACK_ENV != 'development'

      r.response.headers['Vary'] ='Accept-Encoding'

      r.post 'connect' do
        params = JSON.parse(request.body.read)

        # Make sure they are allowed to call that method
        if Opal::Connect.server_methods[params['klass']].include?(params['method'].to_sym)
          response['Content-Type'] = 'application/json'

          Object.const_get(params['klass'])
            .scope(self)
            .public_send(params['method'], *params['args']).to_json
        else
          response.status = 405
        end
      end

      r.root do
        'Hello, World!'
      end
    end
  end
end
