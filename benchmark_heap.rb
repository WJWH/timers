require 'benchmark'

require_relative 'lib/timers/events.rb'
require_relative 'lib/timers/priority_heap.rb'
require 'fc'

events = Timers::Events.new
heap = Timers::PrioHeap.new
fcpq = FastContainers::PriorityQueue.new(:min)

generic_callback = Proc.new { puts "wheeeee" }

# Put a LOT of timers on the queue but don't sort them yet
now = Time.now
range = (1..20000)
range.each do |offset|
  events.schedule(now + 5, generic_callback)
  heap.insert(Timers::Events::Handle.new(now+5, generic_callback))
  fcpq.push(generic_callback, now+5)
end

Benchmark.bm do |x|
  x.report('array   ') { range.each {|offset| events.schedule(now + 10, generic_callback)}; events.first}
  x.report('heap    ') { range.each {|offset| heap.insert(Timers::Events::Handle.new(now+10, generic_callback))}; heap.peek }
  x.report('heap C++') { range.each {|offset| fcpq.push(generic_callback, now+10) }; fcpq.top }
end

p events.first
p heap.peek
p fcpq.top