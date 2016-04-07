#!/usr/bin/ruby

require 'redis'

redis = Redis.new(:host => 'localhost', :port => 6379)

begin
  redis.ping
rescue Exception => e
  e.inspect
  puts "cannot connect to redis db"
  puts "++++++++++++++++++++++++++"
  e.message
end

#----- main -----

loop do 

puts 
puts "++++++++++Actions++++++++++"
puts "enter: 1 or add - add a new movie"
puts "enter: 2 or update - update a movie"
puts "enter: 3 or delete - delete the movie"
puts "enter: 4 or display - display movies"
puts "enter: exit - go out"
puts "+++++++++++++++++++++++++++"

choice = gets.chomp
case choice
when '1' || 'add' 
    puts "What's the name of the movie:"
    title = gets.chomp.to_sym
    if redis.hget('movies', title).nil?
        puts "What's the rating of the movie:"
        rating = gets.chomp.to_i
	redis.hset('movies', title, rating)	
    else
        puts "This movie is already exist"
    end
when '2' || 'update'
    puts "What's the name of the movie:"
    title = gets.chomp.to_sym
    if redis.hget('movies', title).nil?
        puts "There is no such movie"
    else
        puts "What's the rating of #{title} movie:"
        rating = gets.chomp.to_i
        redis.hset('movies', title, rating)
    end
when '3' || 'delete'
    puts "What's the name of the movie:"
    title = gets.chomp.to_sym
    if redis.hget('movies', title).nil?
        puts "There is no such a movie"
    else
        redis.hdel('movies', title)
    end
when '4' || 'display'
    redis.hgetall('movies').each {|k,v| puts "#{k}: #{v}"}
when 'exit'	
    break if choice == 'exit'
else 
    puts "ERROR! There is no such command!"
end
end
