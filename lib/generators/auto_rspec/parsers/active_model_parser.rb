module ActiveModelParser
  def parse_active_model(the_class)
    binding.pry
    {
      validators: parse_validators(the_class)
    }
  end

  private

  def parse_validators(the_class)
    {
      presence: the_class.validators.select { _1.is_a?(ActiveModel::Validations::PresenceValidator) }.first.attributes
    }
  end
end