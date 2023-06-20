module ActiveModelParser
  def parse_active_model(the_class)
    {
      validators: parse_validators(the_class)
    }
  end

  private

  def parse_validators(the_class)
    {
      presence: the_class.validators.select { _1.is_a?(ActiveModel::Validations::PresenceValidator) }.map(&:attributes).flatten,
      absence: the_class.validators.select { _1.is_a?(ActiveModel::Validations::AbsenceValidator) }.map(&:attributes).flatten,
      acceptance: the_class.validators.select { _1.is_a?(ActiveModel::Validations::AcceptanceValidator) }.map(&:attributes).flatten,
      confirmation: the_class.validators.select { _1.is_a?(ActiveModel::Validations::ConfirmationValidator) }.map(&:attributes).flatten,
      exclusion: the_class.validators.select { _1.is_a?(ActiveModel::Validations::ExclusionValidator) }.map do |validator|
        {
          # TODO: thins about possibility of multiple generators declaration
          name: validator.attributes.first,
          options: validator.options
        }
      end.flatten,
      inclusion: the_class.validators.select { _1.is_a?(ActiveModel::Validations::InclusionValidator) }.map do |validator|
        {
          name: validator.attributes.first,
          options: validator.options
        }
      end.flatten,
      length: the_class.validators.select { _1.is_a?(ActiveModel::Validations::LengthValidator) }.map do |validator|
        {
          name: validator.attributes.first,
          options: validator.options
        }
      end.flatten,
      numericality: the_class.validators.select { _1.is_a?(ActiveModel::Validations::NumericalityValidator) }.map do |validator|
        {
          name: validator.attributes.first,
          options: validator.options
        }
      end.flatten
      }
  end
end