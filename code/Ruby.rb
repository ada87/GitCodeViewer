# Ruby Sample Code - Task Management System
#
# @see https://www.ruby-lang.org/en/documentation/

class Priority
  LOW = 'low'.freeze
  MEDIUM = 'medium'.freeze
  HIGH = 'high'.freeze
  CRITICAL = 'critical'.freeze
end

class TaskStatus
  PENDING = 'pending'.freeze
  IN_PROGRESS = 'in_progress'.freeze
  REVIEW = 'review'.freeze
  COMPLETED = 'completed'.freeze
end

class Task
  attr_reader :id, :title, :priority, :status

  def initialize(id, title, priority)
    @id = id
    @title = title
    @priority = priority
    @status = TaskStatus::PENDING
  end
end

class TaskManager
  def initialize
    @tasks = []
    @next_id = 1
  end

  def create(title, priority)
    task = Task.new(@next_id, title, priority)
    @next_id += 1
    @tasks << task
    task
  end

  def count
    @tasks.size
  end
end

m = TaskManager.new
m.create("Implement auth", Priority::HIGH)
puts "Tasks: #{m.count}"
