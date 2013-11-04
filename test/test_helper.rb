require 'rubygems'
require 'mongoid'
require 'test/unit'
require 'mocha/setup'

require File.dirname(__FILE__)+'/../lib/mongoid_timeline_fu'

Mongoid.configure do |config|
  config.master  = Mongo::Connection.new('127.0.0.1', 27017).db("timeline-fu-test-suite")
  config.use_utc = true
  config.include_root_in_json = true
end

class Person
  include Mongoid::Document
  field :email,    :type => String
  field :password, :type => String
  attr_accessor :new_watcher, :fire
  
  fires :follow_created,  :on     => :update, 
                          :actor  => lambda { |person| person.new_watcher }, 
                          :if     => lambda { |person| !person.new_watcher.nil? }
  fires :person_updated,  :on     => :update,
                          :if     => :fire?

  def fire?
    new_watcher.nil? && fire
  end
end

class List
  include Mongoid::Document
  field :title, :type => String

  belongs_to :author, :class_name => "Person"
  has_many :comments
  
  fires :list_created_or_updated,  :actor  => :author, 
                                   :on     => [:create, :update]
end

class Comment
  include Mongoid::Document
  field :body, :type => String

  belongs_to :list
  belongs_to :author, :class_name => "Person"

  fires :comment_created, :actor   => :author,
                          :on      => :create,
                          :secondary_subject => :list
  fires :comment_deleted, :actor   => :author,
                          :on      => :destroy,
                          :subject => :list,
                          :secondary_subject => :self
end

TimelineEvent = Class.new

class Test::Unit::TestCase
  protected
    def hash_for_list(opts = {})
      {:title => 'whatever'}.merge(opts)
    end
    
    def create_list(opts = {})
      List.create!(hash_for_list(opts))
    end
    
    def hash_for_person(opts = {})
      {:email => 'james'}.merge(opts)
    end
    
    def create_person(opts = {})
      Person.create!(hash_for_person(opts))
    end
end
