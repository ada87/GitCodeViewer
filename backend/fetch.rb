# Code Viewer - Ruby Script Example
# Demonstrates: Modules, Classes, Blocks, Mixins, Metaprogramming

require 'json'
require 'date'

module GitCodeViewer
  VERSION = "1.0.0"

  # Mixin for logging capabilities
  module Loggable
    def log(message, level = :info)
      timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      puts "[#{timestamp}] [#{level.upcase}] #{message}"
    end
  end

  # Struct for lightweight objects
  Commit = Struct.new(:hash, :author, :message, :date)

  class Repository
    include Loggable
    
    attr_reader :name, :url
    attr_accessor :branch

    def initialize(name, url)
      @name = name
      @url = url
      @branch = 'main'
      @files = []
      log "Initialized repository: #{@name}"
    end

    def clone!
      log "Cloning from #{@url}..."
      sleep 0.5 # Simulate network
      log "Clone complete."
      yield self if block_given?
    end

    def add_file(filename)
      @files << filename
      log "Added file: #{filename}"
    end

    def list_files
      puts "\nFiles in #{@name}:"
      @files.each_with_index do |f, i|
        puts "#{i + 1}. #{f}"
      end
    end

    def latest_commit
      # Simulate fetching latest commit
      Commit.new(
        SecureRandom.hex(4),
        "ruby_dev",
        "Refactor validation logic",
        Date.today
      )
    end
    
    # Custom inspection for cleaner console output
    def inspect
      "#<Repo: #{@name} @ #{@branch}>"
    end
  end

  class Analyzer
    include Loggable

    def analyze(repo)
      raise ArgumentError, "Not a Repository" unless repo.is_a?(Repository)
      
      log "Analyzing #{repo.name}..."
      
      # Metaprogramming example: dynamic method call
      [:loc, :complexity, :duplication].each do |metric|
        send("check_#{metric}", repo)
      end
    end

    private

    def check_loc(repo)
      lines = rand(1000..50000)
      puts "  Lines of Code: #{lines}"
    end

    def check_complexity(repo)
      score = ['A', 'B', 'C', 'F'].sample
      puts "  Cyclomatic Complexity: #{score}"
    end

    def check_duplication(repo)
      percent = rand(0..15)
      puts "  Code Duplication: #{percent}%"
    end
  end
end

# Helper class for randomness (if SecureRandom not avail)
class SecureRandom
  def self.hex(n)
    ('a'..'f').to_a.concat((0..9).to_a).sample(n * 2).join
  end
end

# --- Main Execution Script ---

include GitCodeViewer

puts "Starting Ruby Demo for GitCodeViewer v#{VERSION}"

# Using a block for configuration
rails_repo = Repository.new("rails", "https://github.com/rails/rails")
rails_repo.clone! do |r|
  r.add_file "Gemfile"
  r.add_file "Rakefile"
  r.add_file "app/models/user.rb"
  r.branch = "stable"
end

rails_repo.list_files

# Inspect object
puts "\nRepo Object: #{rails_repo.inspect}"

# Analyze
analyzer = Analyzer.new
analyzer.analyze(rails_repo)

# Demonstrating Enumerable
puts "\nProcessing stats..."
stats = [10, 20, 30, 45, 12]
sum = stats.reduce(0) { |acc, num| acc + num }
avg = sum / stats.length.to_f
puts "Average load: #{avg}"

# Hash manipulation
config = {
  theme: :dark,
  font_size: 14,
  plugins: ['mermaid', 'markdown']
}

config.each do |key, value|
  puts "Config [#{key}]: #{value}"
end

puts "\nScript finished."