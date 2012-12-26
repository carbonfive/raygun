# http://www.mikeperham.com/2012/12/09/12-gems-of-christmas-4-mailcatcher-and-mail_view/

begin
  sock = TCPSocket.new('localhost', 1025)
  sock.close
  catcher = true
rescue
  catcher = false
end

ActionMailer::Base.smtp_settings = (Rails.env.development? && catcher) ? { host: 'localhost', port: '1025', } : {}
