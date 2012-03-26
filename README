# NoRequire gem
For non-rails ruby apps. NoRequire generates appropriate autoload statements so you no longer need to manage dependencies in your code with require statements.

Rails already takes care of this for you but in a vanilla ruby app or sinatra app you have to require every dependency in your project.
For a reasonable size project with say 10+ ruby files, this is tedious and soon gets complex.

NoRequire uses ruby's autoload to only load a ruby file when needed. Ruby's autoload is used to map ruby class names to the file that defines them.
When the class name is first used, autoload triggers and the file is loaded.

NoRequire handles nested directories too but assumes nested directories imply a module - see login/login_service.rb in the example below.

## Simple usage

For example given the project structure:

<pre>
~/myproject
  app/
    app.rb
    login/
      login_service.rb
  lib/
    oauth_login_service.rb
</pre>

The following autoloads all ruby files in *~/myproject/app, ~/myproject/lib* and any directories nested within them.

<code>
<pre>
root = '~/myproject'
NoRequire.new( root, ['app', 'lib'] )
</pre>
</code>

app.rb can just use Login::LoginService with no require statement
login_service.rb can use OauthLoginService with no require statement


