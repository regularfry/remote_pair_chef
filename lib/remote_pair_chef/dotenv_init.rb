require 'highline'

class DotenvInit
  attr_accessor :captures

  def self.build_dotenv(path=nil)
    path ||= @path
    di = self.new
    di.interrogate
    di.write_file(path)
  end

  def initialize(opts={})
    @highline = opts.fetch(:highline) { HighLine.new($stdin, $stdout) }
    @path     = opts.fetch(:write_file_path) { ".env" }
    @captures = {}
  end

  def interrogate
    self.captures[:aws_access_key_id]     = get_aws_access_key_id
    self.captures[:aws_secret_access_key] = get_aws_secret_access_key
    self.captures[:identity_file]         = get_identity_file
    self.captures[:ssh_key]               = get_ssh_key
  end

  def write_file(path=nil)
    path ||= @path
    File.open(path, "w") do |f|
      self.captures.each do |capture_name, value|
        f.puts "#{capture_name.to_s.upcase}=#{value}"
      end
    end
  end

  private

  attr_accessor :input, :output, :highline

  def get_ssh_key
    highline.ask("Please enter your SSH_KEY: ")
  end

  def get_identity_file
    highline.ask("Please enter your IDENTITY_FILE: ")
  end

  def get_aws_secret_access_key
    ask_silently("AWS_SECRET_ACCESS_KEY")
  end

  def get_aws_access_key_id
    ask_silently("AWS_ACCESS_KEY_ID")
  end

  def ask_silently(capture)
    highline.ask("Please enter your #{capture}: ") { |q| q.echo = false }
  end
end
