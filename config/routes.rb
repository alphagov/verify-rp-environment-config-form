Rails.application.routes.draw do
  get '/' =>  Proc.new { |env| [ 200, {"Content-Type" => 'text/plain'}, ["Hello, world"] ] }
end
