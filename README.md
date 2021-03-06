MongoidTimelineFu
=================

Easily build timelines, much like GitHub's news feed. But, on Mongoid tho. This
project is a port of [TimelineFu](https://github.com/jamesgolick/timeline_fu) on [Mongoid](http://mongoid.org/).

Usage
=====

MongoidTimelineFu requires you to have a TimelineEvent model. 
The simplest way is to use the generator.

    $ rails generate mongoid_timeline_fu
          create  app/models/timeline_event.rb

Next step is to determine what generates an event in your various models.

    class Post
      #...
      belongs_to :author, :class_name => 'Person'
      fires :new_post, :on    => :create,
                       :actor => :author
    end

You can add `fires` statements to as many models as you want on as many models
as you want. 

They are hooked for you after standard Mongoid events. In
the previous example, it's an after_create on Posts. 

Parameters for #fires
=====================

You can supply a few parameters to fires, two of them are mandatory. The first param is a custom name for the event type. It'll be your way of figuring out what events your reading back from the timeline_events table later. `new_post` in the example above.

The rest all fit neatly in an options hash.

- :on => [Mongoid event] 
  - mandatory. You use it to specify whether you want the event created after a create, update or destroy. You can also supply an array of events, e.g. [:create, :update].
- :actor is your way of specifying who took this action.
  - In the example, post.author is going to be this person.
- :subject is automatically set to self, which is good most of the time.  You can however override it if you need to, using :subject.
- :secondary_subject can let you specify something else that's related to the event. A comment to a blog post would be a good example.
- :if => symbol or proc/lambda lets you put conditions on when a TimelineEvent is created. It's passed right to the after_xxx Mongoid event hook, so it's has the same behavior.

Here's another example:

    class Comment
      #...
      belongs_to :commenter, :class_name => 'Person'
      belongs_to :post
      fires :new_comment, :on                 => :create,
                          :actor              => :commenter,
                          #implicit :subject  => self,
                          :secondary_subject  => 'post',
                          :if => lambda { |comment| comment.commenter != comment.post.author }
    end

TimelineEvent instantiation
===========================

The Mongoid event hook will automatically instantiate a 
TimelineEvent instance for you.
It will receive the following parameters in #create!

- event_type 
  - "new_comment" in the comment example
- actor 
  - the commenter
- subject
  - the comment instance
- secondary_subject
  - the post instance

The generated model stores most of its info as polymorphic relationships.

    class TimelineEvent
      include Mongoid::Document
      field :event_type, :type => String

      belongs_to :actor,              :polymorphic => true
      belongs_to :subject,            :polymorphic => true
      belongs_to :secondary_subject,  :polymorphic => true
    end

How you actually get your timeline
==================================

To get your timeline you'll probably have to create your own finder or scopes 
(if your situation is extremely simple). 

MongoidTimelineFu is not currently providing anything to generate your timeline because 
different situations will have wildly different requirements. Like access control 
issues and actually just what crazy stuff you're cramming in that timeline.

We're not saying it can't be done, just that we haven't done it yet. 
Contributions are welcome :-)

Get it
======

    # Gemfile
    gem "mongoid_timeline_fu"

License
=======

Copyright (c) 2011 Teng Siong Ong, released under the MIT license
