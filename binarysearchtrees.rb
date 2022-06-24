class Node
  attr_accessor :left, :right, :data

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root, :data

  def initialize(array)
    @data = array.sort.uniq
    @root = build_tree(data)
  end

  def build_tree(array)
    return nil if array.empty?

    middle = (array.size - 1) / 2
    root_node = Node.new(array[middle])

    root_node.left = build_tree(array[0...middle])
    root_node.right = build_tree(array[(middle + 1)..-1])

    root_node
  end

  def insert(new, position=root)

    if  new > position.data && position.right == nil
      position.right=Node.new(new)
    elsif new < position.data && position.left == nil
      position.left=Node.new(new)
    elsif new < position.data
      insert(new,position.left)
    elsif new > position.data
      insert(new, position.right)
    end
  end

  def delete(value, node = root)
    return node if node.nil?

    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      leftmost_node = leftmost_leaf(node.right)
      node.data = leftmost_node.data
      p delete(leftmost_node.data, node.right)
      node.right = delete(leftmost_node.data, node.right)
    end
    node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def leftmost_leaf(node)
    node = node.left until node.left.nil?

    node
  end

  def find(value, node = root)
    return node if node.nil? || node.data == value

    value < node.data ? find(value, node.left) : find(value, node.right)
  end

  def level_order(node = root, queue = [], array = [])
    array.push(node.data)
    queue.push(node.left) unless node.left.nil?
    queue.push(node.right) unless node.right.nil?
    level_order(queue.shift, queue,array) unless queue.empty?
    array
  end

  def preorder(node = root)
    return if node.nil?

    p node.data
    preorder(node.left)
    preorder(node.right)
  end

  def inorder(node = root)
    return if node.nil?

    inorder(node.left)
    p node.data
    inorder(node.right)
  end

  def postorder(node = root)
    return if node.nil?

    postorder(node.left)
    postorder(node.right)
    p node.data
  end

  def height(node = root)

    return -1 if node.nil?

    h = 1 + [height(node.left), height(node.right)].max

  end

  def depth(node, start = root)
    if node.data > start.data
      depth = 1 + depth(node, start.right)
    elsif node.data < start.data
      depth = 1 + depth(node, start.left)
    else
      return 0
    end
    depth
   end 

   def balanced?
    (height(root.left) - height(root.right)).abs <= 1
   end

   def rebalance

    self.data = level_order.sort.uniq
    self.root = build_tree(data)

   end 



end
 

bst = Tree.new([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,29])

p bst.balanced?


10.times do
  a = rand(100..150)
  bst.insert(a)
  puts "Inserted #{a} to tree."
end

bst.pretty_print



p bst.balanced?

bst.rebalance


bst.pretty_print








