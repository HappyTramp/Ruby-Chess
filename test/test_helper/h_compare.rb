require 'rspec/expectations'

RSpec::Matchers.define :have_same_props do |expected|
  match do |actual|
    compare_instances(actual, expected)
  end
end

def compare_instances(inst, other)
  act_attrs = inst.instance_variables
  exp_attrs = other.instance_variables
  return false if act_attrs.length != exp_attrs.length

  act_attrs.zip(exp_attrs).each do |attrs|
    return false if attrs[0] != attrs[1]
    return false if inst.instance_variable_get(attrs[0]) != other.instance_variable_get(attrs[1])
  end

  true
end

def compare_instances_array(inst_array, other)
  inst_array.zip(other).each do |inst|
    return false if compare_instances(*inst)
  end
  true
end
