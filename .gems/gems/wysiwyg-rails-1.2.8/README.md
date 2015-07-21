# wysiwyg-rails [![Gem Version](https://badge.fury.io/rb/wysiwyg-rails.png)](http://badge.fury.io/rb/wysiwyg-rails) [![Build Status](https://secure.travis-ci.org/froala/wysiwyg-rails.png)](http://travis-ci.org/froala/wysiwyg-rails)

wysiwyg-rails provides the [Froala WYSIWYG HTML Editor](https://froala.com/wysiwyg-editor/) javascript and stylesheets as a Rails engine for use with the asset pipeline.

## Installation

Add this to your Gemfile:

```ruby
gem "wysiwyg-rails"
```

and run `bundle install`.

## Usage

In your `application.css`, include the css file:

```css
/*
 *= require froala_editor.min.css
 *= require froala_style.min.css
 *= require font-awesome
 */
```

If you want to use the dark theme, then you have to include `themes/dark.min.css` file too.

In your `application.js`, include the JS file:

```javascript
//
//= require froala_editor.min.js
//
```

If you need to use any of the [Available Plugins](https://froala.com/wysiwyg-editor/docs/plugins), then you should include those too in your `application.js`.
```javascript
// Include other plugins.
//= require plugins/block_styles.min.js
//= require plugins/colors.min.js
//= require plugins/media_manager.min.js
//= require plugins/tables.min.js
//= require plugins/video.min.js
//= require plugins/font_family.min.js
//= require plugins/font_size.min.js
//= require plugins/file_upload.min.js
//= require plugins/lists.min.js
//= require plugins/char_counter.min.js
//= require plugins/fullscreen.min.js
//= require plugins/urls.min.js
//= require plugins/inline_styles.min.js
//= require plugins/entities.min.js
```

Similar, if you want to use language translation you have to include the translation file.
```javascript
// Include Language if needed
//= require langs/ro.js
```

Then restart your web server if it was previously running.

Congrats all is done!

## License

The `wysiwyg-rails` project is under MIT license.

Froala Editor has [3 different licenses](https://froala.com/wysiwyg-editor/pricing).
For details please see [License Agreement](https://froala.com/wysiwyg-editor/terms).
