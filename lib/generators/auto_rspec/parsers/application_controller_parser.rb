module ApplicationControllerParser
  def parse_application_controller(the_class)
    {
      callbacks: parse_callbacks(the_class)
    }
  end

  private
  def parse_callbacks(the_class)
    callbacks = {
      before: [],
      after: [],
      around: []
    }

    the_class._process_action_callbacks.map do |callback|
      callbacks[callback.kind.to_sym] << callback.filter.to_s
    end

    callbacks.values.any?(&:present?) ? callbacks.compact : nil
  end
end