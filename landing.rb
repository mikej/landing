require 'sinatra'
require 'net/smtp'

get '/' do
  erb :index
end

post '/submit' do
  begin
    msg = "From: <noreply@example.com>\nTo: notify@example.com\n" +
      "Reply-To: #{params[:email]}\nSubject: Request for notification of updates\n\nAddress entered: #{params[:email]}"
    
    Net::SMTP.start('smtp.mandrillapp.com', 587, 'example.com',
      ENV['MANDRILL_USERNAME'], ENV['MANDRILL_APIKEY']) do |smtp|
      smtp.send_message msg, 'noreply@example.com', 'notify@example.com'
    end
    redirect to('/thanks')
  rescue
    erb :sorry
  end
end

get '/thanks' do
  erb :thanks
end
