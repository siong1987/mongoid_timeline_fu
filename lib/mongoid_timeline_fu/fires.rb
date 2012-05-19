module MongoidTimelineFu
  module Fires
    def fires(event_type, opts)
      raise ArgumentError, "Argument :on is mandatory" unless opts.has_key?(:on)

      # Array provided, set multiple callbacks
      if opts[:on].kind_of?(Array)
        opts[:on].each { |on| fires(event_type, opts.merge({:on => on})) }
        return
      end
      opts[:subject] = :self unless opts.has_key?(:subject)

      method_name = :"fire_#{event_type}_after_#{opts[:on]}"
      define_method(method_name) do

        default_fields = ["_type", "_id", "created_at", "event_type", "actor_type", "actor_id", "subject_type", "subject_id", "secondary_subject_type", "secondary_subject_id"]
        additional_fields = (TimelineEvent.fields.keys - default_fields).collect &:to_sym

        create_options = ([:actor, :subject, :secondary_subject] + additional_fields).inject({}) do |memo, sym|
          if opts[sym]
            if opts[sym].respond_to?(:call)
              memo[sym] = opts[sym].call(self)
            elsif opts[sym] == :self
              memo[sym] = self
            else
              memo[sym] = send(opts[sym])
            end
          end
          memo
        end
        create_options[:event_type] = event_type.to_s

        TimelineEvent.create!(create_options)
      end

      send(:"after_#{opts[:on]}", method_name, :if => opts[:if])
    end
  end
end
