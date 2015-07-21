module WYSIWYG
  module Rails
    class Engine < ::Rails::Engine
      initializer 'froala.assets.precompile', group: :all do |app|
        app.config.assets.precompile += %W(
          froala_editor.min.js
          froala_editor_ie8.min.js
          plugins/*.js
          langs/*.js
          froala_content.min.css
          froala_editor.min.css
          froala_style.min.css
          themes/*.css
        )
      end
    end
  end
end