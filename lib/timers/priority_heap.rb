module Timers
  # A bog standard binary minheap implementation, using the `time` field of its contents to determine priority
  class PrioHeap
    def initialize
      @contents = []
    end

    def peek
      @contents[0]
    end

    def pop
      min = @contents[0]
      last = @contents.pop
      @contents[0] = last
      bubble_down(0)
      min
    end

    def insert(element)
      @contents.push(element)
      bubble_up(@contents.size - 1)
      self
    end

    private

    def swap(index1, index2)
      temp = @contents[index1]
      @contents[index1] = @contents[index2]
      @contents[index2] = temp
    end

    def bubble_up(index)
      parent_index = (index - 1) / 2 # integer division!
      while index > 0 && @contents[index] > @contents[parent_index]
        swap(index, parent_index)
        index = parent_index
        parent_index = (index - 1) / 2 # integer division!
      end
    end

    def bubble_down(index)
      least_valued_child_node = 0
      while(true)
        left_child_index = (2 * index) + 1
        left_child_value = @contents[left_child_index]
        if left_child_value.nil?
          # this node has no children so it can't bubble down any further
          # we're done here
          return
        end
        right_child_index = left_child_index + 1
        right_child_value = @contents[right_child_index]
        if right_child_value.nil?
          # node only has a left child
          least_valued_child_node = left_child_value
          least_valued_child_index = left_child_index
        elsif right_child_value < left_child_value
          least_valued_child_node = left_child_value
          least_valued_child_index = left_child_index
        else
          least_valued_child_node = right_child_value
          least_valued_child_index = right_child_index
        end
        if @contents[index] < least_valued_child_node
          # no need to swap, already satisfies the minheap invariant
          return
        else
          swap(index, least_valued_child_index)
          index = least_valued_child_index
        end
      end
    end
  end
end
