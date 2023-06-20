module ApplicationControllerParser
  def parse_application_controller(the_class)
    {
      callbacks: parse_callbacks(the_class),
      routes: parse_route(the_class)
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

  def parse_redirect_to(the_class)
    the_class._process_action_callbacks.map do |callback|
      binding.pry
      callback.options[:redirect_to] if callback.kind == :after && callback.options.key?(:redirect_to)
    end.compact
  end

  def parse_route(the_class)
    # binding.pry
    routes = []
    the_class._routes.routes.map do |route|
      if the_class.controller_name == route.defaults[:controller]
        routes << route
      end
    end
    routes
  end
end
