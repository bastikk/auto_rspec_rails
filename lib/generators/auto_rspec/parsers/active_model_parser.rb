module ActiveModelParser
  # todo how to use it???????
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