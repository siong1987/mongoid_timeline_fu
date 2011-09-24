require "mongoid_timeline_fu/version"
require "mongoid_timeline_fu/fires"

module MongoidTimelineFu
end

Mongoid::Document::ClassMethods.class_eval do
  include MongoidTimelineFu::Fires
end
