require 'pry'
module ActiveRecordParser
  def parse_active_record(the_class)
    active_record_matchers = {}
    active_record_matchers[:relations] = parse_relations(the_class.reflect_on_all_associations)
    active_record_matchers[:nested_attributes] = the_class.nested_attributes_options
    active_record_matchers[:enums] = the_class.defined_enums
    active_record_matchers[:db_columns] = the_class.columns.map(&:name).drop(3)
    active_record_matchers[:db_indexes] = parse_db_indexes(the_class)
    active_record_matchers[:implicit_order_columns] = [the_class.implicit_order_column].flatten
    active_record_matchers[:readonly_attributes] = the_class.readonly_attributes

    active_record_matchers
  end

  private

  def parse_relations(associations)
    relations = {
      belongs_to: [],
      has_many: [],
      has_one: [],
      has_and_belongs_to_many: []
    }
    associations.each do |association|
      case association.macro
      when :belongs_to
        relations[:belongs_to] << association.name
      when :has_many
        relations[:has_many] << association.name
      when :has_one
        relations[:has_one] << association.name
      when :has_and_belongs_to_many
        relations[:has_and_belongs_to_many] << association.name
      end
    end

    return nil if relations.values.all?(&:empty?)
    relations
  end

  def parse_serialized_attributes(the_class)
    serialized_attributes = []

    the_class.attribute_names.each do |attribute_name|
      column = the_class.column_for_attribute(attribute_name)
      serialized_attributes << attribute_name if column&.type == :text && column&.cast_type&.is_a?(ActiveRecord::Type::Serialized)
    end

    serialized_attributes
  end

  def parse_db_indexes(the_class)
    db_indexes = {}
    the_class.connection.indexes(the_class.table_name).map { { _1.unique => _1.columns.first } }.each do |index|
      key = index.keys.first
      next db_indexes[key] << index[key] if db_indexes[key]
      db_indexes[key] = [index[key]]
    end
    db_indexes
  end
end

class AutoRspecGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  include ActiveRecordParser

  def create_spec_file
    # error message if not appropriate path provided
    return puts "#{file_path} doesn't exist!" unless File.exist?(file_path)

    directories = File.dirname(file_path).split('/').drop(1)
    spec_path = 'spec/' + directories.join('/') + "/#{File.basename(file_name, '.*')}_spec.rb"

    # parse classes
    @class_name = class_name.split('.').first
    while !(Object.const_defined?(@class_name) || @class_name.blank?)
      @class_name = @class_name.split('::').drop(1).join('::')
    end
    the_class = Module.const_get(@class_name) unless @class_name.blank?

    if the_class < ActiveRecord::Base
      create_spec_directory(directories)
      @active_record_matchers = parse_active_record(the_class)
      template "application_record.erb", spec_path
    elsif the_class < ActiveModel
      create_spec_directory(directories)
      @active_model_matchers = parse_active_model(the_class)
      template "active_model.erb", spec_path
    elsif the_class < ApplicationController
      create_spec_directory(directories)
      @application_controller_matchers = parse_application_controller(the_class)
      template "application_controller.erb", spec_path
    else
      puts "Spec generation for provided file doesn't supported. Please use it only for ApplicationRecord/ActiveModel classes"
    end
  end

  private

  # Creates spec directory if it doesn't exist
  def create_spec_directory(directories)
    spec_dir_path = 'spec/'
    directories.each do |directory|
      spec_dir_path += "#{directory}/"
      Dir.mkdir(spec_dir_path) unless File.exist?(spec_dir_path)
    end
  end
end