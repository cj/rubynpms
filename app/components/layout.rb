require_relative 'layout/test'

module RubyNpms
  module Components
    class Layout
      include Opal::Connect

      if RUBY_ENGINE == 'opal'
        `require('../assets/css/style.css')`
      end

      server do
        def search(value)
          value
        end
      end unless RUBY_ENGINE == 'opal'

      on :submit, '#search' do |evt|
        evt.prevent_default
      end

      on :keyup, '#search input' do
        search = @params[:search]

        if search.length >= 2
          server(:search, search).then do |response|
            puts response
          end
        end
      end

      setup do
        dom.set! File.read './app/components/layout.html'
      end unless RUBY_ENGINE == 'opal'

      def display
        dom.set! File.read './app/components/layout.html'

        dom
      end unless RUBY_ENGINE == 'opal'
    end
  end
end
