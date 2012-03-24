require 'rack-rewrite'

use Rack::Rewrite do
r301 /.*/,  Proc.new {|path, rack_env| "http://www.#{rack_env['SERVER_NAME']}#{path}" },
    :if => Proc.new {|rack_env| ! (rack_env['SERVER_NAME'] =~ /www\./i)}
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