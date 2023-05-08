class AutoRspecGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  # argument :file_names, type: :array, default: [], banner: "files names"

  def create_service_file
    p 11111
    p file_name
    # return

    generator_dir_path = "spec/"
    #file name make array
    # parse line into dirs
    # generator_dir_path = service_dir_path + ("/#{@module_name.underscore}" if @module_name.present?).to_s
    generator_path = generator_dir_path + "/#{file_name}_spec.rb"

    #make dir path generation
    Dir.mkdir(generator_dir_path) unless File.exist?(generator_dir_path)

    #parsing file
    @relations = parse_relations('app/models/'+file_name+'.rb')

    #add check
    template "model.erb", generator_path
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

  def parse_relations(file_path)
    file = File.open(file_path, "r")
    content = file.read
    file.close
    # binding.pry
    # content.scan(/^ *(belongs_to.*|has_one.*)\r/).uniq

    #add another checks
    # add parameters check
    {
      belongs_to: parse_belongs_to(content),
      has_many: parse_has_many(content),
      has_one: parse_has_one(content),
      has_and_belongs_to_many: parse_has_and_belongs_to_many(content)
    }
  end
end