class LoginGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      puts

      ActiveRecord::Base.transaction do
        print '  Username: '
        puts username  = @args.shift || ENV['USER']
        print '  Name:     '
        puts name      = @args.shift || username.titleize
        print '  E-Mail:   '
        puts email     = @args.shift || "#{ username.demodulize.underscore }@#{ `hostname`.chomp }"

        user = User.create! :name => name, :email => email
        login = user.build_login :username => username

        print '  Password: '
        puts login.password = Login.generate_password

        login.sync_passwords

        login.save!
      end

      puts
    end
  end
end
