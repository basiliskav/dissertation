namespace :data do
  desc "Creates an adminstrator user with email/password given"
  task create_dump: :environment do
    default_email = ENV["ADMIN_EMAIL"]
    default_password = ENV["ADMIN_PASSWORD"]
    default_username = ENV["ADMIN_NAME"]
    puts ENV["ADMIN_NAME"]

    # print "Admininstrator username (default : #{default_username}): "
    # username = STDIN.gets.chop!
    username = default_username if username.blank?


    # print "Admininstrator email (default : #{default_email}): "
    # email = STDIN.gets.chop!
    email = default_email if email.blank?

    # print "Administrator password (default : #{default_password}): "
    # password = STDIN.gets.chop!
    password = default_password if password.blank?

    puts "Creating new Administrator user using \"#{username}\" , \"#{email}\" and \"#{password}\""
    begin
      user = User.new(username: username,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   admin: true)
      if user.save
        user.confirm!
        puts "Admin user created successfully"
      else
        puts "Errors during creation:"
        puts "#{user.errors.full_messages.join("\n")}"
      end
    rescue Exception => e
      puts "Errors during creation:"
      puts e.message
    end

    puts "Creating new User1 using \"userone\" , \"userone@userone.com\" and \"useruser\""
    begin
      user = User.new(username: "userone",
                   email: "userone@userone.com",
                   password: "useruser",
                   password_confirmation: "useruser",
                   admin: false)
      if user.save
        user.confirm!
        puts "User1 created successfully"
      else
        puts "Errors during creation:"
        puts "#{user.errors.full_messages.join("\n")}"
      end
    rescue Exception => e
      puts "Errors during creation:"
      puts e.message
    end

    puts "Creating new User2 using \"usertwo\" , \"usertwo@usertwo.com\" and \"useruser\""
    begin
      user = User.new(username: "usertwo",
                   email: "usertwo@usertwo.com",
                   password: "useruser",
                   password_confirmation: "useruser",
                   admin: false)
      if user.save
        user.confirm!
        puts "User2 created successfully"
      else
        puts "Errors during creation:"
        puts "#{user.errors.full_messages.join("\n")}"
      end
    rescue Exception => e
      puts "Errors during creation:"
      puts e.message
    end
  end
end
