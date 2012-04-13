require 'rack-rewrite'

use Rack::Rewrite do
r301 %r{.*}, 'http://danwoodward.com$&',
  :if => Proc.new { |rack_env| rack_env['SERVER_NAME'] != 'danwoodward.com' }
r301 %r{/projects/(\w+)_\w+}, '/$1'  
end

use Rack::Static, 
  :urls => ["/stylesheets", "/images", "/javascripts", "/blog"],
  :root => "public"

run lambda { |env|
  [
    200, 
    {
      'Content-Type'  => 'text/html', 
      'Cache-Control' => 'public, max-age=86400' 
    },
    File.open('public/index.html', File::RDONLY)
  ]
}