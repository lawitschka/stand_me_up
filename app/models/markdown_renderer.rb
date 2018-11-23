require 'erb'
require 'ostruct'

class MarkdownRenderer
  attr_reader :template

  def initialize(template_name)
    path = Rails.root.join('app', 'views', 'markdown', "#{template_name}.md.erb")
    @template = File.read(path)
  end

  def render(vars)
    ERB.new(template).result(OpenStruct.new(vars).instance_eval { binding })
  end
end
