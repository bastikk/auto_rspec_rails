module ModelParser
  #   read about services

  def parse_relations(file_path)
    file = File.open(file_path, "r")
    content = file.read
    file.close
    # binding.pry
    # content.scan(/^ *(belongs_to.*|has_one.*)\r/).uniq

    # add another checks
    # add parameters check
    {
      belongs_to: parse_belongs_to(content),
      has_many: parse_has_many(content),
      has_one: parse_has_one(content),
      has_and_belongs_to_many: parse_has_and_belongs_to_many(content)
    }
  end

  private

  def parse_belongs_to(content)
    content.scan(/belongs_to\s:(\w+)/).flatten
  end

  def parse_has_many(content)
    content.scan(/has_many\s:(\w+)/).flatten
  end

  def parse_has_one(content)
    content.scan(/has_one\s:(\w+)/).flatten
  end

  def parse_has_and_belongs_to_many(content)
    content.scan(/has_and_belongs_to_many\s:(\w+)/).flatten
  end
end

class AutoRspecGenerator < Rails::Generators::NamedBase
  # todo temporary
  require 'pry'
  source_root File.expand_path('../templates', __FILE__)
  include ModelParser

  def create_service_file
    # error message if not appropriate path provided
    unless File.exist?(file_path)
      puts "#{file_path} doesn't exist!"
      return
    end

    directories = File.dirname(file_path).split('/').drop(1)
    spec_path = 'spec/' + directories.join('/') + "/#{File.basename(file_name, '.*')}_spec.rb"

    # parse classes
    @class_name = class_name.split('.').first
    while !(Object.const_defined?(@class_name) || @class_name.blank?)
      @class_name = @class_name.split('::').drop(1).join('::')
    end
    the_class = Module.const_get(@class_name) unless @class_name.blank?

    if the_class < ApplicationRecord
      create_spec_directory(directories)
      @relations = parse_relations(file_path)
      #  todo add
      template "application_record.erb", spec_path
    elsif the_class < ActiveModel
      create_spec_directory(directories)
      p 'not implemented yet'
      #   todo add
    else
      puts "Spec generation for provided file doesn't supported. Please use it only for ApplicationRecord/ActiveModel classes"
      return
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